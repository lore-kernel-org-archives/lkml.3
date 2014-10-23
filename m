Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956AbaJWQmz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 12:42:55 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43605 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbaJWQmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 12:42:53 -0400
Date: Thu, 23 Oct 2014 18:42:46 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, dmitry.torokhov@gmail.com,
        sre@kernel.org, B38611@freescale.com, aaro.koskinen@iki.fi,
        jg1.han@samsung.com, linux-input@vger.kernel.org
Subject: Re: 3.18.rc1: compile failure in tsc2005.c
Message-ID: <20141023164245.GA13718@amd>
References: <20141023125325.GB30572@amd>
 <201410231501.04540@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201410231501.04540@pali>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Oops, ignore me, this is part of n900 changes that did not make it to
mainline.

> > I get this. Before I start patching it, perhaps someone has
> > fixed it already?
> > 
> >   CC      drivers/input/touchscreen/tsc2005.o
> > drivers/input/touchscreen/tsc2005.c: In function
> > 'tsc2005_disable_store':
> > drivers/input/touchscreen/tsc2005.c:406:2: error: implicit
> > declaration of function 'strict_strtoul'
> > [-Werror=implicit-function-declaration] cc1: some warnings
> > being treated as errors
n> > scripts/Makefile.build:257: recipe for target
> > 'drivers/input/touchscreen/tsc2005.o' failed
> > make[3]: *** [drivers/input/touchscreen/tsc2005.o] Error 1
> > scripts/Makefile.build:402: recipe for target
> > 'drivers/input/touchscreen' failed
> > make[2]: *** [drivers/input/touchscreen] Error 2
> > scripts/Makefile.build:402: recipe for target 'drivers/input'
> > failed make[1]: *** [drivers/input] Error 2
> > make[1]: *** Waiting for unfinished jobs....
> >   CC      net/core/request_sock.o
> 
> Hi, I read somewhere that strict_strtoul function was replaced by 
> some kstrtol function... So maybe somebody forgot to fix tsc2005 
> driver?

Yes.. there are four places in n900 patches that will need fixing.

This only applies to Pali's tree.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

									Pavel

commit 1f031685bd14a13242f78e7cc9cc1cd767aa3dbc
Author: Pavel <pavel@ucw.cz>
Date:   Thu Oct 23 17:23:16 2014 +0200

    Fix compilation by replacing strict_strtoul to kstrtoul
    
    Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/arch/arm/plat-omap/gpio-switch.c b/arch/arm/plat-omap/gpio-switch.c
index 394c45b..ceed4f3 100644
--- a/arch/arm/plat-omap/gpio-switch.c
+++ b/arch/arm/plat-omap/gpio-switch.c
@@ -197,7 +197,7 @@ static ssize_t gpio_sw_disable_store(struct device *dev,
 	struct gpio_switch *sw = dev_get_drvdata(dev);
 	unsigned long res;
 
-	if (strict_strtoul(buf, 10, &res) < 0)
+	if (kstrtoul(buf, 10, &res) < 0)
 		return -EINVAL;
 
 	if (!!res == sw->disabled)
diff --git a/drivers/input/touchscreen/tsc2005.c b/drivers/input/touchscreen/tsc2005.c
index 422ec6e..ec1c276 100644
--- a/drivers/input/touchscreen/tsc2005.c
+++ b/drivers/input/touchscreen/tsc2005.c
@@ -403,7 +403,7 @@ static ssize_t tsc2005_disable_store(struct device *dev,
 	unsigned long val;
 	int error;
 
-	error = strict_strtoul(buf, 10, &val);
+	error = kstrtoul(buf, 10, &val);
 	if (error)
 		return error;
 
diff --git a/drivers/net/wireless/ti/wl1251/main.c b/drivers/net/wireless/ti/wl1251/main.c
index 3a986f3..f697e5f 100644
--- a/drivers/net/wireless/ti/wl1251/main.c
+++ b/drivers/net/wireless/ti/wl1251/main.c
@@ -1506,7 +1506,7 @@ static ssize_t wl1251_sysfs_store_tx_mgmt_frm_rate(struct device *dev,
 	unsigned long res;
 	int ret;
 
-	ret = strict_strtoul(buf, 10, &res);
+	ret = kstrtoul(buf, 10, &res);
 
 	if (ret < 0) {
 		wl1251_warning("incorrect value written to tx_mgmt_frm_rate");
@@ -1600,7 +1600,7 @@ static ssize_t wl1251_sysfs_store_bt_coex_mode(struct device *dev,
 	unsigned long res;
 	int ret;
 
-	ret = strict_strtoul(buf, 10, &res);
+	ret = kstrtoul(buf, 10, &res);
 
 	if (ret < 0) {
 		wl1251_warning("incorrect value written to bt_coex_mode");




-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
