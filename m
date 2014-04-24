Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613AbaDXHj1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 03:39:27 -0400
Received: from ozlabs.org ([103.22.144.67]:50091 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557AbaDXHjU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 03:39:20 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Takao Indoh <indou.takao@jp.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: ftrace/kprobes: Warning when insmod two modules
In-Reply-To: <20140422094103.39488700@gandalf.local.home>
References: <1395637826-3312-1-git-send-email-indou.takao@jp.fujitsu.com> <5330164D.6030507@hitachi.com> <20140324105939.7f823b81@gandalf.local.home> <87bnvunhs9.fsf@rustcorp.com.au> <20140422094103.39488700@gandalf.local.home>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Thu, 24 Apr 2014 17:08:56 +0930
Message-ID: <87k3afdvn3.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> writes:
> On Tue, 22 Apr 2014 13:21:18 +0930
> Rusty Russell <rusty@rustcorp.com.au> wrote:
>
>
>> Sorry, was on paternity leave.
>
> Congratulations! Although having two teenage daughters myself, I'm more
> inclined to say "my condolences".

Thanks... I think!

>> I'm always nervous about adding more states, since every place which
>> examines the state has to be audited.
>
> I didn't really add a state but instead broke an existing state into
> two. More importantly, this second part of the state doesn't get
> exported to other parts of the kernel. That is, there is no notifier
> for it.
>
> This means the only place you need to audit is in module.c itself. Any
> other change requires auditing all module notifiers.

Yes, we only need to check everywhere which looks at mod->state.

>> We set the mod->state to MOD_STATE_COMING in complete_formation;
>> why don't we set NX there instead?  It also makes more sense to
>> set NX before we hit parse_args() which can execute code in the module.
>
> Well, NX is a different issue here all together. Sure if you want to,
> but that wont affect this.

RO and NX get set together in the module code, but you're right, it's
the RO which affects you.

>> +	/* Set RO and NX regions for core */
>> +	set_section_ro_nx(mod->module_core,
>> +				mod->core_text_size,
>> +				mod->core_ro_size,
>> +				mod->core_size);
>> +
>> +	/* Set RO and NX regions for init */
>> +	set_section_ro_nx(mod->module_init,
>> +				mod->init_text_size,
>> +				mod->init_ro_size,
>> +				mod->init_size);
>> +
>>  	/* Mark state as coming so strong_try_module_get() ignores us,
>>  	 * but kallsyms etc. can see us. */
>>  	mod->state = MODULE_STATE_COMING;
>> +	mutex_unlock(&module_mutex);
>> +
>> +	blocking_notifier_call_chain(&module_notify_list,
>> +				     MODULE_STATE_COMING, mod);
>
> Here we break ftrace. ftrace expects that it can still replaces the
> calls to mcount with nops here. If the text is RO, then it will crash.

I think we should apply a patch like the above for other reasons, so...

What if we call the notifier before setting ro_nx, and then set the
state after the notifier?

OTOH, if it's just ftrace (do tracepoints have an issue?) I'd rather
hardcode a ftrace_init_module() call in exactly the right place.
Notifiers which are sensitive to their exact call location tend give me
the creeps...

Cheers,
Rusty.
