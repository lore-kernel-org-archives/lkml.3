Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292AbaDNQB7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 12:01:59 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:22947 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327AbaDNQB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 12:01:57 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-d6-534c067479b3
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Tejun Heo <tj@kernel.org>
Cc: Viresh Kumar <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.hashim@st.com>, linux-ide@vger.kernel.org,
        spear-devel@list.st.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] pata_arasan_cf: fix ata_host_activate() failure handling
Date: Mon, 14 Apr 2014 18:01:47 +0200
Message-id: <1706948.xQXQIMFS2B@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGLMWRmVeSWpSXmKPExsVy+t9jAd0SNp9gg+5+TYtNj6+xWhzb8YjJ
	4vKuOWwWDd097BZzZmxmtfi1/CijxcqLf5kd2D12zrrL7rFpVSebx8kLJ1k8Ni+p93j6Yy+z
	x+dNcgFsUVw2Kak5mWWpRfp2CVwZU76vZiz4z17RdHAdSwPjI7YuRg4OCQETiR9LeboYOYFM
	MYkL99azgdhCAosYJRZ+1uxi5AKyW5gkuu9vZgVJsAlYSUxsX8UIYosIyEpcmfaQEaSIWeAs
	o8S6k7PZQYYKC/hIHD2kDVLDIqAqsevYC2YQm1dAU2Lj6l1MILaogKfEju0r2SDighI/Jt9j
	AbGZBeQl9u2fygpha0ms33mcaQIj3ywkZbOQlM1CUraAkXkVo2hqQXJBcVJ6rpFecWJucWle
	ul5yfu4mRnDoPpPewbiqweIQowAHoxIP74R33sFCrIllxZW5hxglOJiVRHhdtwKFeFMSK6tS
	i/Lji0pzUosPMUpzsCiJ8x5stQ4UEkhPLEnNTk0tSC2CyTJxcEo1MGadevTTqaY37eq8g0V2
	y36+q3xb1B5orfzScIGrtWf7S5GMI6eNpqx0rpm6xe4l70Q3odmfiu+sZV3IOYXJQS9J4K2q
	76J5kn55Z/fwyvSFs7+r3snscPz+s7blQjN5eXyb/UrLA+adPCU3Ie5FzqUazpAFU77W/23O
	UNMu3vvoh89579dv7JRYijMSDbWYi4oTAQOd0z5ZAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing cf_exit() and clk_put() calls to ata_host_activate()
failure path.

Cc: Viresh Kumar <viresh.linux@gmail.com>
Cc: Shiraz Hashim <shiraz.hashim@st.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
---
v2:
- re-order code and then drop redundant goto statement

 drivers/ata/pata_arasan_cf.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: b/drivers/ata/pata_arasan_cf.c
===================================================================
--- a/drivers/ata/pata_arasan_cf.c	2014-04-14 17:26:27.308294246 +0200
+++ b/drivers/ata/pata_arasan_cf.c	2014-04-14 17:44:41.868314795 +0200
@@ -898,9 +898,12 @@ static int arasan_cf_probe(struct platfo
 
 	cf_card_detect(acdev, 0);
 
-	return ata_host_activate(host, acdev->irq, irq_handler, 0,
-			&arasan_cf_sht);
+	ret = ata_host_activate(host, acdev->irq, irq_handler, 0,
+				&arasan_cf_sht);
+	if (!ret)
+		return 0;
 
+	cf_exit(acdev);
 free_clk:
 	clk_put(acdev->clk);
 	return ret;

