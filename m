Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab3EFNFI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 09:05:08 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:23864 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000Ab3EFNFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 09:05:07 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        stefano.stabellini@eu.citrix.com
Subject: [PATCH] Patches to make PVHVM VCPU hotplug work with VCPUOP_register_info (v1).
Date: Mon,  6 May 2013 09:04:54 -0400
Message-Id: <1367845498-14290-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.1.4
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

The first patch is a good candidate for stable, the other are more for
cleanups that I spotted.

The patch:
 [PATCH 1/3] xen/vcpu/pvhvm: Fix vcpu hotplugging hanging.

along with the two earlier patches:
  66ff0fe xen/smp/spinlock: Fix leakage of the spinlock interrupt line for every CPU online/offline
  888b65b xen/smp: Fix leakage of timer interrupt line for every CPU online/offline.

make it possible to do VCPU hotplug in an PVHVM guest. This means that
with Xen 4.1 it works. Xen 4.2 and Xen 4.3 had a regression wherein the
VCPUOP_register_info hypercall did not work in HVM mode which meant:
 - No events delievered to more than 32 VCPUs. I am not exactly
   sure what that means except I think that IPIs would stop working with
   guests with more than 32 VCPUs.

 - Could not take advantage of the per-CPU page allocation for events
   offered by the hypercall.

Anyhow, the regression is fixed in Xen 4.3 (and should appear in Xen 4.2.?)
and with these attached patches the VCPU hotplug mechanism will work.

There are also miscellaneous patches here that.

Note that during testing I found that this combination:

maxvcpus >= vcpus for PVHVM with v3.9 hits a generic bug. This generic
bug is dead-lock in the microcode. Asked x86 folks for assistance on that
as it would seem to appear on generic platforms too.


 arch/x86/xen/enlighten.c | 39 ++++++++++++++++++++++++++++++++++++++-
 arch/x86/xen/spinlock.c  |  2 +-
 2 files changed, 39 insertions(+), 2 deletions(-)

Konrad Rzeszutek Wilk (4):
      xen/vcpu/pvhvm: Fix vcpu hotplugging hanging.
      xen/vcpu: Document the xen_vcpu_info and xen_vcpu
      xen/smp/pvhvm: Don't point per_cpu(xen_vpcu, 33 and larger) to shared_info
      xen/spinlock: Fix check from greater than to be also be greater or equal to.

