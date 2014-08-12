Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197AbaHLFw3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 01:52:29 -0400
Received: from mail-bn1lp0144.outbound.protection.outlook.com ([207.46.163.144]:18419
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750916AbaHLFw1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 01:52:27 -0400
From: Dexuan Cui <decui@microsoft.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH] Input: serio: make HYPERV_KEYBOARD depend on
 SERIO_I8042=y
Thread-Topic: [PATCH] Input: serio: make HYPERV_KEYBOARD depend on
 SERIO_I8042=y
Thread-Index: AQHPtdy8Yuf0lzP9lkKb/sEoSkq/rpvMWd9Q
Date: Tue, 12 Aug 2014 05:51:28 +0000
Message-ID: <EE124450C0AAF944A40DD71E61F878C9920A1C@SINEX14MBXC417.southpacific.corp.microsoft.com>
References: <1407814240-4275-1-git-send-email-decui@microsoft.com>
 <20140812032148.GB6867@kroah.com>
In-Reply-To: <20140812032148.GB6867@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.3.95]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(13464003)(51704005)(189002)(3905001)(164054003)(199003)(33656002)(110136001)(106116001)(50466002)(74502001)(74662001)(106466001)(83072002)(19580395003)(20776003)(47776003)(81156004)(44976005)(64706001)(95666004)(86362001)(6806004)(19580405001)(83322001)(77096002)(31966008)(107046002)(23726002)(85306004)(15202345003)(81542001)(16796002)(80022001)(86612001)(76176999)(99396002)(87936001)(50986999)(54356999)(97736001)(85806002)(97756001)(2656002)(69596002)(68736004)(26826002)(4396001)(15975445006)(76482001)(81342001)(55846006)(84676001)(46406003)(77982001)(92566001)(85852003)(21056001)(46102001)(92726001)(79102001);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB614;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 0301360BF5
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=decui@microsoft.com; 
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> > Decoupling the dependency between hyperv_keyboard and i8042 needs
> > non-trivial efforts and is hence a long term goal.
> >
> > For now, let's make the dependency explicit so people can beware of this.
>
> You didn't make anyone "aware" of this, you just prevented people from
> being able to select the module unless they build the driver into the
> kernel, which isn't very nice.

Yes, exactly.

> What exactly needs to be done to fix this "correctly" that is going to
> take too much work at the moment?
Hi Greg,
The current implementation of hyperv-keyboard.c borrows
serio_interrupt() to pass the key strokes to the high level component.
serio_interrupt() actually depends on atkbd.c and i8042.c, so this doesn't
work for a Generation 2 hyper-v guest because no i8042 keyboard controller
is emulated: http://technet.microsoft.com/en-us/library/dn282285.aspx

To decouple the dependency between the hyperv-keyboard and i8042
modules, I suppose we probably have to re-implement hyperv-keyboard by
using input_allocate_device(), input_register_device(), and using
input_report_key() to pass the key strokes to the high level.

I'll have to need some time for further investigation and a new
implementation. Before the new code is completely ready, IMHO the
patch can help to avoid a bad user experience like Arch Linux working
as a Generation 2 hyper-v guest.

BTW, looks most of Linux distros (like RHEL, Ubuntu, SUSE) have
CONFIG_SERIO_I8042=y, probably because it's the result of
"make defconfig". So the patch actually doesn't affect these distros.

Thanks,
-- Dexuan
