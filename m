Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935579Ab3FTC0S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 22:26:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:6377 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935506Ab3FTC0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 22:26:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,901,1363158000"; 
   d="scan'208";a="332481747"
Message-ID: <51C26861.9050106@intel.com>
Date: Thu, 20 Jun 2013 10:26:41 +0800
From: Aaron Lu <aaron.lu@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, Matthew Garrett <mjg@redhat.com>,
        Liu Jiang <liuj97@gmail.com>, Dirk Griesbach <spamthis@freenet.de>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        Liu Jiang <jiang.liu@huawei.com>, Aaron Lu <aaron.lwe@gmail.com>
Subject: Re: [PATCH] libata: remove dead code from libata-acpi.c
References: <1371265368-7334-1-git-send-email-liuj97@gmail.com> <51BE6B5C.70803@intel.com> <20130617180151.GG32663@mtj.dyndns.org> <51C02571.3090100@intel.com>
In-Reply-To: <51C02571.3090100@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2013 05:16 PM, Aaron Lu wrote:
> On 06/18/2013 02:01 AM, Tejun Heo wrote:
>> On Mon, Jun 17, 2013 at 09:50:20AM +0800, Aaron Lu wrote:
>>> On 06/15/2013 11:02 AM, Liu Jiang wrote:
>>>> From: Liu Jiang <liu97@gmail.com>
>>>>
>>>> Commit 30dcf76acc69 "libata: migrate ACPI code over to new bindings"
>>>> removed ACPI dock notification related code, but there's some dead
>>>> code left, so clean up it.
>>>
>>> I never noticed this, but it looks to be the case...
>>>
>>> I'm not sure the dock notification code is removed intentionally or
>>> mistakenly though, if it is a mistake, then instead of removing the left
>>> code here, we probably should add the dock notification code back.
>>>
>>> But I have no test system or any knowledge about how ata dock works, so
>>> I may be wrong :-)
>>
>> Looks like a regression to me.  We're probably locking up on some
>> older laptops which connects optical drives with hotpluggable PATA.
>> Matthew, can you please fix it?
> 
> A user just reported a bug for this:
> https://bugzilla.kernel.org/show_bug.cgi?id=59871
> 
> And bisected to commit 30dcf76acc69. I proposed a fix patch there, let's
> see what the user's test result.

Patch below.

If it is true that the ATA dock is only for PATA devices, then I can
simply the code a little bit in that I can do the notification registration
in ATA port's binding time for both ATA port ACPI handle and ACPI handle
of ATA devices belonging to this port, since we will always create SCSI
host devices along with its corresponding ATA port, the binding for ATA
port will always occur no matter if there is devices attached or not.

Hi Dirk,
I made a small change in the following patch than the last one I posted
in bugzilla that you tested OK to mimic the original behavior in pre-3.6
kernels to install notification handler for ATA devices even when the ATA
port's handle is NULL, this can only happen in SATA case, so if the
above question is true, then this change will not be necessary.


Subject: [PATCH] libata-acpi: add back ACPI based hotplug functionality

Commit 30dcf76acc mistakenly dropped the code to register hotplug
notificaion handler for ATA port/devices, causing regression for people
using ATA bay, as bug #59871 shows.

Fix this by adding back the hotplug notification handler registration
code. Since this code has to be run once and notification needs to be
installed on every ATA port/devices handle no matter if there is actual
device attached, we can't do this in binding time for ATA device ACPI
handle, as the binding only occurs when a SCSI device is created, i.e.
there is device attached. So introduced the ata_acpi_hotplug_init
function to loop scan all ATA ACPI handles and if it is available,
install the notification handler for it during ATA init time.

With the ATA ACPI handle binding to SCSI device tree, it is possible now
that when the SCSI hotplug work removes the SCSI device, the ACPI unbind
function will find that the corresponding ACPI device has already been
deleted by dock driver, causing a scaring message like:
[  128.263966] scsi 4:0:0:0: Oops, 'acpi_handle' corrupt
Fix this by waiting for SCSI hotplug task finish in our notificaion
handler, so that the removal of ACPI device done in ACPI unbind function
triggered by the removal of SCSI device is run earlier when ACPI device
is still available.

References: https://bugzilla.kernel.org/show_bug.cgi?id=59871
Reported-and-bisected-by: Dirk Griesbach <spamthis@freenet.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/ata/libata-acpi.c | 34 +++++++++++++++++++++++++++++++++-
 drivers/ata/libata-core.c |  2 ++
 drivers/ata/libata.h      |  2 ++
 3 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index 87f2f39..0ad54bb 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -156,8 +156,10 @@ static void ata_acpi_handle_hotplug(struct ata_port *ap, struct ata_device *dev,
 
 	spin_unlock_irqrestore(ap->lock, flags);
 
-	if (wait)
+	if (wait) {
 		ata_port_wait_eh(ap);
+		flush_work(&ap->hotplug_task.work);
+	}
 }
 
 static void ata_acpi_dev_notify_dock(acpi_handle handle, u32 event, void *data)
@@ -214,6 +216,36 @@ static const struct acpi_dock_ops ata_acpi_ap_dock_ops = {
 	.uevent = ata_acpi_ap_uevent,
 };
 
+void ata_acpi_hotplug_init(struct ata_host *host)
+{
+	int i;
+
+	for (i = 0; i < host->n_ports; i++) {
+		struct ata_port *ap = host->ports[i];
+		acpi_handle handle;
+		struct ata_device *dev;
+
+		if (!ap)
+			continue;
+
+		handle = ata_ap_acpi_handle(ap);
+		if (handle) {
+			/* we might be on a docking station */
+			register_hotplug_dock_device(handle,
+					&ata_acpi_ap_dock_ops, ap);
+		}
+
+		ata_for_each_dev(dev, &ap->link, ALL) {
+			handle = ata_dev_acpi_handle(dev);
+			if (handle) {
+				/* we might be on a docking station */
+				register_hotplug_dock_device(handle,
+						&ata_acpi_dev_dock_ops, dev);
+			}
+		}
+	}
+}
+
 /**
  * ata_acpi_dissociate - dissociate ATA host from ACPI objects
  * @host: target ATA host
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index f218427..adf002a 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6148,6 +6148,8 @@ int ata_host_register(struct ata_host *host, struct scsi_host_template *sht)
 	if (rc)
 		goto err_tadd;
 
+	ata_acpi_hotplug_init(host);
+
 	/* set cable, sata_spd_limit and report */
 	for (i = 0; i < host->n_ports; i++) {
 		struct ata_port *ap = host->ports[i];
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index c949dd3..577d902b 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -122,6 +122,7 @@ extern int ata_acpi_register(void);
 extern void ata_acpi_unregister(void);
 extern void ata_acpi_bind(struct ata_device *dev);
 extern void ata_acpi_unbind(struct ata_device *dev);
+extern void ata_acpi_hotplug_init(struct ata_host *host);
 #else
 static inline void ata_acpi_dissociate(struct ata_host *host) { }
 static inline int ata_acpi_on_suspend(struct ata_port *ap) { return 0; }
@@ -134,6 +135,7 @@ static inline int ata_acpi_register(void) { return 0; }
 static inline void ata_acpi_unregister(void) { }
 static inline void ata_acpi_bind(struct ata_device *dev) { }
 static inline void ata_acpi_unbind(struct ata_device *dev) { }
+static inline void ata_acpi_hotplug_init(struct ata_host *host) {}
 #endif
 
 /* libata-scsi.c */
-- 
1.8.3.3.gfada522

