Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003Ab3HFPwR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 11:52:17 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:51519 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755113Ab3HFPwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 11:52:15 -0400
X-AuditID: cbfee61a-b7f196d000007dfa-57-52011baef072
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux@arm.linux.org.uk, mturquette@linaro.org, jiada_wang@mentor.com,
        broonie@kernel.org, vapier@gentoo.org, ralf@linux-mips.org,
        lethal@linux-sh.org, kyungmin.park@samsung.com, shawn.guo@linaro.org,
        sebastian.hesselbarth@gmail.com, LW@KARO-electronics.de,
        t.figa@samsung.com, g.liakhovetski@gmx.de,
        laurent.pinchart@ideasonboard.com, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org, linux-mips@linux-mips.org,
        linux-sh@vger.kernel.org, Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC 0/2] Clock unregistration support in the common clock
 framework
Date: Tue, 06 Aug 2013 17:51:55 +0200
Message-id: <1375804317-10576-1-git-send-email-s.nawrocki@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBLMWRmVeSWpSXmKPExsVy+t9jQd110oxBBq8WKFhMffiEzeL9xnlM
	Fj1/Ki3ONr1ht+icuITdYv/bn6wWmx5fY7W4vGsOm8WEqZPYLeb8mcJscfsyr8WBJ8vZLJ5O
	uMhmcWmPisXhN+2sFu9/Olo8XbeE2WL9jNcsFgsbvrBb3Jzwg9lBxKOluYfNY+V0b4/L398w
	e+ycdZfd48PHOI/ZHTNZPeZPf8TssWlVJ5vHnWt72DyOrlzL5HH6/SFWj81L6j12f21i9Ojb
	sorR4/MmuQD+KC6blNSczLLUIn27BK6MM/vPshYcE6iYs2o6UwPjIt4uRk4OCQETic2PXjFD
	2GISF+6tZ+ti5OIQEpjOKLHj2RlWCKeDSeLTmg5GkCo2AUOJ3qN9YLaIgIbElK7H7CBFzAId
	LBIt076CJYQFQiWmvHzJCmKzCKhKvJp4CMzmFXCT+LxqK9AKDqB1ChJzJtlMYORewMiwilE0
	tSC5oDgpPddQrzgxt7g0L10vOT93EyM4/J9J7WBc2WBxiFGAg1GJh7dCjDFIiDWxrLgy9xCj
	BAezkgivjwRQiDclsbIqtSg/vqg0J7X4EKM0B4uSOO+BVutAIYH0xJLU7NTUgtQimCwTB6dU
	A6P9as0nT0UfrFA0YxWu1ebzt97IlfRHraFqosB+1uuntRPtA1ZGVVu+yQtk45e6cHFnaP/p
	n1sfrJ1bl7r/ZKEy40LxnEsBtzffLu7frlN+IVt4Yba+oXiGwII5lVOzr10pObY1/OPqmp7P
	K6w/umVoPkz76ZkvLT5B78Jp1oNRWmtnc6jNPKfEUpyRaKjFXFScCACr2qiLewIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This short patch set aims to fix issues in the common clock framework WRT
support of the clock suppliers as loadable modules. The thread [1] might
be a good summary and pre-requisiste reading on what this patch series is
trying to achieve.

The first patch adds common implementation of the __clk_get(), __clk_put()
helpers for the common clock framework. Currently these functions are empty
and the modules that registered clocks are prone to removal and leaving
invalid clock references.

The second patch adds implementation of the clk_unregister() function and
is based on patch [2].

I have some doubts whether we need to be taking reference on a module in
clk_get() _and_ use kref to keep track of references to a clock. Taking
reference on a module only seems insufficient, since a clock supplier
driver can be unbound from its device through sysfs, even if the module
stays in place.

We could be doing only reference counting on the clock, but then there
are issues as Russell clearly explained in [1]. It is not obvious what
to do with a clock when it has consumers and its supplier driver is
being deinitialized/unloaded [3]. IMHO clock suppliers should be normally
prevented from being removed when resources they provide are in use,
otherwise it all may get a bit hairy.

Thanks,
Sylwester

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2013-July/183302.html
[2] http://www.spinics.net/lists/arm-kernel/msg247548.html
[3] http://lists.infradead.org/pipermail/linux-arm-kernel/2013-July/183292.html


Sylwester Nawrocki (2):
  clk: add common __clk_get(), __clk_put() implementations
  clk: implement clk_unregister

 arch/arm/include/asm/clkdev.h      |    2 +
 arch/blackfin/include/asm/clkdev.h |    2 +
 arch/mips/include/asm/clkdev.h     |    2 +
 arch/sh/include/asm/clkdev.h       |    2 +
 drivers/clk/clk.c                  |  147 +++++++++++++++++++++++++++++++++++-
 include/linux/clk-private.h        |    5 ++
 include/linux/clkdev.h             |    5 ++
 7 files changed, 162 insertions(+), 3 deletions(-)

--
1.7.9.5

