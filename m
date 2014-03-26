Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756457AbaCZVfO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 17:35:14 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:7931 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755910AbaCZVfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 17:35:09 -0400
X-IronPort-AV: E=Sophos;i="4.97,737,1389740400"; 
   d="scan'208";a="64902683"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: "David S. Miller" <davem@davemloft.net>
Cc: kernel-janitors@vger.kernel.org, tglx@linutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] atm: replace del_timer by del_timer_sync
Date: Wed, 26 Mar 2014 22:33:40 +0100
Message-Id: <1395869625-15209-3-git-send-email-Julia.Lawall@lip6.fr>
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

 net/atm/mpc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/atm/mpc.c b/net/atm/mpc.c
index b71ff6b..91dc58f 100644
--- a/net/atm/mpc.c
+++ b/net/atm/mpc.c
@@ -1492,7 +1492,7 @@ static void __exit atm_mpoa_cleanup(void)
 
 	mpc_proc_clean();
 
-	del_timer(&mpc_timer);
+	del_timer_sync(&mpc_timer);
 	unregister_netdevice_notifier(&mpoa_notifier);
 	deregister_atm_ioctl(&atm_ioctl_ops);
 

