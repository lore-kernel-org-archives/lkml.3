Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759968Ab3E3TlN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 15:41:13 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:55085 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759827Ab3E3TlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 15:41:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Toshi Kani <toshi.kani@hp.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH] ACPI / processor: Initialize per_cpu(processors, pr->id) properly (Re: System slow down from udev)
Date: Thu, 30 May 2013 21:49:57 +0200
Message-ID: <3972909.bTSgjJ1tfq@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAE9FiQWC=2yfVvFAMPQ7D5n5M8QNWROpcr6H-VwWZ+CSoyduyw@mail.gmail.com>
References: <CAE9FiQUbSeCGTsukX3zfVYBhFKgWfVd8WDDvpix==wSXzc=RVQ@mail.gmail.com> <CAE9FiQU=kC7J2Ocqy-Bq8rN-pO_2gDOrngwev_be70j=LLSpUg@mail.gmail.com> <CAE9FiQWC=2yfVvFAMPQ7D5n5M8QNWROpcr6H-VwWZ+CSoyduyw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 30, 2013 11:12:30 AM Yinghai Lu wrote:
> On Thu, May 30, 2013 at 10:42 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> > On Thu, May 30, 2013 at 9:36 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > do you need to remove
> >     per_cpu(processors, pr->id) = NULL;
> > from processor_driver.c::acpi_processor_stop ?
> 
> updated patch.

Thanks!

Appended is essentially the same one with a changelog and tags.

Thanks,
Rafael


---
From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Subject: ACPI / processor: Initialize per_cpu(processors, pr->id) properly

Commit ac212b6 (ACPI / processor: Use common hotplug infrastructure)
forgot about initializing the per-CPU 'processors' variables which
lead to ACPI cpuidle failure to use C-states and caused boot slowdown
on multi-CPU machines.

Fix the problem by adding per_cpu(processors, pr->id) initialization
to acpi_processor_add() and add make acpi_processor_remove() clean it
up as appropriate.

Also modify acpi_processor_stop() so that it doesn't clear
per_cpu(processors, pr->id) on processor driver removal which would
then cause problems to happen when the driver is loaded again.

This version of the patch contains fixes from Yinghai Lu.

Reported-and-tested-by: Yinghai Lu <yinghai@kernel.org>
Reported-and-tested-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/acpi_processor.c   |    6 ++++++
 drivers/acpi/processor_driver.c |    5 -----
 2 files changed, 6 insertions(+), 5 deletions(-)

Index: linux-pm/drivers/acpi/processor_driver.c
===================================================================
--- linux-pm.orig/drivers/acpi/processor_driver.c
+++ linux-pm/drivers/acpi/processor_driver.c
@@ -78,9 +78,6 @@ static struct device_driver acpi_process
 	.remove = acpi_processor_stop,
 };
 
-DEFINE_PER_CPU(struct acpi_processor *, processors);
-EXPORT_PER_CPU_SYMBOL(processors);
-
 static void acpi_processor_notify(acpi_handle handle, u32 event, void *data)
 {
 	struct acpi_device *device = data;
@@ -268,8 +265,6 @@ static int acpi_processor_stop(struct de
 		thermal_cooling_device_unregister(pr->cdev);
 		pr->cdev = NULL;
 	}
-
-	per_cpu(processors, pr->id) = NULL;
 	return 0;
 }
 
Index: linux-pm/drivers/acpi/acpi_processor.c
===================================================================
--- linux-pm.orig/drivers/acpi/acpi_processor.c
+++ linux-pm/drivers/acpi/acpi_processor.c
@@ -29,6 +29,9 @@
 
 ACPI_MODULE_NAME("processor");
 
+DEFINE_PER_CPU(struct acpi_processor *, processors);
+EXPORT_PER_CPU_SYMBOL(processors);
+
 /* --------------------------------------------------------------------------
                                 Errata Handling
    -------------------------------------------------------------------------- */
@@ -387,6 +390,7 @@ static int __cpuinit acpi_processor_add(
 	 * checks.
 	 */
 	per_cpu(processor_device_array, pr->id) = device;
+	per_cpu(processors, pr->id) = pr;
 
 	dev = get_cpu_device(pr->id);
 	result = acpi_bind_one(dev, pr->handle);
@@ -406,6 +410,7 @@ static int __cpuinit acpi_processor_add(
  err:
 	free_cpumask_var(pr->throttling.shared_cpu_map);
 	device->driver_data = NULL;
+	per_cpu(processors, pr->id) = NULL;
  err_free_pr:
 	kfree(pr);
 	return result;
@@ -440,6 +445,7 @@ static void acpi_processor_remove(struct
 
 	/* Clean up. */
 	per_cpu(processor_device_array, pr->id) = NULL;
+	per_cpu(processors, pr->id) = NULL;
 	try_offline_node(cpu_to_node(pr->id));
 
 	/* Remove the CPU. */

