Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306AbaJ0QEN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 12:04:13 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:25964 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846AbaJ0QEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 12:04:09 -0400
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
To: david.vrabel@citrix.com, konrad.wilk@oracle.com,
        stefano.stabellini@eu.citrix.com
Cc: jun.nakajima@intel.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xen.org, boris.ostrovsky@oracle.com
Subject: [PATCH v2 0/2] xen/pci: Use APIC for MSIs when APIC virtualization is supported
Date: Mon, 27 Oct 2014 12:05:51 -0400
Message-Id: <1414425953-13987-1-git-send-email-boris.ostrovsky@oracle.com>
X-Mailer: git-send-email 1.8.1.4
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

 arch/x86/include/asm/xen/cpuid.h |   91 ++++++++++++++++++++++++++++++++++++++
 arch/x86/pci/xen.c               |   24 +++++++++-
 2 files changed, 113 insertions(+), 2 deletions(-)
 create mode 100644 arch/x86/include/asm/xen/cpuid.h

