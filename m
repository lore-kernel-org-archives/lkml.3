Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336AbaJBLp4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 07:45:56 -0400
Received: from smtprelay0085.hostedemail.com ([216.40.44.85]:52252 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750987AbaJBLpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 07:45:53 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:69:355:379:541:599:967:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1543:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2525:2560:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3355:3622:3865:3866:3867:3868:3870:3871:3872:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:6119:7652:7903:9025:9592:10004:10226:10400:10471:10848:11026:11232:11473:11658:11914:12043:12291:12296:12438:12517:12519:12555:12679:12683:12740:13255:13845:13972:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: trick38_331a61315ec22
X-Filterd-Recvd-Size: 4901
Message-ID: <1412250349.3247.44.camel@joe-AO725>
Subject: Re: [PATCH v2] staging: rts5208: Clean up coding style in
 rtsx_chip.c to get rid of checkpatch.pl warnings and combine two ifs into
 one
From: Joe Perches <joe@perches.com>
To: Giedrius Statkevicius <giedrius.statkevicius@gmail.com>
Cc: gregkh@linuxfoundation.org, micky_ching@realsil.com.cn,
        fabio.falzoi84@gmail.com, mahati.chamarthy@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Thu, 02 Oct 2014 04:45:49 -0700
In-Reply-To: <542D336A.1050401@gmail.com>
References: <542D336A.1050401@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-10-02 at 14:13 +0300, Giedrius Statkevicius wrote:
> Fix 10 occurences of coding style errors where the line exceeds 80 characters by breaking them into more lines.
> Checkpatch.pl reports these errors as: 'WARNING: line over 80 characters'
> Also, removes unnecessary returns in two void functions by removing the return statements.
> Checkpatch.pl reports these errors as: 'WARNING: void function return statements are not generally useful'
> Lastly it combines two if statements into one in rtsx_reset_chip()

Another way to reduce indentation is to write another
utility function like the suggested patch at the end
of this email.

Also, changing:

	if (foo) {
		[short code block...]
	} else
		[long code block...]
	}

	return bar;
to:
	if (foo) {
		[short code block...]
		return bar;
	}

	[long code block...]
	return bar;

reduces indentation.

Al Viro once gave good advice about indentation here:
https://lkml.org/lkml/2013/3/20/345

Using ternaries can also reduce line count and
indentation:
	if (something)
		foo(bar, 1, ...);
	else
		foo(bar, 2, ...);
can be written
	foo(bar, something ? 1 : 2, ...)

Here's a suggestion:
---
 drivers/staging/rts5208/rtsx_chip.c | 71 ++++++++++++++++++++-----------------
 1 file changed, 38 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/rts5208/rtsx_chip.c b/drivers/staging/rts5208/rtsx_chip.c
index 1411471..85d670d 100644
--- a/drivers/staging/rts5208/rtsx_chip.c
+++ b/drivers/staging/rts5208/rtsx_chip.c
@@ -226,6 +226,43 @@ static int rtsx_pre_handle_sdio_new(struct rtsx_chip *chip)
 }
 #endif
 
+static int rtsx_reset_aspm(struct rtsx_chip *chip)
+{
+	int rtn = STATUS_SUCCESS;
+
+	if (chip->dynamic_aspm) {
+		if (CHK_SDIO_EXIST(chip) && CHECK_PID(chip, 0x5288)) {
+			rtn = rtsx_write_cfg_dw(chip, 2, 0xC0, 0xFF,
+						chip->aspm_l0s_l1_en);
+			if (rtn != STATUS_SUCCESS)
+				TRACE_RET(chip, STATUS_FAIL);
+		}
+		return rtn;
+	}
+
+	if (CHECK_PID(chip, 0x5208))
+		RTSX_WRITE_REG(chip, ASPM_FORCE_CTL, 0xFF, 0x3F);
+
+	rtn = rtsx_write_config_byte(chip, LCTLR, chip->aspm_l0s_l1_en);
+	if (rtn != STATUS_SUCCESS)
+		TRACE_RET(chip, STATUS_FAIL);
+
+	chip->aspm_level[0] = chip->aspm_l0s_l1_en;
+
+	if (CHK_SDIO_EXIST(chip)) {
+		chip->aspm_level[1] = chip->aspm_l0s_l1_en;
+		rtn = rtsx_write_cfg_dw(chip,
+					CHECK_PID(chip, 0x5288) ? 2 : 1,
+					0xC0, 0xFF, chip->aspm_l0s_l1_en);
+		if (rtn != STATUS_SUCCESS)
+			TRACE_RET(chip, STATUS_FAIL);
+	}
+
+	chip->aspm_enabled = 1;
+
+	return rtn;
+}
+
 int rtsx_reset_chip(struct rtsx_chip *chip)
 {
 	int retval;
@@ -288,39 +325,7 @@ int rtsx_reset_chip(struct rtsx_chip *chip)
 
 	/* Enable ASPM */
 	if (chip->aspm_l0s_l1_en) {
-		if (chip->dynamic_aspm) {
-			if (CHK_SDIO_EXIST(chip)) {
-				if (CHECK_PID(chip, 0x5288)) {
-					retval = rtsx_write_cfg_dw(chip, 2, 0xC0, 0xFF, chip->aspm_l0s_l1_en);
-					if (retval != STATUS_SUCCESS)
-						TRACE_RET(chip, STATUS_FAIL);
-				}
-			}
-		} else {
-			if (CHECK_PID(chip, 0x5208))
-				RTSX_WRITE_REG(chip, ASPM_FORCE_CTL,
-					0xFF, 0x3F);
-
-			retval = rtsx_write_config_byte(chip, LCTLR,
-							chip->aspm_l0s_l1_en);
-			if (retval != STATUS_SUCCESS)
-				TRACE_RET(chip, STATUS_FAIL);
-
-			chip->aspm_level[0] = chip->aspm_l0s_l1_en;
-			if (CHK_SDIO_EXIST(chip)) {
-				chip->aspm_level[1] = chip->aspm_l0s_l1_en;
-				if (CHECK_PID(chip, 0x5288))
-					retval = rtsx_write_cfg_dw(chip, 2, 0xC0, 0xFF, chip->aspm_l0s_l1_en);
-				else
-					retval = rtsx_write_cfg_dw(chip, 1, 0xC0, 0xFF, chip->aspm_l0s_l1_en);
-
-				if (retval != STATUS_SUCCESS)
-					TRACE_RET(chip, STATUS_FAIL);
-
-			}
-
-			chip->aspm_enabled = 1;
-		}
+		retval = rtsx_reset_aspm(chip);
 	} else {
 		if (chip->asic_code && CHECK_PID(chip, 0x5208)) {
 			retval = rtsx_write_phy_register(chip, 0x07, 0x0129);


