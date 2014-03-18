Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932533AbaCRUIS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 16:08:18 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:54781 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932348AbaCRUIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 16:08:13 -0400
From: Silvio F <silvio.fricke@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: daeseok.youn@gmail.com, silvio.fricke@gmail.com, silvio@port1024.net
Subject: [PATCH] staging: unisys: kmalloc/memset to kzalloc conversation
Date: Tue, 18 Mar 2014 21:07:51 +0100
Message-Id: <1395173271-13190-2-git-send-email-silvio.fricke@gmail.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1395173271-13190-1-git-send-email-silvio.fricke@gmail.com>
References: <4376102.svyTz8ADVT@daeseok-laptop.cloud.net>
 <1395173271-13190-1-git-send-email-silvio.fricke@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch solves the Coccinelle warning: "kzalloc should be used
instead of kmalloc/memset"

This patch is a fixup for

	linux-next: 97a84f1203786985856a0d4b49b1d7cc387238ce
	"Staging: unisys: Replace kmalloc/memset with kzalloc"

Signed-off-by: Silvio F <silvio.fricke@gmail.com>
---
 drivers/staging/unisys/include/uisutils.h           | 5 +----
 drivers/staging/unisys/virthba/virthba.c            | 3 +--
 drivers/staging/unisys/virtpci/virtpci.c            | 3 +--
 drivers/staging/unisys/visorutil/memregion_direct.c | 5 ++---
 drivers/staging/unisys/visorutil/periodic_work.c    | 5 ++---
 5 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/unisys/include/uisutils.h b/drivers/staging/unisys/include/uisutils.h
index 81b5d9b..0dd9c80 100644
--- a/drivers/staging/unisys/include/uisutils.h
+++ b/drivers/staging/unisys/include/uisutils.h
@@ -190,10 +190,7 @@ struct chaninfo {
 }
 
 #define ALLOC_CMDRSP(cmdrsp) { \
-	cmdrsp = kmalloc(SIZEOF_CMDRSP, GFP_ATOMIC); \
-	if (cmdrsp != NULL) { \
-		memset(cmdrsp, 0, SIZEOF_CMDRSP); \
-	} \
+	cmdrsp = kzalloc(SIZEOF_CMDRSP, GFP_ATOMIC); \
 }
 
 /* This is a hack until we fix IOVM to initialize the channel header
diff --git a/drivers/staging/unisys/virthba/virthba.c b/drivers/staging/unisys/virthba/virthba.c
index 8aefaa8..d99a38d 100644
--- a/drivers/staging/unisys/virthba/virthba.c
+++ b/drivers/staging/unisys/virthba/virthba.c
@@ -402,9 +402,8 @@ process_disk_notify(struct Scsi_Host *shost, struct uiscmdrsp *cmdrsp)
 	struct diskaddremove *dar;
 	unsigned long flags;
 
-	dar = kmalloc(sizeof(struct diskaddremove), GFP_ATOMIC);
+	dar = kzalloc(sizeof(struct diskaddremove), GFP_ATOMIC);
 	if (dar) {
-		memset(dar, 0, sizeof(struct diskaddremove));
 		dar->add = cmdrsp->disknotify.add;
 		dar->shost = shost;
 		dar->channel = cmdrsp->disknotify.channel;
diff --git a/drivers/staging/unisys/virtpci/virtpci.c b/drivers/staging/unisys/virtpci/virtpci.c
index 1b64632..8e34650 100644
--- a/drivers/staging/unisys/virtpci/virtpci.c
+++ b/drivers/staging/unisys/virtpci/virtpci.c
@@ -254,13 +254,12 @@ static int add_vbus(struct add_vbus_guestpart *addparams)
 {
 	int ret;
 	struct device *vbus;
-	vbus = kmalloc(sizeof(struct device), GFP_ATOMIC);
+	vbus = kzalloc(sizeof(struct device), GFP_ATOMIC);
 
 	POSTCODE_LINUX_2(VPCI_CREATE_ENTRY_PC, POSTCODE_SEVERITY_INFO);
 	if (!vbus)
 		return 0;
 
-	memset(vbus, 0, sizeof(struct device));
 	dev_set_name(vbus, "vbus%d", addparams->busNo);
 	vbus->release = virtpci_bus_release;
 	vbus->parent = &virtpci_rootbus_device;	/* root bus is parent */
diff --git a/drivers/staging/unisys/visorutil/memregion_direct.c b/drivers/staging/unisys/visorutil/memregion_direct.c
index 82c651d..b9b61e8 100644
--- a/drivers/staging/unisys/visorutil/memregion_direct.c
+++ b/drivers/staging/unisys/visorutil/memregion_direct.c
@@ -41,13 +41,12 @@ MEMREGION *
 visor_memregion_create(HOSTADDRESS physaddr, ulong nbytes)
 {
 	MEMREGION *rc = NULL;
-	MEMREGION *memregion = kmalloc(sizeof(MEMREGION),
-				       GFP_KERNEL|__GFP_NORETRY);
+	MEMREGION *memregion = kzalloc(sizeof(MEMREGION),
+				       GFP_KERNEL | __GFP_NORETRY);
 	if (memregion == NULL) {
 		ERRDRV("visor_memregion_create allocation failed");
 		return NULL;
 	}
-	memset(memregion, 0, sizeof(MEMREGION));
 	memregion->physaddr = physaddr;
 	memregion->nbytes = nbytes;
 	memregion->overlapped = FALSE;
diff --git a/drivers/staging/unisys/visorutil/periodic_work.c b/drivers/staging/unisys/visorutil/periodic_work.c
index cc1c678..fb1e894 100644
--- a/drivers/staging/unisys/visorutil/periodic_work.c
+++ b/drivers/staging/unisys/visorutil/periodic_work.c
@@ -56,13 +56,12 @@ PERIODIC_WORK *visor_periodic_work_create(ulong jiffy_interval,
 					  void *workfuncarg,
 					  const char *devnam)
 {
-	PERIODIC_WORK *periodic_work = kmalloc(sizeof(PERIODIC_WORK),
-					       GFP_KERNEL|__GFP_NORETRY);
+	PERIODIC_WORK *periodic_work = kzalloc(sizeof(PERIODIC_WORK),
+					       GFP_KERNEL | __GFP_NORETRY);
 	if (periodic_work == NULL) {
 		ERRDRV("periodic_work allocation failed ");
 		return NULL;
 	}
-	memset(periodic_work, '\0', sizeof(PERIODIC_WORK));
 	rwlock_init(&periodic_work->lock);
 	periodic_work->jiffy_interval = jiffy_interval;
 	periodic_work->workqueue = workqueue;
-- 
1.9.0

