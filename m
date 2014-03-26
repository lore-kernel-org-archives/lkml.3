Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628AbaCZVhy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 17:37:54 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:7931 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756161AbaCZVfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 17:35:10 -0400
X-IronPort-AV: E=Sophos;i="4.97,737,1389740400"; 
   d="scan'208";a="64902685"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: kernel-janitors@vger.kernel.org, tglx@linutronix.de,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] tty: serial: replace del_timer by del_timer_sync
Date: Wed, 26 Mar 2014 22:33:42 +0100
Message-Id: <1395869625-15209-5-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395869625-15209-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1395869625-15209-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Use del_timer_sync to ensure that the timer is stopped on all CPUs before
the driver exists.

This change was suggested by Thomas Gleixner.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r@
declarer name module_exit;
identifier ex;
@@

module_exit(ex);

@@
identifier r.ex;
@@

ex(...) {
  <...
- del_timer
+ del_timer_sync
    (...)
  ...>
}
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
Not tested.

 drivers/tty/serial/mux.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/mux.c b/drivers/tty/serial/mux.c
index 7fd6aaa..19845e3 100644
--- a/drivers/tty/serial/mux.c
+++ b/drivers/tty/serial/mux.c
@@ -613,7 +613,7 @@ static void __exit mux_exit(void)
 {
 	/* Delete the Mux timer. */
 	if(port_cnt > 0) {
-		del_timer(&mux_timer);
+		del_timer_sync(&mux_timer);
 #ifdef CONFIG_SERIAL_MUX_CONSOLE
 		unregister_console(&mux_console);
 #endif

