Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399AbaLDJtt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 04:49:49 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:37385 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753066AbaLDJtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 04:49:45 -0500
From: Eric Auger <eric.auger@linaro.org>
To: eric.auger@st.com, eric.auger@linaro.org, christoffer.dall@linaro.org,
        marc.zyngier@arm.com, andre.przywara@arm.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, alex.williamson@redhat.com, agraf@suse.de,
        gleb@kernel.org, pbonzini@redhat.com
Cc: linux-kernel@vger.kernel.org, patches@linaro.org, will.deacon@arm.com,
        a.motakis@virtualopensystems.com
Subject: [PATCH v2 0/4] VGIC early initialization initiated by user-space
Date: Thu,  4 Dec 2014 10:48:00 +0100
Message-Id: <1417686484-20828-1-git-send-email-eric.auger@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the advent of dynamic initialization of VGIC, this latter is
initialized very late, on the first vcpu run. This initialization
could be initiated much earlier by the user-space, as soon as it has
set the requested dimensioning parameters: number of IRQs, number of
vCPUs, base addresses.

One motivation behind being able to initialize the VGIC sooner is
related to the setup of IRQ injection in VFIO use case. The VFIO
signaling, especially when used along with irqfd must be set *after*
vgic initialization to prevent any virtual IRQ injection before
vgic initialization. If virtual IRQ injection occurs before the VGIC
init, the IRQ cannot be injected and subsequent injection is blocked
due to VFIO completion mechanism (unmask/mask or forward/unforward).

The series includes the following patch files:
[1] changes the error returned by vgic_init_maps when no online vcpu
    can be found
[2] adds a new entry to the VGIC KVM device that allows
    the user to manually request the VGIC init:
    - a new KVM_DEV_ARM_VGIC_GRP_CTRL group is introduced.
    - its first attribute is KVM_DEV_ARM_VGIC_CTRL_INIT
[3] prevents the user-space from creating a new vcpu while the vgic
    already is initialized
[4] prevents the user-space from changing VGIC base addresses if the
    vgic is already initialized

- can be found at:
  http://git.linaro.org/people/eric.auger/linux.git,
  branch 3.18-rc7-vgic-early-init-MLv2

v1 -> v2:
- 1, 3, 4 patch files added
- some rewording in vgic device documentation

Eric Auger (4):
  KVM: arm/arm64: vgic: vgic_init_maps returns -ENODEV when no online
    vcpu
  KVM: arm/arm64: vgic: add init entry to VGIC KVM device
  KVM: arm/arm64: check vgic_initialized before VCPU creation
  KVM: arm/arm64: vgic: check vgic_initialized in
    KVM_DEV_ARM_VGIC_GRP_ADDR

 Documentation/virtual/kvm/devices/arm-vgic.txt | 13 +++++++++++++
 arch/arm/include/uapi/asm/kvm.h                |  2 ++
 arch/arm/kvm/arm.c                             |  5 +++++
 arch/arm64/include/uapi/asm/kvm.h              |  2 ++
 virt/kvm/arm/vgic.c                            | 19 +++++++++++++++++--
 5 files changed, 39 insertions(+), 2 deletions(-)

-- 
1.9.1

