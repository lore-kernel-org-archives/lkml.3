Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932191Ab3ERDBX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 23:01:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32671 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758835Ab3ERDAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 23:00:34 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=2uGmdKO-vx4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=PJKvIJmjzigA:10 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=a3BEMHP2OoWBO_X0gykA:9 a=dGJ0OcVc7YAA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021650.962498965@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:16:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Aaron Lu <aaron.lu@intel.com>, Jeff Garzik <jgarzik@redhat.com>
Subject: [ 057/136 ] acpi: make ata_ap_acpi_handle not block
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0057-acpi-make-ata_ap_acpi_handle-not-block.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Aaron Lu <aaron.lu@intel.com>

[ Upstream commit d66af4df0837f21bf267305dc5ccab2d29e24d86 ]

Since commit 30dcf76acc, ata_ap_acpi_handle will always do a namespace
walk, which requires acquiring an acpi namespace mutex. This made it
impossible to be used when calling path has held a spinlock.

For example, it can occur in the following code path for pata_acpi:
ata_scsi_queuecmd (ap->lock is acquired)
  __ata_scsi_queuecmd
    ata_scsi_translate
      ata_qc_issue
        pacpi_qc_issue
          ata_acpi_stm
            ata_ap_acpi_handle
              acpi_get_child
                acpi_walk_namespace
                  acpi_ut_acquire_mutex (acquire mutex while holding lock)
This caused scheduling while atomic bug, as reported in bug #56781.

Actually, ata_ap_acpi_handle doesn't have to walk the namespace every
time it is called, it can simply return the bound acpi handle on the
corresponding SCSI host. The reason previously it is not done this way
is, ata_ap_acpi_handle is used in the binding function
ata_acpi_bind_host by ata_acpi_gtm when the handle is not bound to the
SCSI host yet. Since we already have the ATA port's handle in its
binding function, we can simply use it instead of calling
ata_ap_acpi_handle there. So introduce a new function __ata_acpi_gtm,
where it will receive an acpi handle param in addition to the ATA port
which is solely used for debug statement. With this change, we can make
ata_ap_acpi_handle simply return the bound handle for SCSI host instead
of walking the acpi namespace now.

Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=56781
Reported-and-tested-by: <kenzopl@o2.pl>
Cc: <stable@vger.kernel.org>
Signed-off-by: Aaron Lu <aaron.lu@intel.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/ata/libata-acpi.c |   45 +++++++++++++++++++++++++++------------------
 1 file changed, 27 insertions(+), 18 deletions(-)

diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index 5b0ba3f..926c9f5 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -60,7 +60,8 @@ acpi_handle ata_ap_acpi_handle(struct ata_port *ap)
 	if (ap->flags & ATA_FLAG_ACPI_SATA)
 		return NULL;
 
-	return acpi_get_child(DEVICE_ACPI_HANDLE(ap->host->dev), ap->port_no);
+	return ap->scsi_host ?
+		DEVICE_ACPI_HANDLE(&ap->scsi_host->shost_gendev) : NULL;
 }
 EXPORT_SYMBOL(ata_ap_acpi_handle);
 
@@ -236,28 +237,15 @@ void ata_acpi_dissociate(struct ata_host *host)
 	}
 }
 
-/**
- * ata_acpi_gtm - execute _GTM
- * @ap: target ATA port
- * @gtm: out parameter for _GTM result
- *
- * Evaluate _GTM and store the result in @gtm.
- *
- * LOCKING:
- * EH context.
- *
- * RETURNS:
- * 0 on success, -ENOENT if _GTM doesn't exist, -errno on failure.
- */
-int ata_acpi_gtm(struct ata_port *ap, struct ata_acpi_gtm *gtm)
+static int __ata_acpi_gtm(struct ata_port *ap, acpi_handle handle,
+			  struct ata_acpi_gtm *gtm)
 {
 	struct acpi_buffer output = { .length = ACPI_ALLOCATE_BUFFER };
 	union acpi_object *out_obj;
 	acpi_status status;
 	int rc = 0;
 
-	status = acpi_evaluate_object(ata_ap_acpi_handle(ap), "_GTM", NULL,
-				      &output);
+	status = acpi_evaluate_object(handle, "_GTM", NULL, &output);
 
 	rc = -ENOENT;
 	if (status == AE_NOT_FOUND)
@@ -291,6 +279,27 @@ int ata_acpi_gtm(struct ata_port *ap, struct ata_acpi_gtm *gtm)
 	return rc;
 }
 
+/**
+ * ata_acpi_gtm - execute _GTM
+ * @ap: target ATA port
+ * @gtm: out parameter for _GTM result
+ *
+ * Evaluate _GTM and store the result in @gtm.
+ *
+ * LOCKING:
+ * EH context.
+ *
+ * RETURNS:
+ * 0 on success, -ENOENT if _GTM doesn't exist, -errno on failure.
+ */
+int ata_acpi_gtm(struct ata_port *ap, struct ata_acpi_gtm *gtm)
+{
+	if (ata_ap_acpi_handle(ap))
+		return __ata_acpi_gtm(ap, ata_ap_acpi_handle(ap), gtm);
+	else
+		return -EINVAL;
+}
+
 EXPORT_SYMBOL_GPL(ata_acpi_gtm);
 
 /**
@@ -1091,7 +1100,7 @@ static int ata_acpi_bind_host(struct ata_port *ap, acpi_handle *handle)
 	if (!*handle)
 		return -ENODEV;
 
-	if (ata_acpi_gtm(ap, &ap->__acpi_init_gtm) == 0)
+	if (__ata_acpi_gtm(ap, *handle, &ap->__acpi_init_gtm) == 0)
 		ap->pflags |= ATA_PFLAG_INIT_GTM_VALID;
 
 	return 0;
-- 
1.7.10.4


