Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662AbaCZVjG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 17:39:06 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:16391 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756136AbaCZVfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 17:35:10 -0400
X-IronPort-AV: E=Sophos;i="4.97,737,1389740400"; 
   d="scan'208";a="64902684"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Willy Tarreau <willy@meta-x.org>
Cc: kernel-janitors@vger.kernel.org, tglx@linutronix.de,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] staging: panel: replace del_timer by del_timer_sync
Date: Wed, 26 Mar 2014 22:33:41 +0100
Message-Id: <1395869625-15209-4-git-send-email-Julia.Lawall@lip6.fr>
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

 drivers/staging/panel/panel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
index 08f9a48..a53f94e 100644
--- a/drivers/staging/panel/panel.c
+++ b/drivers/staging/panel/panel.c
@@ -2298,7 +2298,7 @@ static void __exit panel_cleanup_module(void)
 	unregister_reboot_notifier(&panel_notifier);
 
 	if (scan_timer.function != NULL)
-		del_timer(&scan_timer);
+		del_timer_sync(&scan_timer);
 
 	if (pprt != NULL) {
 		if (keypad_enabled) {

