Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827AbaEIPMQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 11:12:16 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:40563 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756752AbaEIPMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 11:12:13 -0400
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, stefani@seibold.net, luto@amacapital.net,
        konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        stable@vger.kernel.org
Subject: [PATCH] time: Cast tv_nsec to u64 for proper shifting in update_vsyscall()
Date: Fri,  9 May 2014 11:11:27 -0400
Message-Id: <1399648287-15178-1-git-send-email-boris.ostrovsky@oracle.com>
X-Mailer: git-send-email 1.7.1
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With tk->wall_to_monotonic.tv_nsec being a 32-bit value on 32-bit
systems, (tk->wall_to_monotonic.tv_nsec << tk->shift) in update_vsyscall()
may lose upper bits or, worse, add them since compiler will do this:
	(u64)(tk->wall_to_monotonic.tv_nsec << tk->shift)
instead of
	((u64)tk->wall_to_monotonic.tv_nsec << tk->shift)

So if, for example, tv_nsec is 0x800000 and shift is 8 we will end up
with 0xffffffff80000000 instead of 0x80000000. And then we are stuck in
the subsequent 'while' loop.

We need explicit cast.

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: stable@vger.kernel.org
---
 arch/x86/kernel/vsyscall_gtod.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/vsyscall_gtod.c b/arch/x86/kernel/vsyscall_gtod.c
index f9c6e56..9531fbb 100644
--- a/arch/x86/kernel/vsyscall_gtod.c
+++ b/arch/x86/kernel/vsyscall_gtod.c
@@ -43,7 +43,7 @@ void update_vsyscall(struct timekeeper *tk)
 	vdata->monotonic_time_sec	= tk->xtime_sec
 					+ tk->wall_to_monotonic.tv_sec;
 	vdata->monotonic_time_snsec	= tk->xtime_nsec
-					+ (tk->wall_to_monotonic.tv_nsec
+					+ ((u64)tk->wall_to_monotonic.tv_nsec
 						<< tk->shift);
 	while (vdata->monotonic_time_snsec >=
 					(((u64)NSEC_PER_SEC) << tk->shift)) {
-- 
1.7.1

