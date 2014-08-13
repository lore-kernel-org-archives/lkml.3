Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434AbaHMFZ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 01:25:26 -0400
Received: from [207.46.163.143] ([207.46.163.143]:46022 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750835AbaHMFZY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 01:25:24 -0400
From: Dexuan Cui <decui@microsoft.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Greg KH <gregkh@linuxfoundation.org>,
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
Thread-Index: AQHPtfL80p5QO0TZ/0qF/qigPt99A5vMiCDwgAC47oCAAKTFcA==
Date: Wed, 13 Aug 2014 05:24:35 +0000
Message-ID: <EE124450C0AAF944A40DD71E61F878C9925D21@SINEX14MBXC417.southpacific.corp.microsoft.com>
References: <1407814240-4275-1-git-send-email-decui@microsoft.com>
 <20140812032148.GB6867@kroah.com>
 <EE124450C0AAF944A40DD71E61F878C9920A1C@SINEX14MBXC417.southpacific.corp.microsoft.com>
 <20140812060108.GA13231@kroah.com>
 <EE124450C0AAF944A40DD71E61F878C9920EAF@SINEX14MBXC417.southpacific.corp.microsoft.com>
 <20140812175435.GA22386@core.coreip.homeip.net>
In-Reply-To: <20140812175435.GA22386@core.coreip.homeip.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.3.93]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(51704005)(52604005)(189002)(199003)(164054003)(377454003)(13464003)(23726002)(99396002)(84676001)(85806002)(76482001)(79102001)(81342001)(76176999)(50986999)(54356999)(81542001)(69596002)(46406003)(55846006)(31966008)(74662001)(80022001)(21056001)(46102001)(16796002)(68736004)(77982001)(74502001)(4396001)(95666004)(77096002)(87936001)(106466001)(83072002)(93886004)(6806004)(107046002)(83322001)(44976005)(81156004)(50466002)(47776003)(110136001)(20776003)(64706001)(92566001)(86612001)(33656002)(26826002)(85852003)(2656002)(106116001)(85306004)(86362001)(97756001)(92726001)(97736001);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR03MB252;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 0302D4F392
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=decui@microsoft.com; 
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Dmitry Torokhov
> Sent: Wednesday, August 13, 2014 1:55 AM
> > > > To decouple the dependency between the hyperv-keyboard and i8042
> > > > modules, I suppose we probably have to re-implement hyperv-
> keyboard by
> > > > using input_allocate_device(), input_register_device(), and using
> > > > input_report_key() to pass the key strokes to the high level.
> > >
> > > Yes, that would be the best thing to do,
> 
> Why? The backend still delivers AT keyboard data, so why does it make
> sense to write a new driver instead of making sure you can load
> atkbd/libps2 even without i8042 loaded?

Hi Dmitry,
Thanks for pointing this out!
I didn't realize input_report_key() can't accept AT keyboard scan codes.

> > The issue is: the latest Arch Linux release doesn't have a working (virtual)
> > keyboard when it runs as Generation 2 hyper-v guest -- when it runs as
> > a "traditional" Generation 1 hyper-v guest, everything works fine.
> > I hope this patch can temporarily help Arch users if they find the issue
> > and if they can rebuild the kernel.
> 
> The Arch users can simply select to build i8042 into the kernel as a
> workaround.
I agree.

> The proper solution is to allow loading libps2 module even if i8042 did
> not find its device. I wish I could simply drop this i8042_lock_chip and
> stuff, but unfortunately i8042 ports are not truly independent. We need
> to figure a way for libps2 to engage locking in i8042 if the driver is
> loaded, otherwise just ignore it.
> 
> Dmitry
Yeah, this seems the right solution.

How about this:
in libps2.c let's add  and export a function pointer
i8042_lock_chip_if_port_owner: it is used to replace the current 
	if (i8042_check_port_owner(ps2dev->serio))
		i8042_lock_chip();
The function pointer has a default value NULL, and in i8042.c: i8042_init()
we set the function pointer if an i8042 device is found?

Thanks,
-- Dexuan
