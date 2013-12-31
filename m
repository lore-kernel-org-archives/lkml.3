Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959Ab3LaQxO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 11:53:14 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:38628 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695Ab3LaQxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 11:53:13 -0500
Date: Tue, 31 Dec 2013 19:52:58 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Michael Gunselmann <michael.gunselmann@studium.uni-erlangen.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@i4.cs.fau.de,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        martin.hofmann@studium.uni-erlangen.de, forest@alittletooquiet.net
Subject: Re: [PATCH 4/7] vt6655: Fixed most of the checkpatch warnings in wpa2
Message-ID: <20131231165258.GU28413@mwanda>
References: <1388415157-17615-1-git-send-email-michael.gunselmann@studium.uni-erlangen.de>
 <1388415157-17615-5-git-send-email-michael.gunselmann@studium.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1388415157-17615-5-git-send-email-michael.gunselmann@studium.uni-erlangen.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 30, 2013 at 03:52:34PM +0100, Michael Gunselmann wrote:
> wpa2.h: Checkpatch does no longer complain about anything
> 
> wpa2.c: Checkpatch complains about some lines that are longer than
> 	80 characters. Breaking them would deteriorate the readability
> 	so these lines were not touched.
> 
> vntwifi.c: Fixing style problems in wpa2.h made it necessary to adjust
> 	   variable declarations that depended on typedefs in wpa2.h.
> 	   The checkpatch cleanup of this file still remains.
> 

This patch changes too many things at once to review comfortably.  It
random changes to several files all jumbled together.  Break it apart
into logical chunks and resend.

>  
> -		if (pRSN->len >= 8) { // ver(2) + GK(4) + PK count(2)
> -			pBSSNode->wCSSPKCount = *((unsigned short *)&(pRSN->abyRSN[4]));
> +		if (pRSN->len >= 8) { /* ver(2) + GK(4) + PK count(2) */
> +			pBSSNode->wCSSPKCount =
> +				*((unsigned short *)&(pRSN->abyRSN[4]));
>  			j = 0;
>  			pbyOUI = &(pRSN->abyRSN[6]);
>  
> -			for (i = 0; (i < pBSSNode->wCSSPKCount) && (j < sizeof(pBSSNode->abyCSSPK)/sizeof(unsigned char)); i++) {
> -				if (pRSN->len >= 8+i*4+4) { // ver(2)+GK(4)+PKCnt(2)+PKS(4*i)
> +			for (i = 0; (i < pBSSNode->wCSSPKCount)
> +				     && (j < sizeof(pBSSNode->abyCSSPK)/sizeof(unsigned char));
> +			     i++) {


This for loop is a quite nasty.  It would be better to check "j"
separately inside the loop.  There should be spaces around the divide
operation but really the "j" condition should just be:

	j < ARRAY_SIZE(pBSSNode->abyCSSPK)

> +				/* ver(2)+GK(4)+PKCnt(2)+PKS(4*i) */
> +				if (pRSN->len >= 8+i*4+4) {
>  					if (!memcmp(pbyOUI, abyOUIGK, 4)) {
> -						pBSSNode->abyCSSPK[j++] = WLAN_11i_CSS_USE_GROUP;
> +						pBSSNode->abyCSSPK[j++] =
> +							WLAN_11i_CSS_USE_GROUP;
>  						bUseGK = true;
> -					} else if (!memcmp(pbyOUI, abyOUIWEP40, 4)) {
> -						// Invalid CSS, continue to parsing
> -					} else if (!memcmp(pbyOUI, abyOUITKIP, 4)) {
> -						if (pBSSNode->byCSSGK != WLAN_11i_CSS_CCMP)
> -							pBSSNode->abyCSSPK[j++] = WLAN_11i_CSS_TKIP;
> -						else
> -							; // Invalid CSS, continue to parsing
> -					} else if (!memcmp(pbyOUI, abyOUICCMP, 4)) {
> -						pBSSNode->abyCSSPK[j++] = WLAN_11i_CSS_CCMP;
> -					} else if (!memcmp(pbyOUI, abyOUIWEP104, 4)) {
> -						// Invalid CSS, continue to parsing
> -					} else {
> -						// any vendor checks here
> -						pBSSNode->abyCSSPK[j++] = WLAN_11i_CSS_UNKNOWN;
> -					}
> +					} else if (!memcmp(pbyOUI, abyOUIWEP40, 4))
> +						; /* Invalid CSS, continue to parsing */
> +					else if ((!memcmp(pbyOUI, abyOUITKIP, 4))
> +						 && (pBSSNode->byCSSGK != WLAN_11i_CSS_CCMP))
> +						pBSSNode->abyCSSPK[j++] =
> +							WLAN_11i_CSS_TKIP;
> +					else if (!memcmp(pbyOUI, abyOUICCMP, 4))
> +						pBSSNode->abyCSSPK[j++] =
> +							WLAN_11i_CSS_CCMP;
> +					else if (!memcmp(pbyOUI, abyOUIWEP104, 4))
> +						; /* Invalid CSS, continue to parsing */
> +					else
> +						/* any vendor checks here */
> +						pBSSNode->abyCSSPK[j++] =
> +							WLAN_11i_CSS_UNKNOWN;
>  					pbyOUI += 4;

You have changed the logic here without meaning to.  Can you spot the
bug?

I don't like the way the lines are broken at all.  This is a randomly
indented text jumble.  *SPLATCH!*.

If you need to break up a compound condition put the "&&" at the end
of the first line instead of at the start of the second line.
Multi-line indents get curly braces for readability, even though they
are not needed for syntax reasons.  So it would be:

				} else {
					/* any vendor checks here */
					pBSSNode->abyCSSPK[j++] = WLAN_11i_CSS_UNKNOWN;
				}

I know that is over the 80 character limit, so checkpatch.pl will
complain but checkpatch.pl is a perl script and not the king of the
world.  Don't make the code worse just to please a perl script.

The real reason we are going past the end of the line here is because
the code is indented 40 characters to begin with.  You could bring it in
one indent level by reversing the break condition.

			if (pRSN->len < 8 + i * 4 + 4)
				break;

> -					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "abyCSSPK[%d]: %X\n", j-1, pBSSNode->abyCSSPK[j-1]);
> +					DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
> +						"abyCSSPK[%d]: %X\n", j-1,
> +						pBSSNode->abyCSSPK[j-1]);
>  				} else
>  					break;
> -			} //for
> +			} /* for */
                          ^^^^^^^^^
Delete these nonsense comments.

regards,
dan carpenter

