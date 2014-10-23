Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439AbaJWNpE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 09:45:04 -0400
Received: from mail-bl2on0111.outbound.protection.outlook.com ([65.55.169.111]:5358
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750850AbaJWNpB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 09:45:01 -0400
From: Stuart Yoder <stuart.yoder@freescale.com>
To: Alex Williamson <alex.williamson@redhat.com>,
        Marcel Apfelbaum <marcel.a@redhat.com>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "marcel@redhat.com" <marcel@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>
Subject: RE: [PATCH v4] PCI: add kernel parameter to override devid<->driver
 mapping.
Thread-Topic: [PATCH v4] PCI: add kernel parameter to override devid<->driver
 mapping.
Thread-Index: AQHP7iaRIqQChkARrE2ClRQTljGKipw9qqWQ
Date: Thu, 23 Oct 2014 13:44:57 +0000
Message-ID: <d093a0738f61433aafe5ddd36d0393e9@CY1PR0301MB0748.namprd03.prod.outlook.com>
References: <1413813882-27047-1-git-send-email-marcel.a@redhat.com>
 <1414002755.4202.253.camel@ul30vt.home>
In-Reply-To: <1414002755.4202.253.camel@ul30vt.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [192.88.168.50]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0747;
x-forefront-prvs: 0373D94D15
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(189002)(13464003)(57704003)(377454003)(51704005)(199003)(164054003)(377424004)(24454002)(74316001)(40100003)(122556002)(2656002)(77096002)(120916001)(46102003)(101416001)(87936001)(64706001)(20776003)(76482002)(99396003)(4396001)(85852003)(50986999)(21056001)(66066001)(19580395003)(86362001)(95666004)(92566001)(97736003)(19580405001)(31966008)(99286002)(76176999)(108616004)(76576001)(107046002)(106356001)(80022003)(85306004)(54356999)(106116001)(105586002)(33646002)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB0747;H:CY1PR0301MB0748.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9NDjDsc016287



> -----Original Message-----
> From: Alex Williamson [mailto:alex.williamson@redhat.com]
> Sent: Wednesday, October 22, 2014 1:33 PM
> To: Marcel Apfelbaum
> Cc: linux-pci@vger.kernel.org; bhelgaas@google.com; linux-kernel@vger.kernel.org; marcel@redhat.com;
> mst@redhat.com; Yoder Stuart-B08248
> Subject: Re: [PATCH v4] PCI: add kernel parameter to override devid<->driver mapping.
> 
> [cc+ stuart]
> 
> On Mon, 2014-10-20 at 17:04 +0300, Marcel Apfelbaum wrote:
> > Scanning a lot of devices during boot requires a lot of time.
> > On other scenarios there is a need to bind a driver to a specific slot.
> >
> > Binding devices to pci-stub driver does not work,
> > as it will not differentiate between devices of the
> > same type. Using some start scripts is error prone.
> >
> > The solution leverages driver_override functionality introduced by
> >
> > 	commit: 782a985d7af26db39e86070d28f987cad21313c0
> > 	Author: Alex Williamson <alex.williamson@redhat.com>
> > 	Date:   Tue May 20 08:53:21 2014 -0600
> >
> >     	PCI: Introduce new device binding path using pci_dev.driver_override
> >
> > In order to bind PCI slots to specific drivers use:
> > 	pci=driver[xxxx:xx:xx.x]=foo,driver[xxxx:xx:xx.x]=bar,...
> >
> > Signed-off-by: Marcel Apfelbaum <marcel.a@redhat.com>
> > ---
> > v3 -> v4:
> >  - Addressed Alex Williamson's comments:
> >    - Modified the type of driver_override_entry's fields
> >    - Used PCI_DEVFN when appropriated
> >    - Removed redundant checks
> >    - Replaced BUG_ON with pr_err messages
> >    - Simpler command line parsing
> >  - Addressed Michael S. Tsirkin comments
> >    - removed DRIVER_OVERRIDE_NAME_LENGTH limitation
> > v2 -> v3:
> >  - Corrected subject line
> > v1 -> v2:
> >  - Addressed Michael S. Tsirkin comments
> >    - Removed 32 slots limitation
> >    - Better handling of memory allocation failures
> >      (preferred BUG_ON over error messages)
> >  - Addressed Alex Williamson's comments:
> >    - Modified commit message to show parameter usage more clear.
> >  - I preferred to re-use parse_args instead of manually using
> >    strstr in order to better comply with command line parsing
> >    rules.
> >  - I didn't use any locking when parsing the command line args
> >    (see parse_done usage) assuming that first call will be
> >    early in system boot and no race can occur. Please correct
> >    me if I am wrong.
> >
> > Notes:
> >  - I have further ideas on top of this patch based on your reviews.
> >    I thought of:
> >    - Use wildcards to specify entire buses/devices, something like:
> >      	driver[0001:02:*.*]=pci-stub
> >    - Use comma to separate several devices:
> >      	driver[0001:02:03.4,0001:02:04.0,...]=pci-stub
> >    - Make domain optional:
> >    	driver[00:03.0]=pci-stub
> >
> > Comments will be appreciated,
> > Thanks,
> > Marcel
> >  Documentation/kernel-parameters.txt |   4 ++
> >  drivers/pci/bus.c                   | 111 ++++++++++++++++++++++++++++++++++++
> >  drivers/pci/pci.c                   |   2 +
> >  3 files changed, 117 insertions(+)
> 
> The driver_override feature that we're making use of here is also going
> to be supported by platform devices and potentially more bustypes in the
> future, so I'm concerned that making a pci specific kernel parameter is
> too shortsighted.  Instead we could hook on to BUS_NOTIFY_ADD_DEVICE for
> bustypes that support driver_override so we can have a common interface.
> Perhaps:
> 
> driver_override=pci,0000:02:00.0=pci-stub;platform,fakename=vfio-platform
> 
> Finding delimiters that don't conflict may be challenging.

I think what you proposed works--  <bus-name>,<bus-dev>=<driver>;

Think that will work for PCI, platform, and the new fsl-mc bus we are working
on.

> Also, can we
> assume that bus-name:dev-name is unique for every bustype?  It is for
> pci, platform?

I think that has to be the case.

> It also seems like there's a question of how long should this override
> last and how does the user disable it?

Isn't that a general question for the "driver_overrride" mechanism?
I'm forgetting if the mechanism in the kernel now has a way to disable
it--  e.g. echo /dev/null > /sys/pci/devices/.../driver_override ??

So, it would last until explicitly disabled through sysfs.

> I think with pci-stub.ids=
> $VENDOR:$DEVICE a user can echo the IDs to the pci-stub/remove_id sysfs
> entry to cancel the effect.  The only option here seems to be a reboot.
> Do we need a /sys/bus/pci/driver_overrides/{add_name,remove_name} for
> this interface?  Thanks,

Thanks,
Stuart
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
