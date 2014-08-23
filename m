Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234AbaHWPV0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 11:21:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:43441 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144AbaHWPVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 11:21:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,386,1406617200"; 
   d="scan'208";a="592324462"
Message-ID: <1408807277.3315.43.camel@rzhang1-toshiba>
Subject: Re: [PATCH] ACPI / scan: Allow ACPI drivers to bind to PNP device
 objects
From: Zhang Rui <rui.zhang@intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Dirk Griesbach <spamthis@freenet.de>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Date: Sat, 23 Aug 2014 23:21:17 +0800
In-Reply-To: <3770704.uNPCcL4EDK@vostro.rjw.lan>
References: <5487060.QsgluucUH4@vostro.rjw.lan>
	 <2188871.Tr0Kbz91aK@vostro.rjw.lan>
	 <1408672831.3315.35.camel@rzhang1-toshiba>
	 <3770704.uNPCcL4EDK@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-08-22 at 19:53 +0200, Rafael J. Wysocki wrote:
> On Friday, August 22, 2014 10:00:31 AM Zhang Rui wrote:
> > On Thu, 2014-08-21 at 19:10 +0200, Rafael J. Wysocki wrote:
> > > On Thursday, August 21, 2014 08:08:54 PM Zhang Rui wrote:
> > > > Hi, Rafael,
> > > > 
> > > > On Thu, 2014-08-21 at 06:04 +0200, Rafael J. Wysocki wrote:
> > > > > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > 
> > > [cut]
> > > 
> > > > Note that I've just tested on my machine and it works well.
> > > > I still need the bug reporter to check if the patch fixes bug 81511 or not.
> > > 
> > > The FUJ02B1 and FUJ02E3 devices in bug 81971 have the same problem and
> > > they aren't motherboard devices.
> > 
> > Right, but IMO, the rootcause of that bug is that
> > 1. the PNP id table in fujitsu-laptop driver was introduced for some
> > reason, probably it is used as an indicator for module auto-loading, and
> > nowadays, this is redundant because fujitsu-laptop driver probes ACPI
> > device only, and the driver will be loaded if the ACPI device objects
> > for FUJ02B1 and FUJ02E3 is created.
> 
> We may be able to drop the Fujitsu devices from the ACPI PNP list and all may
> work.  Still, does that fix all of the potential problems?
> 
> > 2. This "redundant" PNP id table results in that those IDs are added to
> > PNP ID list unnecessarily, and results in PNP device nodes for those
> > devices are created unnecessarily.
> 
> Yes, that may be the case, but the way to deal with that is not to break
> thing and then see what's broken and fix it, but to get rid of ACPI drivers
> one by one in which case we can control what's been changed and why.
> 
> > >   Yes, we need to convert that driver
> > > to use a PNP driver structure or a platform device, but (1) we need a
> > > -stable fix *first*
> > 
> > I agree.
> > 
> > >  and (2) the cases we already know about may not be
> > > the only broken ones.
> > 
> > Agree.
> > But the issue addressed in your patch is that PNP scan handler blocks
> > ACPI driver from being probed, right?
> 
> Yes.
> 
> > So my question would be,
> > 1. If the id in PNP scan handler does not have a PNP driver, like the
> >    FUJ02B1/FUJ02E3 issue, what do we need the id in PNP scan handler?
> >    In fact, I think this is a good chance for us to cleanup the ACPI PNP
> >    id list, as long as we can fix them in time.
> 
> No.
> 
> We need -stable to work and there's no way I will mark the motherboard
> resource changes for -stable.

I agree. And I would rather consider my patch as the start point of a
long term solution.

>   Second, if we deal with it as I said (that is,
> get rid of ACPI drivers gradually), we will clean up that list in the process
> without breaking things for people in random ways.

Agree.
> 
> > 2. If the id in PNP scan handler has a PNP driver, should we allow both
> >    PNP driver and ACPI driver loaded? I think PNP system driver is the
> >    only case that makes us have to say yes, and what I'm trying to do
> >    is to fix this in the following patch.
> > 
> > Plus, IMO, your patch only fixes the PNP bus vs. ACPI bus issue. We
> > still may get bug report complaining some *PLATFORM* driver stops to
> > functional if the ACPI node has _CID PNP0C01/PNP0C02, sooner or later.
> > right?
> 
> No.
> 
> We never allowed ACPI drivers to bind to ACPI device objects having platform
> device companions,

