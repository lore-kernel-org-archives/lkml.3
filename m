Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751605AbaILEms (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 00:42:48 -0400
Received: from homie.mail.dreamhost.com ([208.97.132.208]:53013 "EHLO
	homiemail-a14.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751166AbaILEmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 00:42:47 -0400
Message-ID: <1410496890.2166.11.camel@linux-t7sj.site>
Subject: [PATCH 8/9] locktorture: Support rwsems
From: Davidlohr Bueso <dave@stgolabs.net>
To: paulmck@linux.vnet.ibm.com
Cc: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        dave@stgolabs.net, dbueso@suse.de
Date: Thu, 11 Sep 2014 21:41:30 -0700
In-Reply-To: <1410493224-3312-1-git-send-email-dave@stgolabs.net>
References: <1410493224-3312-1-git-send-email-dave@stgolabs.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can easily do so with our new reader lock support. Just an arbitrary
design default: readers have higher (5x) critical region latencies than
writers: 50 ms and 10 ms, respectively.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 Documentation/locking/locktorture.txt |  2 ++
 kernel/locking/locktorture.c          | 68 ++++++++++++++++++++++++++++++++++-
 2 files changed, 69 insertions(+), 1 deletion(-)

diff --git a/Documentation/locking/locktorture.txt b/Documentation/locking/locktorture.txt
index 1bdeb71..f7d99e2 100644
--- a/Documentation/locking/locktorture.txt
+++ b/Documentation/locking/locktorture.txt
@@ -47,6 +47,8 @@ torture_type	  Type of lock to torture. By default, only spinlocks will
 
 		     o "mutex_lock": mutex_lock() and mutex_unlock() pairs.
 
+		     o "rwsem_lock": read/write down() and up() semaphore pairs.
+
 torture_runnable  Start locktorture at module init. By default it will begin
 		  once the module is loaded.
 
diff --git a/kernel/locking/locktorture.c b/kernel/locking/locktorture.c
index c1073d7..8480118 100644
--- a/kernel/locking/locktorture.c
+++ b/kernel/locking/locktorture.c
@@ -265,6 +265,71 @@ static struct lock_torture_ops mutex_lock_ops = {
 	.name		= "mutex_lock"
 };
 
+static DECLARE_RWSEM(torture_rwsem);
+static int torture_rwsem_down_write(void) __acquires(torture_rwsem)
+{
+	down_write(&torture_rwsem);
+	return 0;
+}
+
+static void torture_rwsem_write_delay(struct torture_random_state *trsp)
+{
+	const unsigned long longdelay_ms = 100;
+
+	/* We want a long delay occasionally to force massive contention.  */
+	if (!(torture_random(trsp) %
+	      (nrealwriters_stress * 2000 * longdelay_ms)))
+		mdelay(longdelay_ms * 10);
+	else
+		mdelay(longdelay_ms / 10);
+#ifdef CONFIG_PREEMPT
+	if (!(torture_random(trsp) % (nrealwriters_stress * 20000)))
+		preempt_schedule();  /* Allow test to be preempted. */
+#endif
+}
+
+static void torture_rwsem_up_write(void) __releases(torture_rwsem)
+{
+	up_write(&torture_rwsem);
+}
+
+static int torture_rwsem_down_read(void) __acquires(torture_rwsem)
+{
+	down_read(&torture_rwsem);
+	return 0;
+}
+
+static void torture_rwsem_read_delay(struct torture_random_state *trsp)
+{
+	const unsigned long longdelay_ms = 100;
+
+	/* We want a long delay occasionally to force massive contention.  */
+	if (!(torture_random(trsp) %
+	      (nrealwriters_stress * 2000 * longdelay_ms)))
+		mdelay(longdelay_ms * 2);
+	else
+		mdelay(longdelay_ms / 2);
+#ifdef CONFIG_PREEMPT
+	if (!(torture_random(trsp) % (nrealreaders_stress * 20000)))
+		preempt_schedule();  /* Allow test to be preempted. */
+#endif
+}
+
+static void torture_rwsem_up_read(void) __releases(torture_rwsem)
+{
+	up_read(&torture_rwsem);
+}
+
+static struct lock_torture_ops rwsem_lock_ops = {
+	.writelock	= torture_rwsem_down_write,
+	.write_delay	= torture_rwsem_write_delay,
+	.writeunlock	= torture_rwsem_up_write,
+	.readlock       = torture_rwsem_down_read,
+	.read_delay     = torture_rwsem_read_delay,
+	.readunlock     = torture_rwsem_up_read,
+	.name		= "rwsem_lock"
+};
+
 /*
  * Lock torture writer kthread.  Repeatedly acquires and releases
  * the lock, checking for duplicate acquisitions.
@@ -467,7 +532,8 @@ static int __init lock_torture_init(void)
 	int i, j;
 	int firsterr = 0;
 	static struct lock_torture_ops *torture_ops[] = {
-		&lock_busted_ops, &spin_lock_ops, &spin_lock_irq_ops, &mutex_lock_ops,
+		&lock_busted_ops, &spin_lock_ops, &spin_lock_irq_ops,
+		&mutex_lock_ops, &rwsem_lock_ops,
 	};
 
 	if (!torture_init_begin(torture_type, verbose, &torture_runnable))
-- 
1.8.4.5



