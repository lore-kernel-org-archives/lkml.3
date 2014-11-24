Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508AbaKXNik (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 08:38:40 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:50960 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111AbaKXNii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 08:38:38 -0500
Message-ID: <547334D8.40705@ti.com>
Date: Mon, 24 Nov 2014 19:08:32 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Seungwon Jeon <tgih.jun@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, Sekhar Nori <nsekhar@ti.com>
Subject: [Query] Replaced UHS_DDR50 with MMC_DDR52.
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Seungwon,

Enabling UHS in dra7xx resulted in the below error (see blow). It was bisected to

commit 5438ad95a57cbfd95708a5047a27ff3cce345b79
Author: Seungwon Jeon <tgih.jun@samsung.com>
Date:   Fri Mar 14 21:12:27 2014 +0900

    mmc: omap: clarify DDR timing mode between SD-UHS and eMMC

    Replaced UHS_DDR50 with MMC_DDR52.

Actually the second hunk is causing the issue. The commit log didn't adequately
explain why this change is needed as it breaks UHS in dra7xx.

The following patch fixes this.

index f85cd0f..5659793 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -788,7 +788,7 @@ static void omap_hsmmc_set_bus_width(struct omap_hsmmc_host
*host)
        u32 con;

        con = OMAP_HSMMC_READ(host->base, CON);
-       if (ios->timing == MMC_TIMING_MMC_DDR52)
+       if (ios->timing == MMC_TIMING_UHS_DDR50)
                con |= DDR;     /* configure in DDR mode */
        else
                con &= ~DDR;

Thanks
Kishon

[    3.369017] mmc1: new ultra high speed DDR50 SDHC card at address aaaa
[    3.376821] mmcblk1: mmc1:aaaa SL32G 29.7 GiB
[    3.394844] mmcblk1: error -84 transferring data, sector 0, nr 8, cmd
response 0x900, card status 0x0
[    3.404528] mmcblk1: retrying using single block read
[    3.410264] mmcblk1: error -84 transferring data, sector 0, nr 8, cmd
response 0x900, card status 0x0
[    3.419995] blk_update_request: I/O error, dev mmcblk1, sector 0
[    3.426771] mmcblk1: error -84 transferring data, sector 1, nr 7, cmd
response 0x900, card status 0x0
[    3.436455] blk_update_request: I/O error, dev mmcblk1, sector 1
[    3.443259] mmcblk1: error -84 transferring data, sector 2, nr 6, cmd
response 0x900, card status 0x0
[    3.444359] net eth0: phy found : id is : 0x20005c7a
[    3.449554] net eth1: initializing cpsw version 1.15 (0)
[    3.463822] blk_update_request: I/O error, dev mmcblk1, sector 2
[    3.470568] mmcblk1: error -84 transferring data, sector 3, nr 5, cmd
response 0x900, card status 0x0
[    3.480231] blk_update_request: I/O error, dev mmcblk1, sector 3
[    3.486996] mmcblk1: error -84 transferring data, sector 4, nr 4, cmd
response 0x900, card status 0x0
[    3.496685] blk_update_request: I/O error, dev mmcblk1, sector 4
[    3.503446] mmcblk1: error -84 transferring data, sector 5, nr 3, cmd
response 0x900, card status 0x0
[    3.513141] blk_update_request: I/O error, dev mmcblk1, sector 5
[    3.519885] mmcblk1: error -84 transferring data, sector 6, nr 2, cmd
response 0x900, card status 0x0
[    3.529564] blk_update_request: I/O error, dev mmcblk1, sector 6
[    3.534371] net eth1: phy found : id is : 0x20005c7a
[    3.541585] mmcblk1: error -84 transferring data, sector 7, nr 1, cmd
response 0x900, card status 0x0
[    3.551262] blk_update_request: I/O error, dev mmcblk1, sector 7
[    3.557586] Buffer I/O error on dev mmcblk1, logical block 0, async page read
[    3.565680] mmcblk1: error -84 transferring data, sector 0, nr 8, cmd
response 0x900, card status 0xb00
[    3.575536] mmcblk1: retrying using single block read
[    3.581289] mmcblk1: error -84 transferring data, sector 0, nr 8, cmd
response 0x900, card status 0x0
[    3.590983] blk_update_request: I/O error, dev mmcblk1, sector 0
[    3.597731] mmcblk1: error -84 transferring data, sector 1, nr 7, cmd
response 0x900, card status 0x0
[    3.607419] blk_update_request: I/O error, dev mmcblk1, sector 1
[    3.614175] mmcblk1: error -84 transferring data, sector 2, nr 6, cmd
response 0x900, card status 0x0
[    3.624208] mmcblk1: error -84 transferring data, sector 3, nr 5, cmd
response 0x900, card status 0x0
[    3.634344] mmcblk1: error -84 transferring data, sector 4, nr 4, cmd
response 0x900, card status 0x0
[    3.644377] mmcblk1: error -84 transferring data, sector 5, nr 3, cmd
response 0x900, card status 0x0
[    3.654501] mmcblk1: error -84 transferring data, sector 6, nr 2, cmd
response 0x900, card status 0x0
[    3.664536] mmcblk1: error -84 transferring data, sector 7, nr 1, cmd
response 0x900, card status 0x0
[    3.674220] Buffer I/O error on dev mmcblk1, logical block 0, async page read
[    3.681754]  mmcblk1: unable to read partition table
