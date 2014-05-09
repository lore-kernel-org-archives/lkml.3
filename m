Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932068AbaEIQb6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 12:31:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49019 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757082AbaEIQbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 12:31:55 -0400
Date: Fri, 9 May 2014 09:31:40 -0700
From: tip-bot for Boris Ostrovsky <tipbot@zytor.com>
Message-ID: <tip-28b92e09e25bdc0ae864b22eacf195a74f861389@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        konrad.wilk@oracle.com, boris.ostrovsky@oracle.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, boris.ostrovsky@oracle.com, tglx@linutronix.de
In-Reply-To: <1399648287-15178-1-git-send-email-boris.ostrovsky@oracle.com>
References: <1399648287-15178-1-git-send-email-boris.ostrovsky@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, vdso, time:
  Cast tv_nsec to u64 for proper shifting in update_vsyscall()
Git-Commit-ID: 28b92e09e25bdc0ae864b22eacf195a74f861389
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  28b92e09e25bdc0ae864b22eacf195a74f861389
Gitweb:     http://git.kernel.org/tip/28b92e09e25bdc0ae864b22eacf195a74f861389
Author:     Boris Ostrovsky <boris.ostrovsky@oracle.com>
AuthorDate: Fri, 9 May 2014 11:11:27 -0400
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 9 May 2014 08:45:52 -0700

x86, vdso, time: Cast tv_nsec to u64 for proper shifting in update_vsyscall()

With tk->wall_to_monotonic.tv_nsec being a 32-bit value on 32-bit
systems, (tk->wall_to_monotonic.tv_nsec << tk->shift) in update_vsyscall()
may lose upper bits or, worse, add them since compiler will do this:
	(u64)(tk->wall_to_monotonic.tv_nsec << tk->shift)
instead of
	((u64)tk->wall_to_monotonic.tv_nsec << tk->shift)

So if, for example, tv_nsec is 0x800000 and shift is 8 we will end up
with 0xffffffff80000000 instead of 0x80000000. And then we are stuck in
the subsequent 'while' loop.

We need an explicit cast.

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Link: http://lkml.kernel.org/r/1399648287-15178-1-git-send-email-boris.ostrovsky@oracle.com
Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: <stable@vger.kernel.org> # v3.14
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/vsyscall_gtod.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
