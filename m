Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757027AbaCQSdX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 14:33:23 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:52683 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932840AbaCQScR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 14:32:17 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-96-53273fb0b79a
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Tejun Heo <tj@kernel.org>
Cc: Sekhar Nori <nsekhar@ti.com>, Kevin Hilman <khilman@deeprootsystems.com>,
        Viresh Kumar <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.hashim@st.com>, linux-ide@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com,
        spear-devel@list.st.com, b.zolnierkie@samsung.com
Subject: [PATCH 1/4] ata: ahci_platform: fix ahci_platform_data->suspend method
 handling
Date: Mon, 17 Mar 2014 19:31:55 +0100
Message-id: <1395081118-15248-2-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1395081118-15248-1-git-send-email-b.zolnierkie@samsung.com>
References: <1395081118-15248-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrALMWRmVeSWpSXmKPExsVy+t9jQd0N9urBBmePyFhsnLGe1eLcrQZW
	izsrmC02Pb7GanFsxyMmi8u75rBZ7O/dwGTR0N3DbjFnxmZWi1/LjzJarLz4l9mB2+P6q/9M
	Hjtn3WX32LSqk81jzrQmFo+TF06yeGxeUu/Rt2UVo8fTH3uZPY7f2M7k8XmTXABXFJdNSmpO
	Zllqkb5dAldGd88sxoLfHBV/Jk1haWDczN7FyMkhIWAiMeneLFYIW0ziwr31bF2MXBxCAtMZ
	Jc4/3sUO4XQxSTQ9WwLWwSZgJTGxfRUjiC0iICtxZdpDRpAiZoHHTBI7V04BKxIWiJK4sWAZ
	2FgWAVWJe4f2gzXwCnhIfNy1hw1inaJE97MJYDangKfE6h/fmUFsIaCaph3PmCcw8i5gZFjF
	KJpakFxQnJSea6RXnJhbXJqXrpecn7uJERyuz6R3MK5qsDjEKMDBqMTD+4JNPViINbGsuDL3
	EKMEB7OSCK+ECVCINyWxsiq1KD++qDQntfgQozQHi5I478FW60AhgfTEktTs1NSC1CKYLBMH
	p1QDI/8d6a1HVq9pPlMguISb93HOwQaJo0L/IubPn3FA4KjZL2drt/cpH+xer+ms6rGI9px/
	fU7IsSfOTUsOJJ2880yKSUzcVmi3xemQSD3xNS2i/xiXm9Q3xwSrbrYXvbu648AjgUPPt2iH
	zlC4Xnp8v7nIF/kKsZiba5Zwnp345vDvCP4QsYa6h0osxRmJhlrMRcWJAMcBwh5TAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looking at ST SPEAr1340 AHCI code (the only user of the deprecated
pdata->suspend and pdata->resume) it is obvious the we should return
after calling pdata->suspend() only if the function have returned
non-zero return value.  The code has been broken since commit 1e70c2
("ata/ahci_platform: Add clock framework support").  Fix it.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
---
 drivers/ata/ahci_platform.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
index 70fbf66..7bd6adf 100644
--- a/drivers/ata/ahci_platform.c
+++ b/drivers/ata/ahci_platform.c
@@ -521,12 +521,19 @@ int ahci_platform_suspend(struct device *dev)
 	if (rc)
 		return rc;
 
-	if (pdata && pdata->suspend)
-		return pdata->suspend(dev);
+	if (pdata && pdata->suspend) {
+		rc = pdata->suspend(dev);
+		if (rc)
+			goto resume_host;
+	}
 
 	ahci_platform_disable_resources(hpriv);
 
 	return 0;
+
+resume_host:
+	ahci_platform_resume_host(dev);
+	return rc;
 }
 EXPORT_SYMBOL_GPL(ahci_platform_suspend);
 
-- 
1.8.2.3

