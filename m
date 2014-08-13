Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576AbaHMSwz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 14:52:55 -0400
Received: from smtprelay4.synopsys.com ([198.182.44.111]:35402 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750AbaHMSww convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 14:52:52 -0400
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: "narmstrong@neotion.com" <narmstrong@neotion.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ben-linux@fluff.org" <ben-linux@fluff.org>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "r.baldyga@samsung.com" <r.baldyga@samsung.com>
Subject: RE: [PATCH RFC] usb: gadget: dwc2: make driver run on a version
 3.10a instance of DWC_OTG
Thread-Topic: [PATCH RFC] usb: gadget: dwc2: make driver run on a version
 3.10a instance of DWC_OTG
Thread-Index: AQHPtvB39q2cMpg72kaHROiuyQ5frpvO2fow
Date: Wed, 13 Aug 2014 18:52:46 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E0304844C7510@US01WEMBX2.internal.synopsys.com>
References: <53EB5732.3010704@neotion.com>
In-Reply-To: <53EB5732.3010704@neotion.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.64.241]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Neil Armstrong [mailto:narmstrong@neotion.com]
> Sent: Wednesday, August 13, 2014 5:17 AM
> 
> We are trying to make a driver run on our PCD only instance of Synopsys
> DWC_OTG IP with the following parameters :
> - Dedicated Fifos : Yes
> - Descriptor DMA : Yes
> - PHY : 8bit UTMI+ (may need also support for ULPI)
> - Endpoints : 6 (7 with ep0)
> - Periodic IN Endpoints : 0
> - IN Endpoints : 3 (4 with ep0)
> - EP repartition : INOUT, IN, OUT, IN , OUT, IN, OUT
> - DFifo Depth : 1844
> 
> I do not know what is the original s3c hsotg IP config, but to
> correctly support the Dedicated Fifos you need to attribute a FIFO
> index for each IN endpoints, and on the 3.10a release we only have
> 4 TX FIFOS, so we just cannot give the EP number as fifo index.
> 
> It impacts the FIFO repartition, it is not perfect since we do
> not take into account the Isochronous needs, so it needs some
> rework.
> 
> To managed these FIFOs, I load from the registers the EP
> repartition, HW fifo depth and HW revision.
> It also impacts that hw_cfg must be done before init call.
> 
> Same for the num_of_eps value, in the Synopsys documentation,
> it specifies it is the count of non-ep0 endpoints, but the
> driver for loops where like :
> for(i = 1 ; i < hsotg->num_of_eps ; ++i)
> which is absolutely invalid and ignores the last EP.
> 
> We never managed to make the driver work in FIFO mode, but in DMA
> mode it works like a charm, and to support all the gadget drivers,
> we implemented a silly Bounce Buffer mode.
> 
> The PHY configuration was also rewritten according to the
> documentation.
> 
> Fo the descripto DMA mode, I tried to add missing parts, but I get stuck
> with weird HW beheviours....

Hi Neil,

Thanks for your work on this.

First off, please always submit patches, even RFCs, with the proper
kernel coding style. scripts/checkpatch.pl will help you there. That
way other developers are more likely to take your patches seriously.

Second, you should base your work on top of Robert Baldyga's patch
series "usb: dwc2/gadget: fix series". That should be going into the
kernel when the merge window opens up next week. That series also
touches the FIFO configuration code. You can find it at
http://marc.info/?l=linux-kernel&m=140568383216978.

Third, it looks like we may need some way to customize the FIFO
configuration depending on the platform. I don't think it's possible
to configure the FIFOs properly for all platforms otherwise. Maybe
you and Robert could work together on that?

Fourth, you should split out the fixes (like the off-by-one in the
endpoint loops) into separate patches. Those could be applied right
away.

Other than that, this looks OK to me. I especially like that you are
providing a way to enable DMA support, since I will need that myself in
the near future ;)

-- 
Paul

