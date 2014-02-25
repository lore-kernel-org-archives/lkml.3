Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751787AbaBYHXV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 02:23:21 -0500
Received: from mail-bl2lp0212.outbound.protection.outlook.com ([207.46.163.212]:2795
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751336AbaBYHXT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 02:23:19 -0500
From: Peter Chen <Peter.Chen@freescale.com>
To: Neil Zhang <zhangwm@marvell.com>
CC: "balbi@ti.com" <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 5/6] USB: gadget: mv_udc: workaroud for missing dTD
Thread-Topic: [PATCH 5/6] USB: gadget: mv_udc: workaroud for missing dTD
Thread-Index: AQHPMTc/kouVh98R40eL0Q51ygcj35rF5SsA//+rgACAAAGfEA==
Date: Tue, 25 Feb 2014 07:22:57 +0000
Message-ID: <7e44e2c0403f4491b52d434925158536@BN1PR03MB235.namprd03.prod.outlook.com>
References: <1393228996-14787-1-git-send-email-zhangwm@marvell.com>
 <1393228996-14787-6-git-send-email-zhangwm@marvell.com>
 <20140225041854.GB14793@shlinux1.ap.freescale.net>
 <175CCF5F49938B4D99B2E3EF7F558EBE54EC4135A6@SC-VEXCH4.marvell.com>
In-Reply-To: <175CCF5F49938B4D99B2E3EF7F558EBE54EC4135A6@SC-VEXCH4.marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.50]
x-forefront-prvs: 01334458E5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(199002)(189002)(51704005)(24454002)(76796001)(76576001)(76786001)(81542001)(81342001)(69226001)(77982001)(59766001)(79102001)(74706001)(74876001)(74316001)(74366001)(33646001)(63696002)(66066001)(80022001)(51856001)(86362001)(93136001)(85306002)(65816001)(94316002)(93516002)(95416001)(92566001)(87936001)(94946001)(90146001)(80976001)(56816005)(83072002)(83322001)(19580395003)(19580405001)(85852003)(95666003)(46102001)(4396001)(54356001)(53806001)(77096001)(47976001)(47736001)(50986001)(49866001)(47446002)(74502001)(2656002)(81816001)(74662001)(87266001)(54316002)(56776001)(81686001)(76482001)(31966008)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB417;H:BN1PR03MB235.namprd03.prod.outlook.com;CLIP:123.151.195.50;FPR:8C7EE15E.9FDADF19.F3D11F43.CEEA5A52.2039B;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



 
> > From: Peter Chen [mailto:peter.chen@freescale.com]
> > Sent: 2014年2月25日 12:19
> > To: Neil Zhang
> > Cc: balbi@ti.com; gregkh@linuxfoundation.org;
> > linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org
> > Subject: Re: [PATCH 5/6] USB: gadget: mv_udc: workaroud for missing
> > dTD
> >
> > On Mon, Feb 24, 2014 at 04:03:15PM +0800, Neil Zhang wrote:
> > > There is an issue with the add dTD tripwire semaphore (ATDTW bit in
> > > USBCMD register) that can cause the controller to ignore a dTD that
> > > is added to a primed endpoint. When this happens, the software can
> > > read the tripwire bit and the status bit at '1' even though the
> > > endpoint is unprimed.
> > >
> > > After executing a dTD, the device controller endpoint state machine
> > > executes a final read of the dTD terminate bit to check if the
> > > application added a dTD to the linked list at the last moment. This
> > > read is done in the finpkt_read_latest_next_td (44) state. After the
> > > read is performed, if the terminate bit is still set, the state
> > > machine moves to unprime the endpoint. The decision to unprime the
> > > endpoint is done in the checkqh_decision (59) state, based on the
> > > value of
> > the terminate bit.
> > >
> > > Before reaching the checkqh_decision state, the state machine
> > > traverses the writeqhtd_status (57), writeqh_status (56), and
> > > release_prime_mask
> > > (42) states. As shown in the waveform, the ep_addtd_tripwire_clr
> > > signal is not set to clear the tripwire bit in these states.
> > >
> > > Signed-off-by: Neil Zhang <zhangwm@marvell.com>
> > > ---
> > >  drivers/usb/gadget/mv_udc_core.c |   20 ++++++++++++++++++++
> > >  1 file changed, 20 insertions(+)
> > >
> > > diff --git a/drivers/usb/gadget/mv_udc_core.c
> > > b/drivers/usb/gadget/mv_udc_core.c
> > > index a620cff..8df8606 100644
> > > --- a/drivers/usb/gadget/mv_udc_core.c
> > > +++ b/drivers/usb/gadget/mv_udc_core.c
> > > @@ -196,7 +196,27 @@ static int process_ep_req(struct mv_udc *udc,
> > > int
> > index,
> > >  			while (readl(&udc->op_regs->epstatus) & bit_pos)
> > >  				udelay(1);
> > >  			break;
> > > +		} else {
> > > +			if (!(readl(&udc->op_regs->epstatus) & bit_pos)) {
> > > +				/* The DMA engine thinks there is no more dTD */
> > > +				curr_dqh->next_dtd_ptr = curr_dtd->dtd_next
> > > +					& EP_QUEUE_HEAD_NEXT_POINTER_MASK;
> > > +
> > > +				/* clear active and halt bit */
> > > +				curr_dqh->size_ioc_int_sts &=
> > > +						~(DTD_STATUS_ACTIVE
> > > +						| DTD_STATUS_HALTED);
> > > +
> > > +				/* Do prime again */
> > > +				wmb();
> > > +				writel(bit_pos, &udc->op_regs->epprime);
> > > +				while (readl(&udc->op_regs->epprime) & bit_pos)
> > > +					cpu_relax();
> > > +
> > > +				break;
> > > +			}
> > >  		}
> > > +
> > >  		udelay(1);
> > >  	}
> > >
> >
> > Is it a chipidea IP issue? Any errate number for this issue?
> > Does we need it for chipidea driver?
> >
> 
> Yes, I think so.
> 9000531823	B2-Medium	Adding a dTD to a Primed Endpoint May Not Get
> Recognized
> Impacted Configuration: All device mode configurations.
> 
 
Thanks for your information.

Peter

