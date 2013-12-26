Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356Ab3LZP3T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 10:29:19 -0500
Received: from mail-we0-f176.google.com ([74.125.82.176]:47115 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273Ab3LZP3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 10:29:18 -0500
Date: Thu, 26 Dec 2013 16:29:15 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linaro Networking <linaro-networking@linaro.org>
Subject: Re: [Query]: trace-cmd crashing with '-e syscalls' on 3.13-rc1
Message-ID: <20131226152913.GB15303@localhost.localdomain>
References: <CAKohpom5JmFamPpOsyPRqXNAqXu6VF_t0zXXhT90MCMutp5FgQ@mail.gmail.com>
 <20131224084801.57439ca2@gandalf.local.home>
 <CAKohpom3haZ+LSdOtAjCM7x2C4YOC_a31OMPeE05ung4MAR68g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpom3haZ+LSdOtAjCM7x2C4YOC_a31OMPeE05ung4MAR68g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 26, 2013 at 11:51:53AM +0530, Viresh Kumar wrote:
> On 24 December 2013 19:18, Steven Rostedt <rostedt@goodmis.org> wrote:
> > Can you also produce this with just
> > "echo 1 > /sys/kernel/debug/tracing/events/syscalls/enable"?
> 
> Yeah, running any command after doing above results in crash.
> I tried this on latest mainline:
> 
> c5fdd53 Merge branch 'for-linus' of git://git.kernel.dk/linux-block
> 
> with CONFIG_NO_HZ_FULL disabled.
> 
> root@linaro-developer:/home/linaro# echo 1 >
> /sys/kernel/debug/tracing/events/syscalls/enable
> root@linaro-developer:/home/linaro# ls
> [  158.697900] Unable to handle kernel NULL pointer dereference at
> virtual address 0000001b
> [  158.704783] pgd = ee644000
> [  158.707321] [0000001b] *pgd=6e4f9831, *pte=00000000, *ppte=00000000
> [  158.713525] Internal error: Oops: 17 [#1] PREEMPT SMP ARM
> [  158.718928] Modules linked in:
> [  158.721942] CPU: 1 PID: 2004 Comm: ls Not tainted
> 3.13.0-rc5-00075-gd5b6a3e #142
> [  158.729372] task: ee9bf0c0 ti: ee642000 task.ti: ee642000
> [  158.734754] PC is at ftrace_syscall_enter+0x44/0x178
> [  158.739691] LR is at syscall_trace_enter+0xf8/0x144
> [  158.744539] pc : [<c00ad5dc>]    lr : [<c0010f08>]    psr: a0000013

Hi Viresh,

Please post your config, I'll try to at least narrow down the issue
to the faulting instruction.

Thanks!

> [  158.744539] sp : ee643f40  ip : ee643f80  fp : ee643f7c
> [  158.756043] r10: 00000400  r9 : ee642000  r8 : c000eee4
> [  158.761203] r7 : ee643fb0  r6 : ee642000  r5 : ffffffff  r4 : 000f0005
> [  158.767723] r3 : ee642000  r2 : 000f001d  r1 : ee643fb0  r0 : c06cd2f8
> [  158.774236] Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
> [  158.781357] Control: 10c5387d  Table: 6e64406a  DAC: 00000015
> [  158.787074] Process ls (pid: 2004, stack limit = 0xee642240)
> [  158.792712] Stack: (0xee643f40 to 0xee644000)
> [  158.797062] 3f40: ef1c4910 00000000 ee643f8c 00000022 00000003
> ee961890 000f0005 ee642000
> [  158.805251] 3f60: ee643fb0 c000eee4 ee642000 00000400 ee643fa4
> ee643f80 c0010f08 c00ad5a4
> [  158.813432] 3f80: b6f2e4c0 b6f2fc60 00000002 00000000 000f0005
> c000eee4 00000000 ee643fa8
> [  158.821585] 3fa0: c000ee8c c0010e1c b6f2fc60 00000002 b6f2e4c0
> b6f35050 b6f2ebe8 b6f2e4c0
> [  158.829744] 3fc0: b6f2fc60 00000002 00000000 000f0005 00000001
> 00000000 000188bc b6f35958
> [  158.837901] 3fe0: 000f0005 bed314a0 b6f168fb b6f26966 80000030
> b6f2e4c0 6f7fd821 6f7fdc21
> [  158.846103] [<c00ad5dc>] (ftrace_syscall_enter+0x44/0x178) from
> [<c0010f08>] (syscall_trace_enter+0xf8/0x144)
> [  158.856004] [<c0010f08>] (syscall_trace_enter+0xf8/0x144) from
> [<c000ee8c>] (__sys_trace+0xc/0x38)
> [  158.864915] Code: e2842018 e7905102 e3550000 0a000037 (e595201c)
> [  158.871136] ---[ end trace 70ef73d275f741de ]---
> [  158.875673] note: ls[2004] exited with preempt_count 1
> Segmentation fault
