Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545AbaHSI4N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 04:56:13 -0400
Received: from mail-bn1blp0186.outbound.protection.outlook.com ([207.46.163.186]:11183
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752474AbaHSI4I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 04:56:08 -0400
From: Dexuan Cui <decui@microsoft.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH] Input: hyperv-keyboard - implement Type Clipboard Text
Thread-Topic: [PATCH] Input: hyperv-keyboard - implement Type Clipboard Text
Thread-Index: AQHPuKofLzaqUkka1EmYO6oSNGBw9pvVuwLggAD+nACAAHbpAA==
Date: Tue, 19 Aug 2014 08:55:39 +0000
Message-ID: <EE124450C0AAF944A40DD71E61F878C9936FC3@SINEX14MBXC417.southpacific.corp.microsoft.com>
References: <1408095719-19117-1-git-send-email-decui@microsoft.com>
 <20140815165733.GB25225@core.coreip.homeip.net>
 <EE124450C0AAF944A40DD71E61F878C9933040@SINEX14MBXC417.southpacific.corp.microsoft.com>
 <20140818185151.GB31121@core.coreip.homeip.net>
In-Reply-To: <20140818185151.GB31121@core.coreip.homeip.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.3.94]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019006)(6009001)(438002)(52604005)(51704005)(199003)(13464003)(24454002)(164054003)(377454003)(189002)(16796002)(74662001)(74502001)(86362001)(85306004)(81542001)(93886004)(50466002)(23726002)(31966008)(81342001)(50986999)(84676001)(85806002)(76176999)(99396002)(54356999)(97736001)(83072002)(21056001)(92726001)(92566001)(87936001)(97756001)(2656002)(110136001)(85852003)(77096002)(26826002)(33656002)(64706001)(47776003)(83322001)(4396001)(19580395003)(69596002)(20776003)(44976005)(6806004)(86612001)(79102001)(68736004)(95666004)(77982001)(107046002)(80022001)(106116001)(81156004)(106466001)(46102001)(55846006)(76482001)(46406003)(21314002);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR03MB248;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 0308EE423E
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=decui@microsoft.com; 
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Dmitry Torokhov
> Sent: Tuesday, August 19, 2014 2:52 AM
> To: Dexuan Cui
> On Mon, Aug 18, 2014 at 03:54:51AM +0000, Dexuan Cui wrote:
> > > -----Original Message-----
> > > From: Dmitry Torokhov
> > > Sent: Saturday, August 16, 2014 0:58 AM
> > > To: Dexuan Cui
> > > > For each char in the string, the host sends 2 events (key down/up with
> the
> > > > char's UNICODE value) to the guest.
> > > > The patch finds each char's scan codes of key down/up, and injects the
> > > > scan codes to the serio keyboard module.
> > > >
> > > No way. If you want to do this this way, do it in hypervisor code and keep
> > > feeding AT scan codes to hyperv-keyboard, although I am pretty sure
> users
> > Hi Dmitry,
> > Yeah, I had the same wish, but later I found this seems unlikely because
> IMO
> > the feature was firstly invented for Windows VM + generic UNICODE chars,
> > and we know there is no "scan code" for generic UNICODE chars... :-(
>
> Do you know what guest is running? You could potentially gate on that.
I'm not sure if the host knows this or not.
But even if the host knows this, IMO it seems bad for the host to discriminate
between Windows guest and Linux guest. And generally there is no scan code
for UNICODE chars.

And, here the patch tries to use a light-weight and straightforward method
to achieve the basic functionality of "Type (host) clipboard text (to guest)" --
the patch doesn't use the guest's X11 clipboard and it works for both text
mode tty and X11 window's input (for English keyboard layout. Please see my
below reply).

I studied open-vm-tools.sourceforge.net and
github.com/vmware/open-vm-tools.
My impression is: it's a pretty big collection of utilities/daemons and its code
seems bound to vmware-specific  features, maybe that's why it's called
"open-vm-tools" rather than "generic-vm-tools" :-)
1)  2517/2528 of the commits of the git repo are from vmware;
2) In Ubuntu 14.04, the utilities of open-vm-tools are just named as
vmware-XXX (I checked this by "dpkg-query -L open-vm-tools");
3) about the text copy&paste functionality between host/guest in either
direction, the implementation of open-vm-tools uses host/guest X11
clipboards and hence doesn't work in real text mode tty terminal, and,
vmware-specific implementation of backdoor() is extensively used -- I
don't think there is such an equivalent in other hypervisors'
environment, AFAIK.

So IMHO it's impractical for me to re-use open-vm-tools here?

> > > of
> > > French, Czech and other keyboard layouts with numbers in upper register
> > > and
> > > symbols in lower will have a few choice words for you.
> > Sorry, I can't understand what these are.
> > Can you please give more details or a link to further info?
>
> On French and many other European layouts to produce a number one
> needs to use
> Shift key, instead of simply using lower register, as on US or UK layouts. I.e.
> if you send scancode for KEY_3 through your proposed implementation it will
> produce '#' and KEY_SHIFT + KEY_3 will result in '3'.
>
> There are also issues with QWERTY/AZERTY and other layouts...
> Dmitry

Hi Dmitry,
Thanks for pointing this out!
This is a real issue -- my patch only works for English layout. :-(

I wrongly assumed  there is a 1:1 mapping between an ASCII char and a
scan code -- this is not true considering different keyboard layouts(keymaps).

So looks it's impossible for me to implement the functionality through the
path of the keyboard input subsystem... :-(
A feasible method would be: I can write a lightweight userland daemon,
just like open-vm-tools, which receives the string from the host and passes it
to the X11 windowing system directly using X11 APIs(this doesn't work in text
mode however).

Looking forward to your comment.

Thanks,
-- Dexuan

