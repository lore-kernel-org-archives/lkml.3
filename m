Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157Ab3LSU3k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 15:29:40 -0500
Received: from [207.46.163.184] ([207.46.163.184]:34561 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755724Ab3LSU3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 15:29:39 -0500
Message-ID: <1387484961.3140.141.camel@snotra.buserror.net>
Subject: Re: [REPOST][PATCH 2/2] driver core: platform: allow platform
 drivers to bind to any device
From: Scott Wood <scottwood@freescale.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Kim Phillips <kim.phillips@linaro.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <R65777@freescale.com>, <B07421@freescale.com>,
        <B08248@freescale.com>, <christoffer.dall@linaro.org>,
        <alex.williamson@redhat.com>, <a.motakis@virtualopensystems.com>,
        <agraf@suse.de>, <B16395@freescale.com>
Date: Thu, 19 Dec 2013 14:29:21 -0600
In-Reply-To: <20131219010340.GA23055@kroah.com>
References: <20131203123454.3ab18749ed0d0d943b10df9a@linaro.org>
	 <20131219010340.GA23055@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:12bf:48ff:fe84:c9a0]
X-ClientProxiedBy: DM2PR05CA004.namprd05.prod.outlook.com (10.141.96.24) To
 BL2PR03MB387.namprd03.prod.outlook.com (10.141.91.152)
X-Forefront-PRVS: 006546F32A
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009001)(189002)(199002)(377424004)(24454002)(51704005)(65816001)(83322001)(79102001)(54316002)(80022001)(81816001)(80976001)(15975445006)(81342001)(19580395003)(47776003)(88136002)(63696002)(81542001)(19580405001)(87976001)(77982001)(59766001)(62966002)(85852003)(83072002)(56816005)(56776001)(76786001)(76796001)(90146001)(69226001)(81686001)(87286001)(87266001)(31966008)(89996001)(85306002)(74502001)(74662001)(47446002)(4396001)(50226001)(47736001)(47976001)(49866001)(46102001)(77156001)(50986001)(33646001)(74876001)(50466002)(74706001)(19300405004)(51856001)(77096001)(53806001)(15202345003)(42186004)(23676002)(76482001)(74366001)(3826001)(562404015);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB387;H:[IPv6:2601:2:5800:3f7:12bf:48ff:fe84:c9a0];CLIP:2601:2:5800:3f7:12bf:48ff:fe84:c9a0;FPR:;RD:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-12-18 at 17:03 -0800, Greg Kroah-Hartman wrote:
> On Tue, Dec 03, 2013 at 12:34:54PM +0000, Kim Phillips wrote:
> > Platform drivers such as the vfio-platform "meta-" driver [1]
> > should be allowed to specify that they can bind to any device,
> > much like PCI drivers can with PCI_ANY_ID.
> > 
> > Currently, binding platform drivers to devices depends on:
> > 
> > - a string match in the device node's compatible entry (OF)
> > - a string match in the ACPI id list (ACPI)
> > - a string match in the id_table (platform data)
> > - a string match on the driver name (fall-back)
> > 
> > none of which allow for the notion of "match any."
> > 
> > This patch adds the notion by adding a "match any device" boolean to
> > struct platform_driver, for drivers to be able to set and thus not cause
> > platform_match() to fail when a bind is requested.
> > 
> > [1] http://www.spinics.net/lists/kvm/msg96701.html
> > 
> > Signed-off-by: Kim Phillips <kim.phillips@linaro.org>
> > ---
> > rebased onto 3.13-rc2, and reposted from first submission which
> > received no comments:
> > 
> > https://lkml.org/lkml/2013/10/11/48
> > 
> >  drivers/base/platform.c         | 4 ++++
> >  include/linux/platform_device.h | 1 +
> >  2 files changed, 5 insertions(+)
> > 
> > diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> > index 3a94b79..78a5b62 100644
> > --- a/drivers/base/platform.c
> > +++ b/drivers/base/platform.c
> > @@ -736,6 +736,10 @@ static int platform_match(struct device *dev, struct device_driver *drv)
> >  	struct platform_device *pdev = to_platform_device(dev);
> >  	struct platform_driver *pdrv = to_platform_driver(drv);
> >  
> > +	/* the driver matches any device */
> > +	if (pdrv->match_any_dev)
> > +		return 1;
> 
> This breaks userspace in that it will never know to load the module that
> can "bind to anything".
> 
> You need a way to encode this in the platform device id that can be a
> wildcard type of thing, so that userspace can know about this.

How is userspace broken?  vfio platform is a new thing; there's nothing
existing to break.  I don't see how automatic module loading makes sense
for it.  Whether the module needs to be loaded depends on the user's
intentions, not based on what hardware you have.

-Scott


