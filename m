Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758547AbaKALnj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 07:43:39 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:44733 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756970AbaKALni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 07:43:38 -0400
X-Auth-Info: wd3VRUAazVUh8J54A27arbUPJyBqAWjcxdRoGOxCLjc=
From: Marek Vasut <marex@denx.de>
To: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH] crypto: caam: fix error reporting
Date: Sat, 1 Nov 2014 12:43:31 +0100
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.13.1; x86_64; ; )
Cc: Cristian Stoica <cristian.stoica@freescale.com>,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        horia.geanta@freescale.com
References: <1414774653-3583-1-git-send-email-cristian.stoica@freescale.com> <20141031132209.5abced3ca9f55649d0bd6007@freescale.com>
In-Reply-To: <20141031132209.5abced3ca9f55649d0bd6007@freescale.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201411011243.31501.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 31, 2014 at 07:22:09 PM, Kim Phillips wrote:
> On Fri, 31 Oct 2014 18:57:33 +0200
> 
> Cristian Stoica <cristian.stoica@freescale.com> wrote:
> > The error code returned by hardware is four bits wide with an expected
> > zero MSB. A hardware error condition where the error code can get between
> > 0x8 and 0xf will trigger an out of bound array access on the error
> > message table.
> 
> If this issue was brought up by h/w, the appropriate new error codes
> should be being introduced.
> 
> Otherwise, I'm assuming it was brought up by a static code analyser,
> which technically could be ignored, but...
> 
> > -	/*
> > -	 * If there is no further error handling function, just
> > -	 * print the error code, error string and exit. Otherwise
> > -	 * call the handler function.
> > -	 */
> 
> why remove the comment?  It's still valid.
> 
> > -	if (!status_src[ssrc].report_ssed)
> > -		dev_err(jrdev, "%08x: %s: \n", status, status_src[ssrc].error);
> > -	else
> > +	if (status_src[ssrc].report_ssed)
> > 
> >  		status_src[ssrc].report_ssed(jrdev, status, error);
> > 
> > +	else if (error)
> > +		dev_err(jrdev, "%d: %s\n", ssrc, error);
> > +	else
> > +		dev_err(jrdev, "%d: unknown error code\n", ssrc);
> 
> This is simpler:
> 
> diff --git a/drivers/crypto/caam/error.c b/drivers/crypto/caam/error.c
> index 6531054..6f4a148 100644
> --- a/drivers/crypto/caam/error.c
> +++ b/drivers/crypto/caam/error.c
> @@ -224,7 +224,12 @@ void caam_jr_strstatus(struct device *jrdev, u32
> status) { report_cond_code_status, "Condition Code" },
>         };
>         u32 ssrc = status >> JRSTA_SSRC_SHIFT;
> -       const char *error = status_src[ssrc].error;
> +       const char *error;
> +
> +       if (ssrc >= ARRAY_SIZE(status_src)) {
> +               dev_err(jrdev, "unknown error status source %d\n", ssrc);
> +               return;
> +       }
> 
>         /*
>          * If there is no further error handling function, just

This indeed makes sense.

Best regards,
Marek Vasut
