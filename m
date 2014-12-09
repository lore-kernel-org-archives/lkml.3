Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948AbaLIJin (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 04:38:43 -0500
Received: from smarthost01c.mail.zen.net.uk ([212.23.1.5]:50213 "EHLO
	smarthost01c.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754052AbaLIJim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 04:38:42 -0500
Message-ID: <1418117915.3641.16.camel@linaro.org>
Subject: Re: [RESEND][PATCH v15 7/7] ARM: kprobes: enable OPTPROBES for ARM
 32
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: Wang Nan <wangnan0@huawei.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Li Zefan <lizefan@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Date: Tue, 09 Dec 2014 09:38:35 +0000
In-Reply-To: <54865AF2.5040707@huawei.com>
References: <54865AF2.5040707@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01c-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-12-09 at 10:14 +0800, Wang Nan wrote:
> Hi all,
> 
> Looks like v15 patch solves the problems found in patch v13 and v14. I run Tixy's test
> cases in a loop for a whole night on two real unpublished Hisilicon ARM A15 SoCs (I
> backported kprobes to 3.10 kernel), no problem arise, they are still running now.


I get a reproducible failure (below), but I believe it is a flaw in the
test code. Now that we have optimised probes there is a window of
opportunity for and interrupt to happen between the the kprobe which
sets up the test preconditions and the tested probe executing. That will
change the contents of stack memory below SP and make it inconsistent
between test runs.

This recent flurry of kprobes work has been eating up my time somewhat
and I have other urgent matters I should attend to, so I won't be
looking at this problem for a few days.

That test failure...

strh	r3, [r13, #-64]!	@ e16d34b0
FAIL: test memory differs
FAIL: Test strh	r3, [r13, #-64]!
FAIL: Scenario 1
initial_regs:
r0  21522152 | r1  21522052 | r2  21522352 | r3  12345678
r4  21522552 | r5  21522452 | r6  21522752 | r7  21522652
r8  21522952 | r9  21522852 | r10 21522b52 | r11 21522a52
r12 21522d52 | sp  bf053ea0 | lr  21522f52 | pc  80028cf0
cpsr 18010013
expected_regs:
r0  21522152 | r1  21522052 | r2  21522352 | r3  12345678
r4  21522552 | r5  21522452 | r6  21522752 | r7  21522652
r8  21522952 | r9  21522852 | r10 21522b52 | r11 21522a52
r12 21522d52 | sp  bf053e60 | lr  21522f52 | pc  80028cf4
cpsr 18010013
result_regs:
r0  21522152 | r1  21522052 | r2  21522352 | r3  12345678
r4  21522552 | r5  21522452 | r6  21522752 | r7  21522652
r8  21522952 | r9  21522852 | r10 21522b52 | r11 21522a52
r12 21522d52 | sp  bf053e60 | lr  21522f52 | pc  80028cf4
cpsr 18010013
current_stack=bf053da0
expected_memory:
21525678 12345678 21522552 21522452
21522752 21522652 21522952 21522852
21522b52 21522a52 21522d52 bf053ea0
21522f52 80028cf0 18010113 ffffffff
result_memory:
45675678 4567baab 4567bbab 4567bcab
4567bdab 4567beab 4567bfab 4567c0ab
4567c1ab 4567c2ab 4567c3ab 4567c4ab
4567c5ab 4567c6ab 4567c7ab 4567c8ab
strh r3, [r13, #-64-8]!	@ e16d34b8
strh	r4, [r14, #-64-8]!	@ e16e44b8

-- 
Tixy


