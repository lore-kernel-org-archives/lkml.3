Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477Ab3KVJMA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 04:12:00 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:38622 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755392Ab3KVJLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 04:11:45 -0500
Message-ID: <528F1FC9.4070306@linaro.org>
Date: Fri, 22 Nov 2013 14:41:37 +0530
From: viresh kumar <viresh.kumar@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lan Tianyu <tianyu.lan@intel.com>, Nishanth Menon <nm@ti.com>,
        jinchoi@broadcom.com, Sebastian Capella <sebastian.capella@linaro.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH] cpufreq: suspend/resume governors with PM notifiers
References: <0e476d16e0ae4b001f5dd4f9ac191f899095928a.1384510171.git.viresh.kumar@linaro.org> <1531674.UoqyyWSbOg@vostro.rjw.lan> <CAKohpo=e+0cpq5XfWpM6Jm0VrnzzAu-xybpucEG6sRL0ydBmLQ@mail.gmail.com> <2642790.BqNcqy9aCb@vostro.rjw.lan>
In-Reply-To: <2642790.BqNcqy9aCb@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 November 2013 03:44 AM, Rafael J. Wysocki wrote:
> Short-term.  To be precise, governors may be stopped at the beginning of
> dpm_suspend_noirq() (that is, where cpuidle_pause() is called).  Analogously,
> they may be started again in dpm_resume_noirq(), where cpuidle_resume() is
> called.  That at least would be consistent with what cpuidle already does.

Ahh, I mentioned the location to be after "freeze" as I thought CPUs are removed
before calling dpm_suspend_noirq(). And yes I was *wrong*..

So, dpm_suspend_noirq() and resume_noirq() looks to be the right place to get
that stuff in.. And that will fit cleanly in the existing code as well.. Not
many changes would be required in the $subject patch..

> That said in my opinion the appropriate long-term approach would be to split
> CPU offline and online each into two parts, the "core" part and the "extras"
> part, such that the "core" parts would only do the offline/online of the
> cores themselves.  The rest, such as cpufreq/cpuidle "offline/online" would
> be done in the "extras" part.
> 
> Then, system suspend/resume will only use the "core" parts of CPU offline/online
> and the handling of the things belonging to "extras" would be carried out
> through CPU device suspend/resume callbacks.  In turn, the "runtime" CPU offline
> and online would carry out both the "extras" and "core" parts as it does today.
> 
> Makes sense?

Yes it does. Very much.

So, I will probably float a initial patch with the dpm_{suspend|resume}_noirq()
approach to get things fixed for now. And then will do what you suggested. And
yes logically this makes sense, a lot of sense. cpuidle/freq are about managing
CPUs and so we better have a CPU driver here, to take care of suspend/resume paths.

I have few questions regarding the long term solution. There can be only one
driver for any device, this is how device-driver model is. But there can be many
users of cpu driver. Like ACPI (which we already have:
drivers/acpi/processor_driver.c), CPUFreq, CPUIdle and maybe more..

To get all these serviced together we probably need to write another layer on
top of these to which these will register their callbacks.

Then I started looking into kernel code to understand different frameworks we
are using and came across: subsys_interface. This is the comment over it:

 * Simple interfaces attached to a subsystem. Multiple interfaces can
 * attach to a subsystem and its devices. Unlike drivers, they do not
 * exclusively claim or control devices. Interfaces usually represent
 * a specific functionality of a subsystem/class of devices.

And it exactly fits our purpose. We don't really need a CPU driver as there are
multiple frameworks that need it for the same device. And probably we just need
a interface which would call user specific callbacks (user being: cpufreq,
cpuidle, maybe more)..

So, what about something like this ?

diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index f48370d..523c0bc 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -120,6 +120,45 @@ static DEVICE_ATTR(release, S_IWUSR, NULL, cpu_release_store);
 #endif /* CONFIG_ARCH_CPU_PROBE_RELEASE */
 #endif /* CONFIG_HOTPLUG_CPU */

+int cpu_subsys_suspend_noirq(struct device *dev)
+{
+       struct bus_type *bus = dev->bus;
+       struct subsys_interface *sif;
+       int ret = 0;
+
+       list_for_each_entry(sif, &bus->p->interfaces, node) {
+               if (sif->pm && sif->pm->suspend_noirq) {
+                       ret = sif->suspend_noirq(dev);
+                       if (ret)
+                               break;
+               }
+       }
+
+       return ret;
+}
+
+int cpu_subsys_resume_noirq(struct device *dev)
+{
+       struct bus_type *bus = dev->bus;
+       struct subsys_interface *sif;
+       int ret = 0;
+
+       list_for_each_entry(sif, &bus->p->interfaces, node) {
+               if (sif->pm && sif->pm->resume_noirq) {
+                       ret = sif->resume_noirq(dev);
+                       if (ret)
+                               break;
+               }
+       }
+
+       return ret;
+}
+
+static const struct dev_pm_ops cpu_subsys_pm_ops = {
+       .suspend_noirq = cpu_subsys_suspend_noirq,
+       .resume_noirq = cpu_subsys_resume_noirq,
+};
+
 struct bus_type cpu_subsys = {
        .name = "cpu",
        .dev_name = "cpu",
@@ -128,6 +167,7 @@ struct bus_type cpu_subsys = {
        .online = cpu_subsys_online,
        .offline = cpu_subsys_offline,
 #endif
+       .pm = &cpu_subsys_pm_ops,
 };
 EXPORT_SYMBOL_GPL(cpu_subsys);

diff --git a/include/linux/device.h b/include/linux/device.h
index b025925..fa01273 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -298,11 +298,16 @@ struct device *driver_find_device(struct device_driver *drv,
  * @node:       the list of functions registered at the subsystem
  * @add_dev:    device hookup to device function handler
  * @remove_dev: device hookup to device function handler
+ * @pm: Power management operations of this interface.
  *
  * Simple interfaces attached to a subsystem. Multiple interfaces can
  * attach to a subsystem and its devices. Unlike drivers, they do not
  * exclusively claim or control devices. Interfaces usually represent
  * a specific functionality of a subsystem/class of devices.
+ *
+ * PM callbacks are called from individual subsystems instead of PM core. And
+ * hence might not be available for all subsystems. Currently present for:
+ * cpu_subsys.
  */
 struct subsys_interface {
        const char *name;
@@ -310,6 +315,7 @@ struct subsys_interface {
        struct list_head node;
        int (*add_dev)(struct device *dev, struct subsys_interface *sif);
        int (*remove_dev)(struct device *dev, struct subsys_interface *sif);
+       const struct dev_pm_ops *pm;
 };

 int subsys_interface_register(struct subsys_interface *sif);

