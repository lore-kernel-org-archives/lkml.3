Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758659Ab3AOWpE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:45:04 -0500
Received: from mail.kernel.org ([198.145.19.201]:44855 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932470Ab3AOWo6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:44:58 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Shan Hai <shan.hai@windriver.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 005/171] powerpc/vdso: Remove redundant locking in update_vsyscall_tz()
Date: Tue, 15 Jan 2013 14:42:50 -0800
Message-Id: <20130115224313.797053808@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115224313.394976595@linuxfoundation.org>
References: <20130115224313.394976595@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/time.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -749,13 +749,8 @@ void update_vsyscall(struct timespec *wa
 
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


