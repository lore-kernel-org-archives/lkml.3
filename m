Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932246AbaFPQGj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 12:06:39 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:65495 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932191AbaFPQGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 12:06:36 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 3/9] staging: rtl8188eu: Remove function nat25_db_cleanup()
Date: Mon, 16 Jun 2014 21:35:40 +0530
Message-Id: <1402934746-29422-4-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402934746-29422-1-git-send-email-navin.patidar@gmail.com>
References: <1402934746-29422-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've removed the code which was responsible for building NAT table,
so no use of keeping nat_db_cleanup().

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_br_ext.c    |   26 ------------------------
 drivers/staging/rtl8188eu/core/rtw_cmd.c       |    3 +--
 drivers/staging/rtl8188eu/include/rtw_br_ext.h |    2 --
 drivers/staging/rtl8188eu/os_dep/os_intfs.c    |    2 --
 4 files changed, 1 insertion(+), 32 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_br_ext.c b/drivers/staging/rtl8188eu/core/rtw_br_ext.c
index 8689912..b0b1af9 100644
--- a/drivers/staging/rtl8188eu/core/rtw_br_ext.c
+++ b/drivers/staging/rtl8188eu/core/rtw_br_ext.c
@@ -247,32 +247,6 @@ static inline void __network_hash_unlink(struct nat25_network_db_entry *ent)
  *	NAT2.5 interface
  */
 
-void nat25_db_cleanup(struct adapter *priv)
-{
-	int i;
-
-	spin_lock_bh(&priv->br_ext_lock);
-
-	for (i = 0; i < NAT25_HASH_SIZE; i++) {
-		struct nat25_network_db_entry *f;
-		f = priv->nethash[i];
-		while (f != NULL) {
-			struct nat25_network_db_entry *g;
-
-			g = f->next_hash;
-			if (priv->scdb_entry == f) {
-				memset(priv->scdb_mac, 0, ETH_ALEN);
-				memset(priv->scdb_ip, 0, 4);
-				priv->scdb_entry = NULL;
-			}
-			__network_hash_unlink(f);
-			kfree(f);
-			f = g;
-		}
-	}
-	spin_unlock_bh(&priv->br_ext_lock);
-}
-
 void nat25_db_expire(struct adapter *priv)
 {
 	int i;
diff --git a/drivers/staging/rtl8188eu/core/rtw_cmd.c b/drivers/staging/rtl8188eu/core/rtw_cmd.c
index 25f1c36..bb4c703 100644
--- a/drivers/staging/rtl8188eu/core/rtw_cmd.c
+++ b/drivers/staging/rtl8188eu/core/rtw_cmd.c
@@ -2059,8 +2059,7 @@ void rtw_disassoc_cmd_callback(struct adapter *padapter, struct cmd_obj *pcmd)
 
 		RT_TRACE(_module_rtl871x_cmd_c_, _drv_err_, ("\n ***Error: disconnect_cmd_callback Fail ***\n."));
 		return;
-	} else /* clear bridge database */
-		nat25_db_cleanup(padapter);
+	}
 
 	/*  free cmd */
 	rtw_free_cmd_obj(pcmd);
diff --git a/drivers/staging/rtl8188eu/include/rtw_br_ext.h b/drivers/staging/rtl8188eu/include/rtw_br_ext.h
index f21e7a4..f0b2a20 100644
--- a/drivers/staging/rtl8188eu/include/rtw_br_ext.h
+++ b/drivers/staging/rtl8188eu/include/rtw_br_ext.h
@@ -61,6 +61,4 @@ struct br_ext_info {
 	unsigned int	nat25sc_disable;
 };
 
-void nat25_db_cleanup(struct adapter *priv);
-
 #endif /*  _RTW_BR_EXT_H_ */
diff --git a/drivers/staging/rtl8188eu/os_dep/os_intfs.c b/drivers/staging/rtl8188eu/os_dep/os_intfs.c
index 34f7370..43eaba0 100644
--- a/drivers/staging/rtl8188eu/os_dep/os_intfs.c
+++ b/drivers/staging/rtl8188eu/os_dep/os_intfs.c
@@ -1228,8 +1228,6 @@ int netdev_close(struct net_device *pnetdev)
 		rtw_led_control(padapter, LED_CTL_POWER_OFF);
 	}
 
-	nat25_db_cleanup(padapter);
-
 #ifdef CONFIG_88EU_P2P
 	rtw_p2p_enable(padapter, P2P_ROLE_DISABLE);
 #endif /* CONFIG_88EU_P2P */
-- 
1.7.10.4

