Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965405Ab3FTLc5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 07:32:57 -0400
Received: from adelie.canonical.com ([91.189.90.139]:35006 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965378Ab3FTLcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 07:32:53 -0400
Subject: [PATCH v5 6/7] mutex: add more ww tests to test EDEADLK path handling
To: linux-kernel@vger.kernel.org
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: linux-arch@vger.kernel.org, peterz@infradead.org, x86@kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        robclark@gmail.com, rostedt@goodmis.org, daniel@ffwll.ch,
        tglx@linutronix.de, mingo@kernel.org, linux-media@vger.kernel.org
Date: Thu, 20 Jun 2013 13:31:42 +0200
Message-ID: <20130620113141.4001.54331.stgit@patser>
In-Reply-To: <20130620112811.4001.86934.stgit@patser>
References: <20130620112811.4001.86934.stgit@patser>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
---
 lib/locking-selftest.c |  264 +++++++++++++++++++++++++++++++++++++++++++++++-
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

