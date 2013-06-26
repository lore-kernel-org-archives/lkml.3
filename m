Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab3FZME4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 08:04:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55778 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817Ab3FZMEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 08:04:54 -0400
Date: Wed, 26 Jun 2013 05:04:38 -0700
From: tip-bot for Maarten Lankhorst <tipbot@zytor.com>
Message-ID: <tip-2fe3d4b149ccebbb384062fbbe6634439f2bf120@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        akpm@linux-foundation.org, tglx@linutronix.de,
        maarten.lankhorst@canonical.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, tglx@linutronix.de,
        maarten.lankhorst@canonical.com
In-Reply-To: <20130620113130.4001.45423.stgit@patser>
References: <20130620113130.4001.45423.stgit@patser>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/mutexes] mutex: Add more tests to lib/
 locking-selftest.c
Git-Commit-ID: 2fe3d4b149ccebbb384062fbbe6634439f2bf120
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 26 Jun 2013 05:04:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2fe3d4b149ccebbb384062fbbe6634439f2bf120
Gitweb:     http://git.kernel.org/tip/2fe3d4b149ccebbb384062fbbe6634439f2bf120
Author:     Maarten Lankhorst <maarten.lankhorst@canonical.com>
AuthorDate: Thu, 20 Jun 2013 13:31:30 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 26 Jun 2013 12:10:57 +0200

mutex: Add more tests to lib/locking-selftest.c

None of the ww_mutex codepaths should be taken in the 'normal'
mutex calls. The easiest way to verify this is by using the
normal mutex calls, and making sure o.ctx is unmodified.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: dri-devel@lists.freedesktop.org
Cc: linaro-mm-sig@lists.linaro.org
Cc: robclark@gmail.com
Cc: rostedt@goodmis.org
Cc: daniel@ffwll.ch
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/20130620113130.4001.45423.stgit@patser
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 lib/locking-selftest.c | 62 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

diff --git a/lib/locking-selftest.c b/lib/locking-selftest.c
index 9962262..37faefd 100644
--- a/lib/locking-selftest.c
+++ b/lib/locking-selftest.c
@@ -1162,6 +1162,67 @@ static void ww_test_fail_acquire(void)
 #endif
 }
 
+static void ww_test_normal(void)
+{
+	int ret;
+
+	WWAI(&t);
+
+	/*
+	 * None of the ww_mutex codepaths should be taken in the 'normal'
+	 * mutex calls. The easiest way to verify this is by using the
+	 * normal mutex calls, and making sure o.ctx is unmodified.
+	 */
+
+	/* mutex_lock (and indirectly, mutex_lock_nested) */
+	o.ctx = (void *)~0UL;
+	mutex_lock(&o.base);
+	mutex_unlock(&o.base);
+	WARN_ON(o.ctx != (void *)~0UL);
+
+	/* mutex_lock_interruptible (and *_nested) */
+	o.ctx = (void *)~0UL;
+	ret = mutex_lock_interruptible(&o.base);
+	if (!ret)
+		mutex_unlock(&o.base);
+	else
+		WARN_ON(1);
+	WARN_ON(o.ctx != (void *)~0UL);
+
+	/* mutex_lock_killable (and *_nested) */
+	o.ctx = (void *)~0UL;
+	ret = mutex_lock_killable(&o.base);
+	if (!ret)
+		mutex_unlock(&o.base);
+	else
+		WARN_ON(1);
+	WARN_ON(o.ctx != (void *)~0UL);
+
+	/* trylock, succeeding */
+	o.ctx = (void *)~0UL;
+	ret = mutex_trylock(&o.base);
+	WARN_ON(!ret);
+	if (ret)
+		mutex_unlock(&o.base);
+	else
+		WARN_ON(1);
+	WARN_ON(o.ctx != (void *)~0UL);
+
+	/* trylock, failing */
+	o.ctx = (void *)~0UL;
+	mutex_lock(&o.base);
+	ret = mutex_trylock(&o.base);
+	WARN_ON(ret);
+	mutex_unlock(&o.base);
+	WARN_ON(o.ctx != (void *)~0UL);
+
+	/* nest_lock */
+	o.ctx = (void *)~0UL;
+	mutex_lock_nest_lock(&o.base, &t);
+	mutex_unlock(&o.base);
+	WARN_ON(o.ctx != (void *)~0UL);
+}
+
 static void ww_test_two_contexts(void)
 {
 	WWAI(&t);
@@ -1415,6 +1476,7 @@ static void ww_tests(void)
 
 	print_testname("ww api failures");
 	dotest(ww_test_fail_acquire, SUCCESS, LOCKTYPE_WW);
+	dotest(ww_test_normal, SUCCESS, LOCKTYPE_WW);
 	dotest(ww_test_unneeded_slow, FAILURE, LOCKTYPE_WW);
 	printk("\n");
 
