Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759487AbbA0S4t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 13:56:49 -0500
Received: from smtprelay0199.hostedemail.com ([216.40.44.199]:56652 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759298AbbA0S4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 13:56:47 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1042:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:1801:2194:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3870:3871:3872:3873:4321:4384:4389:4395:4605:5007:6119:6261:8568:8784:9036:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12555:12740:13095:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bells30_c9224212f34
X-Filterd-Recvd-Size: 3959
Message-ID: <1422385001.18650.10.camel@perches.com>
Subject: Re: [PATCH] mmc: print message if a card supports secure erase/trim
From: Joe Perches <joe@perches.com>
To: Richard Weinberger <richard@nod.at>
Cc: Alexander Holler <holler@ahsoftware.de>, linux-mmc@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Chris Ball <chris@printf.net>,
        Ulf Hansson <ulf.hansson@linaro.org>
Date: Tue, 27 Jan 2015 10:56:41 -0800
In-Reply-To: <54C77F5D.30302@nod.at>
References: <1422359304-30321-1-git-send-email-holler@ahsoftware.de>
	 <CAFLxGvyuE8odPdNSD1PTccyBXFm=JO=ooikUOJfz41aFpsUAJg@mail.gmail.com>
	 <54C77E69.7050600@ahsoftware.de> <54C77F5D.30302@nod.at>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2015-01-27 at 13:06 +0100, Richard Weinberger wrote:
> Am 27.01.2015 um 13:02 schrieb Alexander Holler:
> > Am 27.01.2015 um 12:55 schrieb Richard Weinberger:
> >> On Tue, Jan 27, 2015 at 12:48 PM, Alexander Holler <holler@ahsoftware.de> wrote:
> >>> It's an interesting detail, so inform the user about it.
[]
> >>> diff --git a/drivers/mmc/core/bus.c b/drivers/mmc/core/bus.c
[]
> >>> @@ -347,6 +347,10 @@ int mmc_add_card(struct mmc_card *card)
> >>>                          uhs_bus_speed_mode, type, card->rca);
> >>>          }
> >>>
> >>> +       if (mmc_can_secure_erase_trim(card))
> >>> +               pr_info("%s: card supports secure erase/trim\n",
> >>> +                       mmc_hostname(card->host));
> >>> +
> >>
> >> Please make this a sysfs attribute.
> >> Exposing such properties as log messages is horrible.
> > 
> > Look at the source at the message which is printed just before and decide which one you find more informational / useful.
> 
> -ENOPARSE

Because you didn't look at the code?

Alexander, while I kind of agree with Richard about various
properties being rightfully exposed in sysfs, it might have
made more short-term sense to extend the original line instead
of printing another new one.

Something like:
---
 drivers/mmc/core/bus.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/core/bus.c b/drivers/mmc/core/bus.c
index c5ef100..e282780 100644
--- a/drivers/mmc/core/bus.c
+++ b/drivers/mmc/core/bus.c
@@ -259,6 +259,7 @@ int mmc_add_card(struct mmc_card *card)
 	int ret;
 	const char *type;
 	const char *uhs_bus_speed_mode = "";
+	const char *secure_trim_erase = "";
 	static const char *const uhs_speeds[] = {
 		[UHS_SDR12_BUS_SPEED] = "SDR12 ",
 		[UHS_SDR25_BUS_SPEED] = "SDR25 ",
@@ -300,21 +301,26 @@ int mmc_add_card(struct mmc_card *card)
 		(card->sd_bus_speed < ARRAY_SIZE(uhs_speeds)))
 		uhs_bus_speed_mode = uhs_speeds[card->sd_bus_speed];
 
+	if (mmc_can_secure_erase_trim(card))
+		secure_trim_erase = " (secure erase/trim)";
+
 	if (mmc_host_is_spi(card->host)) {
-		pr_info("%s: new %s%s%s card on SPI\n",
+		pr_info("%s: new %s%s%s%s card on SPI\n",
 			mmc_hostname(card->host),
 			mmc_card_hs(card) ? "high speed " : "",
 			mmc_card_ddr52(card) ? "DDR " : "",
-			type);
+			type,
+			secure_trim_erase);
 	} else {
-		pr_info("%s: new %s%s%s%s%s card at address %04x\n",
+		pr_info("%s: new %s%s%s%s%s%s card at address %04x\n",
 			mmc_hostname(card->host),
 			mmc_card_uhs(card) ? "ultra high speed " :
 			(mmc_card_hs(card) ? "high speed " : ""),
 			mmc_card_hs400(card) ? "HS400 " :
 			(mmc_card_hs200(card) ? "HS200 " : ""),
 			mmc_card_ddr52(card) ? "DDR " : "",
-			uhs_bus_speed_mode, type, card->rca);
+			uhs_bus_speed_mode, type, secure_trim_erase,
+			card->rca);
 	}
 
 #ifdef CONFIG_DEBUG_FS


