Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721AbaDAQMY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 12:12:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44494 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607AbaDAQK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 12:10:27 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Williams <dan.j.williams@intel.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 62/86] [SCSI] isci: fix reset timeout handling
Date: Tue,  1 Apr 2014 09:08:15 -0700
Message-Id: <1396368519-12728-63-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396368519-12728-1-git-send-email-kamal@canonical.com>
References: <1396368519-12728-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.21 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dan.j.williams@intel.com>

commit ddfadd7736b677de2d4ca2cd5b4b655368c85a7a upstream.

Remove an erroneous BUG_ON() in the case of a hard reset timeout.  The
reset timeout handler puts the port into the "awaiting link-up" state.
The timeout causes the device to be disconnected and we need to be in
the awaiting link-up state to re-connect the port.  The BUG_ON() made
the incorrect assumption that resets never timeout and we always
complete the reset in the "resetting" state.

Testing this patch also uncovered that libata continues to attempt to
reset the port long after the driver has torn down the context.  Once
the driver has committed to abandoning the link it must indicate to
libata that recovery ends by returning -ENODEV from
->lldd_I_T_nexus_reset().

Acked-by: Lukasz Dorau <lukasz.dorau@intel.com>
Reported-by: David Milburn <dmilburn@redhat.com>
Reported-by: Xun Ni <xun.ni@intel.com>
Tested-by: Xun Ni <xun.ni@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/scsi/isci/port_config.c | 7 -------
 drivers/scsi/isci/task.c        | 2 +-
 2 files changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/scsi/isci/port_config.c b/drivers/scsi/isci/port_config.c
index cd962da..5017bde 100644
--- a/drivers/scsi/isci/port_config.c
+++ b/drivers/scsi/isci/port_config.c
@@ -615,13 +615,6 @@ static void sci_apc_agent_link_up(struct isci_host *ihost,
 					  SCIC_SDS_APC_WAIT_LINK_UP_NOTIFICATION);
 	} else {
 		/* the phy is already the part of the port */
-		u32 port_state = iport->sm.current_state_id;
-
-		/* if the PORT'S state is resetting then the link up is from
-		 * port hard reset in this case, we need to tell the port
-		 * that link up is recieved
-		 */
-		BUG_ON(port_state != SCI_PORT_RESETTING);
 		port_agent->phy_ready_mask |= 1 << phy_index;
 		sci_port_link_up(iport, iphy);
 	}
diff --git a/drivers/scsi/isci/task.c b/drivers/scsi/isci/task.c
index 572ab51..e4eb9eb 100644
--- a/drivers/scsi/isci/task.c
+++ b/drivers/scsi/isci/task.c
@@ -801,7 +801,7 @@ int isci_task_I_T_nexus_reset(struct domain_device *dev)
 		/* XXX: need to cleanup any ireqs targeting this
 		 * domain_device
 		 */
-		ret = TMF_RESP_FUNC_COMPLETE;
+		ret = -ENODEV;
 		goto out;
 	}
 
-- 
1.8.3.2

