Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463AbaHNGGw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 02:06:52 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:55048 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbaHNGGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 02:06:50 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s7E66KD0006909, This message is accepted by code: ctloc85258
From: Roger Tseng <rogerable@realtek.com>
To: Ulf Hansson <ulf.hansson@linaro.org>
CC: Chris Ball <chris@printf.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        Wei_wang <wei_wang@realsil.com.cn>, micky <micky_ching@realsil.com.cn>
Subject: Re: [PATCH] mmc: rtsx: fix incorrect last byte in R2 response
Thread-Topic: [PATCH] mmc: rtsx: fix incorrect last byte in R2 response
Thread-Index: AQHPtT6p2i8llYEFYkerTQKIjSGtNpvOIJiAgAD6y4A=
Date: Thu, 14 Aug 2014 06:06:20 +0000
Message-ID: <1407996435.6245.15.camel@debian-rtk5880>
References: <1407745936-18513-1-git-send-email-rogerable@realtek.com>
	 <CAPDyKFrTbiHxYgW5YCR48DKX8arxuxK3rz7k_H-waGEMiPFjSg@mail.gmail.com>
In-Reply-To: <CAPDyKFrTbiHxYgW5YCR48DKX8arxuxK3rz7k_H-waGEMiPFjSg@mail.gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.81.121]
Content-Type: text/plain; charset="utf-8"
Content-ID: <8BD32206F24D7E48BDA853A613E1CBDE@realtek.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s7E66vVK026107

On Wed, 2014-08-13 at 17:09 +0200, Ulf Hansson wrote:
> On 11 August 2014 10:32,  <rogerable@realtek.com> wrote:
> > From: Roger Tseng <rogerable@realtek.com>
> >
> > Current code erroneously fill the last byte of R2 response with an undefined
> > value. In addition, it is impossible to obtain the real values since the
> > controller actually 'offloads' the last byte(CRC7, end bit) while receiving R2
> > response. This could cause mmc stack to obtain inconsistent CID from the same
> > card after resume and misidentify it as a different card.
> >
> > Fix by assigning a dummy value 0x01 to the last byte of R2 response.
> >
> > Signed-off-by: Roger Tseng <rogerable@realtek.com>
> 
> Thanks! Queued for 3.18.
> 
> I guess this should go for stable as well?
Yes. However, since rtsx_usb* is present in 3.16 and later, this patch
will not apply on 3.15.y or older. Should I separately send an adapted
version to stable?

By the way, according to Dan's comment I would like to add a few word
to explain the code. Would you help fix it up by following diff?

diff --git a/drivers/mmc/host/rtsx_pci_sdmmc.c
b/drivers/mmc/host/rtsx_pci_sdmmc.c
index 54849d8..ca31279 100644
--- a/drivers/mmc/host/rtsx_pci_sdmmc.c
+++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
@@ -412,7 +412,13 @@ static void sd_send_cmd_get_rsp(struct
realtek_pci_sdmmc *host,
 	}
 
 	if (rsp_type == SD_RSP_TYPE_R2) {
+		/*
+		 * The controller offloads the last byte {CRC-7, stop bit 1'b1}
+		 * of response type R2. Assign a dummy CRC, 0, and stop bit to
+		 * the byte(ptr[16], goes into the LSB of resp[3] later).
+		 */
 		ptr[16] = 1;
+
 		for (i = 0; i < 4; i++) {
 			cmd->resp[i] = get_unaligned_be32(ptr + 1 + i * 4);
 			dev_dbg(sdmmc_dev(host), "cmd->resp[%d] = 0x%08x\n",
diff --git a/drivers/mmc/host/rtsx_usb_sdmmc.c
b/drivers/mmc/host/rtsx_usb_sdmmc.c
index ca08df1..727a88d 100644
--- a/drivers/mmc/host/rtsx_usb_sdmmc.c
+++ b/drivers/mmc/host/rtsx_usb_sdmmc.c
@@ -435,7 +435,13 @@ static void sd_send_cmd_get_rsp(struct
rtsx_usb_sdmmc *host,
 	}
 
 	if (rsp_type == SD_RSP_TYPE_R2) {
+		/*
+		 * The controller offloads the last byte {CRC-7, stop bit 1'b1}
+		 * of response type R2. Assign a dummy CRC, 0, and stop bit to
+		 * the byte(ptr[16], goes into the LSB of resp[3] later).
+		 */
 		ptr[16] = 1;
+
 		for (i = 0; i < 4; i++) {
 			cmd->resp[i] = get_unaligned_be32(ptr + 1 + i * 4);
 			dev_dbg(sdmmc_dev(host), "cmd->resp[%d] = 0x%08x\n",

-- 
Best regards,
Roger Tseng
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
