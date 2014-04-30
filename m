Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759132AbaD3Ny6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 09:54:58 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:17009 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758924AbaD3Ny1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 09:54:27 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        david.vrabel@citrix.com, boris.ostrovsky@oracle.com, jbeulich@suse.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH v1 6/6] xen/pciback: Don't call xen_pcibk_config_init_dev when device de-assigned.
Date: Wed, 30 Apr 2014 09:54:11 -0400
Message-Id: <1398866051-32714-7-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1398866051-32714-1-git-send-email-konrad.wilk@oracle.com>
References: <1398866051-32714-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the device is de-assigned from a guest (but still owned
by xen-pciback) we would needlessly free all of its dynamic
entries.

That we should not do - that is only to be done when the device has
been removed from xen-pciback. That is, when the reference count
has reached zero - and we end up calling pcistub_device_release
which does this.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/xen-pciback/pci_stub.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/xen/xen-pciback/pci_stub.c b/drivers/xen/xen-pciback/pci_stub.c
index d57a173..158d53df 100644
--- a/drivers/xen/xen-pciback/pci_stub.c
+++ b/drivers/xen/xen-pciback/pci_stub.c
@@ -288,8 +288,6 @@ void pcistub_put_pci_dev(struct pci_dev *dev)
 
 	/* And cleanup up our emulated fields. */
 	xen_pcibk_config_reset_dev(dev);
-	xen_pcibk_config_free_dyn_fields(dev);
-
 	xen_unregister_device_domain_owner(dev);
 
 	spin_lock_irqsave(&found_psdev->lock, flags);
-- 
1.8.5.3

