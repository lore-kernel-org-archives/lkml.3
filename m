Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964884Ab3BTUP6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 15:15:58 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:54854 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936000Ab3BTUPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 15:15:55 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Ilya Zykov <ilya@ilyx.ru>, Dave Jones <davej@redhat.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Shawn Guo <shawn.guo@linaro.org>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v4 31/32] tty: Fix tty_ldisc_lock name collision
Date: Wed, 20 Feb 2013 15:03:18 -0500
Message-Id: <1361390599-15195-32-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
References: <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
In-Reply-To: <1360095638-6624-1-git-send-email-peter@hurleysoftware.com>
References: <1360095638-6624-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_ldisc.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index 9725c94..ba49c0e 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -44,7 +44,7 @@ enum {
  *	callers who will do ldisc lookups and cannot sleep.
  */
 
-static DEFINE_RAW_SPINLOCK(tty_ldisc_lock);
+static DEFINE_RAW_SPINLOCK(tty_ldiscs_lock);
 /* Line disc dispatch table */
 static struct tty_ldisc_ops *tty_ldiscs[NR_LDISCS];
 
@@ -58,7 +58,7 @@ static struct tty_ldisc_ops *tty_ldiscs[NR_LDISCS];
  *	from this point onwards.
  *
  *	Locking:
- *		takes tty_ldisc_lock to guard against ldisc races
+ *		takes tty_ldiscs_lock to guard against ldisc races
  */
 
 int tty_register_ldisc(int disc, struct tty_ldisc_ops *new_ldisc)
@@ -69,11 +69,11 @@ int tty_register_ldisc(int disc, struct tty_ldisc_ops *new_ldisc)
 	if (disc < N_TTY || disc >= NR_LDISCS)
 		return -EINVAL;
 
-	raw_spin_lock_irqsave(&tty_ldisc_lock, flags);
+	raw_spin_lock_irqsave(&tty_ldiscs_lock, flags);
 	tty_ldiscs[disc] = new_ldisc;
 	new_ldisc->num = disc;
 	new_ldisc->refcount = 0;
-	raw_spin_unlock_irqrestore(&tty_ldisc_lock, flags);
+	raw_spin_unlock_irqrestore(&tty_ldiscs_lock, flags);
 
 	return ret;
 }
@@ -88,7 +88,7 @@ EXPORT_SYMBOL(tty_register_ldisc);
  *	currently in use.
  *
  *	Locking:
- *		takes tty_ldisc_lock to guard against ldisc races
+ *		takes tty_ldiscs_lock to guard against ldisc races
  */
 
 int tty_unregister_ldisc(int disc)
@@ -99,12 +99,12 @@ int tty_unregister_ldisc(int disc)
 	if (disc < N_TTY || disc >= NR_LDISCS)
 		return -EINVAL;
 
-	raw_spin_lock_irqsave(&tty_ldisc_lock, flags);
+	raw_spin_lock_irqsave(&tty_ldiscs_lock, flags);
 	if (tty_ldiscs[disc]->refcount)
 		ret = -EBUSY;
 	else
 		tty_ldiscs[disc] = NULL;
-	raw_spin_unlock_irqrestore(&tty_ldisc_lock, flags);
+	raw_spin_unlock_irqrestore(&tty_ldiscs_lock, flags);
 
 	return ret;
 }
@@ -115,7 +115,7 @@ static struct tty_ldisc_ops *get_ldops(int disc)
 	unsigned long flags;
 	struct tty_ldisc_ops *ldops, *ret;
 
-	raw_spin_lock_irqsave(&tty_ldisc_lock, flags);
+	raw_spin_lock_irqsave(&tty_ldiscs_lock, flags);
 	ret = ERR_PTR(-EINVAL);
 	ldops = tty_ldiscs[disc];
 	if (ldops) {
@@ -125,7 +125,7 @@ static struct tty_ldisc_ops *get_ldops(int disc)
 			ret = ldops;
 		}
 	}
-	raw_spin_unlock_irqrestore(&tty_ldisc_lock, flags);
+	raw_spin_unlock_irqrestore(&tty_ldiscs_lock, flags);
 	return ret;
 }
 
@@ -133,10 +133,10 @@ static void put_ldops(struct tty_ldisc_ops *ldops)
 {
 	unsigned long flags;
 
-	raw_spin_lock_irqsave(&tty_ldisc_lock, flags);
+	raw_spin_lock_irqsave(&tty_ldiscs_lock, flags);
 	ldops->refcount--;
 	module_put(ldops->owner);
-	raw_spin_unlock_irqrestore(&tty_ldisc_lock, flags);
+	raw_spin_unlock_irqrestore(&tty_ldiscs_lock, flags);
 }
 
 /**
@@ -149,7 +149,7 @@ static void put_ldops(struct tty_ldisc_ops *ldops)
  *	available
  *
  *	Locking:
- *		takes tty_ldisc_lock to guard against ldisc races
+ *		takes tty_ldiscs_lock to guard against ldisc races
  */
 
 static struct tty_ldisc *tty_ldisc_get(struct tty_struct *tty, int disc)
-- 
1.8.1.2

