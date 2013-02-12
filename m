Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758142Ab3BLICS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 03:02:18 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:57728 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468Ab3BLICQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 03:02:16 -0500
X-AuditID: cbfee61a-b7f7d6d000000f4e-0c-5119f7074a54
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Chris Ball <cjb@laptop.org>,
        Kevin Liu <keyuan.liu@gmail.com>
Subject: [PATCH 3/3 RESEND] mmc: sdhci: check voltage range only on regulators
 aware of voltage value
Date: Tue, 12 Feb 2013 09:01:36 +0100
Message-id: <1360656096-1671-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <87bobqrcb4.fsf@octavius.laptop.org>
References: <87bobqrcb4.fsf@octavius.laptop.org>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMJMWRmVeSWpSXmKPExsVy+t9jAV3275KBBtNPiVlc3jWHzeLI/35G
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDKu7HnIXHCDo+L+tiMsDYwz2bsYOTgkBEwkTr3k7WLk
	BDLFJC7cW8/WxcjFISSwiFFi/dGVTBBOO5PEwZkgDicHm4ChRNfbLjaQZhEBa4m9C31BapgF
	3jJKLL+1nQUkLiyQLrHrXR5IOYuAqsSki0dZQGxeAXeJhnPrmSD2KkjMmWQDEuYEmrhxYSPY
	OUICBhIXz3pOYORdwMiwilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyPY68+kdjCubLA4xCjA
	wajEw3tDXDJQiDWxrLgy9xCjBAezkggvwyegEG9KYmVValF+fFFpTmrxIUZpDhYlcV7GU08C
	hATSE0tSs1NTC1KLYLJMHJxSDYzqyZxaDT3GKfczZ077wtvi85Rn0f+f27J/vFwV1S1Xov/C
	wUTu4zmNIv/GW/z5L894L00LvyY+n0PlA0v6ef7bP61KDZUXLJXfrqF0d+uxKRwLajkfHFTf
	0mq1NDHpTbVtI5usatmtAn2V91nfD8ibnfxxX7fi6DVfO6b1MdsSPac7mzJ5hSuxFGckGmox
	FxUnAgAcJ24x9gEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some regulators don't report any voltage values, so checking supported
voltage range results in disabling all SDHCI_CAN_VDD_* flags and
registration failure. This patch finally provides a correct fix for the
registration of SDHCI driver with all possible voltage regulators:
dummy, fixed and regulated without using regulator_count_voltages()
hacks.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/mmc/host/sdhci.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index ba586ae..735526b 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -2976,7 +2976,11 @@ int sdhci_add_host(struct sdhci_host *host)
 	}
 
 #ifdef CONFIG_REGULATOR
-	if (host->vmmc) {
+	/*
+	 * Voltage range check makes sense only if regulator reports
+	 * any voltage value.
+	 */
+	if (host->vmmc && regulator_get_voltage(host->vmmc) > 0) {
 		ret = regulator_is_supported_voltage(host->vmmc, 2700000,
 			3600000);
 		if ((ret <= 0) || (!(caps[0] & SDHCI_CAN_VDD_330)))
-- 
1.7.9.5

