Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759296Ab3KMObU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 09:31:20 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:64503 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759031Ab3KMObS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 09:31:18 -0500
Date: Wed, 13 Nov 2013 14:31:10 +0000
From: Will Deacon <will.deacon@arm.com>
To: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "steve.capper@linaro.org" <steve.capper@linaro.org>,
        "nico@linaro.org" <nico@linaro.org>,
        "srikar@linux.vnet.ibm.com" <srikar@linux.vnet.ibm.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "Vijaya.Kumar@caviumnetworks.com" <Vijaya.Kumar@caviumnetworks.com>,
        Jiang Liu <liuj97@gmail.com>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: Re: Re: [PATCH RFC 2/6] arm64: Kprobes with single stepping
 support
Message-ID: <20131113143110.GF28881@mudshark.cambridge.arm.com>
References: <20131108165639.GD15074@mudshark.cambridge.arm.com>
 <527DFC1C.1020107@hitachi.com>
 <CA+b37P3U=cAbUvs=2B9wA4F7S9o49vh7d-KamjPsHcz-b9ZYLA@mail.gmail.com>
 <52808D53.7080904@hitachi.com>
 <5280B6C8.7050807@hitachi.com>
 <20131111105812.GC28302@mudshark.cambridge.arm.com>
 <528114C4.5000506@hitachi.com>
 <CA+b37P08cLAvBYAXSkozLPzrpuXn=N0SUetwL6N8JL+10AtYjQ@mail.gmail.com>
 <5281D848.7000502@hitachi.com>
 <CA+b37P1sNsEXrJFfVL51sZ-SeGNCBiwXnOwCiFY8CBwSXPw+mQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+b37P1sNsEXrJFfVL51sZ-SeGNCBiwXnOwCiFY8CBwSXPw+mQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 13, 2013 at 06:55:33AM +0000, Sandeepa Prabhu wrote:
> >>> I'm unsure about arm64's debug feature behavior, what does happen when
> >>> it performs a single-step on sw-breakpoint?
> >>>
> >>>> Sandeepa: I think you need to retry Masami's test on the arm64 model, since
> >>>> I'm fairly sure it won't work as expected without some additional code.
> >>>
> >>> OK, anyway, for testing same one, we need to port ftrace first. So the next
> >
> > Sorry for confusion, s/next/fallback is what I meant. Making a kprobe module
> > can be done without ftrace port.
> >
> >>> plan is to make a kprobe module to put a probe (which just printk something)
> >>> on a specific function (e.g. vfs_symlink), and run perf record with
> >>> hw-breakpoint as below
> >>>
> >>> $ perf record -e "mem:0xXXXXXX:k" ln -s /dev/null /tmp/foo
> >>>
> >>> Note that 0xXXXXXX is the address of vfs_symlink.
> >>>
> >>> After that, you can see the message in dmesg and also check the perf result
> >>> with "sudo perf script --dump" (you can find a PERF_RECORD_SAMPLE entry if
> >>> it works)
> Hi Will, Masami,
> 
> I am not sure of 'perf' right now (my minimal rootfs doesn't have) but
> I tried to test hardware breakpoints using sample modules
> "samples/hw_breakpoint/" on arm64 upstream branch. This should use
> same kernel api as perf I believe.
> 
> 1.  Placing watchpoint ( attr.bp_type = HW_BREAKPOINT_W |
> HW_BREAKPOINT_R) upon vfs_symlink symbol, but seems watch-point is not
> triggering at all.

vfs_symlink is a function. Why would you expect to write it?

> 2.  Placing text breakpoint (modified sample module with attr.bp_type
> = HW_BREAKPOINT_X) upon vfs_symlink, and run "ln -s /dev/null
> /tmp/foo".  This time, breakpoint hit but exception is re-cursing
> infinitely!

The problem here is that we expect the overflow handler to deal with the
stepping (like GDB does via ptrace). If you don't register a handler, the
kernel will do the step (like you would get if you used perf stat -e
mem:0xNNNN:x).

Will
