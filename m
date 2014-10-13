Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990AbaJMCgO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 22:36:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46125 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754651AbaJMCaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 22:30:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 3.17 12/25] PCI: pciehp: Fix wait time in timeout message
Date: Mon, 13 Oct 2014 04:25:05 +0200
Message-Id: <20141013022454.819586920@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141013022454.289398272@linuxfoundation.org>
References: <20141013022454.289398272@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yinghai Lu <yinghai@kernel.org>

commit d433889cd5a0933fbd90f1e65bff5a8d7963cc52 upstream.

When we warned about a timeout on a hotplug command, we previously printed
the time between calls to pcie_write_cmd(), without accounting for any time
spent actually waiting.  Consider this sequence:

  pcie_write_cmd
    write SLTCTL
    cmd_started = jiffies          # T1

  pcie_write_cmd
    pcie_wait_cmd
      now = jiffies                # T2
      wait_event_timeout           # we may wait here
      if (timeout)
        ctrl_info("Timeout on command issued %u msec ago",
                  jiffies_to_msecs(now - cmd_started))

We previously printed (T2 - T1), but that doesn't include the time spent in
wait_event_timeout().

Fix this by using the current jiffies value, not the one cached before
calling wait_event_timeout().

[bhelgaas: changelog, use current jiffies instead of adding timeout]
Fixes: 40b960831cfa ("PCI: pciehp: Compute timeout from hotplug command start time")
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/hotplug/pciehp_hpc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -173,7 +173,7 @@ static void pcie_wait_cmd(struct control
 	if (!rc)
 		ctrl_info(ctrl, "Timeout on hotplug command %#010x (issued %u msec ago)\n",
 			  ctrl->slot_ctrl,
-			  jiffies_to_msecs(now - ctrl->cmd_started));
+			  jiffies_to_msecs(jiffies - ctrl->cmd_started));
 }
 
 /**


