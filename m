Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932319AbaJUKeX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 06:34:23 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:48980 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754553AbaJUKeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 06:34:22 -0400
Message-ID: <544636A5.1080204@hitachi.com>
Date: Tue, 21 Oct 2014 19:34:13 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: Re: [RFC PATCH 5/5] module: Remove stop_machine from module
 unloading
References: <20140825105520.21089.26870.stgit@kbuild-fedora.novalocal> <20140825105555.21089.99958.stgit@kbuild-fedora.novalocal> <87ppdweg5g.fsf@rustcorp.com.au>
In-Reply-To: <87ppdweg5g.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/10/13 13:40), Rusty Russell wrote:
> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> writes:
>> Remove stop_machine from module unloading by replacing module_ref
>> with atomic_t. Note that this can cause a performance regression
>> on big-SMP machine by direct memory access. For those machines,
>> you can lockdwon all modules. Since the lockdown skips reference
>> counting, it'll be more scalable than per-cpu module_ref counters.
> 
> Sorry for the delay; I didn't get to this before I left, and then
> I was away for 3 weeks vacation.
> 
> First, I agree you should drop the MODULE_STATE_LOCKUP patch.  While I
> can't audit every try_module_get() call, I did put an mdelay(100) in
> there and did a quick boot for any obvious slowdown.

OK, I might be thinking too much about performance. I'll drop it :)

> Second, this patch should be split into two parts.  The first would
> simply replace module_ref with atomic_t (a significant simplification),
> the second would get rid of stop machine.

OK, I'll do that.

> 
>> +/*
>> + * MODULE_REF_BASE must be 1, since we use atomic_inc_not_zero() for
>> + * recovering refcnt (see try_release_module_ref() ).
>> + */
>> +#define MODULE_REF_BASE	1
> 
> True, but we could use atomic_add_unless() instead, and make this
> completely generic, right?

Would you mean just replacing atomic_inc_not_zero() with atomic_add_unless()?

> 
>> +
>>  /* Init the unload section of the module. */
>>  static int module_unload_init(struct module *mod)
>>  {
>> -	mod->refptr = alloc_percpu(struct module_ref);
>> -	if (!mod->refptr)
>> -		return -ENOMEM;
>> +	/*
>> +	 * Initialize reference counter to MODULE_REF_BASE.
>> +	 * refcnt == 0 means module is going.
>> +	 */
>> +	atomic_set(&mod->refcnt, MODULE_REF_BASE);
>>  
>>  	INIT_LIST_HEAD(&mod->source_list);
>>  	INIT_LIST_HEAD(&mod->target_list);
>>  
>>  	/* Hold reference count during initialization. */
>> -	raw_cpu_write(mod->refptr->incs, 1);
>> +	atomic_inc(&mod->refcnt);
>>  
>>  	return 0;
>>  }
>> @@ -721,8 +728,6 @@ static void module_unload_free(struct module *mod)
>>  		kfree(use);
>>  	}
>>  	mutex_unlock(&module_mutex);
>> -
>> -	free_percpu(mod->refptr);
>>  }
>>  
>>  #ifdef CONFIG_MODULE_FORCE_UNLOAD
>> @@ -740,60 +745,38 @@ static inline int try_force_unload(unsigned int flags)
>>  }
>>  #endif /* CONFIG_MODULE_FORCE_UNLOAD */
>>  
>> -struct stopref
>> +/* Try to release refcount of module, 0 means success. */
>> +static int try_release_module_ref(struct module *mod)
>>  {
>> -	struct module *mod;
>> -	int flags;
>> -	int *forced;
>> -};
>> +	int ret;
>>  
>> -/* Whole machine is stopped with interrupts off when this runs. */
>> -static int __try_stop_module(void *_sref)
>> -{
>> -	struct stopref *sref = _sref;
>> +	/* Try to decrement refcnt which we set at loading */
>> +	ret = atomic_sub_return(MODULE_REF_BASE, &mod->refcnt);
>> +	if (ret)
>> +		/* Someone can put this right now, recover with checking */
>> +		ret = atomic_inc_not_zero(&mod->refcnt);
>> +
>> +	return ret;
>> +}
> 
> This is very clever!  I really like it.

Thanks!

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


