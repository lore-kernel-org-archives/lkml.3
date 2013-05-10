Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272Ab3EJOUJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:20:09 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56912 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753823Ab3EJOUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:20:05 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Benjamin Poirier" <bpoirier@suse.de>,
        "Stephen Ko" <stephen.s.ko@intel.com>,
        "Jeff Kirsher" <jeffrey.t.kirsher@intel.com>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.655444496@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [114/118] ixgbe: add missing rtnl_lock in PM resume path
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Poirier <bpoirier@suse.de>

commit 34948a947d1a576c10afee6d14792fd237549577 upstream.

Upon resume from standby, ixgbe may trigger the ASSERT_RTNL() in
netif_set_real_num_tx_queues(). The call stack is:
	netif_set_real_num_tx_queues
	ixgbe_set_num_queues
	ixgbe_init_interrupt_scheme
	ixgbe_resume

Signed-off-by: Benjamin Poirier <bpoirier@suse.de>
Tested-by: Stephen Ko <stephen.s.ko@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -5418,7 +5418,9 @@ static int ixgbe_resume(struct pci_dev *
 
 	pci_wake_from_d3(pdev, false);
 
+	rtnl_lock();
 	err = ixgbe_init_interrupt_scheme(adapter);
+	rtnl_unlock();
 	if (err) {
 		e_dev_err("Cannot initialize interrupts for device\n");
 		return err;

