Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817Ab3LBFKL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 00:10:11 -0500
Received: from mail-db9lp0250.outbound.messaging.microsoft.com ([213.199.154.250]:43551
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750967Ab3LBFKI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 00:10:08 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 2
X-BigFish: VS2(z579eh6cdkzdb82h1102I1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6hzz1de097hz2dh109h2a8h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h19ceh1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h2184h21a6h2216h22d0h2336hbe9i1155h)
From: Peter Chen <Peter.Chen@freescale.com>
To: Chris Ruehl <chris.ruehl@gtsys.com.hk>
CC: "alexander.shishkin@linux.intel.com" 
	<alexander.shishkin@linux.intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/3 v3] usb: chipidea: Fix Internal error: : 808 [#1]
 ARM related to STS flag
Thread-Topic: [PATCH 2/3 v3] usb: chipidea: Fix Internal error: : 808 [#1]
 ARM related to STS flag
Thread-Index: AQHO7X+Nm+SsIvgQf0Gz6GYyRX43tZo9j3TQgAKXCgCAADPVkA==
Date: Mon, 2 Dec 2013 05:10:04 +0000
Message-ID: <F281D0F91ED19E4D8E63A7504E8A64980413D5A8@039-SN2MPN1-021.039d.mgd.msft.net>
References: <1385783513-22502-1-git-send-email-chris.ruehl@gtsys.com.hk>
 <F281D0F91ED19E4D8E63A7504E8A64980413B204@039-SN2MPN1-021.039d.mgd.msft.net>
 <529BE72C.9030805@gtsys.com.hk>
In-Reply-To: <529BE72C.9030805@gtsys.com.hk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [114.86.20.54]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> 
> If you have a look into the function hw_write() you will see that there
> is no
> effect if hw_write(...,sts) is called with sts=0/1, because the mask will
> cut
> off all bits beside BIT(29).

Yes, it is my careless. I thought sts is PORTCS_STS.

> I used BIT(29) rather then PORTCS_STS to make it more clear what going on.

It is not a good coding style, you do need use MACRO to instead of raw number directly.

> A write to PORTCS will always be "0" for the STS Register no matter if
> sts is 1
> or 0 within Patch v2. Patch v3 will take care of the registers bit
> position and
> set 1 or 0 to PORTCS_STS.
>

My suggestion like below:

	if (ci->hw_bank.lpm) {
 		hw_write(ci, OP_DEVLC, DEVLC_PTS(7) | DEVLC_PTW, lpm);
-		hw_write(ci, OP_DEVLC, DEVLC_STS, sts);
+		if (sts)
+			hw_write(ci, OP_DEVLC, DEVLC_STS, DEVLC_STS);
 	} else {
 		hw_write(ci, OP_PORTSC, PORTSC_PTS(7) | PORTSC_PTW, portsc);
-		hw_write(ci, OP_PORTSC, PORTSC_STS, sts);
+		if (sts)
+			hw_write(ci, OP_PORTSC, PORTSC_STS, PORTSC_STS);
 	}


I think we just need to fix the original bug, and do not add any new fixes
since we don't know which one is correct for every platform. My proposal is 
just set PORTSC_STS (DEVLC_STS is lpm) if it is serial PHY. For any other PHYS, just keep
the reset value.

Peter
 
> I used the imx27 reference manual Capital 30.8.1.5.12 PORTSCx.
> 




