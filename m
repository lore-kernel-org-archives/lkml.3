Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933352AbaLBUTi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 15:19:38 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:24546 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933114AbaLBUTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 15:19:08 -0500
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
To: david.vrabel@citrix.com, konrad.wilk@oracle.com,
        stefano.stabellini@eu.citrix.com
Cc: jun.nakajima@intel.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xen.org, boris.ostrovsky@oracle.com
Subject: [PATCH v4 0/2]  xen/pci: Use APIC for MSIs when APIC virtualization is supported
Date: Tue,  2 Dec 2014 15:19:11 -0500
Message-Id: <1417551553-22234-1-git-send-email-boris.ostrovsky@oracle.com>
X-Mailer: git-send-email 1.9.3
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes in v4:
* Added comment describing what we check for in pci_xen_init()

Changes in v3:
* Explicitly include asm/apic.h in arch/x86/pci/xen.c for !CONFIG_SMP.

Changes in v2:
* New version of cpuid.h file from Xen tree (with a couple of style adjustments)
* Whitespace cleanup

Currently HVM guests handle MSI interrupts using pirqs/event channels, allowing
us to not issue APIC accesses that result in somewhat expensive VMEXITs. When
hardware supports APIC virtualization we don't need to use pirqs anymore
since now guest's APIC accesses can be handled by the processor itself.

There are two patches in this series:

1. Move setting of x86_msi ops to a later point. The reason for doing so is that
we currently decide whether or not to use pirqs before kernel had a chance to
see whether it should be using x2APIC instead of plain APIC. Since hardware may
virtualize either or both of those two we can only make pirqs vs. APIC selection
after kernel has settled down on which APIC version it will use. (Note that
currently x2APIC is not used by HVM guests so technically this patch is not
necessary. However, it probably makes sense to apply it now to avoid
forgetting to do it when we enable x2APIC).

2. Set x86_msi ops to use pirqs only when APIC virtualization is not available.
The commit message describes performance improvements that this change brings.


Boris Ostrovsky (2):
  xen/pci: Defer initialization of MSI ops on HVM guests until after
    x2APIC has been set up
  xen/pci: Use APIC directly when APIC virtualization is supported by
    hardware

 arch/x86/include/asm/xen/cpuid.h | 91 ++++++++++++++++++++++++++++++++++++++++
 arch/x86/pci/xen.c               | 31 +++++++++++++-
 2 files changed, 120 insertions(+), 2 deletions(-)
 create mode 100644 arch/x86/include/asm/xen/cpuid.h

-- 
1.8.1.4

