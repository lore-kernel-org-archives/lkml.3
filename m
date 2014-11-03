Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949AbaKCJe1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 04:34:27 -0500
Received: from mail-bn1on0135.outbound.protection.outlook.com ([157.56.110.135]:14256
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751541AbaKCJeZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 04:34:25 -0500
X-Greylist: delayed 937 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Nov 2014 04:34:25 EST
Message-ID: <5457486C.3030205@freescale.com>
Date: Mon, 3 Nov 2014 11:18:36 +0200
From: Cristian Stoica <cristian.stoica@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Kim Phillips <kim.phillips@freescale.com>
CC: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <horia.geanta@freescale.com>, <marex@denx.de>
Subject: Re: [PATCH] crypto: caam: fix error reporting
References: <1414774653-3583-1-git-send-email-cristian.stoica@freescale.com>
 <20141031132209.5abced3ca9f55649d0bd6007@freescale.com>
In-Reply-To: <20141031132209.5abced3ca9f55649d0bd6007@freescale.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(51704005)(24454002)(377454003)(479174003)(64126003)(6806004)(19580395003)(64706001)(36756003)(4396001)(47776003)(46102003)(50466002)(62966003)(104016003)(87936001)(97736003)(20776003)(69596002)(19580405001)(107046002)(65806001)(110136001)(21056001)(83506001)(68736004)(59896002)(65956001)(106466001)(31966008)(26826002)(44976005)(80316001)(23756003)(84676001)(95666004)(81156004)(105606002)(102836001)(99136001)(65816999)(92726001)(33656002)(92566001)(54356999)(120916001)(99396003)(87266999)(76176999)(50986999)(77156002);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR03MB392;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB392;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0384275935
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=B18196@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kim,

On 10/31/2014 08:22 PM, Kim Phillips wrote:
> On Fri, 31 Oct 2014 18:57:33 +0200
> Cristian Stoica <cristian.stoica@freescale.com> wrote:
> 
> If this issue was brought up by h/w, the appropriate new error codes
> should be being introduced.

If you have the new error codes please send them to me and I'll make an
update.

> Otherwise, I'm assuming it was brought up by a static code analyser,
> which technically could be ignored, but...

Actually, our static code analyzer did not see this one.

>> -	/*
>> -	 * If there is no further error handling function, just
>> -	 * print the error code, error string and exit. Otherwise
>> -	 * call the handler function.
>> -	 */
> 
> why remove the comment?  It's still valid.

The comment was disagreeing with the new code, so I just removed it.

>> -	if (!status_src[ssrc].report_ssed)
>> -		dev_err(jrdev, "%08x: %s: \n", status, status_src[ssrc].error);
>> -	else
>> +	if (status_src[ssrc].report_ssed)
>>  		status_src[ssrc].report_ssed(jrdev, status, error);
>> +	else if (error)
>> +		dev_err(jrdev, "%d: %s\n", ssrc, error);
>> +	else
>> +		dev_err(jrdev, "%d: unknown error code\n", ssrc);
> 
> This is simpler:
> 
> diff --git a/drivers/crypto/caam/error.c b/drivers/crypto/caam/error.c
> index 6531054..6f4a148 100644
> --- a/drivers/crypto/caam/error.c
> +++ b/drivers/crypto/caam/error.c
> @@ -224,7 +224,12 @@ void caam_jr_strstatus(struct device *jrdev, u32 status)
>                 { report_cond_code_status, "Condition Code" },
>         };
>         u32 ssrc = status >> JRSTA_SSRC_SHIFT;
> -       const char *error = status_src[ssrc].error;
> +       const char *error;
> +
> +       if (ssrc >= ARRAY_SIZE(status_src)) {
> +               dev_err(jrdev, "unknown error status source %d\n", ssrc);
> +               return;
> +       }

It is indeed simpler but does it consider also the missing error codes
at index 1 and 5? Just checking for an upper bound is not enough.

On the other hand, if the error field is only three bits wide instead of
four as stated by the documentation, a better fix means using a three
bit mask instead of reporting an invalid error code.


Thanks for review,

Cristian S.
