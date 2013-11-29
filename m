Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275Ab3K2Eri (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 23:47:38 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:7381 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750972Ab3K2Erf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 23:47:35 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(z579eh6cdkz98dI9371I1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097hz2dh109h2a8h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h2184h21a6h2216h22d0h2336hbe9i1155h)
From: Peter Chen <Peter.Chen@freescale.com>
To: Chris Ruehl <chris.ruehl@gtsys.com.hk>
CC: "alexander.shishkin@linux.intel.com" 
	<alexander.shishkin@linux.intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/3] usb: chipidea: Fix Internal error: : 808 [#1] ARM
 related to STS flag
Thread-Topic: [PATCH 2/3] usb: chipidea: Fix Internal error: : 808 [#1] ARM
 related to STS flag
Thread-Index: AQHO7KfZ+Zd7XHwGEk62m3tz6khfvpo7ikZwgAAWy4CAAACwQA==
Date: Fri, 29 Nov 2013 04:47:30 +0000
Message-ID: <F281D0F91ED19E4D8E63A7504E8A649804139AEB@039-SN2MPN1-021.039d.mgd.msft.net>
References: <1385690869-32266-1-git-send-email-chris.ruehl@gtsys.com.hk>
 <F281D0F91ED19E4D8E63A7504E8A649804139AAE@039-SN2MPN1-021.039d.mgd.msft.net>
 <52981AD7.2020102@gtsys.com.hk>
In-Reply-To: <52981AD7.2020102@gtsys.com.hk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.242.175]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



 
> 
> On Friday, November 29, 2013 11:27 AM, Peter Chen wrote:
> >
> >> * init the sts flag to 0 (missed)
> >> * set the sts flag only if not 0
> >>
> > does PORTSC_STS bit as 1 or 0 affect your case?
> > If not, please remove hw_write(ci, OP_DEVLC, DEVLC_STS, sts),
> > since it is useless at current code logic.
> >
> > Peter
> 
> Peter,
> 
> in the switch statement sts is set to 1 therefore I think its used.
> 
>         case USBPHY_INTERFACE_MODE_SERIAL:
>                  portsc = PORTSC_PTS(PTS_SERIAL);
>                  lpm = DEVLC_PTS(PTS_SERIAL);
>                  sts = 1;
>                  break;
> 
> Regards
> Chris
> 
> 

Yes, you are right. It is just not showed at the patch.

Would you move the sts = 0 to sts declaration, it can reduce the code line.

u32 portsc, lpm, sts = 0;

> >
> >> Signed-off-by: Chris Ruehl <chris.ruehl@gtsys.com.hk>
> >> ---
> >>   drivers/usb/chipidea/core.c |    8 ++++++--
> >>   1 file changed, 6 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/usb/chipidea/core.c b/drivers/usb/chipidea/core.c
> >> index 5075407..1a6010e 100644
> >> --- a/drivers/usb/chipidea/core.c
> >> +++ b/drivers/usb/chipidea/core.c
> >> @@ -245,6 +245,8 @@ static void hw_phymode_configure(struct ci_hdrc
> *ci)
> >>   {
> >>   	u32 portsc, lpm, sts;
> >>
> >> +	sts = 0;
> >> +
> >>   	switch (ci->platdata->phy_mode) {
> >>   	case USBPHY_INTERFACE_MODE_UTMI:
> >>   		portsc = PORTSC_PTS(PTS_UTMI);
> >> @@ -273,10 +275,12 @@ static void hw_phymode_configure(struct ci_hdrc
> *ci)
> >>
> >>   	if (ci->hw_bank.lpm) {
> >>   		hw_write(ci, OP_DEVLC, DEVLC_PTS(7) | DEVLC_PTW, lpm);
> >> -		hw_write(ci, OP_DEVLC, DEVLC_STS, sts);
> >> +		if (sts)
> >> +			hw_write(ci, OP_DEVLC, DEVLC_STS, sts);
> >>   	} else {
> >>   		hw_write(ci, OP_PORTSC, PORTSC_PTS(7) | PORTSC_PTW, portsc);
> >> -		hw_write(ci, OP_PORTSC, PORTSC_STS, sts);
> >> +		if ( sts )
> >> +			hw_write(ci, OP_PORTSC, PORTSC_STS, sts);
> >>   	}
> >>   }
> >>
> >> --
 


