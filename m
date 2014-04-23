Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081AbaDWB0n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 21:26:43 -0400
Received: from [133.145.228.5] ([133.145.228.5]:39421 "EHLO
	mail4.hitachi.co.jp" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755304AbaDWB0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 21:26:39 -0400
Message-ID: <535716A8.4050205@hitachi.com>
Date: Wed, 23 Apr 2014 10:26:00 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Takao Indoh <indou.takao@jp.fujitsu.com>
Cc: rusty@rustcorp.com.au, rostedt@goodmis.org, fweisbec@gmail.com,
        mingo@redhat.com, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com,
        davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: Re: ftrace/kprobes: Warning when insmod two modules
References: <1395637826-3312-1-git-send-email-indou.takao@jp.fujitsu.com> <5330164D.6030507@hitachi.com> <20140324105939.7f823b81@gandalf.local.home> <87bnvunhs9.fsf@rustcorp.com.au> <5355FE49.3030502@jp.fujitsu.com> <53561A06.9050405@hitachi.com> <535629E1.9090107@jp.fujitsu.com>
In-Reply-To: <535629E1.9090107@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/04/22 17:35), Takao Indoh wrote:
>>> >> But the text is already RO, so it causes panic. We need to call notifier
>>> >> before setting it RO. Or should we unset RO temporarily in
>>> >> ftrace_process_locs()?
>> > 
>> > Perhaps, IMHO, ftrace needs to change the module RW in ftrace_init_module and
>> > makes it RO after modifying the module text.
> Hmm..., I think the same problem occurs if we set module RW in
> ftrace_init_module().
> 
> <insmod module B>
> init_module
>   load_module
>     complete_formation
>       set_section_ro_nx -------------------------------------- (1)
>       set_section_ro_nx -------------------------------------- (2)
>       blocking_notifier_call_chain
>         ftrace_module_notify_enter
>           ftrace_init_module --------------------------------- (3)
>             ftrace_process_locs
>              mutex_lock(&ftrace_lock) ------------------------ (4)
>              ftrace_update_code
>                __ftrace_replace_code
>                  ftrace_make_nop
>                    ftrace_modify_code_direct
>                      do_ftrace_mod_code
>                        probe_kernel_write -------------------- (5)
> 
> 
> The text of module B is set to RO at (1) and (2) by Rusty's patch. And
> even if we change it to RW at (3), it set to RO again by another module
> while module B is waiting at (4).
> 
> So, we need to set module to RW somewhere after get ftrace_lock, maybe
> in ftrace_update_code()?

Agreed. That should be done in a protected (critical) region,
and the region must be protected by correct lock. It seems that
the ftrace_lock is not a correct one.

Thank you,


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


