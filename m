Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758879AbaJaSli (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 14:41:38 -0400
Received: from mail-by2on0122.outbound.protection.outlook.com ([207.46.100.122]:13973
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750778AbaJaSlh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 14:41:37 -0400
Date: Fri, 31 Oct 2014 13:22:09 -0500
From: Kim Phillips <kim.phillips@freescale.com>
To: Cristian Stoica <cristian.stoica@freescale.com>
CC: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <horia.geanta@freescale.com>, <marex@denx.de>
Subject: Re: [PATCH] crypto: caam: fix error reporting
Message-ID: <20141031132209.5abced3ca9f55649d0bd6007@freescale.com>
In-Reply-To: <1414774653-3583-1-git-send-email-cristian.stoica@freescale.com>
References: <1414774653-3583-1-git-send-email-cristian.stoica@freescale.com>
Organization: Freescale Semiconductor, Inc.
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(24454002)(50466002)(46102003)(50226001)(4396001)(104016003)(64706001)(62966003)(89996001)(33646002)(36756003)(87936001)(23726002)(97736003)(100306002)(88136002)(47776003)(20776003)(87286001)(6806004)(19580395003)(69596002)(44976005)(19580405001)(107046002)(46406003)(110136001)(21056001)(68736004)(106466001)(104166001)(31966008)(81156004)(26826002)(95666004)(102836001)(84676001)(105606002)(50986999)(76176999)(120916001)(99396003)(92566001)(93916002)(92726001)(86362001)(77156002);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR03MB392;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB392;
X-Forefront-PRVS: 03818C953D
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Kim.Phillips@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Oct 2014 18:57:33 +0200
Cristian Stoica <cristian.stoica@freescale.com> wrote:

> The error code returned by hardware is four bits wide with an expected
> zero MSB. A hardware error condition where the error code can get between
> 0x8 and 0xf will trigger an out of bound array access on the error
> message table.

If this issue was brought up by h/w, the appropriate new error codes
should be being introduced.

Otherwise, I'm assuming it was brought up by a static code analyser,
which technically could be ignored, but...

> -	/*
> -	 * If there is no further error handling function, just
> -	 * print the error code, error string and exit. Otherwise
> -	 * call the handler function.
> -	 */

why remove the comment?  It's still valid.

> -	if (!status_src[ssrc].report_ssed)
> -		dev_err(jrdev, "%08x: %s: \n", status, status_src[ssrc].error);
> -	else
> +	if (status_src[ssrc].report_ssed)
>  		status_src[ssrc].report_ssed(jrdev, status, error);
> +	else if (error)
> +		dev_err(jrdev, "%d: %s\n", ssrc, error);
> +	else
> +		dev_err(jrdev, "%d: unknown error code\n", ssrc);

This is simpler:

diff --git a/drivers/crypto/caam/error.c b/drivers/crypto/caam/error.c
index 6531054..6f4a148 100644
--- a/drivers/crypto/caam/error.c
+++ b/drivers/crypto/caam/error.c
@@ -224,7 +224,12 @@ void caam_jr_strstatus(struct device *jrdev, u32 status)
                { report_cond_code_status, "Condition Code" },
        };
        u32 ssrc = status >> JRSTA_SSRC_SHIFT;
-       const char *error = status_src[ssrc].error;
+       const char *error;
+
+       if (ssrc >= ARRAY_SIZE(status_src)) {
+               dev_err(jrdev, "unknown error status source %d\n", ssrc);
+               return;
+       }
 
        /*
         * If there is no further error handling function, just

Kim
