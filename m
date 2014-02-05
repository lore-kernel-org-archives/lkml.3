Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469AbaBEUIt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:08:49 -0500
Received: from mail1.windriver.com ([147.11.146.13]:48677 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755461AbaBEUIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:08:43 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Dan Williams <dan.j.williams@intel.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 206/213] SCSI: libsas: fix sas_discover_devices return code handling
Date: Wed, 5 Feb 2014 15:02:41 -0500
Message-ID: <1391630568-49251-207-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Williams <dan.j.williams@intel.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit e69e5d3d25d6b58543f782a515baeda064e2b601 upstream.

commit b17caa174a7e1fd2e17b26e210d4ee91c4c28b37 upstream.

commit 198439e4 [SCSI] libsas: do not set res = 0 in sas_ex_discover_dev()
commit 19252de6 [SCSI] libsas: fix wide port hotplug issues

The above commits seem to have confused the return value of
sas_ex_discover_dev which is non-zero on failure and
sas_ex_join_wide_port which just indicates short circuiting discovery on
already established ports.  The result is random discovery failures
depending on configuration.

Calls to sas_ex_join_wide_port are the source of the trouble as its
return value is errantly assigned to 'res'.  Convert it to bool and stop
returning its result up the stack.

Tested-by: Dan Melnic <dan.melnic@amd.com>
Reported-by: Dan Melnic <dan.melnic@amd.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Jack Wang <jack_wang@usish.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/scsi/libsas/sas_expander.c | 39 ++++++++++++--------------------------
 1 file changed, 12 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index cb4964b54191..f31f85e03f3a 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -755,7 +755,7 @@ static struct domain_device *sas_ex_discover_end_dev(
 }
 
 /* See if this phy is part of a wide port */
-static int sas_ex_join_wide_port(struct domain_device *parent, int phy_id)
+static bool sas_ex_join_wide_port(struct domain_device *parent, int phy_id)
 {
 	struct ex_phy *phy = &parent->ex_dev.ex_phy[phy_id];
 	int i;
@@ -771,11 +771,11 @@ static int sas_ex_join_wide_port(struct domain_device *parent, int phy_id)
 			sas_port_add_phy(ephy->port, phy->phy);
 			phy->port = ephy->port;
 			phy->phy_state = PHY_DEVICE_DISCOVERED;
-			return 0;
+			return true;
 		}
 	}
 
-	return -ENODEV;
+	return false;
 }
 
 static struct domain_device *sas_ex_discover_expander(
@@ -913,8 +913,7 @@ static int sas_ex_discover_dev(struct domain_device *dev, int phy_id)
 		return res;
 	}
 
-	res = sas_ex_join_wide_port(dev, phy_id);
-	if (!res) {
+	if (sas_ex_join_wide_port(dev, phy_id)) {
 		SAS_DPRINTK("Attaching ex phy%d to wide port %016llx\n",
 			    phy_id, SAS_ADDR(ex_phy->attached_sas_addr));
 		return res;
@@ -959,8 +958,7 @@ static int sas_ex_discover_dev(struct domain_device *dev, int phy_id)
 			if (SAS_ADDR(ex->ex_phy[i].attached_sas_addr) ==
 			    SAS_ADDR(child->sas_addr)) {
 				ex->ex_phy[i].phy_state= PHY_DEVICE_DISCOVERED;
-				res = sas_ex_join_wide_port(dev, i);
-				if (!res)
+				if (sas_ex_join_wide_port(dev, i))
 					SAS_DPRINTK("Attaching ex phy%d to wide port %016llx\n",
 						    i, SAS_ADDR(ex->ex_phy[i].attached_sas_addr));
 
@@ -1813,32 +1811,20 @@ static int sas_discover_new(struct domain_device *dev, int phy_id)
 {
 	struct ex_phy *ex_phy = &dev->ex_dev.ex_phy[phy_id];
 	struct domain_device *child;
-	bool found = false;
-	int res, i;
+	int res;
 
 	SAS_DPRINTK("ex %016llx phy%d new device attached\n",
 		    SAS_ADDR(dev->sas_addr), phy_id);
 	res = sas_ex_phy_discover(dev, phy_id);
 	if (res)
-		goto out;
-	/* to support the wide port inserted */
-	for (i = 0; i < dev->ex_dev.num_phys; i++) {
-		struct ex_phy *ex_phy_temp = &dev->ex_dev.ex_phy[i];
-		if (i == phy_id)
-			continue;
-		if (SAS_ADDR(ex_phy_temp->attached_sas_addr) ==
-		    SAS_ADDR(ex_phy->attached_sas_addr)) {
-			found = true;
-			break;
-		}
-	}
-	if (found) {
-		sas_ex_join_wide_port(dev, phy_id);
+		return res;
+
+	if (sas_ex_join_wide_port(dev, phy_id))
 		return 0;
-	}
+
 	res = sas_ex_discover_devices(dev, phy_id);
-	if (!res)
-		goto out;
+	if (res)
+		return res;
 	list_for_each_entry(child, &dev->ex_dev.children, siblings) {
 		if (SAS_ADDR(child->sas_addr) ==
 		    SAS_ADDR(ex_phy->attached_sas_addr)) {
@@ -1848,7 +1834,6 @@ static int sas_discover_new(struct domain_device *dev, int phy_id)
 			break;
 		}
 	}
-out:
 	return res;
 }
 
-- 
1.8.5.2

