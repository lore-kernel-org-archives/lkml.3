Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655AbaHNGIe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 02:08:34 -0400
Received: from mail-bn1blp0187.outbound.protection.outlook.com ([207.46.163.187]:54894
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752450AbaHNGIc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 02:08:32 -0400
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
Thread-Index: AQHPtfL80p5QO0TZ/0qF/qigPt99A5vMiCDwgAC47oCAAKTFcIAAzKIAgADqqjA=
Date: Thu, 14 Aug 2014 06:07:11 +0000
Message-ID: <EE124450C0AAF944A40DD71E61F878C9929597@SINEX14MBXC417.southpacific.corp.microsoft.com>
References: <1407814240-4275-1-git-send-email-decui@microsoft.com>
 <20140812032148.GB6867@kroah.com>
 <EE124450C0AAF944A40DD71E61F878C9920A1C@SINEX14MBXC417.southpacific.corp.microsoft.com>
 <20140812060108.GA13231@kroah.com>
 <EE124450C0AAF944A40DD71E61F878C9920EAF@SINEX14MBXC417.southpacific.corp.microsoft.com>
 <20140812175435.GA22386@core.coreip.homeip.net>
 <EE124450C0AAF944A40DD71E61F878C9925D21@SINEX14MBXC417.southpacific.corp.microsoft.com>
 <20140813155644.GA6940@core.coreip.homeip.net>
In-Reply-To: <20140813155644.GA6940@core.coreip.homeip.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.3.91]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(199003)(51704005)(189002)(164054003)(13464003)(84676001)(2656002)(87936001)(86612001)(4396001)(26826002)(79102001)(33656002)(97756001)(69596002)(83072002)(81542001)(50466002)(21056001)(64706001)(46102001)(85852003)(92726001)(23726002)(92566001)(77982001)(107046002)(99396002)(55846006)(16796002)(74662001)(31966008)(74502001)(77096002)(106116001)(76176999)(68736004)(86362001)(110136001)(46406003)(97736001)(83322001)(6806004)(76482001)(20776003)(47776003)(106466001)(95666004)(81342001)(85306004)(85806002)(54356999)(50986999)(81156004)(80022001)(93886004)(44976005);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB619;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 03030B9493
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=decui@microsoft.com; 
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Dmitry Torokhov
> > How about this:
> > in libps2.c let's add  and export a function pointer
> > i8042_lock_chip_if_port_owner: it is used to replace the current
> > 	if (i8042_check_port_owner(ps2dev->serio))
> > 		i8042_lock_chip();
> > The function pointer has a default value NULL, and in i8042.c: i8042_init()
> > we set the function pointer if an i8042 device is found?
> 
> Hmm, that would make i8042 depend on libps2, which might be OK, but how
> do you deal with the locking here? I.e. what happens if you unload i8042
> right when we go through this sequence?
Ok, I got it.

> Maybe we need to split i8042_lock_chip() and friends into a separate
> module that always loads, even if i8042 is not present.
> Dmitry
Good idea!

However the more difficult thing is 
i8042_check_port_owner() -- used by  libps2.c too.
Then  the separate module will also have to include and EXPORT
	DEFINE_SPINLOCK(i8042_lock);
	struct i8042_port i8042_ports[I8042_NUM_PORTS];
?

This seems a non-trivial change... :-(

Thanks,
-- Dexuan
