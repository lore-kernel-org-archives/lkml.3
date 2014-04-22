Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbaDVIgM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 04:36:12 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43723 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442AbaDVIgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 04:36:06 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.2.3
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20140219-2
Message-ID: <535629E1.9090107@jp.fujitsu.com>
Date: Tue, 22 Apr 2014 17:35:45 +0900
From: Takao Indoh <indou.takao@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: masami.hiramatsu.pt@hitachi.com
CC: rusty@rustcorp.com.au, rostedt@goodmis.org, fweisbec@gmail.com,
        mingo@redhat.com, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com,
        davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: Re: ftrace/kprobes: Warning when insmod two modules
References: <1395637826-3312-1-git-send-email-indou.takao@jp.fujitsu.com> <5330164D.6030507@hitachi.com> <20140324105939.7f823b81@gandalf.local.home> <87bnvunhs9.fsf@rustcorp.com.au> <5355FE49.3030502@jp.fujitsu.com> <53561A06.9050405@hitachi.com>
In-Reply-To: <53561A06.9050405@hitachi.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/04/22 16:28), Masami Hiramatsu wrote:
> (2014/04/22 14:29), Takao Indoh wrote:
>> (2014/04/22 12:51), Rusty Russell wrote:
>>> Steven Rostedt <rostedt@goodmis.org> writes:
>>>> On Mon, 24 Mar 2014 20:26:05 +0900
>>>> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
>>>>
>>>>
>>>>> Thank you for reporting with this pretty backtrace :)
>>>>> Steven, I think this is not the kprobe bug but ftrace (and perhaps, module).
>>>>
>>>> Looks to be more of a module issue than a ftrace issue.
>>>>
>>>>>
>>>>> If the ftrace can set loading module text read only before the module subsystem
>>>>> expected, I think it should be protected by the module subsystem itself
>>>>> (e.g. set_all_modules_text_ro(rw) skips the modules which is MODULE_STATE_COMING)
>>>>>
>>>>
>>>> Does this patch fix it?
>>>>
>>>> In-review-off-by: Steven Rostedt <rostedt@goodmis.org>
>>>
>>> Sorry, was on paternity leave.
>>>
>>> I'm always nervous about adding more states, since every place which
>>> examines the state has to be audited.
>>>
>>> We set the mod->state to MOD_STATE_COMING in complete_formation;
>>> why don't we set NX there instead?  It also makes more sense to
>>> set NX before we hit parse_args() which can execute code in the module.
>>>
>>> In fact, we should probably call the notifier there too, so people
>>> can breakpoint/tracepoint/etc parameter calls.
>>>
>>> Of course, this means that we set NX before the notifier; does anything
>>> break?
>>
>> This does not work. ftrace_process_locs() is called from the notifier,
>> and it tries to change its text like this.
>>
>> load_module
>>    blocking_notifier_call_chain
>>      ftrace_module_notify_enter
>>        ftrace_init_module
>>          ftrace_process_locs
>>            sort
>>              ftrace_swap_ips
>>
>> But the text is already RO, so it causes panic. We need to call notifier
>> before setting it RO. Or should we unset RO temporarily in
>> ftrace_process_locs()?
> 
> Perhaps, IMHO, ftrace needs to change the module RW in ftrace_init_module and
> makes it RO after modifying the module text.

Hmm..., I think the same problem occurs if we set module RW in
ftrace_init_module().

<insmod module B>
init_module
  load_module
    complete_formation
      set_section_ro_nx -------------------------------------- (1)
      set_section_ro_nx -------------------------------------- (2)
      blocking_notifier_call_chain
        ftrace_module_notify_enter
          ftrace_init_module --------------------------------- (3)
            ftrace_process_locs
             mutex_lock(&ftrace_lock) ------------------------ (4)
             ftrace_update_code
               __ftrace_replace_code
                 ftrace_make_nop
                   ftrace_modify_code_direct
                     do_ftrace_mod_code
                       probe_kernel_write -------------------- (5)


The text of module B is set to RO at (1) and (2) by Rusty's patch. And
even if we change it to RW at (3), it set to RO again by another module
while module B is waiting at (4).

So, we need to set module to RW somewhere after get ftrace_lock, maybe
in ftrace_update_code()?

Thanks,
Takao Indoh