No, I mean, a platform device is used to be created as the ACPI device
object _HID was in the previous acpi_platform scan handler list, but if
this device has _CID PNP0C01/PNP0C02, the platform device will not be
created any more after the ACPI enumeration re-work patches.

>  wherease we *did* allow that for ACPI device objects having
> PNP device companions.  We simply need to go back to what we were doing and fix
> things *on* *top* of that.
> 
> Any other approach pretty much guarantees leaving breakage in random places.
> 
> So I'm fine with cleaning up the PNP list *if* you convert the drivers in
> question from ACPI drivers to something else (platform drivers preferably)
> at the same time.
> 
yes, I see.

So I guess the following patch can be upstream candidate, right?

>From e32c2de37750d622dae6ef9d2f5c448a528a7edb Mon Sep 17 00:00:00 2001
From: Zhang Rui <rui.zhang@intel.com>
Date: Fri, 22 Aug 2014 09:06:10 +0800
Subject: [PATCH] ACPI: remove Fujitsu backlight and hotkey device ID from ACPI
 PNP id list

Fujitsu backlight and hotkey devices have ACPI drivers.
The PNP MODULE_DEVICE_TABLE in fujitsu-laptop driver is just used as an
indicator for module autoloading. But this is wrong because what we need is
ACPI module device table instead because the driver is probing ACPI devices.

Thus remove those ids from ACPI PNP scan handler list as we don't
have PNP driver for them, and convert the fujitsu-laptop PNP
MODULE_DEVICE_TABLE to ACPI MODULE_DEVICE_TABLE.

Reference: https://bugzilla.kernel.org/show_bug.cgi?id=81971
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Tested-by: Dirk Griesbach <spamthis@freenet.de>
---
 drivers/acpi/acpi_pnp.c               |  4 ----
 drivers/platform/x86/fujitsu-laptop.c | 16 +++++++---------
 2 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/acpi/acpi_pnp.c b/drivers/acpi/acpi_pnp.c
index 1f8b204..b193f84 100644
--- a/drivers/acpi/acpi_pnp.c
+++ b/drivers/acpi/acpi_pnp.c
@@ -130,10 +130,6 @@ static const struct acpi_device_id acpi_pnp_device_ids[] = {
 	{"PNP0401"},		/* ECP Printer Port */
 	/* apple-gmux */
 	{"APP000B"},
-	/* fujitsu-laptop.c */
-	{"FUJ02bf"},
-	{"FUJ02B1"},
-	{"FUJ02E3"},
 	/* system */
 	{"PNP0c02"},		/* General ID for reserving resources */
 	{"PNP0c01"},		/* memory controller */
diff --git a/drivers/platform/x86/fujitsu-laptop.c b/drivers/platform/x86/fujitsu-laptop.c
index 87aa28c..2655d4a 100644
--- a/drivers/platform/x86/fujitsu-laptop.c
+++ b/drivers/platform/x86/fujitsu-laptop.c
@@ -1050,6 +1050,13 @@ static struct acpi_driver acpi_fujitsu_hotkey_driver = {
 		},
 };
 
+static const struct acpi_device_id fujitsu_ids[] __used = {
+	{ACPI_FUJITSU_HID, 0},
+	{ACPI_FUJITSU_HOTKEY_HID, 0},
+	{"", 0}
+};
+MODULE_DEVICE_TABLE(acpi, fujitsu_ids);
+
 static int __init fujitsu_init(void)
 {
 	int ret, result, max_brightness;
@@ -1208,12 +1215,3 @@ MODULE_LICENSE("GPL");
 MODULE_ALIAS("dmi:*:svnFUJITSUSIEMENS:*:pvr:rvnFUJITSU:rnFJNB1D3:*:cvrS6410:*");
 MODULE_ALIAS("dmi:*:svnFUJITSUSIEMENS:*:pvr:rvnFUJITSU:rnFJNB1E6:*:cvrS6420:*");
 MODULE_ALIAS("dmi:*:svnFUJITSU:*:pvr:rvnFUJITSU:rnFJNB19C:*:cvrS7020:*");
-
-static struct pnp_device_id pnp_ids[] __used = {
-	{.id = "FUJ02bf"},
-	{.id = "FUJ02B1"},
-	{.id = "FUJ02E3"},
-	{.id = ""}
-};
-
-MODULE_DEVICE_TABLE(pnp, pnp_ids);
-- 
1.8.3.2



