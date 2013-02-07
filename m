Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422644Ab3BGUOS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 15:14:18 -0500
Received: from mail.tpi.com ([70.99.223.143]:2882 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757326Ab3BGUOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 15:14:17 -0500
From: Tim Gardner <tim.gardner@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>,
        Brett Rudley <brudley@broadcom.com>,
        Arend van Spriel <arend@broadcom.com>,
        "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
        Hante Meuleman <meuleman@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        Pieter-Paul Giesberts <pieterpg@broadcom.com>,
        Hauke Mehrtens <hauke@hauke-m.de>, linux-wireless@vger.kernel.org,
        brcm80211-dev-list@broadcom.com, netdev@vger.kernel.org
Subject: [PATCH wireless-next] brcmsmac: avoid 512 byte stack variable
Date: Thu,  7 Feb 2013 13:13:52 -0700
Message-Id: <1360268032-52414-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dynamically allocate the probe response template which
avoids potential stack corruption. Observed with smatch:

drivers/net/wireless/brcm80211/brcmsmac/main.c:7412 brcms_c_bss_update_probe_resp()
 warn: 'prb_resp' puts 512 bytes on stack

Cc: Brett Rudley <brudley@broadcom.com>
Cc: Arend van Spriel <arend@broadcom.com>
Cc: "Franky (Zhenhui) Lin" <frankyl@broadcom.com>
Cc: Hante Meuleman <meuleman@broadcom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: Seth Forshee <seth.forshee@canonical.com>
Cc: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org
Cc: brcm80211-dev-list@broadcom.com
Cc: netdev@vger.kernel.org
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/main.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index c26992a..e392e76 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -7408,9 +7408,16 @@ brcms_c_bss_update_probe_resp(struct brcms_c_info *wlc,
 			      struct brcms_bss_cfg *cfg,
 			      bool suspend)
 {
-	u16 prb_resp[BCN_TMPL_LEN / 2];
+	u16 *prb_resp;
 	int len = BCN_TMPL_LEN;
 
+	prb_resp = kmalloc(BCN_TMPL_LEN, GFP_ATOMIC);
+	if (!prb_resp) {
+		wiphy_err(wlc->wiphy, "wl: %s: failed to alloc %u bytes\n",
+			__func__, BCN_TMPL_LEN);
+		return;
+	}
+
 	/*
 	 * write the probe response to hardware, or save in
 	 * the config structure
@@ -7444,6 +7451,8 @@ brcms_c_bss_update_probe_resp(struct brcms_c_info *wlc,
 
 	if (suspend)
 		brcms_c_enable_mac(wlc);
+
+	kfree(prb_resp);
 }
 
 void brcms_c_update_probe_resp(struct brcms_c_info *wlc, bool suspend)
-- 
1.7.9.5

