Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617Ab3FZMFN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 08:05:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55801 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817Ab3FZMFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 08:05:08 -0400
Date: Wed, 26 Jun 2013 05:04:47 -0700
From: tip-bot for Maarten Lankhorst <tipbot@zytor.com>
Message-ID: <tip-f3cf139efa4bc0fe4f032af6ca3e49e38a5d9ae5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        akpm@linux-foundation.org, tglx@linutronix.de,
        maarten.lankhorst@canonical.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, tglx@linutronix.de,
        maarten.lankhorst@canonical.com
In-Reply-To: <20130620113141.4001.54331.stgit@patser>
References: <20130620113141.4001.54331.stgit@patser>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/mutexes] mutex: Add more w/
 w tests to test EDEADLK path handling
Git-Commit-ID: f3cf139efa4bc0fe4f032af6ca3e49e38a5d9ae5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 26 Jun 2013 05:04:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f3cf139efa4bc0fe4f032af6ca3e49e38a5d9ae5
Gitweb:     http://git.kernel.org/tip/f3cf139efa4bc0fe4f032af6ca3e49e38a5d9ae5
Author:     Maarten Lankhorst <maarten.lankhorst@canonical.com>
AuthorDate: Thu, 20 Jun 2013 13:31:42 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 26 Jun 2013 12:10:58 +0200

mutex: Add more w/w tests to test EDEADLK path handling

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: dri-devel@lists.freedesktop.org
Cc: linaro-mm-sig@lists.linaro.org
Cc: rostedt@goodmis.org
Cc: daniel@ffwll.ch
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/20130620113141.4001.54331.stgit@patser
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 lib/locking-selftest.c | 264 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 261 insertions(+), 3 deletions(-)

diff --git a/lib/locking-selftest.c b/lib/locking-selftest.c
index 37faefd..d554f3f 100644
--- a/lib/locking-selftest.c
+++ b/lib/locking-selftest.c
@@ -47,7 +47,7 @@ __setup("debug_locks_verbose=", setup_debug_locks_verbose);
 #define LOCKTYPE_WW	0x10
 
 static struct ww_acquire_ctx t, t2;
