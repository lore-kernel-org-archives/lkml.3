Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445Ab3KRS7U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 13:59:20 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57479 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693Ab3KRSku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 13:40:50 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Zhang Rui <rui.zhang@intel.com>, Jonghwan Choi <jhbird.choi@gmail.com>
Subject: [PATCH 3.11 12/25] Thermal: x86_pkg_temp: change spin lock
Date: Mon, 18 Nov 2013 10:40:41 -0800
Message-Id: <20131118184035.991787661@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131118184032.248465920@linuxfoundation.org>
References: <20131118184032.248465920@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

commit 7bed1b3caaedd5918f0820b29f3b7a2ddc812922 upstream.

x86_pkg_temp receives thermal notifications via a callback from a
therm_throt driver, where thermal interrupts are processed.
This callback is pkg_temp_thermal_platform_thermal_notify. Here to
avoid multiple interrupts from cores in a package, we disable the
source and also set a variable to avoid scheduling delayed work function.
This variable is protected via spin_lock_irqsave. On one buggy platform,
we still receiving interrupts even if the source is disabled. This
can cause deadlock/lockdep warning, when interrupt is generated while under
spinlock in work function.
Change spin_lock to spin_lock_irqsave and spin_unlock to
spin_unlock_irqrestore as the data it is trying to protect can also
be modified in a notification call called from interrupt handler.

Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Cc: Jonghwan Choi <jhbird.choi@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/thermal/x86_pkg_temp_thermal.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/drivers/thermal/x86_pkg_temp_thermal.c
+++ b/drivers/thermal/x86_pkg_temp_thermal.c
@@ -316,18 +316,19 @@ static void pkg_temp_thermal_threshold_w
 	int phy_id = topology_physical_package_id(cpu);
 	struct phy_dev_entry *phdev = pkg_temp_thermal_get_phy_entry(cpu);
 	bool notify = false;
+	unsigned long flags;
 
 	if (!phdev)
 		return;
 
-	spin_lock(&pkg_work_lock);
+	spin_lock_irqsave(&pkg_work_lock, flags);
 	++pkg_work_cnt;
 	if (unlikely(phy_id > max_phy_id)) {
-		spin_unlock(&pkg_work_lock);
+		spin_unlock_irqrestore(&pkg_work_lock, flags);
 		return;
 	}
 	pkg_work_scheduled[phy_id] = 0;
-	spin_unlock(&pkg_work_lock);
+	spin_unlock_irqrestore(&pkg_work_lock, flags);
 
 	enable_pkg_thres_interrupt();
 	rdmsrl(MSR_IA32_PACKAGE_THERM_STATUS, msr_val);
@@ -397,6 +398,7 @@ static int pkg_temp_thermal_device_add(u
 	int thres_count;
 	u32 eax, ebx, ecx, edx;
 	u8 *temp;
+	unsigned long flags;
 
 	cpuid(6, &eax, &ebx, &ecx, &edx);
 	thres_count = ebx & 0x07;
@@ -420,19 +422,19 @@ static int pkg_temp_thermal_device_add(u
 		goto err_ret_unlock;
 	}
 
-	spin_lock(&pkg_work_lock);
+	spin_lock_irqsave(&pkg_work_lock, flags);
 	if (topology_physical_package_id(cpu) > max_phy_id)
 		max_phy_id = topology_physical_package_id(cpu);
 	temp = krealloc(pkg_work_scheduled,
 			(max_phy_id+1) * sizeof(u8), GFP_ATOMIC);
 	if (!temp) {
-		spin_unlock(&pkg_work_lock);
+		spin_unlock_irqrestore(&pkg_work_lock, flags);
 		err = -ENOMEM;
 		goto err_ret_free;
 	}
 	pkg_work_scheduled = temp;
 	pkg_work_scheduled[topology_physical_package_id(cpu)] = 0;
-	spin_unlock(&pkg_work_lock);
+	spin_unlock_irqrestore(&pkg_work_lock, flags);
 
 	phy_dev_entry->phys_proc_id = topology_physical_package_id(cpu);
 	phy_dev_entry->first_cpu = cpu;


