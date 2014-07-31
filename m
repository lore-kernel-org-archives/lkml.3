Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751262AbaGaMPo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 08:15:44 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:27619 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750782AbaGaMPn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 08:15:43 -0400
From: Marc Zyngier <marc.zyngier@arm.com>
To: Christoffer Dall <christofferdall@christofferdall.dk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next\@vger.kernel.org" <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>
Subject: Re: linux-next: manual merge of the kvm-arm tree with Linus' tree
In-Reply-To: <CAEDV+gJ1oSPzgZMO=kdFDNPnzy-EOHGuLxHqTB8KO6d_8yPrxQ@mail.gmail.com>
	(Christoffer Dall's message of "Thu, 31 Jul 2014 12:53:03 +0100")
Organization: ARM Ltd
References: <20140731163004.474501fb@canb.auug.org.au>
	<CAEDV+gJ1oSPzgZMO=kdFDNPnzy-EOHGuLxHqTB8KO6d_8yPrxQ@mail.gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
Date: Thu, 31 Jul 2014 13:15:40 +0100
Message-ID: <87mwbpiv0z.fsf@approximate.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31 2014 at 12:53:03 pm BST, Christoffer Dall <christofferdall@christofferdall.dk> wrote:

Hi Christoffer,

> On Thu, Jul 31, 2014 at 8:30 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
>     Hi all,
>    
>     Today's linux-next merge of the kvm-arm tree got a conflict in
>     virt/kvm/arm/vgic.c between commit 63afbe7a0ac1 ("kvm: arm64: vgic: fix
>     hyp panic with 64k pages on juno platform") from Linus' tree and commit
>     8f186d522c69 ("KVM: ARM: vgic: split GICv2 backend from the main vgic
>     code") and others from the kvm-arm tree.
>    
>     I fixed it up (the latter extensively rewrites the function, so I just
>     used that) and can carry the fix as necessary (no action is required).
>
> Hmm that doesn't look correct, the checks  for
> PAGE_ALIGNED(vcpu_res.start) and PAGE_ALIGNED(resource_size(vcpu_res))
> still need to be enforced for both vgic-v2 and vgic-v3.  How do we
> provide a correct fix for Linux-next?

I've provided a resolution for GICv2 in a separate email. For GICv3, I
have the following patch in my tree, which can be added at a later time.

Thanks,

	M.

>From 3eedf1d172230a117ec90832748879e88d9c3471 Mon Sep 17 00:00:00 2001
From: Marc Zyngier <marc.zyngier@arm.com>
Date: Thu, 31 Jul 2014 11:42:18 +0100
Subject: [PATCH] KVM: arm64: GICv3: mandate page-aligned GICV region

Just like GICv2 was fixed in 63afbe7a0ac1
(kvm: arm64: vgic: fix hyp panic with 64k pages on juno platform),
mandate the GICV region to be both aligned on a page boundary and
its size to be a multiple of page size.

This prevents a guest from being able to poke at regions where we
have no idea what is sitting there.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic-v3.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/virt/kvm/arm/vgic-v3.c b/virt/kvm/arm/vgic-v3.c
index f01d446..1c2c8ee 100644
--- a/virt/kvm/arm/vgic-v3.c
+++ b/virt/kvm/arm/vgic-v3.c
@@ -215,6 +215,22 @@ int vgic_v3_probe(struct device_node *vgic_node,
 		ret = -ENXIO;
 		goto out;
 	}
+
+	if (!PAGE_ALIGNED(vcpu_res.start)) {
+		kvm_err("GICV physical address 0x%llx not page aligned\n",
+			(unsigned long long)vcpu_res.start);
+		ret = -ENXIO;
+		goto out;
+	}
+
+	if (!PAGE_ALIGNED(resource_size(&vcpu_res))) {
+		kvm_err("GICV size 0x%llx not a multiple of page size 0x%lx\n",
+			(unsigned long long)resource_size(&vcpu_res),
+			PAGE_SIZE);
+		ret = -ENXIO;
+		goto out;
+	}
+
 	vgic->vcpu_base = vcpu_res.start;
 	vgic->vctrl_base = NULL;
 	vgic->type = VGIC_V3;
-- 
2.0.0


-- 
Jazz is not dead. It just smells funny.
