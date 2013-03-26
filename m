Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935000Ab3CZQOz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 12:14:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54571 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933855Ab3CZQOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 12:14:06 -0400
Message-ID: <5151C94B.7000407@canonical.com>
Date: Tue, 26 Mar 2013 17:14:03 +0100
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH] lockdep/selftest: Add tests for the mixed read-write case.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rlock_AA5 will pass unexpectedly, marking the test as FAILED and breaking lockdep for everyone.

The following test should make lockdep complain, but currently doesn't:

lock(a); readlock(x);

writelock(x); lock(a);

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
---

diff --git a/lib/locking-selftest.c b/lib/locking-selftest.c
index 8a1a230..d0d2540 100644
--- a/lib/locking-selftest.c
+++ b/lib/locking-selftest.c
@@ -301,6 +301,51 @@ static void rsem_AA3(void)
 	RSL(X2); // this one should fail
 }
 
+static void rlock_AA4(void)
+{
+	ML(A);
+	RL(X1);
+	RU(X1);
+	MU(A);
+
+	RL(X1);
+	ML(A);
+}
+
+static void rsem_AA4(void)
+{
+	ML(A);
+	RSL(X1);
+	RSU(X1);
+	MU(A);
+
+	RSL(X1);
+	ML(A);
+}
+
+static void rlock_AA5(void)
+{
+	ML(A);
+	RL(X1);
+	RU(X1);
+	MU(A);
+
+	WL(X1);
+	ML(A);
+}
+
+static void rsem_AA5(void)
+{
+	ML(A);
+	RSL(X1);
+	RSU(X1);
+	MU(A);
+
+	WSL(X1);
+	ML(A);
+}
+
+
 /*
  * ABBA deadlock:
  */
@@ -1661,6 +1706,21 @@ void locking_selftest(void)
 	dotest(rsem_AA3, FAILURE, LOCKTYPE_RWSEM);
 	printk("\n");
 
+	print_testname("mixed normal-read-lock");
+	printk("             |");
+	dotest(rlock_AA4, SUCCESS, LOCKTYPE_RWLOCK);
+	printk("             |");
+	dotest(rsem_AA4, FAILURE, LOCKTYPE_RWSEM);
+	printk("\n");
+
+	print_testname("mixed normal-r/w-lock");
+	printk("             |");
+	dotest(rlock_AA5, FAILURE, LOCKTYPE_RWLOCK);
+	printk("             |");
+	dotest(rsem_AA5, FAILURE, LOCKTYPE_RWSEM);
+	printk("\n");
+
+
 	printk("  --------------------------------------------------------------------------\n");
 
 	/*

