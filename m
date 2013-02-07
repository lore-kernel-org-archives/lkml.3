Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759406Ab3BGUYL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 15:24:11 -0500
Received: from mms1.broadcom.com ([216.31.210.17]:1534 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759386Ab3BGUYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 15:24:08 -0500
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
Message-ID: <51140CFB.1060100@broadcom.com>
Date: Thu, 7 Feb 2013 21:22:19 +0100
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Tim Gardner" <tim.gardner@canonical.com>
cc: linux-kernel@vger.kernel.org, "Brett Rudley" <brudley@broadcom.com>,
        "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
        "Hante Meuleman" <meuleman@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "Seth Forshee" <seth.forshee@canonical.com>,
        "Pieter-Paul Giesberts" <pieterpg@broadcom.com>,
        "Hauke Mehrtens" <hauke@hauke-m.de>, linux-wireless@vger.kernel.org,
        brcm80211-dev-list@broadcom.com, netdev@vger.kernel.org,
        "Joe Perches" <joe@perches.com>
Subject: Re: [PATCH wireless-next] brcmsmac: avoid 512 byte stack
 variable
References: <1360268032-52414-1-git-send-email-tim.gardner@canonical.com>
In-Reply-To: <1360268032-52414-1-git-send-email-tim.gardner@canonical.com>
X-Enigmail-Version: 1.4.6
X-WSS-ID: 7D0AD3571YS1947775-11-01
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2013 09:13 PM, Tim Gardner wrote:
> Dynamically allocate the probe response template which
> avoids potential stack corruption. Observed with smatch:
> 
> drivers/net/wireless/brcm80211/brcmsmac/main.c:7412 brcms_c_bss_update_probe_resp()
>  warn: 'prb_resp' puts 512 bytes on stack
> 
> Cc: Brett Rudley <brudley@broadcom.com>
> Cc: Arend van Spriel <arend@broadcom.com>
> Cc: "Franky (Zhenhui) Lin" <frankyl@broadcom.com>
> Cc: Hante Meuleman <meuleman@broadcom.com>
> Cc: "John W. Linville" <linville@tuxdriver.com>
> Cc: Seth Forshee <seth.forshee@canonical.com>
> Cc: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Cc: Hauke Mehrtens <hauke@hauke-m.de>
> Cc: linux-wireless@vger.kernel.org
> Cc: brcm80211-dev-list@broadcom.com
> Cc: netdev@vger.kernel.org

One comment below. When taken care of feel free to add:

Acked-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> ---
>  drivers/net/wireless/brcm80211/brcmsmac/main.c |   11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
> index c26992a..e392e76 100644
> --- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
> +++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
> @@ -7408,9 +7408,16 @@ brcms_c_bss_update_probe_resp(struct brcms_c_info *wlc,
>  			      struct brcms_bss_cfg *cfg,
>  			      bool suspend)
>  {
> -	u16 prb_resp[BCN_TMPL_LEN / 2];
> +	u16 *prb_resp;
>  	int len = BCN_TMPL_LEN;
>  
> +	prb_resp = kmalloc(BCN_TMPL_LEN, GFP_ATOMIC);
> +	if (!prb_resp) {
> +		wiphy_err(wlc->wiphy, "wl: %s: failed to alloc %u bytes\n",
> +			__func__, BCN_TMPL_LEN);

I believe the kmalloc() call spews enough info upon allocation failure
so please remove the error message here.

> +		return;
> +	}
> +
>  	/*
>  	 * write the probe response to hardware, or save in
>  	 * the config structure
> @@ -7444,6 +7451,8 @@ brcms_c_bss_update_probe_resp(struct brcms_c_info *wlc,
>  
>  	if (suspend)
>  		brcms_c_enable_mac(wlc);
> +
> +	kfree(prb_resp);
>  }
>  
>  void brcms_c_update_probe_resp(struct brcms_c_info *wlc, bool suspend)
> 


