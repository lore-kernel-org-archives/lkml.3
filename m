Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149Ab3AMRxs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 12:53:48 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34982 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755347Ab3AMRp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 12:45:27 -0500
Message-Id: <20130113174258.756399429@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 13 Jan 2013 17:43:09 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Shan Hai <shan.hai@windriver.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 14/49] powerpc/vdso: Remove redundant locking in update_vsyscall_tz()
In-Reply-To: <20130113174255.736888844@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/powerpc/kernel/time.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index b3b1435..6f6b1cc 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -770,13 +770,8 @@ void update_vsyscall_old(struct timespec *wall_time, struct timespec *wtm,
 
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


