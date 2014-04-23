Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164AbaDWCh4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 22:37:56 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:49794 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbaDWChy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 22:37:54 -0400
Message-ID: <5357277B.10208@hitachi.com>
Date: Wed, 23 Apr 2014 11:37:47 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Takao Indoh <indou.takao@jp.fujitsu.com>, rusty@rustcorp.com.au,
        fweisbec@gmail.com, mingo@redhat.com, ananth@in.ibm.com,
        anil.s.keshavamurthy@intel.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: Re: ftrace/kprobes: Warning when insmod two modules
References: <1395637826-3312-1-git-send-email-indou.takao@jp.fujitsu.com> <5330164D.6030507@hitachi.com> <20140324105939.7f823b81@gandalf.local.home> <87bnvunhs9.fsf@rustcorp.com.au> <5355FE49.3030502@jp.fujitsu.com> <53561A06.9050405@hitachi.com> <535629E1.9090107@jp.fujitsu.com> <535716A8.4050205@hitachi.com> <20140422215637.6920fb4a@gandalf.local.home>
In-Reply-To: <20140422215637.6920fb4a@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/04/23 10:56), Steven Rostedt wrote:
> On Wed, 23 Apr 2014 10:26:00 +0900
> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
> 
>> Agreed. That should be done in a protected (critical) region,
>> and the region must be protected by correct lock. It seems that
>> the ftrace_lock is not a correct one.
> 
> The setting of RO to RW done by ftrace before doing the normal
> modification is under the ftrace_lock mutex. Why wouldn't that be the
> correct lock?

Hmm, Ok. I checked that currently ftrace is the only user of
set_all_modules_text_rw(), so until another user appears,
ftrace_lock mutex can work.  (and also, we need a comment
on the top of such functions, about by what it is protected. )

> The issue today is with the loading of a module and ftrace
> expecting its code to be RW. Here's the current race:
> 
> 
> 	CPU 1				CPU 2
> 	-----				-----
>   load_module()
>    module->state = MODULE_STATE_COMING
> 
> 				register_ftrace_function()
> 				 mutex_lock(&ftrace_lock);
> 				 ftrace_startup()
> 				  update_ftrace_function();
> 				   ftrace_arch_code_modify_prepare()
> 				    set_all_module_text_rw();
> 				   <enables-ftrace>
> 				    ftrace_arch_code_modify_post_process()
> 				     set_all_module_text_ro();
> 
> 				[ here all module text is set to RO,
> 				  including the module that is
> 				  loading!! ]
> 
>    blocking_notifier_call_chain(MODULE_STATE_COMING);
>     ftrace_init_module()
> 
> 
>      [ tries to modify code, but it's RO, and fails! ]
> 
> One solution is to add a way to set a single module text to ro and rw,
> and then we can encapsulate ftrace_init_module() under ftrace_lock
> mutex and have the ftrace_init_module() set the text to RW and then
> back to RO, and this will keep ftrace from having issues with the
> loaded module.

It sounds nicer solution, less side-effect.

> Now, if text poke does something similar, we need to make another mutex
> that covers modifying text. Don't we have one already?

We have the text_mutex already :).

> The worry I have here, and why I still prefer the simple split state of
> MODULE_STATE_COMING, is that once you add another mutex, we now have to
> fight mutex ordering. Not to mention where else things might do this :-p

I see, however, we should take care of it, at least comment level.

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


