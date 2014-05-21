Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305AbaEUXLX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 19:11:23 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:52029 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752292AbaEUXLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 19:11:20 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Mike Turquette <mturquette@linaro.org>, Jin Yao <yao.jin@linux.intel.com>,
        Li Aubrey <aubrey.li@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 2/4] ACPI / LPSS: custom power domain for LPSS
Date: Thu, 22 May 2014 01:28:16 +0200
Message-ID: <1484699.LPqrzmlevB@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140521105258.GB29349@xps8300>
References: <1400161226-24067-1-git-send-email-heikki.krogerus@linux.intel.com> <4546817.Xm9e491t74@vostro.rjw.lan> <20140521105258.GB29349@xps8300>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, May 21, 2014 01:52:58 PM Heikki Krogerus wrote:
> On Wed, May 21, 2014 at 01:01:31PM +0200, Rafael J. Wysocki wrote:
> > On Wednesday, May 21, 2014 01:05:11 PM Heikki Krogerus wrote:
> > > On Tue, May 20, 2014 at 11:33:09PM +0200, Rafael J. Wysocki wrote:
> > > > First, is the 10 ms sleep really necessary?  I'd expect the AML to take care of
> > > > such delays (this is not a PCI device formally).
> > > 
> > > Unfortunately that is not the case. There is nothing in the AML for
> > > this. Mika, correct me if I'm wrong.
> > > 
> > > > And because this is not a PCI device formally, why is the comment talking about
> > > > the PCI spec?  Why is PCI relevant in any way here?
> > > 
> > > Under the hood the devices are still PCI devices, even if they
> > > formally aren't. Maybe I should point that out in the comment..
> > > 
> > > We put the sleep there because without it there was no guarantee if
> > > the device was properly resumed by the time the drivers resume hooks
> > > were called. The symptom in case of a failure was simply that the
> > > registers could not be written, which leads into timeouts at least in
> > > case of the I2C and UART and making them unusable until the next
> > > suspend followed by resume.
> > 
> > OK, so the msleep() is functionally necessary.  Instead of talking about the
> > PCI in the comment, which will make a casual reader think "What the heck?",
> > please say something like "the delay is necessary for the subsequent register
> > writes to succeed on <example system>".
> 
> OK.

So I have one more concern.  Namely, async suspend is not enabled for the LPSS
devices, so the delays will accumulate for them and that may become a big deal
at one point.

This may be addressed either (1) by enabling async suspend for them or, which would
be more complicated, by doing the msleep() once for the whole LPSS in .resume_early()
and restoring the register values in .resume() without delaying.

