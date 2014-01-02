Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726AbaABOaS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 09:30:18 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:24370 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbaABOaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 09:30:16 -0500
Date: Thu, 2 Jan 2014 17:29:54 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Sebastian Rachuj <sebastian.rachuj@studium.uni-erlangen.de>
Cc: linux@rationality.eu, devel@driverdev.osuosl.org,
        linux-kernel@i4.cs.fau.de, tvboxspy@gmail.com,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        forest@alittletooquiet.net, more.andres@gmail.com
Subject: Re: [PATCH 10/11] Staging: vt6656: Combined nested conditions
Message-ID: <20140102142953.GE28413@mwanda>
References: <1388084140-21562-1-git-send-email-sebastian.rachuj@studium.uni-erlangen.de>
 <1388084140-21562-11-git-send-email-sebastian.rachuj@studium.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1388084140-21562-11-git-send-email-sebastian.rachuj@studium.uni-erlangen.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 26, 2013 at 07:55:39PM +0100, Sebastian Rachuj wrote:
> -	if (pbyDesireSSID != NULL) {
> -		if (((PWLAN_IE_SSID) pbyDesireSSID)->len != 0)
> -			pSSID = (PWLAN_IE_SSID) pbyDesireSSID;
> -	}
> +	if ((pbyDesireSSID != NULL) &&
> +	    (((PWLAN_IE_SSID) pbyDesireSSID)->len != 0))
> +		pSSID = (PWLAN_IE_SSID) pbyDesireSSID;

That's a lot of extra parentheses!

This patch is fine, but for future reference, adding a double negative
" != NULL" almost never doesn't makes the code less readable.  If we
remove it then this fits on one line.

	if (pbyDesireSSID && ((PWLAN_IE_SSID) pbyDesireSSID)->len != 0)
		pSSID = (PWLAN_IE_SSID) pbyDesireSSID;

The casting is horrible and this is garbage staging code.  If the types
were cleaned up then it would look like:

	if (pbyDesireSSID && pbyDesireSSID->len != 0)
		pSSID = pbyDesireSSID;

The naming is also totally bogus, of course.  What does "pby" mean?  I
think "Desire" is clear but I don't think it's native English.  The "p"
in "pSSID" probably stands for pointer???  It's as if someone
deliberately made every single character of this code as terrible as can
be.

	if (new_ssid && new_ssid->len != 0)
		ssid = new_ssid;

Technically " != 0" is the same as " != NULL" but " != 0" tells a story
and makes the code more readable.


> +				} else if ((pMgmt->eConfigMode == WMAC_CONFIG_AUTO) ||
> +					((pMgmt->eConfigMode == WMAC_CONFIG_IBSS_STA) && WLAN_GET_CAP_INFO_IBSS(pCurrBSS->wCapInfo)) ||
> +					((pMgmt->eConfigMode == WMAC_CONFIG_ESS_STA) && WLAN_GET_CAP_INFO_ESS(pCurrBSS->wCapInfo))) {

Adding all these extra parentheses makes it harder to tell which are
needed and which are noise.

				} else if (pMgmt->eConfigMode == WMAC_CONFIG_AUTO ||
					   (pMgmt->eConfigMode == WMAC_CONFIG_IBSS_STA &&
					    WLAN_GET_CAP_INFO_IBSS(pCurrBSS->wCapInfo)) ||
					   (pMgmt->eConfigMode == WMAC_CONFIG_ESS_STA &&
					    WLAN_GET_CAP_INFO_ESS(pCurrBSS->wCapInfo)) {

In this case, the extra parentheses were there in the original code but
there are other times where this patch adds a number of pretty bogus
parens.

regards,
dan carpenter

