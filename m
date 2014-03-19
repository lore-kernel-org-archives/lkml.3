Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965348AbaCSOYH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 10:24:07 -0400
Received: from mail-bn1lp0140.outbound.protection.outlook.com ([207.46.163.140]:31704
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965252AbaCSOYF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 10:24:05 -0400
From: "suresh.gupta@freescale.com" <suresh.gupta@freescale.com>
To: "balbi@ti.com" <balbi@ti.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Stefani Seibold" <stefani@seibold.net>
Subject: RE: [PATCH] USB: Gadget: fsl driver pullup fix
Thread-Topic: [PATCH] USB: Gadget: fsl driver pullup fix
Thread-Index: AQHPPo+XZEI7T+n+/Eyk3iTo1DVy5JrfI8CAgAHhkxCAAFs/gIAG00Dw
Date: Wed, 19 Mar 2014 14:23:59 +0000
Message-ID: <35bc432e846140e3b5d89ef677c8287f@BN1PR03MB251.namprd03.prod.outlook.com>
References: <1394716255-26963-1-git-send-email-suresh.gupta@freescale.com>
 <20140313152517.GG4599@saruman.home>
 <797f2a4344754765a968250ef26f2b53@BN1PR03MB251.namprd03.prod.outlook.com>
 <20140315013529.GB31520@saruman.home>
In-Reply-To: <20140315013529.GB31520@saruman.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.169.1]
x-forefront-prvs: 01559F388D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(51704005)(43234003)(24454002)(377454003)(189002)(13464003)(199002)(93516002)(56776001)(54316002)(76482001)(85306002)(46102001)(94316002)(86362001)(95416001)(94946001)(31966008)(74502001)(90146001)(56816005)(85852003)(63696002)(20776003)(97336001)(47446002)(83072002)(33646001)(74662001)(97186001)(19580405001)(65816001)(77982001)(80022001)(80976001)(4396001)(59766001)(83322001)(19580395003)(74316001)(92566001)(74366001)(81686001)(69226001)(81816001)(79102001)(49866001)(47736001)(50986001)(47976001)(93136001)(2656002)(95666003)(87936001)(74876001)(53806001)(66066001)(87266001)(54356001)(81542001)(74706001)(76796001)(76786001)(76576001)(77096001)(51856001)(81342001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR03MB252;H:BN1PR03MB251.namprd03.prod.outlook.com;FPR:E4FFD177.A4EA92DE.73E9D9A3.92F4F871.20530;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Felipe Balbi [mailto:balbi@ti.com]
> Sent: Saturday, March 15, 2014 7:05 AM
> To: Gupta Suresh-B42813
> Cc: balbi@ti.com; gregkh@linuxfoundation.org; linux-usb@vger.kernel.org;
> linux-kernel@vger.kernel.org; Stefani Seibold
> Subject: Re: [PATCH] USB: Gadget: fsl driver pullup fix
> 
> Hi,
> 
> (first of all, please fix your email client, we need the quotation marks.
> See Documentation/email-clients.txt)
> 
> On Fri, Mar 14, 2014 at 08:53:24PM +0000, suresh.gupta@freescale.com
> wrote:
> > > On Thu, Mar 13, 2014 at 06:40:55PM +0530, Suresh Gupta wrote:
> > > > Attached is a small fix for the fsl usb gadget driver. This fix
> > > > the driver in a way that the usb device will be only "pulled up"
> > > > on requests like other usb gadget drivers do.
> > > > This is necessary, because the device information is not always
> > > > available until an application is up and running which provides
> > > > this datas.
> > > >
> > > > Signed-off-by: Stefani Seibold <stefani@seibold.net>
> > > > Signed-off-by: Suresh Gupta <suresh.gupta@freescale.com>
> > > > ---
> > > >  drivers/usb/gadget/fsl_udc_core.c | 38
> > > > +++++++++++++++++++++-----------------
> > > >  1 file changed, 21 insertions(+), 17 deletions(-)
> > > >
> > > > diff --git a/drivers/usb/gadget/fsl_udc_core.c
> > > > b/drivers/usb/gadget/fsl_udc_core.c
> > > > index 35cb972..9a93727 100644
> > > > --- a/drivers/usb/gadget/fsl_udc_core.c
> > > > +++ b/drivers/usb/gadget/fsl_udc_core.c
> > > > @@ -153,6 +153,21 @@ static inline void fsl_set_accessors(struct
> > > > fsl_usb2_platform_data *pdata) {}
> > > >
> /********************************************************************
> > > >   *	Internal Used Function
> > > >
> > > > ******************************************************************
> > > > **/
> > > > +static int can_pullup(struct fsl_udc *udc) {
> > > > +	return udc->driver && udc->softconnect && udc->vbus_active; }
> > > > +
> > > > +static void set_pullup(struct fsl_udc *udc) {
> > > > +	if (can_pullup(udc))
> > > > +		fsl_writel((fsl_readl(&dr_regs->usbcmd) |
> USB_CMD_RUN_STOP),
> > > > +				&dr_regs->usbcmd);
> > > > +	else
> > > > +		fsl_writel((fsl_readl(&dr_regs->usbcmd) &
> ~USB_CMD_RUN_STOP),
> > > > +				&dr_regs->usbcmd);
> > > > +}
> > >
> > > why is this a "fix", you just re-factored some code into
> set_pullup().
> > >
> > [SuresH] I set udc->vbus_active and udc->softconnect to default value
> > of 1 in struct_udc_setup. This was actual fix in this patch.  The
> 
> right, you see now why is it a problem to mix cleanups with fixes ? You
> *never*, ever combine unrelated changes in a single patch. It makes it a
> lot more difficult to see what you're actually changing. So, to start
> with, this patch should (if it was correct) be split into two smaller
> patches: one re-factoring the duplicated code into set_pullup() and
> another which fixes vbus_active and softconnect flags.

Agreed, I will resend the patches.  

> 
> But hang on, before you do that...
> 
> > can_pullup function return false when these values was not set and
> > intern the code return without enabling the pullup and gadget
> > controller stops.
> 
> So here's you mistake: the idea of can_pullup() (and thus, vbus_active
> and softconnect flags) is to tell the driver "we're connet to a host,
> it's safe to connect your pullups".
> 
> When you set both those flags to true, you're telling the driver that
> you, indeed, are connected to a host. This might not be true if you first
> boot up your platform, load all drivers and only after connect the cable.
> In essence, you're lying to your driver and, as my mommy used to say,
> "nobody likes a liar, my boy".
> 
> Curret situation isn't very good either since the driver is assuming that
> cable is only plugged after driver is loaded, so it won't cope very well
> with situation where cable is first plugged, then you apply power to your
> board.
> 
> What you *really* need to do here is ask the HW for initial states of
> those flags. During your probe() routine - as the name says - you probe
> your HW to check its state (or to initialize its state), then you ask
> "Hey IP, is VBUS above session valid threshold ?" Then you use the HW's
> reply to initialize both flags, the way you want.

After your explanation and some code browsing, I think the exact place to
set vbus_active is fsl_vbus_session which called on detecting vbus.
Also fsl_pullup should return without doing anything if vbus_active is not set.
Please suggest.

I do not get the usage of softconnect. Do I set softconnect also in fsl_vbus_session.
Please suggest.

Thanks
SuresH
