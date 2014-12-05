Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203AbaLEKKg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 05:10:36 -0500
Received: from smarthost01a.mail.zen.net.uk ([212.23.1.1]:39994 "EHLO
	smarthost01a.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752454AbaLEKKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 05:10:34 -0500
X-Greylist: delayed 64083 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Dec 2014 05:10:34 EST
Message-ID: <1417774227.2232.1.camel@linaro.org>
Subject: Re: [PATCH v12 7/7] ARM: kprobes: enable OPTPROBES for ARM 32
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: Wang Nan <wangnan0@huawei.com>
Cc: masami.hiramatsu.pt@hitachi.com, linux@arm.linux.org.uk,
        lizefan@huawei.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Date: Fri, 05 Dec 2014 10:10:27 +0000
In-Reply-To: <5481289E.4060504@huawei.com>
References: <1417671172-52915-1-git-send-email-wangnan0@huawei.com>
		 <1417671360-53399-1-git-send-email-wangnan0@huawei.com>
	 <1417710073.2239.10.camel@linaro.org> <5481289E.4060504@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01a-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-12-05 at 11:38 +0800, Wang Nan wrote:
> On 2014/12/5 0:21, Jon Medhurst (Tixy) wrote:
> > On Thu, 2014-12-04 at 13:36 +0800, Wang Nan wrote:
> > 
> 
> [trim some text]
> 
> > 
> > I have retested this patch and on one of the arm test cases I get an
> > undefined instruction exception in kprobe_arm_test_cases. When this
> > happens PC points to the second nop below. 
> > 
> > 
> > 80028a38:	e320f000 	nop	{0}
> > 80028a3c:	e11000b2 	ldrh	r0, [r0, -r2]
> > 80028a40:	e320f000 	nop	{0}
> > 
> > As all three instructions will have probes on them during testing, and
> > un-optimised probes are implemented by using an undefined instruction to
> > act as a breakpoint, my first thought was that we have a race condition
> > somewhere with adding, removing or optimizing probes. Though a reboot a
> > retest failed in the same way on the same instruction, so I'm not 100%
> > convinced about strictly timing related bugs.
> >  
> 
> Does the problem appear in your platform in each time?

Three times out of three tries yes. Though the third try was built
differently and the problem occurred on a different test case.


>  Currently I have only
> QEMU machine for testing and haven't seen problem like this before.

I don't know much about QEMU and have never used it, but I'm assuming
QEMU doesn't make any attempt to simulate caches like the data cache,
instruction cache, TLBs, branch predictor? Does it even emulate multiple
CPUs with multiple host CPU threads? Basically, I very much doubt QEMU
is a very good test of kernel code in general, and especially code that
modifies code and has multiple cpus running in parallel.

Do you not have access to any kind of ARM board to try some testing on?


>  Could
> you please provide a detail steps for me to reproduce it? Or do you just
> enable kprobe test code when booting and this exception simply appear twice?

I applied the patches on top of Linux 3.18-rc5 and set VERBOSE in
arm/probes/kprobes/test-core.h to 1. Then built a kernel configured
using vexpress_defconfig and enabled

CONFIG_KPROBES=y
CONFIG_ARM_KPROBES_TEST=y
CONFIG_DEBUG_INFO=y

then booted on a Versatile Express board with a TC2 CoreTile (A15/A7
big.LITTLE CPU).

The Oops I described happened on two consecutive boots of the board. I
then tried again setting VERBOSE to 0 and I got a similar OOPs but on a
different test case.

I'm worried because this whole optimised kprobes has some rather
complicated interactions, e.g. can the background thread that changes
breakpoints to jumps (or back again?) could occur at the same time
another CPU is processing a kprobe that's been hit, or is in the process
of removing a probe.

-- 
Tixy

