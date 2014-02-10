Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309AbaBJI53 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 03:57:29 -0500
Received: from mail.w1.fi ([212.71.239.96]:50888 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751371AbaBJI5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 03:57:25 -0500
X-Greylist: delayed 415 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Feb 2014 03:57:25 EST
Date: Mon, 10 Feb 2014 10:50:27 +0200
From: Jouni Malinen <j@w1.fi>
To: Calvin Owens <jcalvinowens@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ieee80211: Print human-readable disassoc/deauth reason
 codes
Message-ID: <20140210085027.GA3549@w1.fi>
References: <1391651088-31785-1-git-send-email-jcalvinowens@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391651088-31785-1-git-send-email-jcalvinowens@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 05, 2014 at 07:44:48PM -0600, Calvin Owens wrote:
> Create a function to return a descriptive string for each reason code,
> and print that instead of the numeric value in the kernel log. These
> codes are easily found on popular search engines, but one is generally
> not able to access the internet when dealing with wireless connectivity
> issues.

I don't personally see need for this, but if others find it helpful, I'm
not that strongly against either (even though this would really belong
to user space), as long as it does not do this:

> + * ieee80211_get_reason_code_string - Get human readable reason code
> + *
> + * This function returns a string describing the @reason_code.
> + *
> + * @reason_code: Reason code we want a human readable string for
> + *
> + * Return: Human readable reason string, or "(INVALID)"

That "(INVALID)" is not helpful. It is just hiding the "unknown" value.
Printing out the actual reason code is much more valuable than making
this "human readable" in this way.

> +const char *ieee80211_get_reason_code_string(u16 reason_code)
> +{
> +	if (reason_code <= 24)
> +		return reason_code_strings[reason_code];
> +	else if (reason_code >= 32 && reason_code <= 39)
> +		return reason_code_strings[reason_code - 7];
> +	else if (reason_code == 45)
> +		return reason_code_strings[33];
> +	else if (reason_code >= 52 && reason_code <= 66)
> +		return reason_code_strings[reason_code - 18];
> +	else
> +		return "(INVALID)";
> +}

This is hiding a large number of recently added reason codes.. For most
of the "human readable" strings in the reason_code_strings array, I
would end up having to find the full explanation from the standard
anyway, so I would like to be able to find this easily (and seeing the
real value of the reason code field would be the easiest way).

> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> @@ -2231,8 +2231,8 @@ static void ieee80211_rx_mgmt_deauth(struct ieee80211_sub_if_data *sdata,
> -	sdata_info(sdata, "deauthenticated from %pM (Reason: %u)\n",
> -		   bssid, reason_code);
> +	sdata_info(sdata, "deauthenticated from %pM (reason: %s)\n",
> +		   bssid, ieee80211_get_reason_code_string(reason_code));

Please don't do this unless ieee80211_get_reason_code_string() includes
the actual reason code number for every possible case, i.e., just leave
%u print of reason_code here even if the string is added.

-- 
Jouni Malinen                                            PGP id EFC895FA
