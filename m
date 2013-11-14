Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932307Ab3KNQ5Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:57:16 -0500
Received: from smtprelay0166.hostedemail.com ([216.40.44.166]:52690 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755786Ab3KNQ5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:57:04 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2525:2553:2560:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3622:3834:3865:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4321:4560:5007:6119:6120:7576:7652:7901:7903:9025:9545:10004:10400:10848:10967:11026:11232:11657:11658:11914:12043:12296:12438:12517:12519:12555:12698:12737:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesia
X-HE-Tag: goose74_2021e293b6c1a
X-Filterd-Recvd-Size: 2662
Message-ID: <1384448222.15774.12.camel@joe-AO722>
Subject: Re: [PATCH] alx: Reset phy speed after resume
From: Joe Perches <joe@perches.com>
To: hahnjo <linux@hahnjo.de>
Cc: jcliburn@gmail.com, chris.snook@gmail.com, davem@davemloft.net,
        johannes@sipsolutions.net, wangyijing@huawei.com,
        maarten.lankhorst@canonical.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 14 Nov 2013 08:57:02 -0800
In-Reply-To: <1384445773.29057.5.camel@localhost.tld>
References: <1384445773.29057.5.camel@localhost.tld>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-11-14 at 17:16 +0100, hahnjo wrote:
> From 27744b24f9291782c1342dbd6cac511e68da907c Mon Sep 17 00:00:00 2001
> From: hahnjo <hahnjo@hahnjo.de>
> Date: Tue, 12 Nov 2013 18:19:24 +0100
> Subject: [PATCH] alx: Reset phy speed after resume
> 
> This fixes bug 62491 (https://bugzilla.kernel.org/show_bug.cgi?id=62491).
> After resuming some users got the following error flooding the kernel log:
> alx 0000:02:00.0: invalid PHY speed/duplex: 0xffff
> 
> Signed-off-by: Jonas Hahnfeld <linux@hahnjo.de>
> ---
>  drivers/net/ethernet/atheros/alx/main.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/net/ethernet/atheros/alx/main.c b/drivers/net/ethernet/atheros/alx/main.c
> index fc95b23..6305a5d 100644
> --- a/drivers/net/ethernet/atheros/alx/main.c
> +++ b/drivers/net/ethernet/atheros/alx/main.c
> @@ -1389,6 +1389,9 @@ static int alx_resume(struct device *dev)
>  {
>  	struct pci_dev *pdev = to_pci_dev(dev);
>  	struct alx_priv *alx = pci_get_drvdata(pdev);
> +	struct alx_hw *hw = &alx->hw;
> +
> +	alx_reset_phy(hw);
>  
>  	if (!netif_running(alx->dev))
>  		return 0;

Perhaps this would help too:
---
 drivers/net/ethernet/atheros/alx/hw.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/atheros/alx/hw.c b/drivers/net/ethernet/atheros/alx/hw.c
index 1e8c24a..3396224 100644
--- a/drivers/net/ethernet/atheros/alx/hw.c
+++ b/drivers/net/ethernet/atheros/alx/hw.c
@@ -908,7 +908,8 @@ int alx_read_phy_link(struct alx_hw *hw)
 	return 0;
 
 wrong_speed:
-	dev_err(&pdev->dev, "invalid PHY speed/duplex: 0x%x\n", giga);
+	dev_err_ratelimited(&pdev->dev, "invalid PHY speed/duplex: 0x%x\n",
+			    giga);
 	return -EINVAL;
 }
 


