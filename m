Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314AbaDVH2Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 03:28:16 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:60151 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbaDVH2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 03:28:13 -0400
Message-ID: <53561A06.9050405@hitachi.com>
Date: Tue, 22 Apr 2014 16:28:06 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Takao Indoh <indou.takao@jp.fujitsu.com>
Cc: rusty@rustcorp.com.au, rostedt@goodmis.org, fweisbec@gmail.com,
        mingo@redhat.com, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com,
        davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: Re: Re: ftrace/kprobes: Warning when insmod two modules
References: <1395637826-3312-1-git-send-email-indou.takao@jp.fujitsu.com> <5330164D.6030507@hitachi.com> <20140324105939.7f823b81@gandalf.local.home> <87bnvunhs9.fsf@rustcorp.com.au> <5355FE49.3030502@jp.fujitsu.com>
In-Reply-To: <5355FE49.3030502@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/04/22 14:29), Takao Indoh wrote:
> (2014/04/22 12:51), Rusty Russell wrote:
>> Steven Rostedt <rostedt@goodmis.org> writes:
>>> On Mon, 24 Mar 2014 20:26:05 +0900
>>> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
>>>
>>>
>>>> Thank you for reporting with this pretty backtrace :)
>>>> Steven, I think this is not the kprobe bug but ftrace (and perhaps, module).
>>>
>>> Looks to be more of a module issue than a ftrace issue.
>>>
>>>>
>>>> If the ftrace can set loading module text read only before the module subsystem
>>>> expected, I think it should be protected by the module subsystem itself
>>>> (e.g. set_all_modules_text_ro(rw) skips the modules which is MODULE_STATE_COMING)
>>>>
>>>
>>> Does this patch fix it?
>>>
>>> In-review-off-by: Steven Rostedt <rostedt@goodmis.org>
>>
>> Sorry, was on paternity leave.
>>
>> I'm always nervous about adding more states, since every place which
>> examines the state has to be audited.
>>
>> We set the mod->state to MOD_STATE_COMING in complete_formation;
>> why don't we set NX there instead?  It also makes more sense to
>> set NX before we hit parse_args() which can execute code in the module.
>>
>> In fact, we should probably call the notifier there too, so people
>> can breakpoint/tracepoint/etc parameter calls.
>>
>> Of course, this means that we set NX before the notifier; does anything
>> break?
> 
> This does not work. ftrace_process_locs() is called from the notifier,
> and it tries to change its text like this.
> 
> load_module
>   blocking_notifier_call_chain
>     ftrace_module_notify_enter
>       ftrace_init_module
>         ftrace_process_locs
>           sort
>             ftrace_swap_ips
> 
> But the text is already RO, so it causes panic. We need to call notifier
> before setting it RO. Or should we unset RO temporarily in
> ftrace_process_locs()?

Perhaps, IMHO, ftrace needs to change the module RW in ftrace_init_module and
makes it RO after modifying the module text.

Thank you,


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


