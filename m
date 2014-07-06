Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043AbaGFSBT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 14:01:19 -0400
Received: from smtprelay0041.hostedemail.com ([216.40.44.41]:54467 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751795AbaGFSBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 14:01:17 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:69:355:379:541:599:857:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3870:3871:4321:4605:5007:6119:7652:7904:8603:8879:10004:10400:10848:11026:11232:11657:11658:11914:12043:12295:12296:12438:12517:12519:12555:12740:13161:13229:13255:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: word48_622f87370500c
X-Filterd-Recvd-Size: 3586
Message-ID: <1404669673.27043.50.camel@joe-AO725>
Subject: Re: [PATCH] video: fbdev: omap: omapfb_main.c:  Cleaning up wrong
 type in format string
From: Joe Perches <joe@perches.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sun, 06 Jul 2014 11:01:13 -0700
In-Reply-To: <1404668049-15016-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1404668049-15016-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-07-06 at 19:34 +0200, Rickard Strandqvist wrote:
> Wrong type in sscanf format string, requires 'int *' but the
> argument type is 'unsigned int *'

Maybe use kstrtouint?

> diff --git a/drivers/video/fbdev/omap/omapfb_main.c b/drivers/video/fbdev/omap/omapfb_main.c

> @@ -1371,7 +1371,7 @@ static ssize_t omapfb_store_bklight_level(struct device *dev,
>  	if (fbdev->panel->set_bklight_level) {
>  		unsigned int level;
>  
> -		if (sscanf(buf, "%10d", &level) == 1) {
> +		if (sscanf(buf, "%10u", &level) == 1) {
>  			r = fbdev->panel->set_bklight_level(fbdev->panel,
>  							    level);
>  		} else

Something like: (more comments below patch too)

 drivers/video/fbdev/omap/omapfb_main.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/video/fbdev/omap/omapfb_main.c b/drivers/video/fbdev/omap/omapfb_main.c
index d8d028d..96dd2f0 100644
--- a/drivers/video/fbdev/omap/omapfb_main.c
+++ b/drivers/video/fbdev/omap/omapfb_main.c
@@ -1365,20 +1365,16 @@ static ssize_t omapfb_store_bklight_level(struct device *dev,
 					  struct device_attribute *attr,
 					  const char *buf, size_t size)
 {
+	unsigned int level;
 	struct omapfb_device *fbdev = dev_get_drvdata(dev);
-	int r;
 
-	if (fbdev->panel->set_bklight_level) {
-		unsigned int level;
+	if (!fbdev->panel->set_bklight_level)
+		return -ENODEV;
 
-		if (sscanf(buf, "%10d", &level) == 1) {
-			r = fbdev->panel->set_bklight_level(fbdev->panel,
-							    level);
-		} else
-			r = -EINVAL;
-	} else
-		r = -ENODEV;
-	return r ? r : size;
+	if (kstrtouint(buf, 10, &level) < 0)
+		return -EINVAL;
+
+	return fbdev->panel->set_bklight_level(fbdev->panel, level) ?: size;
 }
 
 static ssize_t omapfb_show_bklight_max(struct device *dev,

---

The brightness permissions seem odd:

drivers/video/fbdev/omap/omapfb_main.c-static struct device_attribute dev_attr_panel_name =
drivers/video/fbdev/omap/omapfb_main.c- __ATTR(name, 0444, omapfb_show_panel_name, NULL);
drivers/video/fbdev/omap/omapfb_main.c-static DEVICE_ATTR(backlight_level, 0664,
drivers/video/fbdev/omap/omapfb_main.c:            omapfb_show_bklight_level, omapfb_store_bklight_level);
drivers/video/fbdev/omap/omapfb_main.c-static DEVICE_ATTR(backlight_max, 0444, omapfb_show_bklight_max, NULL);

Why 0644 for backlight_level when backlight_max is 0444?


