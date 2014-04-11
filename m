Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901AbaDKWtt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 18:49:49 -0400
Received: from mail-by2lp0242.outbound.protection.outlook.com ([207.46.163.242]:21137
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755060AbaDKWtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 18:49:47 -0400
From: KY Srinivasan <kys@microsoft.com>
To: "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "JBeulich@suse.com" <JBeulich@suse.com>, "bp@alien8.de" <bp@alien8.de>
CC: Thomas Gleixner <tglx@linutronix.de>
Subject: RE: [PATCH 1/1] X86: Probe for PIC and set legacy_pic appropriately
Thread-Topic: [PATCH 1/1] X86: Probe for PIC and set legacy_pic appropriately
Thread-Index: AQHPVdJ54mIOF0NK6kabgQnp4ES6l5sNARmAgAAC2NA=
Date: Fri, 11 Apr 2014 22:49:45 +0000
Message-ID: <3559a13421554386bdcc0e8b418802c3@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1397257344-3035-1-git-send-email-kys@microsoft.com>
 <53486E3F.1020307@zytor.com>
In-Reply-To: <53486E3F.1020307@zytor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [131.107.159.180]
x-o365ent-eop-header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
x-forefront-prvs: 0178184651
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(199002)(189002)(51704005)(24454002)(479174003)(377454003)(13464003)(31966008)(80022001)(83322001)(85852003)(76576001)(79102001)(87936001)(46102001)(19580405001)(80976001)(92566001)(76176999)(74316001)(2656002)(77096999)(74502001)(2201001)(86362001)(50986999)(54356999)(81542001)(4396001)(86612001)(20776003)(99396002)(19580395003)(83072002)(33646001)(99286001)(76482001)(74662001)(77982001)(66066001)(81342001)(1121002)(921003)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB297;H:BY2PR03MB299.namprd03.prod.outlook.com;FPR:8DCDF925.8BE2A118.34F3FFB3.48F5EA0B.20384;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s3BMnswc007486



> -----Original Message-----
> From: H. Peter Anvin [mailto:hpa@zytor.com]
> Sent: Friday, April 11, 2014 3:36 PM
> To: KY Srinivasan; x86@kernel.org; gregkh@linuxfoundation.org; linux-
> kernel@vger.kernel.org; devel@linuxdriverproject.org; olaf@aepfle.de;
> apw@canonical.com; jasowang@redhat.com; tglx@linutronix.de;
> JBeulich@suse.com; bp@alien8.de
> Cc: Thomas Gleixner
> Subject: Re: [PATCH 1/1] X86: Probe for PIC and set legacy_pic appropriately
> 
> On 04/11/2014 04:02 PM, K. Y. Srinivasan wrote:
> >
> > diff --git a/arch/x86/kernel/i8259.c b/arch/x86/kernel/i8259.c index
> > 2e977b5..0a57a19 100644
> > --- a/arch/x86/kernel/i8259.c
> > +++ b/arch/x86/kernel/i8259.c
> > @@ -299,11 +299,22 @@ static void unmask_8259A(void)  static void
> > init_8259A(int auto_eoi)  {
> >  	unsigned long flags;
> > +	unsigned char probe_val = 0xfb;
> >
> >  	i8259A_auto_eoi = auto_eoi;
> >
> >  	raw_spin_lock_irqsave(&i8259A_lock, flags);
> >
> > +	/* Check to see if we have a PIC */
> > +	outb(probe_val, PIC_MASTER_IMR);
> > +	probe_val = inb(PIC_MASTER_IMR);
> > +	if (probe_val == 0xff) {
> > +		printk(KERN_INFO "Using NULL legacy PIC\n");
> > +		legacy_pic = &null_legacy_pic;
> > +		raw_spin_unlock_irqrestore(&i8259A_lock, flags);
> > +		return;
> > +	}
> > +
> >  	outb(0xff, PIC_MASTER_IMR);	/* mask all of 8259A-1 */
> >  	outb(0xff, PIC_SLAVE_IMR);	/* mask all of 8259A-2 */
> >
> 
> I think it is important to document what this actually means here.  0xfb is
> "mask all except for the cascade."
> 
> Arguably, we should do this after masking the slave PIC.
> 
> On a whole other subject... the whole __byte() logic is a just plain horrific
> piece of crap.  Clearly whomever wrote it had never heard of a union.
> 
> I'm still horrifically confused, though, why we mask IRQ 2 (the cascade
> interrupt) in i8259.c, but we explicitly do *not* mask IRQ 2 in boot/pm.c (nor
> in the assembly code on which boot/pm.c was based.)  In fact, it looks like we
> never unmask it.  I'm guessing that the masking status of the cascade input
> simply doesn't matter.
> 
> At the very least, though, we shouldn't have 0xfb as a magic number, but use
> ~(1U << PIC_CASCADE_IR).

I will get rid of this magic number as you have suggested.

K. Y
 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éÝ¶¥Šwÿº{.nÇ+‰·¥Š{±þG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŽŠÝ¢j"ú¶m§ÿÿ¾«þG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
