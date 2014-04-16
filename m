Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161364AbaDPOMs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 10:12:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:52384 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161180AbaDPOMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 10:12:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,872,1389772800"; 
   d="diff'?scan'208";a="494170383"
Date: Wed, 16 Apr 2014 17:12:39 +0300
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Vivek Gautam <gautam.vivek@samsung.com>
Cc: Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        linux-omap@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, Felipe Balbi <balbi@ti.com>,
        Kukjin Kim <kgene.kim@samsung.com>, kishon <kishon@ti.com>,
        Jingoo Han <jg1.han@samsung.com>, Julius Werner <jwerner@chromium.org>
Subject: Re: [PATCH RFC 3/4] xhci: Tune PHY for the DWC3-Exynos host
 controller
Message-ID: <20140416141239.GB30528@xps8300>
References: <1386672926-26885-1-git-send-email-gautam.vivek@samsung.com>
 <1386672926-26885-4-git-send-email-gautam.vivek@samsung.com>
 <20131210135548.GA28456@xps8300>
 <CAFp+6iGAdDgC=21VjCUjx3u_ZohhCyj2nG8qzvz3CHTZzoXWJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="xHFwDpU9dbj6ez1V"
Content-Disposition: inline
In-Reply-To: <CAFp+6iGAdDgC=21VjCUjx3u_ZohhCyj2nG8qzvz3CHTZzoXWJQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

On Tue, Apr 15, 2014 at 06:24:11PM +0530, Vivek Gautam wrote:
> I had seen your patches in the mailing list, but i don't see any
> updated version of these patches.
> Are you planning to work on this above mentioned patch-series any time soon ?

I'm sorry, I forgot this completely. I have not prepared new version
of those patches as the drivers I need them for are not ready yet, but
I guess I can also use this case as justification for them.

> Or, should i try to find a different approach for handling the phy
> from the host controller (child of DWC3 in this case, which has the
> phys).

Well, there is now an issue with the lookup method I'm suggesting in
this case. Since the device ID is now generated automatically for
xhci-hcd in dwc3, we don't know the xhci-hcd device name before
platform_device_add(), and that is too late. I don't see why the
device could not be named when platform_device_alloc() is called, so I
think I'll suggest something like the attached patch to fix this
issue.

In any case, I'll send an updated version of the phy patches soon.

Thanks,

-- 
heikki

--xHFwDpU9dbj6ez1V
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="pdev_set_name.diff"

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index e714709..13f8edb 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -169,11 +169,47 @@ struct platform_object {
  */
 void platform_device_put(struct platform_device *pdev)
 {
-	if (pdev)
-		put_device(&pdev->dev);
+	if (!pdev)
+		return;
+
+	if (pdev->id_auto) {
+		ida_simple_remove(&platform_devid_ida, pdev->id);
+		pdev->id = PLATFORM_DEVID_AUTO;
+	}
+
+	put_device(&pdev->dev);
 }
 EXPORT_SYMBOL_GPL(platform_device_put);
 
+static int pdev_set_name(struct platform_device *pdev)
+{
+	int ret;
+
+	switch (pdev->id) {
+	default:
+		dev_set_name(&pdev->dev, "%s.%d", pdev->name,  pdev->id);
+		break;
+	case PLATFORM_DEVID_NONE:
+		dev_set_name(&pdev->dev, "%s", pdev->name);
+		break;
+	case PLATFORM_DEVID_AUTO:
+		/*
+		 * Automatically allocated device ID. We mark it as such so
+		 * that we remember it must be freed, and we append a suffix
+		 * to avoid namespace collision with explicit IDs.
+		 */
+		ret = ida_simple_get(&platform_devid_ida, 0, 0, GFP_KERNEL);
+		if (ret < 0)
+			return ret;
+		pdev->id = ret;
+		pdev->id_auto = true;
+		dev_set_name(&pdev->dev, "%s.%d.auto", pdev->name, pdev->id);
+		break;
+	}
+
+	return 0;
+}
+
 static void platform_device_release(struct device *dev)
 {
 	struct platform_object *pa = container_of(dev, struct platform_object,
@@ -206,6 +242,10 @@ struct platform_device *platform_device_alloc(const char *name, int id)
 		device_initialize(&pa->pdev.dev);
 		pa->pdev.dev.release = platform_device_release;
 		arch_setup_pdev_archdata(&pa->pdev);
+		if (pdev_set_name(&pa->pdev)) {
+			kfree(pa);
+			return NULL;
+		}
 	}
 
 	return pa ? &pa->pdev : NULL;
@@ -286,28 +326,6 @@ int platform_device_add(struct platform_device *pdev)
 
 	pdev->dev.bus = &platform_bus_type;
 
-	switch (pdev->id) {
-	default:
-		dev_set_name(&pdev->dev, "%s.%d", pdev->name,  pdev->id);
-		break;
-	case PLATFORM_DEVID_NONE:
-		dev_set_name(&pdev->dev, "%s", pdev->name);
-		break;
-	case PLATFORM_DEVID_AUTO:
-		/*
-		 * Automatically allocated device ID. We mark it as such so
-		 * that we remember it must be freed, and we append a suffix
-		 * to avoid namespace collision with explicit IDs.
-		 */
-		ret = ida_simple_get(&platform_devid_ida, 0, 0, GFP_KERNEL);
-		if (ret < 0)
-			goto err_out;
-		pdev->id = ret;
-		pdev->id_auto = true;
-		dev_set_name(&pdev->dev, "%s.%d.auto", pdev->name, pdev->id);
-		break;
-	}
-
 	for (i = 0; i < pdev->num_resources; i++) {
 		struct resource *p, *r = &pdev->resource[i];
 
@@ -350,7 +368,6 @@ int platform_device_add(struct platform_device *pdev)
 			release_resource(r);
 	}
 
- err_out:
 	return ret;
 }
 EXPORT_SYMBOL_GPL(platform_device_add);
@@ -370,11 +387,6 @@ void platform_device_del(struct platform_device *pdev)
 	if (pdev) {
 		device_del(&pdev->dev);
 
-		if (pdev->id_auto) {
-			ida_simple_remove(&platform_devid_ida, pdev->id);
-			pdev->id = PLATFORM_DEVID_AUTO;
-		}
-
 		for (i = 0; i < pdev->num_resources; i++) {
 			struct resource *r = &pdev->resource[i];
 			unsigned long type = resource_type(r);
@@ -392,8 +404,15 @@ EXPORT_SYMBOL_GPL(platform_device_del);
  */
 int platform_device_register(struct platform_device *pdev)
 {
+	int ret;
+
 	device_initialize(&pdev->dev);
 	arch_setup_pdev_archdata(pdev);
+
+	ret = pdev_set_name(pdev);
+	if (ret)
+		return ret;
+
 	return platform_device_add(pdev);
 }
 EXPORT_SYMBOL_GPL(platform_device_register);

--xHFwDpU9dbj6ez1V--
