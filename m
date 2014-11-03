Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463AbaKCTwi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 14:52:38 -0500
Received: from mail-by2on0114.outbound.protection.outlook.com ([207.46.100.114]:64896
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752340AbaKCTwf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 14:52:35 -0500
Date: Mon, 3 Nov 2014 13:47:16 -0600
From: Kim Phillips <kim.phillips@freescale.com>
To: Cristian Stoica <cristian.stoica@freescale.com>
CC: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <horia.geanta@freescale.com>, <marex@denx.de>
Subject: Re: [PATCH] crypto: caam: fix error reporting
Message-ID: <20141103134716.775acd39d6334c6f8aeca151@freescale.com>
In-Reply-To: <5457486C.3030205@freescale.com>
References: <1414774653-3583-1-git-send-email-cristian.stoica@freescale.com>
	<20141031132209.5abced3ca9f55649d0bd6007@freescale.com>
	<5457486C.3030205@freescale.com>
Organization: Freescale Semiconductor, Inc.
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(51704005)(377454003)(479174003)(24454002)(87286001)(33646002)(87936001)(89996001)(36756003)(88136002)(23726002)(104016003)(110136001)(92566001)(93916002)(47776003)(46102003)(86362001)(20776003)(62966003)(92726001)(64706001)(97736003)(100306002)(50466002)(76176999)(105606002)(84676001)(120916001)(50986999)(26826002)(102836001)(104166001)(68736004)(107046002)(95666004)(50226001)(31966008)(19580405001)(99396003)(106466001)(21056001)(44976005)(19580395003)(6806004)(4396001)(46406003)(77156002);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB388;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB388;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0384275935
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Kim.Phillips@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Nov 2014 11:18:36 +0200
Cristian Stoica <cristian.stoica@freescale.com> wrote:

> On 10/31/2014 08:22 PM, Kim Phillips wrote:
> > On Fri, 31 Oct 2014 18:57:33 +0200
> > Cristian Stoica <cristian.stoica@freescale.com> wrote:
> > 
> > If this issue was brought up by h/w, the appropriate new error codes
> > should be being introduced.
> 
> If you have the new error codes please send them to me and I'll make an
> update.

I was mainly inquiring as to the motive of the patch.  fwiw, I don't
see error codes with the most significant bit set in the latest
documentation (which is available from STC).

> > Otherwise, I'm assuming it was brought up by a static code analyser,
> > which technically could be ignored, but...
> 
> Actually, our static code analyzer did not see this one.

ok, so the patch technically isn't fixing anything broken, then.

> >> -	/*
> >> -	 * If there is no further error handling function, just
> >> -	 * print the error code, error string and exit. Otherwise
> >> -	 * call the handler function.
> >> -	 */
> > 
> > why remove the comment?  It's still valid.
> 
> The comment was disagreeing with the new code, so I just removed it.

the new code just added a new condition, which doesn't invalidate
the comment.  And simply removing the comment as opposed to amending
it is a bit overkill.

> >> -	if (!status_src[ssrc].report_ssed)
> >> -		dev_err(jrdev, "%08x: %s: \n", status, status_src[ssrc].error);
> >> -	else
> >> +	if (status_src[ssrc].report_ssed)
> >>  		status_src[ssrc].report_ssed(jrdev, status, error);
> >> +	else if (error)
> >> +		dev_err(jrdev, "%d: %s\n", ssrc, error);
> >> +	else
> >> +		dev_err(jrdev, "%d: unknown error code\n", ssrc);
> > 
> > This is simpler:
> > 
> > diff --git a/drivers/crypto/caam/error.c b/drivers/crypto/caam/error.c
> > index 6531054..6f4a148 100644
> > --- a/drivers/crypto/caam/error.c
> > +++ b/drivers/crypto/caam/error.c
> > @@ -224,7 +224,12 @@ void caam_jr_strstatus(struct device *jrdev, u32 status)
> >                 { report_cond_code_status, "Condition Code" },
> >         };
> >         u32 ssrc = status >> JRSTA_SSRC_SHIFT;
> > -       const char *error = status_src[ssrc].error;
> > +       const char *error;
> > +
> > +       if (ssrc >= ARRAY_SIZE(status_src)) {
> > +               dev_err(jrdev, "unknown error status source %d\n", ssrc);
> > +               return;
> > +       }
> 
> It is indeed simpler but does it consider also the missing error codes
> at index 1 and 5? Just checking for an upper bound is not enough.

no, the existing code already handles that.  Note that newer
documentation fills the 1 and 5 slots, too.

> On the other hand, if the error field is only three bits wide instead of
> four as stated by the documentation, a better fix means using a three
> bit mask instead of reporting an invalid error code.

true, but then we'd introduce a direct discrepancy with the
documentation, and thus h/w.

Kim
