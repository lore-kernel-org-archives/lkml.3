Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932716AbaJUTAZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 15:00:25 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:19121 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932526AbaJUS7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 14:59:44 -0400
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
To: david.vrabel@citrix.com, konrad.wilk@oracle.com
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xen.org,
        boris.ostrovsky@oracle.com
Subject: [PATCH 0/2] xen/pci: Use APIC for MSIs when APIC virtualization is supported
Date: Tue, 21 Oct 2014 15:01:13 -0400
Message-Id: <1413918075-26146-1-git-send-email-boris.ostrovsky@oracle.com>
X-Mailer: git-send-email 1.8.1.4
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

 arch/x86/include/asm/xen/cpuid.h | 81 ++++++++++++++++++++++++++++++++++++++++
 arch/x86/pci/xen.c               | 24 +++++++++++-
 2 files changed, 103 insertions(+), 2 deletions(-)
 create mode 100644 arch/x86/include/asm/xen/cpuid.h

-- 
1.8.1.4

