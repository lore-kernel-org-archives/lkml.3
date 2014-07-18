Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934926AbaGRJwm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 05:52:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36317 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933929AbaGRJwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 05:52:34 -0400
Date: Fri, 18 Jul 2014 02:52:09 -0700
From: tip-bot for Cyrill Gorcunov <tipbot@zytor.com>
Message-ID: <tip-af9c4957cf212ad9cf0bee34c95cb11de5426e85@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        gorcunov@openvz.org, xemul@parallels.com, avagin@openvz.org,
        akpm@linux-foundation.org, tglx@linutronix.de, vdavydov@parallels.com,
        mtk.manpages@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        gorcunov@openvz.org, xemul@parallels.com, avagin@openvz.org,
        akpm@linux-foundation.org, tglx@linutronix.de, vdavydov@parallels.com,
        mtk.manpages@gmail.com
In-Reply-To: <20140715215703.114365649@openvz.org>
References: <20140715215703.114365649@openvz.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] timerfd: Implement show_fdinfo method
Git-Commit-ID: af9c4957cf212ad9cf0bee34c95cb11de5426e85
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

Commit-ID:  af9c4957cf212ad9cf0bee34c95cb11de5426e85
Gitweb:     http://git.kernel.org/tip/af9c4957cf212ad9cf0bee34c95cb11de5426e85
Author:     Cyrill Gorcunov <gorcunov@openvz.org>
AuthorDate: Wed, 16 Jul 2014 01:54:52 +0400
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 18 Jul 2014 11:49:57 +0200

timerfd: Implement show_fdinfo method

For checkpoint/restore of timerfd files we need to know how exactly
the timer were armed, to be able to recreate it on restore stage.
Thus implement show_fdinfo method which provides enough information
for that.

One of significant changes I think is the addition of @settime_flags
member. Currently there are two flags TFD_TIMER_ABSTIME and
TFD_TIMER_CANCEL_ON_SET, and the second can be found from
@might_cancel variable but in case if the flags will be extended
in future we most probably will have to somehow remember them
explicitly anyway so I guss doing that right now won't hurt.

To not bloat the timerfd_ctx structure I've converted @expired
to short integer and defined @settime_flags as short too.

v2 (by avagin@, vdavydov@ and tglx@):

 - Add it_value/it_interval fields
 - Save flags being used in timerfd_setup in context

v3 (by tglx@):
 - don't forget to use CONFIG_PROC_FS

v4 (by akpm@):
 -Use define timerfd_show NULL for non c/r config

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Andrey Vagin <avagin@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Link: http://lkml.kernel.org/r/20140715215703.114365649@openvz.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 fs/timerfd.c | 34 +++++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

diff --git a/fs/timerfd.c b/fs/timerfd.c
index 0013142..77183f0 100644
--- a/fs/timerfd.c
+++ b/fs/timerfd.c
@@ -35,8 +35,9 @@ struct timerfd_ctx {
 	ktime_t moffs;
 	wait_queue_head_t wqh;
 	u64 ticks;
-	int expired;
 	int clockid;
+	short unsigned expired;
+	short unsigned settime_flags;	/* to show in fdinfo */
 	struct rcu_head rcu;
 	struct list_head clist;
 	bool might_cancel;
@@ -196,6 +197,8 @@ static int timerfd_setup(struct timerfd_ctx *ctx, int flags,
 		if (timerfd_canceled(ctx))
 			return -ECANCELED;
 	}
+
+	ctx->settime_flags = flags & TFD_SETTIME_FLAGS;
 	return 0;
 }
 
@@ -284,11 +287,40 @@ static ssize_t timerfd_read(struct file *file, char __user *buf, size_t count,
 	return res;
 }
 
+#ifdef CONFIG_PROC_FS
+static int timerfd_show(struct seq_file *m, struct file *file)
+{
+	struct timerfd_ctx *ctx = file->private_data;
+	struct itimerspec t;
+
+	spin_lock_irq(&ctx->wqh.lock);
+	t.it_value = ktime_to_timespec(timerfd_get_remaining(ctx));
+	t.it_interval = ktime_to_timespec(ctx->tintv);
+	spin_unlock_irq(&ctx->wqh.lock);
+
+	return seq_printf(m,
+			  "clockid: %d\n"
+			  "ticks: %llu\n"
+			  "settime flags: 0%o\n"
+			  "it_value: (%llu, %llu)\n"
+			  "it_interval: (%llu, %llu)\n",
+			  ctx->clockid, (unsigned long long)ctx->ticks,
+			  ctx->settime_flags,
+			  (unsigned long long)t.it_value.tv_sec,
+			  (unsigned long long)t.it_value.tv_nsec,
+			  (unsigned long long)t.it_interval.tv_sec,
+			  (unsigned long long)t.it_interval.tv_nsec);
+}
+#else
+#define timerfd_show NULL
+#endif
+
 static const struct file_operations timerfd_fops = {
 	.release	= timerfd_release,
 	.poll		= timerfd_poll,
 	.read		= timerfd_read,
 	.llseek		= noop_llseek,
+	.show_fdinfo	= timerfd_show,
 };
 
 static int timerfd_fget(int fd, struct fd *p)
