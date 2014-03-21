Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934101AbaCUAO7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:14:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37421 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966173AbaCUAJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:09:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lukasz Dorau <lukasz.dorau@intel.com>,
        David Milburn <dmilburn@redhat.com>, Xun Ni <xun.ni@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [PATCH 3.4 29/35] SCSI: isci: fix reset timeout handling
Date: Thu, 20 Mar 2014 17:11:20 -0700
Message-Id: <20140321001055.116321239@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321001054.038170009@linuxfoundation.org>
References: <20140321001054.038170009@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/isci/port_config.c |    7 -------
 drivers/scsi/isci/task.c        |    2 +-
 2 files changed, 1 insertion(+), 8 deletions(-)

--- a/drivers/scsi/isci/port_config.c
+++ b/drivers/scsi/isci/port_config.c
@@ -619,13 +619,6 @@ static void sci_apc_agent_link_up(struct
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
--- a/drivers/scsi/isci/task.c
+++ b/drivers/scsi/isci/task.c
@@ -1312,7 +1312,7 @@ int isci_task_I_T_nexus_reset(struct dom
 		/* XXX: need to cleanup any ireqs targeting this
 		 * domain_device
 		 */
-		ret = TMF_RESP_FUNC_COMPLETE;
+		ret = -ENODEV;
 		goto out;
 	}
 


