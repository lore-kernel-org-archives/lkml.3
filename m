Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121AbaFDXWZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:22:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40111 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421AbaFDXWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:22:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Christoph Paasch <christoph.paasch@uclouvain.be>,
        Jeff Pieper <jeffrey.e.pieper@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [PATCH 3.14 119/228] igb: Fix Null-pointer dereference in igb_reset_q_vector
Date: Wed,  4 Jun 2014 16:22:28 -0700
Message-Id: <20140604232351.868091781@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Paasch <christoph.paasch@uclouvain.be>

commit cb06d102327eadcd1bdc480bfd9f8876251d1007 upstream.

When igb_set_interrupt_capability() calls
igb_reset_interrupt_capability() (e.g., because CONFIG_PCI_MSI is unset),
num_q_vectors has been set but no vector has yet been allocated.

igb_reset_interrupt_capability() will then call igb_reset_q_vector,
which assumes that the vector is allocated. As this is not the case, we
are accessing a NULL-pointer.

This patch fixes it by checking that q_vector is indeed different from
NULL.

Fixes: 02ef6e1d0b0023 (igb: Fix queue allocation method to accommodate changing during runtime)
Cc: Carolyn Wyborny <carolyn.wyborny@intel.com>
Signed-off-by: Christoph Paasch <christoph.paasch@uclouvain.be>
Tested-by: Jeff Pieper <jeffrey.e.pieper@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/intel/igb/igb_main.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -1014,6 +1014,12 @@ static void igb_reset_q_vector(struct ig
 {
 	struct igb_q_vector *q_vector = adapter->q_vector[v_idx];
 
+	/* Coming from igb_set_interrupt_capability, the vectors are not yet
+	 * allocated. So, q_vector is NULL so we should stop here.
+	 */
+	if (!q_vector)
+		return;
+
 	if (q_vector->tx.ring)
 		adapter->tx_ring[q_vector->tx.ring->queue_index] = NULL;
 


