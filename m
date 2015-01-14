Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098AbbANH0X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:26:23 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57778 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051AbbANH0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:26:17 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jerry Hoemann <jerry.hoemann@hp.com>, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 3.18 045/150] iommu/vt-d: Fix dmar_domain leak in iommu_attach_device
Date: Tue, 13 Jan 2015 23:21:56 -0800
Message-Id: <20150114072057.913394718@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072055.842408181@linuxfoundation.org>
References: <20150114072055.842408181@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joerg Roedel <jroedel@suse.de>

commit 62c22167dd70b730f61c2b88f950e98154a87980 upstream.

Since commit 1196c2f a domain is only destroyed in the
notifier path if it is hot-unplugged. This caused a
domain leakage in iommu_attach_device when a driver was
unbound from the device and bound to VFIO. In this case the
device is attached to a new domain and unlinked from the old
domain. At this point nothing points to the old domain
anymore and its memory is leaked.
Fix this by explicitly freeing the old domain in
iommu_attach_domain.

Fixes: 1196c2f (iommu/vt-d: Fix dmar_domain leak in iommu_attach_device)
Tested-by: Jerry Hoemann <jerry.hoemann@hp.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/intel-iommu.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -4265,6 +4265,10 @@ static int intel_iommu_attach_device(str
 				domain_remove_one_dev_info(old_domain, dev);
 			else
 				domain_remove_dev_info(old_domain);
+
+			if (!domain_type_is_vm_or_si(old_domain) &&
+			     list_empty(&old_domain->devices))
+				domain_exit(old_domain);
 		}
 	}
 


