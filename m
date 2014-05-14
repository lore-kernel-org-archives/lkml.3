Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884AbaENO4K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 10:56:10 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:44584 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399AbaENO4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 10:56:04 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org
Cc: patches@linaro.org, linaro-kernel@lists.linaro.org,
        Daniel Thompson <daniel.thompson@linaro.org>,
        linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Colin Cross <ccross@android.com>, kernel-team@android.com,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3/4] serial: kgdb_nmi: Switch from tasklets to real timers
Date: Wed, 14 May 2014 15:55:34 +0100
Message-Id: <1400079335-32125-4-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1400079335-32125-1-git-send-email-daniel.thompson@linaro.org>
References: <1400079335-32125-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kgdb_nmi uses tasklets on the assumption they will not be scheduled
until the next timer tick. This assumption is invalid and can lead to
live lock, continually servicing the kgdb_nmi tasklet. This is fixed
by using the timer API instead.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
---
 drivers/tty/serial/kgdb_nmi.c | 30 +++++++++---------------------
 1 file changed, 9 insertions(+), 21 deletions(-)

diff --git a/drivers/tty/serial/kgdb_nmi.c b/drivers/tty/serial/kgdb_nmi.c
index d51b2a1..20d21d0 100644
--- a/drivers/tty/serial/kgdb_nmi.c
+++ b/drivers/tty/serial/kgdb_nmi.c
@@ -80,24 +80,10 @@ static struct console kgdb_nmi_console = {
 
 struct kgdb_nmi_tty_priv {
 	struct tty_port port;
-	struct tasklet_struct tlet;
+	struct timer_list timer;
 	STRUCT_KFIFO(char, KGDB_NMI_FIFO_SIZE) fifo;
 };
 
-/*
- * Our debugging console is polled in a tasklet, so we'll check for input
- * every tick. In HZ-less mode, we should program the next tick.  We have
- * to use the lowlevel stuff as no locks should be grabbed.
- */
-#ifdef CONFIG_HIGH_RES_TIMERS
-static void kgdb_tty_poke(void)
-{
-	tick_program_event(ktime_get(), 0);
-}
-#else
-static inline void kgdb_tty_poke(void) {}
-#endif
-
 static struct tty_port *kgdb_nmi_port;
 
 static void kgdb_tty_recv(int ch)
@@ -108,14 +94,13 @@ static void kgdb_tty_recv(int ch)
 	if (!kgdb_nmi_port || ch < 0)
 		return;
 	/*
-	 * Can't use port->tty->driver_data as tty might be not there. Tasklet
+	 * Can't use port->tty->driver_data as tty might be not there. Timer
 	 * will check for tty and will get the ref, but here we don't have to
 	 * do that, and actually, we can't: we're in NMI context, no locks are
 	 * possible.
 	 */
 	priv = container_of(kgdb_nmi_port, struct kgdb_nmi_tty_priv, port);
 	kfifo_in(&priv->fifo, &c, 1);
-	kgdb_tty_poke();
 }
 
 static int kgdb_nmi_poll_one_knock(void)
@@ -199,7 +184,8 @@ static void kgdb_nmi_tty_receiver(unsigned long data)
 	struct kgdb_nmi_tty_priv *priv = (void *)data;
 	char ch;
 
-	tasklet_schedule(&priv->tlet);
+	priv->timer.expires = jiffies + (HZ/100);
+	add_timer(&priv->timer);
 
 	if (likely(!kgdb_nmi_tty_enabled || !kfifo_len(&priv->fifo)))
 		return;
@@ -215,7 +201,9 @@ static int kgdb_nmi_tty_activate(struct tty_port *port, struct tty_struct *tty)
 	    container_of(port, struct kgdb_nmi_tty_priv, port);
 
 	kgdb_nmi_port = port;
-	tasklet_schedule(&priv->tlet);
+	priv->timer.expires = jiffies + (HZ/100);
+	add_timer(&priv->timer);
+
 	return 0;
 }
 
@@ -224,7 +212,7 @@ static void kgdb_nmi_tty_shutdown(struct tty_port *port)
 	struct kgdb_nmi_tty_priv *priv =
 	    container_of(port, struct kgdb_nmi_tty_priv, port);
 
-	tasklet_kill(&priv->tlet);
+	del_timer(&priv->timer);
 	kgdb_nmi_port = NULL;
 }
 
@@ -243,7 +231,7 @@ static int kgdb_nmi_tty_install(struct tty_driver *drv, struct tty_struct *tty)
 		return -ENOMEM;
 
 	INIT_KFIFO(priv->fifo);
-	tasklet_init(&priv->tlet, kgdb_nmi_tty_receiver, (unsigned long)priv);
+	setup_timer(&priv->timer, kgdb_nmi_tty_receiver, (unsigned long)priv);
 	tty_port_init(&priv->port);
 	priv->port.ops = &kgdb_nmi_tty_port_ops;
 	tty->driver_data = priv;
-- 
1.9.0

