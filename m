Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760610Ab3GSOja (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 10:39:30 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:61875 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760543Ab3GSOj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 10:39:26 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        herbert@gondor.hengli.com.au, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, ak <ak@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 3.11-rc1] crypto: Fix boot failure due to module dependency.
Date: Fri, 19 Jul 2013 16:49:22 +0200
Message-ID: <2493652.fjZLqTL8IF@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <3364013.pHWIsx89Eq@vostro.rjw.lan>
References: <201307180550.BDB51536.LHMQOOOVFJFSFt@I-love.SAKURA.ne.jp> <1374188894.22432.354.camel@schen9-DESK> <3364013.pHWIsx89Eq@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 19, 2013 03:03:36 PM Rafael J. Wysocki wrote:
> On Thursday, July 18, 2013 04:08:14 PM Tim Chen wrote:
> > On Fri, 2013-07-19 at 00:17 +0200, Rafael J. Wysocki wrote:
> > > On 7/18/2013 11:00 PM, Tim Chen wrote:
> > > > On Thu, 2013-07-18 at 12:47 +0900, Tetsuo Handa wrote:
> > > >> Tim Chen wrote:
> > > >>>>> Your approach is quite complicated.  I think something simpler like the
> > > >>>>> following will work:
> > > >>>> We cannot benefit from PCLMULQDQ. Is it acceptable for you?
> > > >>>
> > > >>> The following code in crct10dif-pclmul_glue.c
> > > >>>
> > > >>> static const struct x86_cpu_id crct10dif_cpu_id[] = {
> > > >>>          X86_FEATURE_MATCH(X86_FEATURE_PCLMULQDQ),
> > > >>>          {}
> > > >>> };
> > > >>> MODULE_DEVICE_TABLE(x86cpu, crct10dif_cpu_id);
> > > >>>
> > > >>> will put the module in the device table and get the module
> > > >>> loaded, as long as the cpu support PCLMULQDQ. So we should be able
> > > >>> to benefit.
> > > >> Excuse me, how can crct10dif-pclmul.ko get loaded automatically?
> > > >> Did you test CONFIG_CRYPTO_CRCT10DIF_PCLMUL=m with below debug message?
> > > > The code:
> > > >
> > > > static const struct x86_cpu_id crct10dif_cpu_id[] = {
> > > >           X86_FEATURE_MATCH(X86_FEATURE_PCLMULQDQ),
> > > >           {}
> > > > };
> > > > MODULE_DEVICE_TABLE(x86cpu, crct10dif_cpu_id);
> > > >
> > > > causes the following line to be added to modules.alias file:
> > > >
> > > > alias x86cpu:vendor:*:family:*:model:*:feature:*0081* crct10dif_pclmul
> > > >
> > > > This should cause udev to load the crct10dif_pclml module when cpu
> > > > support the PCLMULQDQ (feature code 0081).  I did my testing during
> > > > development on 3.10 and the module was indeed loaded.
> > > >
> > > > However, I found that the following commit under 3.11-rc1 broke
> > > > the mechanism after some bisection.
> > > >
> > > > commit ac212b6980d8d5eda705864fc5a8ecddc6d6eacc
> > > > Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > > Date:   Fri May 3 00:26:22 2013 +0200
> > > >
> > > >      ACPI / processor: Use common hotplug infrastructure
> > > >      
> > > >      Split the ACPI processor driver into two parts, one that is
> > > >      non-modular, resides in the ACPI core and handles the enumeration
> > > >      and hotplug of processors and one that implements the rest of the
> > > >      existing processor driver functionality.
> > > >      
> > > > Rafael, can you check and see if this can be fixed so those optimized
> > > > crypto modules for Intel cpu that support them can be loaded?
> > > 
> > > I think this is an ordering issue between udev startup and the time when 
> > > devices are registered.
> > 
> > Something that can be fixed?
> 
> I'm sure it can be fixes, but I'm not sure whether it's a udev bug or real
> breakage in the kernel yet.  I need to figure out that part.

OK

I wonder if the appended patch makes the issue go away for you?

Rafael


---
 drivers/acpi/acpi_platform.c    |   24 +++++++++++++-----------
 drivers/acpi/acpi_processor.c   |   14 ++++----------
 drivers/acpi/processor_driver.c |   26 ++++++++++++++------------
 3 files changed, 31 insertions(+), 33 deletions(-)

Index: linux-pm/drivers/acpi/acpi_processor.c
===================================================================
--- linux-pm.orig/drivers/acpi/acpi_processor.c
+++ linux-pm/drivers/acpi/acpi_processor.c
@@ -397,20 +397,14 @@ static int __cpuinit acpi_processor_add(
 		result = -ENODEV;
 		goto err;
 	}
-
-	result = acpi_bind_one(dev, pr->handle);
-	if (result)
-		goto err;
-
 	pr->dev = dev;
 	dev->offline = pr->flags.need_hotplug_init;
 
-	/* Trigger the processor driver's .probe() if present. */
-	if (device_attach(dev) >= 0)
-		return 1;
+	result = acpi_create_platform_device(device, id);
+	if (result > 0)
+		return result;
 
-	dev_err(dev, "Processor driver could not be attached\n");
-	acpi_unbind_one(dev);
+	dev_err(dev, "Unable to create processor platform device\n");
 
  err:
 	free_cpumask_var(pr->throttling.shared_cpu_map);
