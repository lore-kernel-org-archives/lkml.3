Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755AbaBUANb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 19:13:31 -0500
Received: from mail-bl2lp0212.outbound.protection.outlook.com ([207.46.163.212]:31089
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754689AbaBUAN1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 19:13:27 -0500
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "rja@sgi.com" <rja@sgi.com>
CC: "lenb@kernel.org" <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "minyard@acm.org" <minyard@acm.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH V2] Change ACPI IPMI support to "default y"
Thread-Topic: [PATCH V2] Change ACPI IPMI support to "default y"
Thread-Index: AQHPLMZ9xGM3QUTlOk+rIS3zgvGkBZq+l00AgAAHJxWAAAUvD4AACFkLgAAKotuAAArDa4AAFJArgAAD7AA=
Date: Fri, 21 Feb 2014 00:13:13 +0000
Message-ID: <1392941592.20109.36.camel@x230>
References: <20140220204028.GJ17949@sgi.com> <1392929163.20109.5.camel@x230>
	 <20140220205901.GM17949@sgi.com> <1392930047.20109.6.camel@x230>
	 <20140220212854.GO17949@sgi.com> <1392932363.20109.11.camel@x230>
	 <20140220220656.GT17949@sgi.com> <1392935204.20109.17.camel@x230>
	 <20140220224529.GV17949@sgi.com> <1392937781.20109.24.camel@x230>
	 <20140220235904.GZ17949@sgi.com>
In-Reply-To: <20140220235904.GZ17949@sgi.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:6267:20ff:fec3:2318]
x-forefront-prvs: 01294F875B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(24454002)(377424004)(199002)(189002)(51704005)(83072002)(46102001)(85852003)(92566001)(47976001)(4396001)(92726001)(65816001)(80022001)(63696002)(93136001)(81542001)(74662001)(33646001)(31966008)(33716001)(81816001)(50986001)(49866001)(47736001)(95666003)(79102001)(90146001)(56816005)(59766001)(77982001)(47446002)(54316002)(54356001)(76482001)(56776001)(51856001)(69226001)(80976001)(53806001)(74706001)(76796001)(76786001)(81342001)(19580405001)(95416001)(2656002)(81686001)(83322001)(19580395003)(77096001)(74366001)(94946001)(74502001)(87936001)(94316002)(74876001)(86362001)(93516002)(87266001)(85306002)(3826001)(217873001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR05MB423;H:BN1PR05MB423.namprd05.prod.outlook.com;CLIP:2001:470:1f07:1371:6267:20ff:fec3:2318;FPR:E477F2E7.A63597A3.7AF051B2.4AE651A1.20495;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <AB318AF0FCA1AB4481A2AF41E908ECFD@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s1L0Dsr9023958

On Thu, 2014-02-20 at 17:59 -0600, Russ Anderson wrote:
> On Thu, Feb 20, 2014 at 11:09:42PM +0000, Matthew Garrett wrote:
> > On Thu, 2014-02-20 at 16:45 -0600, Russ Anderson wrote:
> > > 
> > > The ACPI spec requires IPMI functionality before a module loads at
> > > boot time?  And the kernel is *broken* if it does not support ACIP IPMI
> > > functionality before module load time?  Really?
> > 
> > There's no mechanism to ensure that IPMI support will be loaded before
> > ACPI calls attempt to access IPMI operation regions. Really.
> 
> And no mechanism can be added to ensure that ACPI call are
> not attempted before IPMI is initialized?  A flag or lock
> or exported symbol indicating IPMI support is ready.

ACPI functions are a black box to drivers. You make an ACPI call, the
AML code does something. We could block there, but what's the driver
supposed to do at that point? The core could call out to a module
loader, but if the driver is built in and IPMI isn't then you'll end up
with a 60 second pause in boot and a driver that doesn't work. 

> > > > ACPI 4.0 includes support for IPMI operation regions. Modular IPMI means
> > > > that the kernel will spend a significant amount of time (potentially
> > > > until a user manually loads a driver) failing to implement part of the
> > > > IPMI specification. That's a problem, and the correct fix is to ensure
> > > > that the kernel always implements IPMI support.
> > > 
> > > The ACPI spec says ipmi_si cannot be a driver?  Really?
> > > What is the real problem you are trying to solve?
> > 
> > The most straightforward case is that of an ACPI power meter.
> 
> So it is just a matter of making sure ipmi_si modules loads before
> the ACPI power meter module loads, right?  module dependency issue.

No, because the power meter driver has no way of knowing that a vendor
has implemented this interface via IPMI. *Any* ACPI entry point could
theoretically reference IPMI code, even the _INI method that's called
during ACPI core init. If it does, and if you don't have built-in ACPI
support, you'd fail ACPI initialisation and things would go downhill
from there.

(I don't think failure of this magnitude is actually *likely*, but it
would be spec-compliant)

> > I've repeatedly asked for you to provide detailed descriptions of the
> > problems you've seen because I have a genuine interest in fixing them.
> > If you're just going to childishly refuse then this discussion is
> > pointless. 
> 
> The distro cases I would point you at are marked private. 
> And you do not have access to our internal support system.
> A simple google search for "kipmi0" shows a lot of reports of
> high cpu utilization.  

And nobody seems to have put any effort into figuring out what the
underlying cause is. Is it spinning because there are messages? If so,
is it because the BMC would really like some kind of response to those
messages? Is it spinning because the BMC is wedged? If so, can we detect
that case, flag it as broken and cleanly disengage?

We're running systems from a wide range of vendors (including basically
all the Tier 1 server manufacturers, plus some whitebox), use IPMI
functionality heavily and genuinely do not see the described problems. I
don't think there's evidence of widespread breakage, and where it does
exist we should treat it as we would any other bug - diagnose the
underlying problem and fix it.

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