For (1) I have the following untested patch (on top of my bleeding-edge branch, but
it should apply to the mainline too if I haven't overlooked anything).  Can you
please try it on boxes with LPSS and see if it doesn't break suspend/resume on them?

Rafael


---
 drivers/acpi/acpi_lpss.c     |   10 +++++++---
 drivers/acpi/acpi_platform.c |   25 ++++++++++++++-----------
 drivers/acpi/internal.h      |    3 +--
 3 files changed, 22 insertions(+), 16 deletions(-)

Index: linux-pm/drivers/acpi/acpi_lpss.c
===================================================================
--- linux-pm.orig/drivers/acpi/acpi_lpss.c
+++ linux-pm/drivers/acpi/acpi_lpss.c
@@ -276,6 +276,7 @@ static int acpi_lpss_create_device(struc
 	struct lpss_private_data *pdata;
 	struct resource_list_entry *rentry;
 	struct list_head resource_list;
+	struct platform_device *pdev;
 	int ret;
 
 	dev_desc = (struct lpss_device_desc *)id->driver_data;
@@ -331,10 +332,13 @@ static int acpi_lpss_create_device(struc
 		dev_desc->setup(pdata);
 
 	adev->driver_data = pdata;
-	ret = acpi_create_platform_device(adev, id);
-	if (ret > 0)
-		return ret;
+	pdev = acpi_create_platform_device(adev);
+	if (!IS_ERR_OR_NULL(pdev)) {
+		device_enable_async_suspend(&pdev->dev);
+		return 1;
+	}
 
+	ret = PTR_ERR(pdev);
 	adev->driver_data = NULL;
 
  err_out:
Index: linux-pm/drivers/acpi/acpi_platform.c
===================================================================
--- linux-pm.orig/drivers/acpi/acpi_platform.c
+++ linux-pm/drivers/acpi/acpi_platform.c
@@ -43,7 +43,6 @@ static const struct acpi_device_id acpi_
 /**
  * acpi_create_platform_device - Create platform device for ACPI device node
  * @adev: ACPI device node to create a platform device for.
- * @id: ACPI device ID used to match @adev.
  *
  * Check if the given @adev can be represented as a platform device and, if
  * that's the case, create and register a platform device, populate its common
@@ -51,8 +50,7 @@ static const struct acpi_device_id acpi_
  *
  * Name of the platform device will be the same as @adev's.
  */
-int acpi_create_platform_device(struct acpi_device *adev,
-				const struct acpi_device_id *id)
+struct platform_device *acpi_create_platform_device(struct acpi_device *adev)
 {
 	struct platform_device *pdev = NULL;
 	struct acpi_device *acpi_parent;
@@ -64,19 +62,19 @@ int acpi_create_platform_device(struct a
 
 	/* If the ACPI node already has a physical device attached, skip it. */
 	if (adev->physical_node_count)
-		return 0;
+		return NULL;
 
 	INIT_LIST_HEAD(&resource_list);
 	count = acpi_dev_get_resources(adev, &resource_list, NULL, NULL);
 	if (count < 0) {
-		return 0;
+		return NULL;
 	} else if (count > 0) {
 		resources = kmalloc(count * sizeof(struct resource),
 				    GFP_KERNEL);
 		if (!resources) {
 			dev_err(&adev->dev, "No memory for resources\n");
 			acpi_dev_free_resource_list(&resource_list);
-			return -ENOMEM;
+			return ERR_PTR(-ENOMEM);
 		}
 		count = 0;
 		list_for_each_entry(rentry, &resource_list, node)
@@ -113,22 +111,27 @@ int acpi_create_platform_device(struct a
 	pdevinfo.num_res = count;
 	pdevinfo.acpi_node.companion = adev;
 	pdev = platform_device_register_full(&pdevinfo);
-	if (IS_ERR(pdev)) {
+	if (IS_ERR(pdev))
 		dev_err(&adev->dev, "platform device creation failed: %ld\n",
 			PTR_ERR(pdev));
-		pdev = NULL;
-	} else {
+	else
 		dev_dbg(&adev->dev, "created platform device %s\n",
 			dev_name(&pdev->dev));
-	}
 
 	kfree(resources);
+	return pdev;
+}
+
+static int acpi_platform_attach(struct acpi_device *adev,
+				const struct acpi_device_id *id)
+{
+	acpi_create_platform_device(adev);
 	return 1;
 }
 
 static struct acpi_scan_handler platform_handler = {
 	.ids = acpi_platform_device_ids,
-	.attach = acpi_create_platform_device,
+	.attach = acpi_platform_attach,
 };
 
 void __init acpi_platform_init(void)
Index: linux-pm/drivers/acpi/internal.h
===================================================================
--- linux-pm.orig/drivers/acpi/internal.h
+++ linux-pm/drivers/acpi/internal.h
@@ -180,8 +180,7 @@ static inline void suspend_nvs_restore(v
   -------------------------------------------------------------------------- */
 struct platform_device;
 
-int acpi_create_platform_device(struct acpi_device *adev,
-				const struct acpi_device_id *id);
+struct platform_device *acpi_create_platform_device(struct acpi_device *adev);
 
 /*--------------------------------------------------------------------------
 					Video

