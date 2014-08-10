Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751276AbaHJHaE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 03:30:04 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50950 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbaHJHaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 03:30:03 -0400
Date: Sun, 10 Aug 2014 09:29:59 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Miguel Oliveira <cmroliv@gmail.com>, gulsah.1004@gmail.com,
        peter.p.waskiewicz.jr@intel.com, kristina.martsenko@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] staging: nokia_h4: switch to right types and use
 bdaddr_t
Message-ID: <20140810072959.GA19735@amd.pavel.ucw.cz>
References: <1401445633-5290-1-git-send-email-cmroliv@gmail.com>
 <20140530123023.GA10549@amd.pavel.ucw.cz>
 <20140530155959.GA10682@kroah.com>
 <201405301815.10811@pali>
 <20140530163604.GA11943@kroah.com>
 <DB71A450-EF1D-479F-9111-A36FF8EA89B2@holtmann.org>
 <20140806213055.GA26046@amd.pavel.ucw.cz>
 <20140807002532.GB23406@kroah.com>
 <20140807081328.GB24700@amd.pavel.ucw.cz>
 <20140807202407.GC6060@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140807202407.GC6060@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Switch bluetooth address to right type and use bacmp to replace
explicit checks for zero addresses.
    
Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/drivers/staging/nokia_h4p/hci_h4p.h b/drivers/staging/nokia_h4p/hci_h4p.h
index 99c4da6..76eaaaa 100644
--- a/drivers/staging/nokia_h4p/hci_h4p.h
+++ b/drivers/staging/nokia_h4p/hci_h4p.h
@@ -77,7 +77,7 @@ struct hci_h4p_info {
 	unsigned long rx_state;
 	unsigned long garbage_bytes;
 
-	u8 bd_addr[6];
+	bdaddr_t bd_addr;
 	struct sk_buff_head *fw_q;
 
 	int pm_enabled;
diff --git a/drivers/staging/nokia_h4p/nokia_core.c b/drivers/staging/nokia_h4p/nokia_core.c
index 775e1d0..79d8b01 100644
--- a/drivers/staging/nokia_h4p/nokia_core.c
+++ b/drivers/staging/nokia_h4p/nokia_core.c
@@ -993,7 +993,7 @@ static ssize_t hci_h4p_store_bdaddr(struct device *dev,
 	for (i = 0; i < 6; i++) {
 		if (bdaddr[i] > 0xff)
 			return -EINVAL;
-		info->bd_addr[i] = bdaddr[i] & 0xff;
+		info->bd_addr.b[i] = bdaddr[i] & 0xff;
 	}
 
 	return count;
@@ -1004,7 +1004,7 @@ static ssize_t hci_h4p_show_bdaddr(struct device *dev,
 {
 	struct hci_h4p_info *info = dev_get_drvdata(dev);
 
-	return sprintf(buf, "%pMR\n", info->bd_addr);
+	return sprintf(buf, "%pMR\n", info->bd_addr.b);
 }
 
 static DEVICE_ATTR(bdaddr, S_IRUGO | S_IWUSR, hci_h4p_show_bdaddr,
diff --git a/drivers/staging/nokia_h4p/nokia_fw-bcm.c b/drivers/staging/nokia_h4p/nokia_fw-bcm.c
index 14fe3ae..054a78b 100644
--- a/drivers/staging/nokia_h4p/nokia_fw-bcm.c
+++ b/drivers/staging/nokia_h4p/nokia_fw-bcm.c
@@ -30,17 +30,17 @@ static int hci_h4p_bcm_set_bdaddr(struct hci_h4p_info *info,
 {
 	int i;
 	static const u8 nokia_oui[3] = {0x00, 0x1f, 0xdf};
-	int not_valid = !bacmp(info->bd_addr, BDADDR_ANY);
+	int not_valid = !bacmp(&info->bd_addr, BDADDR_ANY);
 
 	if (not_valid) {
 		dev_info(info->dev, "Valid bluetooth address not found, setting some random\n");
 		/* When address is not valid, use some random but Nokia MAC */
-		memcpy(info->bd_addr, nokia_oui, 3);
-		get_random_bytes(info->bd_addr + 3, 3);
+		memcpy(info->bd_addr.b, nokia_oui, 3);
+		get_random_bytes(info->bd_addr.b + 3, 3);
 	}
 
 	for (i = 0; i < 6; i++)
-		skb->data[9 - i] = info->bd_addr[i];
+		skb->data[9 - i] = info->bd_addr.b[i];
 
 	return 0;
 }
diff --git a/drivers/staging/nokia_h4p/nokia_fw-csr.c b/drivers/staging/nokia_h4p/nokia_fw-csr.c
index 925ed86d0..a2c58c4 100644
--- a/drivers/staging/nokia_h4p/nokia_fw-csr.c
+++ b/drivers/staging/nokia_h4p/nokia_fw-csr.c
@@ -48,7 +48,7 @@ int hci_h4p_bc4_send_fw(struct hci_h4p_info *info,
 	static const u8 nokia_oui[3] = {0x00, 0x19, 0x4F};
 	struct sk_buff *skb;
 	unsigned int offset;
-	int retries, count, i, not_valid;
+	int retries, count, not_valid;
 	unsigned long flags;
 
 	info->fw_error = 0;
@@ -65,21 +65,21 @@ int hci_h4p_bc4_send_fw(struct hci_h4p_info *info,
 		skb->data[offset + 1] = 0x00;
 		skb->data[offset + 5] = 0x00;
 
-		not_valid = !bacmp(info->bd_addr, BDADDR_ANY);
+		not_valid = !bacmp(&info->bd_addr, BDADDR_ANY);
 
 		if (not_valid) {
 			dev_info(info->dev, "Valid bluetooth address not found, setting some random\n");
 			/* When address is not valid, use some random */
-			memcpy(info->bd_addr, nokia_oui, 3);
-			get_random_bytes(info->bd_addr + 3, 3);
+			memcpy(info->bd_addr.b, nokia_oui, 3);
+			get_random_bytes(info->bd_addr.b + 3, 3);
 		}
 
-		skb->data[offset + 7] = info->bd_addr[0];
-		skb->data[offset + 6] = info->bd_addr[1];
-		skb->data[offset + 4] = info->bd_addr[2];
-		skb->data[offset + 0] = info->bd_addr[3];
-		skb->data[offset + 3] = info->bd_addr[4];
-		skb->data[offset + 2] = info->bd_addr[5];
+		skb->data[offset + 7] = info->bd_addr.b[0];
+		skb->data[offset + 6] = info->bd_addr.b[1];
+		skb->data[offset + 4] = info->bd_addr.b[2];
+		skb->data[offset + 0] = info->bd_addr.b[3];
+		skb->data[offset + 3] = info->bd_addr.b[4];
+		skb->data[offset + 2] = info->bd_addr.b[5];
 	}
 
 	for (count = 1; ; count++) {

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
