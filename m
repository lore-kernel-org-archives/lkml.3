Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141Ab3IVIWU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 04:22:20 -0400
Received: from smtprelay0008.hostedemail.com ([216.40.44.8]:40055 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752743Ab3IVIWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 04:22:15 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3867:3868:3871:3872:4321:4605:5007:7652:10004:10400:10848:11026:11232:11473:11657:11658:11914:12043:12438:12517:12519:12555:12679:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: road86_12d5abd6f850e
X-Filterd-Recvd-Size: 2770
Message-ID: <1379838128.2086.6.camel@joe-AO722>
Subject: Re: [PATCH 12/19] wireless: Change variable type to bool
From: Joe Perches <joe@perches.com>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: Larry.Finger@lwfinger.net, chaoming_li@realsil.com.cn,
        linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Date: Sun, 22 Sep 2013 01:22:08 -0700
In-Reply-To: <1379802471-30252-12-git-send-email-peter.senna@gmail.com>
References: <1379802471-30252-1-git-send-email-peter.senna@gmail.com>
	 <1379802471-30252-12-git-send-email-peter.senna@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-09-22 at 00:27 +0200, Peter Senna Tschudin wrote:
> The variable continual is only assigned the values true and false.
> Change its type to bool.
[]
> diff --git a/drivers/net/wireless/rtlwifi/efuse.c b/drivers/net/wireless/rtlwifi/efuse.c
[]
> @@ -1203,7 +1203,7 @@ static void efuse_power_switch(struct ieee80211_hw *hw, u8 write, u8 pwrstate)
>  
>  static u16 efuse_get_current_size(struct ieee80211_hw *hw)
>  {
> -	int continual = true;
> +	bool continual = true;
>  	u16 efuse_addr = 0;
>  	u8 hworden;
>  	u8 efuse_data, word_cnts;

Yes, this could use bool, but would probably be better
written without continual at all

as it is before this patch:

static u16 efuse_get_current_size(struct ieee80211_hw *hw)
{
	int continual = true;
	u16 efuse_addr = 0;
	u8 hworden;
	u8 efuse_data, word_cnts;

	while (continual && efuse_one_byte_read(hw, efuse_addr, &efuse_data)
	       && (efuse_addr < EFUSE_MAX_SIZE)) {
		if (efuse_data != 0xFF) {
			hworden = efuse_data & 0x0F;
			word_cnts = efuse_calculate_word_cnts(hworden);
			efuse_addr = efuse_addr + (word_cnts * 2) + 1;
		} else {
			continual = false;
		}
	}

	return efuse_addr;
}

I think writing it without continual, which is effectively
an ersatz "break", would be better

Something like:

static u16 efuse_get_current_size(struct ieee80211_hw *hw)
{
	u16 efuse_addr = 0;
	u8 hworden;
	u8 efuse_data, word_cnts;

	while (efuse_one_byte_read(hw, efuse_addr, &efuse_data) &&
	       (efuse_addr < EFUSE_MAX_SIZE) {
		if (efuse_data == 0xff)
			break;
		hworden = efuse_data & 0x0F;
		word_cnts = efuse_calculate_word_cnts(hworden);
		efuse_addr = efuse_addr + (word_cnts * 2) + 1;
	}

	return efuse_addr;
}

