Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506AbaETLgm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 07:36:42 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:58087 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbaETLgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 07:36:41 -0400
Message-ID: <537B3E43.5070306@suse.cz>
Date: Tue, 20 May 2014 13:36:35 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Aravinda Prasad <aravinda@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Vojtech Pavlik <vojtech@suse.cz>, Michael Matz <matz@suse.de>,
        Jiri Kosina <jkosina@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [RFC 03/16] kgr: initial code
References: <1398868249-26169-1-git-send-email-jslaby@suse.cz> <1398868249-26169-4-git-send-email-jslaby@suse.cz> <53733746.1040200@linux.vnet.ibm.com>
In-Reply-To: <53733746.1040200@linux.vnet.ibm.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2014 11:28 AM, Aravinda Prasad wrote:
>> +/*
>> + * The stub needs to modify the RIP value stored in struct pt_regs
>> + * so that ftrace redirects the execution properly.
>> + */
>> +#define KGR_STUB_ARCH_SLOW(_name, _new_function)			\
>> +static void _new_function ##_stub_slow (unsigned long ip, unsigned long parent_ip,	\
>> +		struct ftrace_ops *ops, struct pt_regs *regs)		\
>> +{									\
>> +	struct kgr_loc_caches *c = ops->private;			\
>> +									\
>> +	if (task_thread_info(current)->kgr_in_progress && current->mm) {\
> 
> Is there a race here? The per task kgr_in_progress is set after
> the slow stub is registered in register_ftrace_function(). If the
> patched function is called in between it will be redirected to new code.

Hi Aravinda!

Yes, you are right. I have just fixed by first setting the flag, then
start patching.

>> +		pr_info("kgr: slow stub: calling old code at %lx\n",	\
>> +				c->old);				\
>> +		regs->ip = c->old + MCOUNT_INSN_SIZE;			\
>> +	} else {							\
>> +		pr_info("kgr: slow stub: calling new code at %lx\n",	\
>> +				c->new);				\
>> +		regs->ip = c->new;					\
>> +	}								\
> 
> [...]
> 
>> +static void kgr_mark_processes(void)
>> +{
>> +	struct task_struct *p;
>> +
>> +	read_lock(&tasklist_lock);
>> +	for_each_process(p)
>> +		task_thread_info(p)->kgr_in_progress = true;
> 
> Is there a need for memory barrier here (or in slow stub) to avoid
> the race if the slow stub is about to be called from a thread executing
> on another CPU?

Yes, it should. But since we convert it to bit-ops in 16/16, this is no
issue in the final implementation. I will fix the "initial code" though.

>> + * kgr_start_patching -- the entry for a kgraft patch
>> + * @patch: patch to be applied
>> + *
>> + * Start patching of code that is neither running in IRQ context nor
>> + * kernel thread.
>> + */
>> +int kgr_start_patching(const struct kgr_patch *patch)
>> +{
>> +	const struct kgr_patch_fun *const *patch_fun;
>> +
>> +	if (!kgr_initialized) {
>> +		pr_err("kgr: can't patch, not initialized\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	mutex_lock(&kgr_in_progress_lock);
>> +	if (kgr_in_progress) {
>> +		pr_err("kgr: can't patch, another patching not yet finalized\n");
>> +		mutex_unlock(&kgr_in_progress_lock);
>> +		return -EAGAIN;
>> +	}
>> +
>> +	for (patch_fun = patch->patches; *patch_fun; patch_fun++) {
>> +		int ret;
>> +
>> +		ret = kgr_patch_code(*patch_fun, false);
>> +		/*
>> +		 * In case any of the symbol resolutions in the set
>> +		 * has failed, patch all the previously replaced fentry
>> +		 * callsites back to nops and fail with grace
>> +		 */
>> +		if (ret < 0) {
>> +			for (; patch_fun >= patch->patches; patch_fun--)
>> +				unregister_ftrace_function((*patch_fun)->ftrace_ops_slow);
>> +			mutex_unlock(&kgr_in_progress_lock);
>> +			return ret;
>> +		}
>> +	}
>> +	kgr_in_progress = true;
>> +	kgr_patch = patch;
>> +	mutex_unlock(&kgr_in_progress_lock);
>> +
>> +	kgr_mark_processes();
>> +
>> +	/*
>> +	 * give everyone time to exit kernel, and check after a while
>> +	 */
> 
> I understand that the main intention of kgraft is to apply simple
> security fixes. However, if the patch changes the locking order,
> I think, there is a possibility of deadlock.
> 
> A thread which has not yet returned to user space calls the old
> code (not redirected to new code in slow stub) which might acquire
> the lock in the old order say lock1 followed by lock2. Meanwhile
> another thread which re-enters the kernel space, with kgr_in_progress
> unset, is redirected to the new code which acquires the lock in reverse
> order, say lock2 and lock1. This can cause deadlock.

Yes, this is a problem I was thinking of in another context yesterday.
Patching ->read or any other file_openrations which hold state over
user<->kernel switches may be a potential threat like above. The same as
in other implementations of live patching IMO. I put that on a TODO
checklist for creating patches. This has to be investigated manually
when creating a patch.

thanks for review,
-- 
js
suse labs
