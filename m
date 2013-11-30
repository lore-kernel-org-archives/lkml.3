Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434Ab3K3KPC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 05:15:02 -0500
Received: from mail-db9lp0252.outbound.messaging.microsoft.com ([213.199.154.252]:27299
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750994Ab3K3KO7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 05:14:59 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 7
X-BigFish: VS7(z579eh6cdkz1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6hzz1de098h17326ah8275dh1de097h186068ha509lz2dh109h2a8h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h19ceh1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h2184h21a6h2216h22d0h2336hbe9i1155h)
From: Peter Chen <Peter.Chen@freescale.com>
To: Michael Grzeschik <mgr@pengutronix.de>,
        Chris Ruehl <chris.ruehl@gtsys.com.hk>
CC: "alexander.shishkin@linux.intel.com" 
	<alexander.shishkin@linux.intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/3 v2] usb: chipidea: Fix Internal error: : 808 [#1]
 ARM related to STS flag
Thread-Topic: [PATCH 2/3 v2] usb: chipidea: Fix Internal error: : 808 [#1]
 ARM related to STS flag
Thread-Index: AQHO7NN7PUjosVZfh0axoC7TxABhL5o8h94AgAEAO7A=
Date: Sat, 30 Nov 2013 10:14:51 +0000
Message-ID: <F281D0F91ED19E4D8E63A7504E8A64980413B1EF@039-SN2MPN1-021.039d.mgd.msft.net>
References: <1385709585-10459-1-git-send-email-chris.ruehl@gtsys.com.hk>
 <20131129182812.GF3516@pengutronix.de>
In-Reply-To: <20131129182812.GF3516@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [114.84.183.131]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 
> >  {
> >  	u32 portsc, lpm, sts = 0;
> >
> >  	switch (ci->platdata->phy_mode) {
> >  	case USBPHY_INTERFACE_MODE_UTMI:
> >  		portsc = PORTSC_PTS(PTS_UTMI);
> > @@ -273,10 +275,12 @@ static void hw_phymode_configure(struct ci_hdrc
> *ci)
> >
> >  	if (ci->hw_bank.lpm) {
> >  		hw_write(ci, OP_DEVLC, DEVLC_PTS(7) | DEVLC_PTW, lpm);
> > -		hw_write(ci, OP_DEVLC, DEVLC_STS, sts);
> > +		if (sts)
> > +			hw_write(ci, OP_DEVLC, DEVLC_STS, sts);
> >  	} else {
> >  		hw_write(ci, OP_PORTSC, PORTSC_PTS(7) | PORTSC_PTW, portsc);
> > -		hw_write(ci, OP_PORTSC, PORTSC_STS, sts);
> > +		if ( sts )
> > +			hw_write(ci, OP_PORTSC, PORTSC_STS, sts);
> 
> The conditions coding style is broken.
> 
> >  	}
> >  }
> 
> Still don't get why a system with ehci compliant PORTSC register
> should not want to have the sts bit _explicitly_ set to 0 if
> we don't use serial phy mode. So NACK!
> 

At current code the PORTSC_STS is set to unknown value due to sts is
uninitialized, and it causes ARM internal error at Chris's imx27 platform.

This patch just gives sts an initialized value, and only set PORTSC_STS
for serial phy, it follows the code original logic mostly.

Until now, no one reports problem due to the wrong value of PORTSC_STS, it means
both 1 and 0 are working for most of platforms. So, just keep its current logic
until someone blames.

The chipidea datasheet said "This bit has no effect unless Parallel Transceiver Select is set to UTMI+.",
my imx6 uses UTIM+, but the controller works fine whether PORTSC_STS is 0 or 1.
My original idea is just delete the code about PORTSC_STS, but chris
mentions it is used by serial phy at current logic, then, just keep current logic.
 
Peter

> Michael
> 
> --
> Pengutronix e.K.                           |
> |
> Industrial Linux Solutions                 | http://www.pengutronix.de/
> |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0
> |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555
> |
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


