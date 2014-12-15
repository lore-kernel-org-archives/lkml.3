Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751099AbaLORpY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 12:45:24 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:46969 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbaLORpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 12:45:20 -0500
From: Eric Auger <eric.auger@linaro.org>
To: eric.auger@st.com, eric.auger@linaro.org, christoffer.dall@linaro.org,
        marc.zyngier@arm.com, andre.przywara@arm.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, gleb@kernel.org, pbonzini@redhat.com
Cc: linux-kernel@vger.kernel.org, patches@linaro.org
Subject: [PATCH v3 0/2] VGIC early initialization initiated by user-space
Date: Mon, 15 Dec 2014 18:43:31 +0100
Message-Id: <1418665413-31521-1-git-send-email-eric.auger@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the advent of VGIC dynamic initialization, this latter is
initialized quite late on the first vcpu run or "on-demand", when
injecting an IRQ or when the guest sets its registers.

This series now allows the user space to explicitly request the VGIC init,
when the dimensioning parameters have been set: number of IRQs, number of
vCPUs. The target state is "initialized".

- the first patch file changes the error returned by vgic_init when no
  online vcpu can be found.
- the second adds a new entry to the VGIC KVM device that allows
  the user-space to manually request the VGIC init:
  - a new KVM_DEV_ARM_VGIC_GRP_CTRL group is introduced.
  - its first attribute is KVM_DEV_ARM_VGIC_CTRL_INIT

Applies on top of Christoffer's series:
"[PATCH v2 0/6] Fix vgic initialization problems"

- can be found at:
  http://git.linaro.org/people/eric.auger/linux.git,
  branch kvmarm-next-vgic-early-init-v3-official)

v2 -> v3:
- in KVM_DEV_ARM_VGIC_GRP_CTRL: vgic_init is called in place of former
  kvm_vgic_init. Means this control moves the VGIC in initialized state
  and not in ready state as before.
- "[PATCH v2 3/4] KVM: arm/arm64: check vgic_initialized before VCPU creation"
  removed since included in Christoffer's
  "arm/arm64: KVM: Don't allow creating VCPUs after vgic_initialized"
- [PATCH v2 4/4] KVM: arm/arm64: vgic: check vgic_initialized in
  KVM_DEV_ARM_VGIC_GRP_ADDR removed since I noticed vgic_ioaddr_assign
  would return -EEXIST in case vgic_map_resources were already been called.
- rewording in cover letter

v1 -> v2:
- 1, 3, 4 patch files added
- some rewording in vgic device documentation


Eric Auger (2):
  KVM: arm/arm64: vgic: vgic_init returns -ENODEV when no online vcpu
  KVM: arm/arm64: vgic: add init entry to VGIC KVM device

 Documentation/virtual/kvm/devices/arm-vgic.txt | 11 +++++++++++
 arch/arm/include/uapi/asm/kvm.h                |  2 ++
 arch/arm64/include/uapi/asm/kvm.h              |  2 ++
 virt/kvm/arm/vgic.c                            | 16 ++++++++++++++--
 4 files changed, 29 insertions(+), 2 deletions(-)

-- 
1.9.1

