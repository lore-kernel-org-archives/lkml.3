Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714AbaBFEo3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 23:44:29 -0500
Received: from smtprelay0020.hostedemail.com ([216.40.44.20]:35661 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753942AbaBFEo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 23:44:27 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:1960:2194:2199:2393:2559:2562:2741:2828:2901:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3870:3871:3874:4321:5007:7652:10004:10400:10848:11026:11232:11473:11658:11914:12043:12295:12296:12347:12438:12517:12519:12555:12740:13071,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: spark15_7de1a2007e137
X-Filterd-Recvd-Size: 3646
Message-ID: <1391661863.30094.56.camel@joe-AO722>
Subject: Re: [PATCH] ieee80211: Print human-readable disassoc/deauth reason
 codes
From: Joe Perches <joe@perches.com>
To: Calvin Owens <jcalvinowens@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 05 Feb 2014 20:44:23 -0800
In-Reply-To: <1391651088-31785-1-git-send-email-jcalvinowens@gmail.com>
References: <1391651088-31785-1-git-send-email-jcalvinowens@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-02-05 at 19:44 -0600, Calvin Owens wrote:
> Create a function to return a descriptive string for each reason code,
> and print that instead of the numeric value in the kernel log. These
> codes are easily found on popular search engines, but one is generally
> not able to access the internet when dealing with wireless connectivity
> issues.

Hello Calvin.

Some suggestions below...

> diff --git a/net/mac80211/main.c b/net/mac80211/main.c
[]
> @@ -743,6 +743,72 @@ static int ieee80211_init_cipher_suites(struct ieee80211_local *local)
>  	return 0;
>  }
>  
> +static const char *reason_code_strings[49] = {

static const char * const reason_etc...

> +	"(RESERVED)",
> +	"UNSPECIFIED",

etc..., but perhaps this thing below is fragile.

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

Perhaps use a more common kernel style

struct ieee80211_reason_descriptions {
	u16		code;
	const char *	desc;
}

and enumerate the reason codes with #defines and use a
macro to populate the descriptions

#define IEEE80211_REASON_RESERVED		0
#define IEEE80211_REASON_UNSPECIFIED		1

etc.

#define POPULATE_IEEE_REASON(code)			\
	{.code = IEEE80211_REASON_##code, .desc = #code}

static const struct ieee80211_reason_descriptions reasons[] = {
	POPULATE_IEEE_REASON(RESERVED),
	POPULATE_IEEE_REASON(UNSPECIFIED),
	[etc...]
};

So this function becomes something like:

const char *ieee80211_get_reason_code_string(u16 reason_code)
{
	int i;

	for (i = 0; i < ARRAY_SIZE(reasons); i++) {
		if (reasons[i].code == reason_code)
			return reasons[i].desc;
	}

	return "UNKNOWN";
}

This seems a lot less fragile.

> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
[]
> @@ -2231,8 +2231,8 @@ static void ieee80211_rx_mgmt_deauth(struct ieee80211_sub_if_data *sdata,
>  
>  	reason_code = le16_to_cpu(mgmt->u.deauth.reason_code);
>  
> -	sdata_info(sdata, "deauthenticated from %pM (Reason: %u)\n",
> -		   bssid, reason_code);
> +	sdata_info(sdata, "deauthenticated from %pM (reason: %s)\n",
> +		   bssid, ieee80211_get_reason_code_string(reason_code));

Perhaps

	"%u:%s",
	reason_code, ieee80211_get_reason_code_string(reason_code))

might be better here and the other places.

