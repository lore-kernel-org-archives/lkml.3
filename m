Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037AbaDXG7Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 02:59:16 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51362 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbaDXG7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 02:59:15 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.2.3
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20140219-2
Message-ID: <5358B62D.2020701@jp.fujitsu.com>
Date: Thu, 24 Apr 2014 15:58:53 +0900
From: Takao Indoh <indou.takao@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: masami.hiramatsu.pt@hitachi.com, rostedt@goodmis.org
CC: rusty@rustcorp.com.au, fweisbec@gmail.com, mingo@redhat.com,
        ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: Re: ftrace/kprobes: Warning when insmod two modules
References: <1395637826-3312-1-git-send-email-indou.takao@jp.fujitsu.com> <5330164D.6030507@hitachi.com> <20140324105939.7f823b81@gandalf.local.home> <87bnvunhs9.fsf@rustcorp.com.au> <5355FE49.3030502@jp.fujitsu.com> <53561A06.9050405@hitachi.com> <535629E1.9090107@jp.fujitsu.com> <535716A8.4050205@hitachi.com> <20140422215637.6920fb4a@gandalf.local.home> <5357277B.10208@hitachi.com>
In-Reply-To: <5357277B.10208@hitachi.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/04/23 11:37), Masami Hiramatsu wrote:
> (2014/04/23 10:56), Steven Rostedt wrote:
>> On Wed, 23 Apr 2014 10:26:00 +0900
>> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
>>
>>
>>> Agreed. That should be done in a protected (critical) region,
>>> and the region must be protected by correct lock. It seems that
>>> the ftrace_lock is not a correct one.
>>
>> The setting of RO to RW done by ftrace before doing the normal
>> modification is under the ftrace_lock mutex. Why wouldn't that be the
>> correct lock?
> 
> Hmm, Ok. I checked that currently ftrace is the only user of
> set_all_modules_text_rw(), so until another user appears,
> ftrace_lock mutex can work.  (and also, we need a comment
> on the top of such functions, about by what it is protected. )
> 
>> The issue today is with the loading of a module and ftrace
>> expecting its code to be RW. Here's the current race:
>>
>>
>> 	CPU 1				CPU 2
>> 	-----				-----
>>    load_module()
>>     module->state = MODULE_STATE_COMING
>>
>> 				register_ftrace_function()
>> 				 mutex_lock(&ftrace_lock);
>> 				 ftrace_startup()
>> 				  update_ftrace_function();
>> 				   ftrace_arch_code_modify_prepare()
>> 				    set_all_module_text_rw();
>> 				   <enables-ftrace>
>> 				    ftrace_arch_code_modify_post_process()
>> 				     set_all_module_text_ro();
>>
>> 				[ here all module text is set to RO,
>> 				  including the module that is
>> 				  loading!! ]
>>
>>     blocking_notifier_call_chain(MODULE_STATE_COMING);
>>      ftrace_init_module()
>>
>>
>>       [ tries to modify code, but it's RO, and fails! ]
>>
>> One solution is to add a way to set a single module text to ro and rw,
>> and then we can encapsulate ftrace_init_module() under ftrace_lock
>> mutex and have the ftrace_init_module() set the text to RW and then
>> back to RO, and this will keep ftrace from having issues with the
>> loaded module.
> 
> It sounds nicer solution, less side-effect.
> 
>> Now, if text poke does something similar, we need to make another mutex
>> that covers modifying text. Don't we have one already?
> 
> We have the text_mutex already :).
> 
>> The worry I have here, and why I still prefer the simple split state of
>> MODULE_STATE_COMING, is that once you add another mutex, we now have to
>> fight mutex ordering. Not to mention where else things might do this :-p
> 
> I see, however, we should take care of it, at least comment level.

Ok, I'll do this. Something like this, right?

static void ftrace_init_module(struct module *mod,
                               unsigned long *start, unsigned long *end)
{
	if (ftrace_disabled || start == end)
		return;

	/*
	 * Need ftrace_lock here to prevent someone from changing the module
	 * text to RO by set_all_modules_text_ro(). Currently ftrace is the
	 * only user of set_all_modules_text_ro(), so until another user
	 * appears, ftrace_lock mutex can work.
	 */
	mutex_lock(&ftrace_lock);

	set_one_module_text_rw(mod);
	ftrace_process_locs(mod, start, end);
	set_one_module_text_ro(mod);

	mutex_unlock(&ftrace_lock);
}

Thanks,
Takao Indoh

