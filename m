Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770AbaBNVcl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 16:32:41 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:36864 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbaBNVcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 16:32:39 -0500
Message-ID: <52FE8B74.8020408@lwfinger.net>
Date: Fri, 14 Feb 2014 15:32:36 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Peter Wu <lekensteyn@gmail.com>, Chaoming_Li <chaoming_li@realsil.com.cn>
CC: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] rtlwifi: properly apply filter flags
References: <1392401026-18417-1-git-send-email-lekensteyn@gmail.com> <1392401026-18417-3-git-send-email-lekensteyn@gmail.com>
In-Reply-To: <1392401026-18417-3-git-send-email-lekensteyn@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2014 12:03 PM, Peter Wu wrote:
> commit 0baa0fd76f3f5a134461d6cf30294f6bb1bb824c
> ("rtlwifi: Convert core routines for addition of rtl8192se and
> rtl8192de") removed setting HW_VAR_RCR, HW_VAR_MGT_FILTER and
> HW_VAR_CTRL_FILTER. The last two are probably done because some hardware
> does not support them. The first is probably a mistake. This patch adds
> the missing set_hw_reg call.
>
> For PCI support, rx_conf is not touched directly. Instead, get_hw_reg is
> used to abstract between receive_config (for PCI) and rx_conf (for USB).
>
> This was tested on a 10ec:8176 Realtek RTL8188CE (according to the
> label on the mini-PCIe card). Before this patch, `iw wlan0 set monitor
> otherbss` did not capture frames from other BSS's. After this patch, it
> does print packets.
>
> Tested-by: Peter Wu <lekensteyn@gmail.com>
> Signed-off-by: Peter Wu <lekensteyn@gmail.com>
> ---

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks,

Larry

>   drivers/net/wireless/rtlwifi/core.c | 52 +++++++++++++++++++++----------------
>   1 file changed, 30 insertions(+), 22 deletions(-)
>
> diff --git a/drivers/net/wireless/rtlwifi/core.c b/drivers/net/wireless/rtlwifi/core.c
> index 2d337a0..6df4df0 100644
> --- a/drivers/net/wireless/rtlwifi/core.c
> +++ b/drivers/net/wireless/rtlwifi/core.c
> @@ -475,20 +475,40 @@ static void rtl_op_configure_filter(struct ieee80211_hw *hw,
>   {
>   	struct rtl_priv *rtlpriv = rtl_priv(hw);
>   	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
> +	u32 rx_conf;
>
>   	*new_flags &= RTL_SUPPORTED_FILTERS;
>   	if (!changed_flags)
>   		return;
>
> +	/* if ssid not set to hw don't check bssid
> +	 * here just used for linked scanning, & linked
> +	 * and nolink check bssid is set in set network_type */
> +	if ((changed_flags & FIF_BCN_PRBRESP_PROMISC) &&
> +		(mac->link_state >= MAC80211_LINKED)) {
> +		if (mac->opmode != NL80211_IFTYPE_AP &&
> +		    mac->opmode != NL80211_IFTYPE_MESH_POINT) {
> +			if (*new_flags & FIF_BCN_PRBRESP_PROMISC) {
> +				rtlpriv->cfg->ops->set_chk_bssid(hw, false);
> +			} else {
> +				rtlpriv->cfg->ops->set_chk_bssid(hw, true);
> +			}
> +		}
> +	}
> +
> +	/* must be called after set_chk_bssid since that function modifies the
> +	 * RCR register too. */
> +	rtlpriv->cfg->ops->get_hw_reg(hw, HW_VAR_RCR, (u8 *)(&rx_conf));
> +
>   	/*TODO: we disable broadcase now, so enable here */
>   	if (changed_flags & FIF_ALLMULTI) {
>   		if (*new_flags & FIF_ALLMULTI) {
> -			mac->rx_conf |= rtlpriv->cfg->maps[MAC_RCR_AM] |
> +			rx_conf |= rtlpriv->cfg->maps[MAC_RCR_AM] |
>   			    rtlpriv->cfg->maps[MAC_RCR_AB];
>   			RT_TRACE(rtlpriv, COMP_MAC80211, DBG_LOUD,
>   				 "Enable receive multicast frame\n");
>   		} else {
> -			mac->rx_conf &= ~(rtlpriv->cfg->maps[MAC_RCR_AM] |
> +			rx_conf &= ~(rtlpriv->cfg->maps[MAC_RCR_AM] |
>   					  rtlpriv->cfg->maps[MAC_RCR_AB]);
>   			RT_TRACE(rtlpriv, COMP_MAC80211, DBG_LOUD,
>   				 "Disable receive multicast frame\n");
> @@ -497,39 +517,25 @@ static void rtl_op_configure_filter(struct ieee80211_hw *hw,
>
>   	if (changed_flags & FIF_FCSFAIL) {
>   		if (*new_flags & FIF_FCSFAIL) {
> -			mac->rx_conf |= rtlpriv->cfg->maps[MAC_RCR_ACRC32];
> +			rx_conf |= rtlpriv->cfg->maps[MAC_RCR_ACRC32];
>   			RT_TRACE(rtlpriv, COMP_MAC80211, DBG_LOUD,
>   				 "Enable receive FCS error frame\n");
>   		} else {
> -			mac->rx_conf &= ~rtlpriv->cfg->maps[MAC_RCR_ACRC32];
> +			rx_conf &= ~rtlpriv->cfg->maps[MAC_RCR_ACRC32];
>   			RT_TRACE(rtlpriv, COMP_MAC80211, DBG_LOUD,
>   				 "Disable receive FCS error frame\n");
>   		}
>   	}
>
> -	/* if ssid not set to hw don't check bssid
> -	 * here just used for linked scanning, & linked
> -	 * and nolink check bssid is set in set network_type */
> -	if ((changed_flags & FIF_BCN_PRBRESP_PROMISC) &&
> -		(mac->link_state >= MAC80211_LINKED)) {
> -		if (mac->opmode != NL80211_IFTYPE_AP &&
> -		    mac->opmode != NL80211_IFTYPE_MESH_POINT) {
> -			if (*new_flags & FIF_BCN_PRBRESP_PROMISC) {
> -				rtlpriv->cfg->ops->set_chk_bssid(hw, false);
> -			} else {
> -				rtlpriv->cfg->ops->set_chk_bssid(hw, true);
> -			}
> -		}
> -	}
>
>   	if (changed_flags & FIF_CONTROL) {
>   		if (*new_flags & FIF_CONTROL) {
> -			mac->rx_conf |= rtlpriv->cfg->maps[MAC_RCR_ACF];
> +			rx_conf |= rtlpriv->cfg->maps[MAC_RCR_ACF];
>
>   			RT_TRACE(rtlpriv, COMP_MAC80211, DBG_LOUD,
>   				 "Enable receive control frame\n");
>   		} else {
> -			mac->rx_conf &= ~rtlpriv->cfg->maps[MAC_RCR_ACF];
> +			rx_conf &= ~rtlpriv->cfg->maps[MAC_RCR_ACF];
>   			RT_TRACE(rtlpriv, COMP_MAC80211, DBG_LOUD,
>   				 "Disable receive control frame\n");
>   		}
> @@ -537,15 +543,17 @@ static void rtl_op_configure_filter(struct ieee80211_hw *hw,
>
>   	if (changed_flags & FIF_OTHER_BSS) {
>   		if (*new_flags & FIF_OTHER_BSS) {
> -			mac->rx_conf |= rtlpriv->cfg->maps[MAC_RCR_AAP];
> +			rx_conf |= rtlpriv->cfg->maps[MAC_RCR_AAP];
>   			RT_TRACE(rtlpriv, COMP_MAC80211, DBG_LOUD,
>   				 "Enable receive other BSS's frame\n");
>   		} else {
> -			mac->rx_conf &= ~rtlpriv->cfg->maps[MAC_RCR_AAP];
> +			rx_conf &= ~rtlpriv->cfg->maps[MAC_RCR_AAP];
>   			RT_TRACE(rtlpriv, COMP_MAC80211, DBG_LOUD,
>   				 "Disable receive other BSS's frame\n");
>   		}
>   	}
> +
> +	rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_RCR, (u8 *)(&rx_conf));
>   }
>   static int rtl_op_sta_add(struct ieee80211_hw *hw,
>   			 struct ieee80211_vif *vif,
>

