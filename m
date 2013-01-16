Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932943Ab3APQKi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:10:38 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36867 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932933Ab3APQKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:10:32 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Shan Hai <shan.hai@windriver.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 200/222] powerpc/vdso: Remove redundant locking in update_vsyscall_tz()
Date: Wed, 16 Jan 2013 13:56:40 -0200
Message-Id: <1358351822-7675-201-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shan Hai <shan.hai@windriver.com>

commit ce73ec6db47af84d1466402781ae0872a9e7873c upstream.

The locking in update_vsyscall_tz() is not only unnecessary because the vdso
code copies the data unproteced in __kernel_gettimeofday() but also
introduces a hard to reproduce race condition between update_vsyscall()
and update_vsyscall_tz(), which causes user space process to loop
forever in vdso code.

The following patch removes the locking from update_vsyscall_tz().

Locking is not only unnecessary because the vdso code copies the data
unprotected in __kernel_gettimeofday() but also erroneous because updating
the tb_update_count is not atomic and introduces a hard to reproduce race
condition between update_vsyscall() and update_vsyscall_tz(), which further
causes user space process to loop forever in vdso code.

The below scenario describes the race condition,
x==0	Boot CPU			other CPU
	proc_P: x==0
	    timer interrupt
		update_vsyscall
x==1		    x++;sync		settimeofday
					    update_vsyscall_tz
x==2						x++;sync
x==3		    sync;x++
						sync;x++
	proc_P: x==3 (loops until x becomes even)

Because the ++ operator would be implemented as three instructions and not
atomic on powerpc.

A similar change was made for x86 in commit 6c260d58634
("x86: vdso: Remove bogus locking in update_vsyscall_tz")

Signed-off-by: Shan Hai <shan.hai@windriver.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 arch/powerpc/kernel/time.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index be171ee..3c50ed9 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -750,13 +750,8 @@ void update_vsyscall(struct timespec *wall_time, struct timespec *wtm,
 
 void update_vsyscall_tz(void)
 {
-	/* Make userspace gettimeofday spin until we're done. */
-	++vdso_data->tb_update_count;
-	smp_mb();
 	vdso_data->tz_minuteswest = sys_tz.tz_minuteswest;
 	vdso_data->tz_dsttime = sys_tz.tz_dsttime;
-	smp_mb();
-	++vdso_data->tb_update_count;
 }
 
 static void __init clocksource_init(void)
-- 
1.7.9.5

