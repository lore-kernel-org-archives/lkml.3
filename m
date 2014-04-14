Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807AbaDNPq1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 11:46:27 -0400
Received: from mail-bn1blp0181.outbound.protection.outlook.com ([207.46.163.181]:3911
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753471AbaDNPqY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 11:46:24 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Jan Beulich <JBeulich@suse.com>
CC: "olaf@aepfle.de" <olaf@aepfle.de>, "apw@canonical.com" <apw@canonical.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>
Subject: RE: [PATCH V2 1/1] X86: Probe for PIC and set legacy_pic
 appropriately
Thread-Topic: [PATCH V2 1/1] X86: Probe for PIC and set legacy_pic
 appropriately
Thread-Index: AQHPVgxXx3xHMeu1FkmhJbd/k88QaJsQxzoAgAB90zA=
Date: Mon, 14 Apr 2014 15:46:18 +0000
Message-ID: <0607a43156f945ad89d5ebec257b1955@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1397282200-10143-1-git-send-email-kys@microsoft.com>
 <534BB5320200007800008463@nat28.tlf.novell.com>
In-Reply-To: <534BB5320200007800008463@nat28.tlf.novell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:4898:80e8:ee31::3]
x-forefront-prvs: 0181F4652A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(51704005)(13464003)(24454002)(377454003)(199002)(189002)(2656002)(83072002)(81342001)(83322001)(76576001)(81542001)(99396002)(19580405001)(19580395003)(99286001)(74502001)(85852003)(74316001)(46102001)(79102001)(4396001)(86612001)(86362001)(87936001)(76482001)(33646001)(31966008)(80022001)(54356999)(74662001)(50986999)(76176999)(77982001)(92566001)(80976001)(20776003)(77096999)(3826001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB298;H:BY2PR03MB299.namprd03.prod.outlook.com;FPR:8DDFF502.B73AAD1E.30E3DBB3.98E5E9E8.202D5;MLV:nov;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Jan Beulich [mailto:JBeulich@suse.com]
> Sent: Monday, April 14, 2014 1:15 AM
> To: KY Srinivasan
> Cc: olaf@aepfle.de; apw@canonical.com; x86@kernel.org;
> tglx@linutronix.de; devel@linuxdriverproject.org;
> gregkh@linuxfoundation.org; jasowang@redhat.com; linux-
> kernel@vger.kernel.org; hpa@zytor.com
> Subject: Re: [PATCH V2 1/1] X86: Probe for PIC and set legacy_pic
> appropriately
> 
> >>> On 12.04.14 at 07:56, <kys@microsoft.com> wrote:
> > --- a/arch/x86/kernel/i8259.c
> > +++ b/arch/x86/kernel/i8259.c
> > @@ -299,11 +299,30 @@ static void unmask_8259A(void)  static void
> > init_8259A(int auto_eoi)  {
> >  	unsigned long flags;
> > +	unsigned char probe_val = ~(1 << PIC_CASCADE_IR);
> > +	unsigned char new_val;
> >
> >  	i8259A_auto_eoi = auto_eoi;
> >
> >  	raw_spin_lock_irqsave(&i8259A_lock, flags);
> >
> > +	/*
> > +	 * Check to see if we have a PIC.
> > +	 * Mask all except the cascade and read
> > +	 * back the value we just wrote. If we don't
> > +	 * have a PIC, we will read 0xff as opposed to the
> > +	 * value we wrote.
> > +	 */
> > +	outb(0xff, PIC_SLAVE_IMR);	/* mask all of 8259A-2 */
> > +	outb(probe_val, PIC_MASTER_IMR);
> > +	new_val = inb(PIC_MASTER_IMR);
> > +	if (probe_val != new_val) {
> > +		printk(KERN_INFO "Using NULL legacy PIC\n");
> > +		legacy_pic = &null_legacy_pic;
> > +		raw_spin_unlock_irqrestore(&i8259A_lock, flags);
> > +		return;
> > +	}
> > +
> >  	outb(0xff, PIC_MASTER_IMR);	/* mask all of 8259A-1 */
> >  	outb(0xff, PIC_SLAVE_IMR);	/* mask all of 8259A-2 */
> 
> And I guess you should delete this last line now that this is already being
> done slightly earlier - having it done twice is possibly going to confuse future
> readers (in that they might ask themselves or others whether this really
> needs to be done twice).

Good point! I will fix this and resend.

K. Y
> 
> Jan

