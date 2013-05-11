Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996Ab3EKJQc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 05:16:32 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:57749 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936Ab3EKJQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 05:16:29 -0400
Message-ID: <518E0BB0.2000401@linux.vnet.ibm.com>
Date: Sat, 11 May 2013 14:43:20 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Robin Holt <holt@sgi.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, "H. Peter Anvin" <hpa@zytor.com>,
        Russ Anderson <rja@sgi.com>, Russell King <linux@arm.linux.org.uk>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH -v8 01/11] CPU hotplug: Provide a generic helper to disable/enable
 CPU hotplug
References: <1367937595-32241-1-git-send-email-holt@sgi.com> <1367937595-32241-2-git-send-email-holt@sgi.com> <20130509150121.8c3ef60b2fc748ce542a1a52@linux-foundation.org> <1651579.orCh9JNVz6@vostro.rjw.lan> <20130510100324.e1e066ab.akpm@linux-foundation.org> <20130511041610.GZ3672@sgi.com>
In-Reply-To: <20130511041610.GZ3672@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051109-6102-0000-0000-000003811690
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2013 09:46 AM, Robin Holt wrote:
> On Fri, May 10, 2013 at 10:03:24AM -0700, Andrew Morton wrote:
>> On Fri, 10 May 2013 13:11:51 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
>>
>>> ...
>>>
>>>> cpu_hotplug_disable() doesn't get compiled unless we've defined
>>>> CONFIG_PM_SLEEP_SMP.  I cannot begin to imagine what the logic is
>>>> behind that!
>>>
>>> I suppose it was only used by suspend/hibernate code paths when this was
>>> introduced.
>>
>> OK, well I suspect that what I have now is simply wrong for Robin's
>> application.  Robin, can you please check this?  We probably want to
>> make the does-something version of cpu_hotplug_disable/enable available
>> if CONFIG_HOTPLUG_CPU.
> 
> This patch came from "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
> I think I need to defer.

Here is a revised patch, which should address all the problems, IMHO.
Let me know if you face any issues. (And thanks a lot for fixing up the
!SMP case in the previous version.)

--------------------------------------------------------------------->

From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH] CPU hotplug: Provide a generic helper to disable/enable CPU hotplug

There are instances in the kernel where we would like to disable
CPU hotplug (from sysfs) during some important operation. Today
the freezer code depends on this and the code to do it was kinda
tailor-made for that.

Restructure the code and make it generic enough to be useful for
other usecases too.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 include/linux/cpu.h |    4 ++++
 kernel/cpu.c        |   55 +++++++++++++++++++++------------------------------
 2 files changed, 27 insertions(+), 32 deletions(-)

diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index c6f6e08..9f3c7e8 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -175,6 +175,8 @@ extern struct bus_type cpu_subsys;
 
 extern void get_online_cpus(void);
 extern void put_online_cpus(void);
+extern void cpu_hotplug_disable(void);
+extern void cpu_hotplug_enable(void);
 #define hotcpu_notifier(fn, pri)	cpu_notifier(fn, pri)
 #define register_hotcpu_notifier(nb)	register_cpu_notifier(nb)
 #define unregister_hotcpu_notifier(nb)	unregister_cpu_notifier(nb)
@@ -198,6 +200,8 @@ static inline void cpu_hotplug_driver_unlock(void)
 
 #define get_online_cpus()	do { } while (0)
 #define put_online_cpus()	do { } while (0)
+#define cpu_hotplug_disable()	do { } while (0)
+#define cpu_hotplug_enable()	do { } while (0)
 #define hotcpu_notifier(fn, pri)	do { (void)(fn); } while (0)
 /* These aren't inline functions due to a GCC bug. */
 #define register_hotcpu_notifier(nb)	({ (void)(nb); 0; })
diff --git a/kernel/cpu.c b/kernel/cpu.c
index b5e4ab2..198a388 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -133,6 +133,27 @@ static void cpu_hotplug_done(void)
 	mutex_unlock(&cpu_hotplug.lock);
 }
 
+/*
+ * Wait for currently running CPU hotplug operations to complete (if any) and
+ * disable future CPU hotplug (from sysfs). The 'cpu_add_remove_lock' protects
+ * the 'cpu_hotplug_disabled' flag. The same lock is also acquired by the
+ * hotplug path before performing hotplug operations. So acquiring that lock
+ * guarantees mutual exclusion from any currently running hotplug operations.
+ */
+void cpu_hotplug_disable(void)
+{
+	cpu_maps_update_begin();
+	cpu_hotplug_disabled = 1;
+	cpu_maps_update_done();
+}
+
+void cpu_hotplug_enable(void)
+{
+	cpu_maps_update_begin();
+	cpu_hotplug_disabled = 0;
+	cpu_maps_update_done();
+}
+
 #else /* #if CONFIG_HOTPLUG_CPU */
 static void cpu_hotplug_begin(void) {}
 static void cpu_hotplug_done(void) {}
@@ -541,36 +562,6 @@ static int __init alloc_frozen_cpus(void)
 core_initcall(alloc_frozen_cpus);
 
 /*
- * Prevent regular CPU hotplug from racing with the freezer, by disabling CPU
- * hotplug when tasks are about to be frozen. Also, don't allow the freezer
- * to continue until any currently running CPU hotplug operation gets
- * completed.
- * To modify the 'cpu_hotplug_disabled' flag, we need to acquire the
- * 'cpu_add_remove_lock'. And this same lock is also taken by the regular
- * CPU hotplug path and released only after it is complete. Thus, we
- * (and hence the freezer) will block here until any currently running CPU
- * hotplug operation gets completed.
- */
-void cpu_hotplug_disable_before_freeze(void)
-{
-	cpu_maps_update_begin();
-	cpu_hotplug_disabled = 1;
-	cpu_maps_update_done();
-}
-
-
-/*
- * When tasks have been thawed, re-enable regular CPU hotplug (which had been
- * disabled while beginning to freeze tasks).
- */
-void cpu_hotplug_enable_after_thaw(void)
-{
-	cpu_maps_update_begin();
-	cpu_hotplug_disabled = 0;
-	cpu_maps_update_done();
-}
-
-/*
  * When callbacks for CPU hotplug notifications are being executed, we must
  * ensure that the state of the system with respect to the tasks being frozen
  * or not, as reported by the notification, remains unchanged *throughout the
@@ -589,12 +580,12 @@ cpu_hotplug_pm_callback(struct notifier_block *nb,
 
 	case PM_SUSPEND_PREPARE:
 	case PM_HIBERNATION_PREPARE:
-		cpu_hotplug_disable_before_freeze();
+		cpu_hotplug_disable();
 		break;
 
 	case PM_POST_SUSPEND:
 	case PM_POST_HIBERNATION:
-		cpu_hotplug_enable_after_thaw();
+		cpu_hotplug_enable();
 		break;
 
 	default:


