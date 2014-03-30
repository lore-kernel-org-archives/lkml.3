Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051AbaC3XgV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:36:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36482 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753114AbaC3XZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:25:04 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "James Bottomley" <JBottomley@Parallels.com>,
        "Xun Ni" <xun.ni@intel.com>, "Dan Williams" <dan.j.williams@intel.com>,
        "Lukasz Dorau" <lukasz.dorau@intel.com>,
        "David Milburn" <dmilburn@redhat.com>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.185834891@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 169/200] [SCSI] isci: fix reset timeout handling
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/isci/port_config.c | 7 -------
 drivers/scsi/isci/task.c        | 2 +-
 2 files changed, 1 insertion(+), 8 deletions(-)

--- a/drivers/scsi/isci/port_config.c
+++ b/drivers/scsi/isci/port_config.c
@@ -610,13 +610,6 @@ static void sci_apc_agent_link_up(struct
 		sci_apc_agent_configure_ports(ihost, port_agent, iphy, true);
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
--- a/drivers/scsi/isci/task.c
+++ b/drivers/scsi/isci/task.c
@@ -1390,7 +1390,7 @@ int isci_task_I_T_nexus_reset(struct dom
 	spin_unlock_irqrestore(&ihost->scic_lock, flags);
 
 	if (!idev || !test_bit(IDEV_EH, &idev->flags)) {
-		ret = TMF_RESP_FUNC_COMPLETE;
+		ret = -ENODEV;
 		goto out;
 	}
 

