Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023AbaI3Wcs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 18:32:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbaI3Wcr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 18:32:47 -0400
Message-ID: <542B2F7E.8030801@redhat.com>
Date: Tue, 30 Sep 2014 18:32:30 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131028 Thunderbird/17.0.10
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        Jason Wessel <jason.wessel@windriver.com>,
        Roland McGrath <roland@hack.frob.com>,
        kgdb-bugreport@lists.sourceforge.net
Subject: Re: [PATCH] modules, split MODULE_STATE_UNFORMED into separate states
References: <1412104110-18441-1-git-send-email-prarit@redhat.com> <20140930195733.GA26492@redhat.com>
In-Reply-To: <20140930195733.GA26492@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 09/30/2014 03:57 PM, Oleg Nesterov wrote:
> On 09/30, Prarit Bhargava wrote:
>>
>> MODULE_STATE_UNFORMED needs to be separated into two states; one for the
>> module load (MODULE_STATE_LOAD), and one for the module delete
>> (MODULE_STATE_DELETE).
> 
> And personally I think this makes sense in any case, but I can't really
> comment the changes in this area.
> 
>> @@ -3647,18 +3646,29 @@ static int m_show(struct seq_file *m, void *p)
>>  	struct module *mod = list_entry(p, struct module, list);
>>  	char buf[8];
>>  
>> -	/* We always ignore unformed modules. */
>> -	if (mod->state == MODULE_STATE_UNFORMED)
>> +	/*
>> +	 * If the state is MODULE_STATE_LOAD then the module is in
>> +	 * the early stages of loading.  No information should be printed
>> +	 * for this module as the data could be in an uninitialized state.
>> +	 */
>> +	if (mod->state == MODULE_STATE_LOAD)
>>  		return 0;
> 
> So this assumes that _UNFORMED state is fine...
> 
> Not sure, but I can be easily wrong. For example, print_unload_info() ->
> module_refcount() plays with mod->refptr, while free_module() does
> module_unload_free() -> free_percpu(mod->refptr). No?

Oh geez -- I didn't see that in module_unload_free().  I had assumed that all
the percpu data was free'd in free_module() call to percpu_modfree(mod) ...

You're right though, the _DELETE state is not okay in this path, and if that's
the case then I'm not sure we have to distinguish the two cases.

> 
> Perhaps it makes sense to start with the simple patch for stable,
> 
> 	+	// sync with m_show()
> 	+	mutex_lock(module_mutex);
> 		mod->state = MODULE_STATE_UNFORMED;
> 	+	mutex_unlock(module_mutex);
> 
> then do a more sophisticated fix?

I actually toyed around with this but thought that was too "hacky" for a fix.
But if Rusty is okay with it, I'd be okay with it too.

P.


> 
> Oleg.
> 