-static struct ww_mutex o, o2;
+static struct ww_mutex o, o2, o3;
 
 /*
  * Normal standalone locks, for the circular and irq-context
@@ -947,12 +947,12 @@ static void reset_locks(void)
 
 	I1(A); I1(B); I1(C); I1(D);
 	I1(X1); I1(X2); I1(Y1); I1(Y2); I1(Z1); I1(Z2);
-	I_WW(t); I_WW(t2); I_WW(o.base); I_WW(o2.base);
+	I_WW(t); I_WW(t2); I_WW(o.base); I_WW(o2.base); I_WW(o3.base);
 	lockdep_reset();
 	I2(A); I2(B); I2(C); I2(D);
 	init_shared_classes();
 
-	ww_mutex_init(&o, &ww_lockdep); ww_mutex_init(&o2, &ww_lockdep);
+	ww_mutex_init(&o, &ww_lockdep); ww_mutex_init(&o2, &ww_lockdep); ww_mutex_init(&o3, &ww_lockdep);
 	memset(&t, 0, sizeof(t)); memset(&t2, 0, sizeof(t2));
 	memset(&ww_lockdep.acquire_key, 0, sizeof(ww_lockdep.acquire_key));
 	memset(&ww_lockdep.mutex_key, 0, sizeof(ww_lockdep.mutex_key));
@@ -1292,6 +1292,251 @@ static void ww_test_object_lock_stale_context(void)
 	WWL(&o, &t);
 }
 
+static void ww_test_edeadlk_normal(void)
+{
+	int ret;
+
+	mutex_lock(&o2.base);
+	o2.ctx = &t2;
+	mutex_release(&o2.base.dep_map, 1, _THIS_IP_);
+
+	WWAI(&t);
+	t2 = t;
+	t2.stamp--;
+
+	ret = WWL(&o, &t);
+	WARN_ON(ret);
+
+	ret = WWL(&o2, &t);
+	WARN_ON(ret != -EDEADLK);
+
+	o2.ctx = NULL;
+	mutex_acquire(&o2.base.dep_map, 0, 1, _THIS_IP_);
+	mutex_unlock(&o2.base);
+	WWU(&o);
+
+	WWL(&o2, &t);
+}
+
+static void ww_test_edeadlk_normal_slow(void)
+{
+	int ret;
+
+	mutex_lock(&o2.base);
+	mutex_release(&o2.base.dep_map, 1, _THIS_IP_);
+	o2.ctx = &t2;
+
+	WWAI(&t);
+	t2 = t;
+	t2.stamp--;
+
+	ret = WWL(&o, &t);
+	WARN_ON(ret);
+
+	ret = WWL(&o2, &t);
+	WARN_ON(ret != -EDEADLK);
+
+	o2.ctx = NULL;
+	mutex_acquire(&o2.base.dep_map, 0, 1, _THIS_IP_);
+	mutex_unlock(&o2.base);
+	WWU(&o);
+
+	ww_mutex_lock_slow(&o2, &t);
+}
+
+static void ww_test_edeadlk_no_unlock(void)
+{
+	int ret;
+
+	mutex_lock(&o2.base);
+	o2.ctx = &t2;
+	mutex_release(&o2.base.dep_map, 1, _THIS_IP_);
+
+	WWAI(&t);
+	t2 = t;
+	t2.stamp--;
+
+	ret = WWL(&o, &t);
+	WARN_ON(ret);
+
+	ret = WWL(&o2, &t);
+	WARN_ON(ret != -EDEADLK);
+
+	o2.ctx = NULL;
+	mutex_acquire(&o2.base.dep_map, 0, 1, _THIS_IP_);
+	mutex_unlock(&o2.base);
+
+	WWL(&o2, &t);
+}
+
+static void ww_test_edeadlk_no_unlock_slow(void)
+{
+	int ret;
+
+	mutex_lock(&o2.base);
+	mutex_release(&o2.base.dep_map, 1, _THIS_IP_);
+	o2.ctx = &t2;
+
+	WWAI(&t);
+	t2 = t;
+	t2.stamp--;
+
+	ret = WWL(&o, &t);
+	WARN_ON(ret);
+
+	ret = WWL(&o2, &t);
+	WARN_ON(ret != -EDEADLK);
+
+	o2.ctx = NULL;
+	mutex_acquire(&o2.base.dep_map, 0, 1, _THIS_IP_);
+	mutex_unlock(&o2.base);
+
+	ww_mutex_lock_slow(&o2, &t);
+}
+
+static void ww_test_edeadlk_acquire_more(void)
+{
+	int ret;
+
+	mutex_lock(&o2.base);
+	mutex_release(&o2.base.dep_map, 1, _THIS_IP_);
+	o2.ctx = &t2;
+
+	WWAI(&t);
+	t2 = t;
+	t2.stamp--;
+
+	ret = WWL(&o, &t);
+	WARN_ON(ret);
+
+	ret = WWL(&o2, &t);
+	WARN_ON(ret != -EDEADLK);
+
+	ret = WWL(&o3, &t);
+}
+
+static void ww_test_edeadlk_acquire_more_slow(void)
+{
+	int ret;
+
+	mutex_lock(&o2.base);
+	mutex_release(&o2.base.dep_map, 1, _THIS_IP_);
+	o2.ctx = &t2;
+
+	WWAI(&t);
+	t2 = t;
+	t2.stamp--;
+
+	ret = WWL(&o, &t);
+	WARN_ON(ret);
+
+	ret = WWL(&o2, &t);
+	WARN_ON(ret != -EDEADLK);
+
+	ww_mutex_lock_slow(&o3, &t);
+}
+
+static void ww_test_edeadlk_acquire_more_edeadlk(void)
+{
+	int ret;
+
+	mutex_lock(&o2.base);
+	mutex_release(&o2.base.dep_map, 1, _THIS_IP_);
+	o2.ctx = &t2;
+
+	mutex_lock(&o3.base);
+	mutex_release(&o3.base.dep_map, 1, _THIS_IP_);
+	o3.ctx = &t2;
+
+	WWAI(&t);
+	t2 = t;
+	t2.stamp--;
+
+	ret = WWL(&o, &t);
+	WARN_ON(ret);
+
+	ret = WWL(&o2, &t);
+	WARN_ON(ret != -EDEADLK);
+
+	ret = WWL(&o3, &t);
+	WARN_ON(ret != -EDEADLK);
+}
+
+static void ww_test_edeadlk_acquire_more_edeadlk_slow(void)
+{
+	int ret;
+
+	mutex_lock(&o2.base);
+	mutex_release(&o2.base.dep_map, 1, _THIS_IP_);
+	o2.ctx = &t2;
+
+	mutex_lock(&o3.base);
+	mutex_release(&o3.base.dep_map, 1, _THIS_IP_);
+	o3.ctx = &t2;
+
+	WWAI(&t);
+	t2 = t;
+	t2.stamp--;
+
+	ret = WWL(&o, &t);
+	WARN_ON(ret);
+
+	ret = WWL(&o2, &t);
+	WARN_ON(ret != -EDEADLK);
+
+	ww_mutex_lock_slow(&o3, &t);
+}
+
+static void ww_test_edeadlk_acquire_wrong(void)
+{
+	int ret;
+
+	mutex_lock(&o2.base);
+	mutex_release(&o2.base.dep_map, 1, _THIS_IP_);
+	o2.ctx = &t2;
+
+	WWAI(&t);
+	t2 = t;
+	t2.stamp--;
+
+	ret = WWL(&o, &t);
+	WARN_ON(ret);
+
+	ret = WWL(&o2, &t);
+	WARN_ON(ret != -EDEADLK);
+	if (!ret)
+		WWU(&o2);
+
+	WWU(&o);
+
+	ret = WWL(&o3, &t);
+}
+
+static void ww_test_edeadlk_acquire_wrong_slow(void)
+{
+	int ret;
+
+	mutex_lock(&o2.base);
+	mutex_release(&o2.base.dep_map, 1, _THIS_IP_);
+	o2.ctx = &t2;
+
+	WWAI(&t);
+	t2 = t;
+	t2.stamp--;
+
+	ret = WWL(&o, &t);
+	WARN_ON(ret);
+
+	ret = WWL(&o2, &t);
+	WARN_ON(ret != -EDEADLK);
+	if (!ret)
+		WWU(&o2);
+
+	WWU(&o);
+
+	ww_mutex_lock_slow(&o3, &t);
+}
+
 static void ww_test_spin_nest_unlocked(void)
 {
 	raw_spin_lock_nest_lock(&lock_A, &o.base);
@@ -1498,6 +1743,19 @@ static void ww_tests(void)
 	dotest(ww_test_object_lock_stale_context, FAILURE, LOCKTYPE_WW);
 	printk("\n");
 
+	print_testname("EDEADLK handling");
+	dotest(ww_test_edeadlk_normal, SUCCESS, LOCKTYPE_WW);
+	dotest(ww_test_edeadlk_normal_slow, SUCCESS, LOCKTYPE_WW);
+	dotest(ww_test_edeadlk_no_unlock, FAILURE, LOCKTYPE_WW);
+	dotest(ww_test_edeadlk_no_unlock_slow, FAILURE, LOCKTYPE_WW);
+	dotest(ww_test_edeadlk_acquire_more, FAILURE, LOCKTYPE_WW);
+	dotest(ww_test_edeadlk_acquire_more_slow, FAILURE, LOCKTYPE_WW);
+	dotest(ww_test_edeadlk_acquire_more_edeadlk, FAILURE, LOCKTYPE_WW);
+	dotest(ww_test_edeadlk_acquire_more_edeadlk_slow, FAILURE, LOCKTYPE_WW);
+	dotest(ww_test_edeadlk_acquire_wrong, FAILURE, LOCKTYPE_WW);
+	dotest(ww_test_edeadlk_acquire_wrong_slow, FAILURE, LOCKTYPE_WW);
+	printk("\n");
+
 	print_testname("spinlock nest unlocked");
 	dotest(ww_test_spin_nest_unlocked, FAILURE, LOCKTYPE_WW);
 	printk("\n");
