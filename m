Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbaCYSwD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 14:52:03 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:60742 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754680AbaCYSv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 14:51:59 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-1c-5331d04e4c3b
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Tejun Heo <tj@kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>, Sekhar Nori <nsekhar@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Viresh Kumar <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.hashim@st.com>, linux-ide@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com,
        spear-devel@list.st.com, b.zolnierkie@samsung.com
Subject: [PATCH v4 1/4] ata: ahci_platform: fix ahci_platform_data->suspend
 method handling
Date: Tue, 25 Mar 2014 19:51:38 +0100
Message-id: <1395773501-6663-2-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1395773501-6663-1-git-send-email-b.zolnierkie@samsung.com>
References: <1395773501-6663-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJLMWRmVeSWpSXmKPExsVy+t9jAV2/C4bBBof+s1lsnLGe1eLcrQZW
	izfHpzNZ3FnBbLHp8TVWi2M7HjFZXN41h81if+8GJouG7h52izkzNrNa/Fp+lNFi5cW/zA48
	Htdf/Wfy2DnrLrvHplWdbB5zpjWxeJy8cJLFY/OSeo/3+66yefRtWcXo8fTHXmaP4ze2M3l8
	3iQXwB3FZZOSmpNZllqkb5fAldF9YhZbwUmuirb365kbGO9wdDFyckgImEi8Xn2IBcIWk7hw
	bz1bFyMXh5DAIkaJC4+uQTldTBJz999hBqliE7CSmNi+ihHEFhGQlbgy7SEjSBGzQBezxJLZ
	W8ASwgKxEgsnLGMHsVkEVCXW7/gL1MzBwSvgLnHmKSvENkWJ7mcT2EBsTgEPif/31jGB2EIg
	JfPms01g5F3AyLCKUTS1ILmgOCk911CvODG3uDQvXS85P3cTIziAn0ntYFzZYHGIUYCDUYmH
	d8IEw2Ah1sSy4srcQ4wSHMxKIrx/TwKFeFMSK6tSi/Lji0pzUosPMUpzsCiJ8x5otQ4UEkhP
	LEnNTk0tSC2CyTJxcEo1MPqy75oTvHr5pWUqrXoXdi9zOVDpfLHWeFbWHr66vJPPknvXv2VP
	eX/03a5LCnu/OR85Nq9SWjYhTf3elrdcH1f/+rnlJteiv6+F2ioFfNKPTshbuTLC8W2HuFbb
	qTkW0ZF8vfLvtV9Om9w9N8FD5t6sqVq/qoKWiLLuYZnBs3o7j3rLw0apQz+UWIozEg21mIuK
	EwEecmBPXAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looking at ST SPEAr1340 AHCI code (the only user of the deprecated
pdata->suspend and pdata->resume) it is obvious the we should return
after calling pdata->suspend() only if the function have returned
non-zero return value.  The code has been broken since commit 1e70c2
("ata/ahci_platform: Add clock framework support").  Fix it.

Cc: Viresh Kumar <viresh.linux@gmail.com>
Cc: Shiraz Hashim <shiraz.hashim@st.com>
Acked-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
---
v4:
- no changes
v3:
- no changes
v2:
- updated patch description

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

