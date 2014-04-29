Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964882AbaD2MfT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 08:35:19 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:44153 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964818AbaD2MfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 08:35:16 -0400
From: Grant Likely <grant.likely@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@kernel.org>, Stable <stable@vger.kernel.org>
Subject: [PATCH v4] drivercore: deferral race condition fix
Date: Tue, 29 Apr 2014 13:35:09 +0100
Message-Id: <1398774909-13649-1-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the kernel is built with CONFIG_PREEMPT it is possible to reach a state
when all modules loaded but some driver still stuck in the deferred list
and there is a need for external event to kick the deferred queue to probe
these drivers.

The issue has been observed on embedded systems with CONFIG_PREEMPT enabled,
audio support built as modules and using nfsroot for root filesystem.

The following log fragment shows such sequence when all audio modules
were loaded but the sound card is not present since the machine driver has
failed to probe due to missing dependency during it's probe.
The board is am335x-evmsk (McASP<->tlv320aic3106 codec) with davinci-evm
machine driver:

...
[   12.615118] davinci-mcasp 4803c000.mcasp: davinci_mcasp_probe: ENTER
[   12.719969] davinci_evm sound.3: davinci_evm_probe: ENTER
[   12.725753] davinci_evm sound.3: davinci_evm_probe: snd_soc_register_card
[   12.753846] davinci-mcasp 4803c000.mcasp: davinci_mcasp_probe: snd_soc_register_component
[   12.922051] davinci-mcasp 4803c000.mcasp: davinci_mcasp_probe: snd_soc_register_component DONE
[   12.950839] davinci_evm sound.3: ASoC: platform (null) not registered
[   12.957898] davinci_evm sound.3: davinci_evm_probe: snd_soc_register_card DONE (-517)
[   13.099026] davinci-mcasp 4803c000.mcasp: Kicking the deferred list
[   13.177838] davinci-mcasp 4803c000.mcasp: really_probe: probe_count = 2
[   13.194130] davinci_evm sound.3: snd_soc_register_card failed (-517)
[   13.346755] davinci_mcasp_driver_init: LEAVE
[   13.377446] platform sound.3: Driver davinci_evm requests probe deferral
[   13.592527] platform sound.3: really_probe: probe_count = 0

In the log the machine driver enters it's probe at 12.719969 (this point it
has been removed from the deferred lists). McASP driver already executing
it's probing (since 12.615118).
The machine driver tries to construct the sound card (12.950839) but did
not found one of the components so it fails. After this McASP driver
registers all the ASoC components (the machine driver still in it's probe
function after it failed to construct the card) and the deferred work is
prepared at 13.099026 (note that this time the machine driver is not in the
lists so it is not going to be handled when the work is executing).
Lastly the machine driver exit from it's probe and the core places it to
the deferred list but there will be no other driver going to load and the
deferred queue is not going to be kicked again - till we have external event
like connecting USB stick, etc.

The proposed solution is to try the deferred queue once more when the last
driver is asking for deferring and we had drivers loaded while this last
driver was probing.

This way we can avoid drivers stuck in the deferred queue.

v4: New approach; keep track of trigger events instead of nested probing.

Signed-off-by: Grant Likely <grant.likely@linaro.org>
Reviewed-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Tested-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Stable <stable@vger.kernel.org> # v3.4+
---

Hi Greg,

This change needs to go into 3.15. I've got this patch in the
devicetree/merge branch of my tree and can ask Linus to pull it directly
if you would like.

g.


 drivers/base/dd.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 8986b9f22781..62ec61e8f84a 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -52,6 +52,7 @@ static DEFINE_MUTEX(deferred_probe_mutex);
 static LIST_HEAD(deferred_probe_pending_list);
 static LIST_HEAD(deferred_probe_active_list);
 static struct workqueue_struct *deferred_wq;
+static atomic_t deferred_trigger_count = ATOMIC_INIT(0);
 
 /**
  * deferred_probe_work_func() - Retry probing devices in the active list.
@@ -135,6 +136,17 @@ static bool driver_deferred_probe_enable = false;
  * This functions moves all devices from the pending list to the active
  * list and schedules the deferred probe workqueue to process them.  It
  * should be called anytime a driver is successfully bound to a device.
+ *
+ * Note, there is a race condition in multi-threaded probe. In the case where
+ * more than one device is probing at the same time, it is possible for one
+ * probe to complete successfully while another is about to defer. If the second
+ * depends on the first, then it will get put on the pending list after the
+ * trigger event has already occured and will be stuck there.
+ *
+ * The atomic 'deferred_trigger_count' is used to determine if a successful
+ * trigger has occurred in the midst of probing a driver. If the trigger count
+ * changes in the midst of a probe, then deferred processing should be triggered
+ * again.
  */
 static void driver_deferred_probe_trigger(void)
 {
@@ -147,6 +159,7 @@ static void driver_deferred_probe_trigger(void)
 	 * into the active list so they can be retried by the workqueue
 	 */
 	mutex_lock(&deferred_probe_mutex);
+	atomic_inc(&deferred_trigger_count);
 	list_splice_tail_init(&deferred_probe_pending_list,
 			      &deferred_probe_active_list);
 	mutex_unlock(&deferred_probe_mutex);
@@ -265,6 +278,7 @@ static DECLARE_WAIT_QUEUE_HEAD(probe_waitqueue);
 static int really_probe(struct device *dev, struct device_driver *drv)
 {
 	int ret = 0;
+	int local_trigger_count = atomic_read(&deferred_trigger_count);
 
 	atomic_inc(&probe_count);
 	pr_debug("bus: '%s': %s: probing driver %s with device %s\n",
@@ -310,6 +324,9 @@ probe_failed:
 		/* Driver requested deferred probing */
 		dev_info(dev, "Driver %s requests probe deferral\n", drv->name);
 		driver_deferred_probe_add(dev);
+		/* Did a trigger occur while probing? Need to re-trigger if yes */
+		if (local_trigger_count != atomic_read(&deferred_trigger_count))
+			driver_deferred_probe_trigger();
 	} else if (ret != -ENODEV && ret != -ENXIO) {
 		/* driver matched but the probe failed */
 		printk(KERN_WARNING
-- 
1.9.1

