Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949AbaJPUUy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 16:20:54 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:64344 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887AbaJPUUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 16:20:51 -0400
Date: Thu, 16 Oct 2014 13:20:45 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: atull <atull@opensource.altera.com>
Cc: jdelvare@suse.de, lm-sensors@lm-sensors.org, lgirdwood@gmail.com,
        broonie@kernel.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, delicious.quinoa@gmail.com,
        dinguyen@opensource.altera.com, yvanderv@opensource.altera.com
Subject: Re: [PATCH v6 3/4] pmbus: add regulator support
Message-ID: <20141016202045.GA23966@roeck-us.net>
References: <1413399310-19277-1-git-send-email-atull@opensource.altera.com>
 <1413399310-19277-4-git-send-email-atull@opensource.altera.com>
 <20141016183501.GA21253@roeck-us.net>
 <alpine.DEB.2.02.1410161339450.28663@atx-linux-37>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1410161339450.28663@atx-linux-37>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 01:40:23PM -0500, atull wrote:
> On Thu, 16 Oct 2014, Guenter Roeck wrote:
> 
> > On Wed, Oct 15, 2014 at 01:55:09PM -0500, atull@opensource.altera.com wrote:
> > > From: Alan Tull <atull@opensource.altera.com>
> > > 
> > > Add support for simple on/off control of each channel.
> > > 
> > > To add regulator support, the pmbus part driver needs to add
> > > regulator_desc information and number of regulators to its
> > > pmbus_driver_info struct.
> > > 
> > > regulator_desc can be declared using default macro for a
> > > regulator (PMBUS_REGULATOR) that is in pmbus.h
> > > 
> > > The regulator_init_data can be initialized from either
> > > platform data or the device tree.
> > > 
> > > Signed-off-by: Alan Tull <atull@opensource.altera.com>
> > > Reviewed-by: Mark Brown <broonie@kernel.org>
> > > Cc: Guenter Roeck <linux@roeck-us.net>
> > 
> > Hi Alan,
> > 
> > I am still seeing lots of the following:
> > 
> > vout0: Failed to create debugfs directory
> > vout1: Failed to create debugfs directory
> > vout2: Failed to create debugfs directory
> > vout3: Failed to create debugfs directory
> > vout4: Failed to create debugfs directory
> > vout5: Failed to create debugfs directory
> > vout6: Failed to create debugfs directory
> > vout7: Failed to create debugfs directory
> > 
> > I thought there was a problem in the regulator core, but after looking
> > into it concluded that the regulator core _should_ prepend the names
> > with the device name when creating the debugfs entries, unless no device
> > name is specified. So something must be missing. We'll need to sort
> > this out before I can accept the code.
> > 
> > Thanks,
> > Guenter
> > 
> 
> Hi Guenter,
> 
> OK, I will look into it.
> 

Can you try the following patch ? It may not be perfect, but it does
the job for me.

Mark, would that patch be acceptable ?

Thanks,
Guenter
---
From: Guenter Roeck <linux@roeck-us.net>
Date: Thu, 16 Oct 2014 13:08:35 -0700
Subject: [PATCH] regulator: Ensure unique regulator debugfs directory names

If multiple regulator devices of the same type exist in a system,
the regulator driver assigns generic names for the regulators it
provides, and debugfs is enabled, the regulator subsystem attempts
to create multiple entries with the same name in the regulator debugfs
directory. This fails for all but the first regulator, resulting in
multiple "Failed to create debugfs directory" log entries.

To avoid the problem, prepend the debugfs directory name for a regulator
with its parent device name if available, but only if no explicit
regulator name was provided.

Cc: Alan Tull <atull@opensource.altera.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/regulator/core.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index cd87c0c..92f7a53 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -3538,7 +3538,18 @@ static int add_regulator_attributes(struct regulator_dev *rdev)
 
 static void rdev_init_debugfs(struct regulator_dev *rdev)
 {
-	rdev->debugfs = debugfs_create_dir(rdev_get_name(rdev), debugfs_root);
+	struct device *parent = rdev->dev.parent;
+	const char *rname = rdev_get_name(rdev);
+	char name[NAME_MAX];
+
+	/* Avoid duplicate debugfs directory names */
+	if (parent && rname == rdev->desc->name) {
+		snprintf(name, sizeof(name), "%s-%s", dev_name(parent),
+			 rname);
+		rname = name;
+	}
+
+	rdev->debugfs = debugfs_create_dir(rname, debugfs_root);
 	if (!rdev->debugfs) {
 		rdev_warn(rdev, "Failed to create debugfs directory\n");
 		return;
-- 
1.9.1



