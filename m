Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110AbaLNUls (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 15:41:48 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53369 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbaLNUbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 15:31:47 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Catalin Iacob <iacobcatalin@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3.18 14/19] rtlwifi: rtl8192ce: Fix missing interrupt ready flag
Date: Sun, 14 Dec 2014 12:21:25 -0800
Message-Id: <20141214201823.950211816@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141214201823.543296369@linuxfoundation.org>
References: <20141214201823.543296369@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 87141db0848aa20c43d453f5545efc8f390d4372 upstream.

Proper operation with the rewritten PCI mini driver requires that a flag be set
when interrupts are enabled. This flag was missed.  This patch is one of three needed to
fix the kernel regression reported at https://bugzilla.kernel.org/show_bug.cgi?id=88951.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Reported-by: Catalin Iacob <iacobcatalin@gmail.com>
Tested-by: Catalin Iacob <iacobcatalin@gmail.com>
Cc: Catalin Iacob <iacobcatalin@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
@@ -1287,6 +1287,7 @@ void rtl92ce_enable_interrupt(struct iee
 
 	rtl_write_dword(rtlpriv, REG_HIMR, rtlpci->irq_mask[0] & 0xFFFFFFFF);
 	rtl_write_dword(rtlpriv, REG_HIMRE, rtlpci->irq_mask[1] & 0xFFFFFFFF);
+	rtlpci->irq_enabled = true;
 }
 
 void rtl92ce_disable_interrupt(struct ieee80211_hw *hw)
@@ -1296,7 +1297,7 @@ void rtl92ce_disable_interrupt(struct ie
 
 	rtl_write_dword(rtlpriv, REG_HIMR, IMR8190_DISABLED);
 	rtl_write_dword(rtlpriv, REG_HIMRE, IMR8190_DISABLED);
-	synchronize_irq(rtlpci->pdev->irq);
+	rtlpci->irq_enabled = false;
 }
 
 static void _rtl92ce_poweroff_adapter(struct ieee80211_hw *hw)


