Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528Ab3K3KUV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 05:20:21 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:16767 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751017Ab3K3KUS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 05:20:18 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(z579eh6cdkz1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097hz2dh109h2a8h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h19ceh1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h2184h21a6h2216h22d0h2336hbe9i1155h)
From: Peter Chen <Peter.Chen@freescale.com>
To: Chris Ruehl <chris.ruehl@gtsys.com.hk>,
        "alexander.shishkin@linux.intel.com" 
	<alexander.shishkin@linux.intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/3 v3] usb: chipidea: Fix Internal error: : 808 [#1]
 ARM related to STS flag
Thread-Topic: [PATCH 2/3 v3] usb: chipidea: Fix Internal error: : 808 [#1]
 ARM related to STS flag
Thread-Index: AQHO7X+Nm+SsIvgQf0Gz6GYyRX43tZo9j3TQ
Date: Sat, 30 Nov 2013 10:20:13 +0000
Message-ID: <F281D0F91ED19E4D8E63A7504E8A64980413B204@039-SN2MPN1-021.039d.mgd.msft.net>
References: <1385783513-22502-1-git-send-email-chris.ruehl@gtsys.com.hk>
In-Reply-To: <1385783513-22502-1-git-send-email-chris.ruehl@gtsys.com.hk>
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

 
> 
> usb: chipidea: Fix Internal error: : 808 [#1] ARM related to STS flag
> 
> * init the sts flag to 0 (missed)
> * Set PORTCS_STS only if VUSB_HS_PHY_TYPE > 1
>   otherwise the register is ReadOnly
> * Set/Reset correct BIT(28)/BIT(29) for STS
> 
> Signed-off-by: Chris Ruehl <chris.ruehl@gtsys.com.hk>
> ---
>  drivers/usb/chipidea/core.c |   20 +++++++++++++++++---
>  1 file changed, 17 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/usb/chipidea/core.c b/drivers/usb/chipidea/core.c
> index 5075407..2c634c1 100644
> --- a/drivers/usb/chipidea/core.c
> +++ b/drivers/usb/chipidea/core.c
> @@ -243,7 +243,7 @@ static int hw_device_init(struct ci_hdrc *ci, void
> __iomem *base)
> 
>  static void hw_phymode_configure(struct ci_hdrc *ci)
>  {
> -	u32 portsc, lpm, sts;
> +	u32 portsc, lpm, sts = 0;
> 
>  	switch (ci->platdata->phy_mode) {
>  	case USBPHY_INTERFACE_MODE_UTMI:
> @@ -273,10 +273,24 @@ static void hw_phymode_configure(struct ci_hdrc *ci)
> 
>  	if (ci->hw_bank.lpm) {
>  		hw_write(ci, OP_DEVLC, DEVLC_PTS(7) | DEVLC_PTW, lpm);
> -		hw_write(ci, OP_DEVLC, DEVLC_STS, sts);
> +		if ( sts )
> +			hw_write(ci, OP_DEVLC, DEVLC_STS, BIT(28));
> +		else
> +			hw_write(ci, OP_DEVLC, DEVLC_STS, ~BIT(28));
>  	} else {
>  		hw_write(ci, OP_PORTSC, PORTSC_PTS(7) | PORTSC_PTW, portsc);
> -		hw_write(ci, OP_PORTSC, PORTSC_STS, sts);
> +		if (((portsc >> 30) & 0x3) > 1) {
> +			if (sts) {
> +				hw_write(ci, OP_PORTSC, PORTSC_STS, BIT(29));
> +			}
> +			else {
> +				portsc = (ioread32(ci->hw_bank.regmap[OP_PORTSC])
> +						& PORTSC_STS);
> +				if (portsc)
> +					hw_write(ci, OP_PORTSC, PORTSC_STS,
> +							~BIT(29));
> +			}
> +		}
>  	}
>  }
> 
> --

At my chipidea datasheet, the VUSB_HS_PHY_SERIAL is at HWGENERAL (bit[10..11]),
We are still not sure the portsc_sts is needed to set or clear, and how to do
it. My suggestion is just use v2 patch (except fixing one code style problem)

Peter