Index: linux-pm/drivers/acpi/acpi_platform.c
===================================================================
--- linux-pm.orig/drivers/acpi/acpi_platform.c
+++ linux-pm/drivers/acpi/acpi_platform.c
@@ -52,7 +52,7 @@ int acpi_create_platform_device(struct a
 	struct platform_device_info pdevinfo;
 	struct resource_list_entry *rentry;
 	struct list_head resource_list;
-	struct resource *resources;
+	struct resource *resources = NULL;
 	int count;
 
 	/* If the ACPI node already has a physical device attached, skip it. */
@@ -61,20 +61,22 @@ int acpi_create_platform_device(struct a
 
 	INIT_LIST_HEAD(&resource_list);
 	count = acpi_dev_get_resources(adev, &resource_list, NULL, NULL);
-	if (count <= 0)
+	if (count < 0) {
 		return 0;
+	} else if (count > 0) {
+		resources = kmalloc(count * sizeof(struct resource),
+				    GFP_KERNEL);
+		if (!resources) {
+			dev_err(&adev->dev, "No memory for resources\n");
+			acpi_dev_free_resource_list(&resource_list);
+			return -ENOMEM;
+		}
+		count = 0;
+		list_for_each_entry(rentry, &resource_list, node)
+			resources[count++] = rentry->res;
 
-	resources = kmalloc(count * sizeof(struct resource), GFP_KERNEL);
-	if (!resources) {
-		dev_err(&adev->dev, "No memory for resources\n");
 		acpi_dev_free_resource_list(&resource_list);
-		return -ENOMEM;
 	}
-	count = 0;
-	list_for_each_entry(rentry, &resource_list, node)
-		resources[count++] = rentry->res;
-
-	acpi_dev_free_resource_list(&resource_list);
 
 	memset(&pdevinfo, 0, sizeof(pdevinfo));
 	/*
Index: linux-pm/drivers/acpi/processor_driver.c
===================================================================
--- linux-pm.orig/drivers/acpi/processor_driver.c
+++ linux-pm/drivers/acpi/processor_driver.c
@@ -36,6 +36,7 @@
 #include <linux/cpuidle.h>
 #include <linux/slab.h>
 #include <linux/acpi.h>
+#include <linux/platform_device.h>
 
 #include <acpi/processor.h>
 
@@ -54,8 +55,8 @@ MODULE_AUTHOR("Paul Diefenbaugh");
 MODULE_DESCRIPTION("ACPI Processor Driver");
 MODULE_LICENSE("GPL");
 
-static int acpi_processor_start(struct device *dev);
-static int acpi_processor_stop(struct device *dev);
+static int acpi_processor_start(struct platform_device *pdev);
+static int acpi_processor_stop(struct platform_device *pdev);
 
 static const struct acpi_device_id processor_device_ids[] = {
 	{ACPI_PROCESSOR_OBJECT_HID, 0},
@@ -64,10 +65,11 @@ static const struct acpi_device_id proce
 };
 MODULE_DEVICE_TABLE(acpi, processor_device_ids);
 
-static struct device_driver acpi_processor_driver = {
-	.name = "processor",
-	.bus = &cpu_subsys,
-	.acpi_match_table = processor_device_ids,
+static struct platform_driver acpi_processor_driver = {
+	.driver = {
+		.name = "processor",
+		.acpi_match_table = processor_device_ids,
+	},
 	.probe = acpi_processor_start,
 	.remove = acpi_processor_stop,
 };
@@ -222,22 +224,22 @@ static __cpuinit int __acpi_processor_st
 	return result;
 }
 
-static int __cpuinit acpi_processor_start(struct device *dev)
+static int __cpuinit acpi_processor_start(struct platform_device *pdev)
 {
 	struct acpi_device *device;
 
-	if (acpi_bus_get_device(ACPI_HANDLE(dev), &device))
+	if (acpi_bus_get_device(ACPI_HANDLE(&pdev->dev), &device))
 		return -ENODEV;
 
 	return __acpi_processor_start(device);
 }
 
-static int acpi_processor_stop(struct device *dev)
+static int acpi_processor_stop(struct platform_device *pdev)
 {
 	struct acpi_device *device;
 	struct acpi_processor *pr;
 
-	if (acpi_bus_get_device(ACPI_HANDLE(dev), &device))
+	if (acpi_bus_get_device(ACPI_HANDLE(&pdev->dev), &device))
 		return 0;
 
 	acpi_remove_notify_handler(device->handle, ACPI_DEVICE_NOTIFY,
@@ -271,7 +273,7 @@ static int __init acpi_processor_driver_
 	if (acpi_disabled)
 		return 0;
 
-	result = driver_register(&acpi_processor_driver);
+	result = platform_driver_register(&acpi_processor_driver);
 	if (result < 0)
 		return result;
 
@@ -292,7 +294,7 @@ static void __exit acpi_processor_driver
 	acpi_thermal_cpufreq_exit();
 	unregister_hotcpu_notifier(&acpi_cpu_notifier);
 	acpi_processor_syscore_exit();
-	driver_unregister(&acpi_processor_driver);
+	platform_driver_unregister(&acpi_processor_driver);
 }
 
 module_init(acpi_processor_driver_init);

