Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176AbaCaRtY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 13:49:24 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:25130 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075AbaCaRtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 13:49:22 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-cf-5339aaa043b7
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Tejun Heo <tj@kernel.org>
Cc: Viresh Kumar <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.hashim@st.com>, linux-ide@vger.kernel.org,
        spear-devel@list.st.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] pata_arasan_cf: fix ata_host_activate() failure handling
Date: Mon, 31 Mar 2014 19:49 +0200
Message-id: <7093981.6c4k98qyGh@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJLMWRmVeSWpSXmKPExsVy+t9jQd0FqyyDDY7ts7bY9Pgaq8WxHY+Y
	LC7vmsNm0dDdw24xZ8ZmVotfy48yWqy8+JfZgd1j56y77B6bVnWyeZy8cJLFY/OSeo+nP/Yy
	e3zeJBfAFsVlk5Kak1mWWqRvl8CV8aJ7LmPBQ/aKO4cfsTQwnmbrYuTkkBAwkWjt72KGsMUk
	LtxbDxTn4hASmM4osfLvHiYIp4VJ4mfnSXaQKjYBK4mJ7asYQWwRAVmJK9MeMoIUMQucZZRY
	d3I2WJGwgKfErCdbwcayCChJnJo0B8zmFdCU2PfvNdhqUaCaHdtXskHEBSV+TL7HAmIzC8hL
	7Ns/lRXC1pJYv/M40wRGvllIymYhKZuFpGwBI/MqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxN
	jOAAfia9g3FVg8UhRgEORiUeXotyy2Ah1sSy4srcQ4wSHMxKIrxbFwCFeFMSK6tSi/Lji0pz
	UosPMUpzsCiJ8x5stQ4UEkhPLEnNTk0tSC2CyTJxcEo1MMbO/3LNekPATK65wbO4p8+UkJkV
	lczBHra9hkGifz/jlV9fLj69IFclKVe7ylRxbvAa24cfb6yoUm/uWPt2572rcbaBWnn8k3f+
	u3Dy9Zq9/T6vtDaJbDxRMeVh3LGH59OeLhG9uDWZ+aaJj9Df+sXvO0257BNdQzqXerfnXdD/
	1bM6oEHr9CclluKMREMt5qLiRAAVXYqaXAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing cf_exit() and clk_put() calls to ata_host_activate()
failure path.

Cc: Viresh Kumar <viresh.linux@gmail.com>
Cc: Shiraz Hashim <shiraz.hashim@st.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
---
 drivers/ata/pata_arasan_cf.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

Index: b/drivers/ata/pata_arasan_cf.c
===================================================================
--- a/drivers/ata/pata_arasan_cf.c	2014-03-31 16:57:47.443727785 +0200
+++ b/drivers/ata/pata_arasan_cf.c	2014-03-31 17:09:48.171715498 +0200
@@ -898,9 +898,15 @@ static int arasan_cf_probe(struct platfo
 
 	cf_card_detect(acdev, 0);
 
-	return ata_host_activate(host, acdev->irq, irq_handler, 0,
-			&arasan_cf_sht);
+	ret = ata_host_activate(host, acdev->irq, irq_handler, 0,
+				&arasan_cf_sht);
+	if (ret)
+		goto exit_cf;
 
+	return 0;
+
+exit_cf:
+	cf_exit(acdev);
 free_clk:
 	clk_put(acdev->clk);
 	return ret;

