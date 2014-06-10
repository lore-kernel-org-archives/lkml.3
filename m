Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075AbaFJI1R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 04:27:17 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:45479 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754522AbaFJI1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 04:27:14 -0400
Date: Tue, 10 Jun 2014 11:26:55 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Remi Pommarel <repk@triplefau.lt>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: rtl8821ae: use kmalloc instead of variable
 length stack arrays
Message-ID: <20140610082539.GK5500@mwanda>
References: <1401903945-21094-1-git-send-email-repk@triplefau.lt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401903945-21094-1-git-send-email-repk@triplefau.lt>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 07:45:45PM +0200, Remi Pommarel wrote:
> This removes stack arrays of variable length and use kmalloc() instead, thus
> removing the sparse warnings "Variable length array is used".
> 
> Signed-off-by: Remi Pommarel <repk@triplefau.lt>
> ---
>  drivers/staging/rtl8821ae/efuse.c | 38 +++++++++++++++++++++++++++++++-------
>  1 file changed, 31 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/staging/rtl8821ae/efuse.c b/drivers/staging/rtl8821ae/efuse.c
> index 206012c..a41aa84 100644
> --- a/drivers/staging/rtl8821ae/efuse.c
> +++ b/drivers/staging/rtl8821ae/efuse.c
> @@ -232,7 +232,7 @@ void read_efuse(struct ieee80211_hw *hw, u16 _offset, u16 _size_byte, u8 *pbuf)
>  {
>  	struct rtl_priv *rtlpriv = rtl_priv(hw);
>  	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
> -	u8 efuse_tbl[rtlpriv->cfg->maps[EFUSE_HWSET_MAX_SIZE]];
> +	u8 *efuse_tbl;
>  	u8 rtemp8[1];
>  	u16 efuse_addr = 0;
>  	u8 offset, wren;
> @@ -243,7 +243,7 @@ void read_efuse(struct ieee80211_hw *hw, u16 _offset, u16 _size_byte, u8 *pbuf)
>  		rtlpriv->cfg->maps[EFUSE_MAX_SECTION_MAP];
>  	const u32 efuse_real_content_len =
>  		rtlpriv->cfg->maps[EFUSE_REAL_CONTENT_SIZE];
> -	u16 efuse_word[efuse_max_section][EFUSE_MAX_WORD_UNIT];
> +	u16 **efuse_word;
>  	u16 efuse_utilized = 0;
>  	u8 efuse_usage;
>  
> @@ -254,9 +254,26 @@ void read_efuse(struct ieee80211_hw *hw, u16 _offset, u16 _size_byte, u8 *pbuf)
>  		return;
>  	}
>  
> +	efuse_tbl = kmalloc(rtlpriv->cfg->maps[EFUSE_HWSET_MAX_SIZE] *
> +			sizeof(*efuse_tbl), GFP_ATOMIC);

sizeof(*efuse_tbl) is a complicated way to say 1.  Just say:

	efuse_tbl = kmalloc(rtlpriv->cfg->maps[EFUSE_HWSET_MAX_SIZE], GFP_ATOMIC);

Why is it GFP_ATOMIC btw?  That wasn't immediately clear to me and I
didn't spend a lot of time looking.

> +	if (efuse_tbl == NULL)
> +		return;
> +
> +	efuse_word = kcalloc(EFUSE_MAX_WORD_UNIT, sizeof(*efuse_word),
> +			GFP_ATOMIC);
> +	if (efuse_word == NULL)
> +		goto out;
> +
> +	for (i = 0; i < EFUSE_MAX_WORD_UNIT; i++) {
> +		efuse_word[i] = kmalloc(efuse_max_section *
> +				sizeof(**efuse_word), GFP_ATOMIC);
> +		if (efuse_word[i] == NULL)
> +			goto done;
> +	}


Why is this so complicated?  Why not just:

	efuse_word = kmalloc(sizeof(*efuse_word) * efuse_max_section *
			     EFUSE_MAX_WORD_UNIT, GFP_ATOMIC);


> +
>  	for (i = 0; i < efuse_max_section; i++)
>  		for (j = 0; j < EFUSE_MAX_WORD_UNIT; j++)
> -			efuse_word[i][j] = 0xFFFF;
> +			efuse_word[j][i] = 0xFFFF;

Why are you re-ordering things here?

regards,
dan carpenter

