Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450Ab3B1Oq1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:46:27 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41919 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754872Ab3B1OqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:46:23 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        Gleb Natapov <gleb@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 016/139] s390/kvm: Fix store status for ACRS/FPRS
Date: Thu, 28 Feb 2013 14:42:46 +0000
Message-Id: <1362062689-2567-17-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Borntraeger <borntraeger@de.ibm.com>

commit 15bc8d8457875f495c59d933b05770ba88d1eacb upstream.

On store status we need to copy the current state of registers
into a save area. Currently we might save stale versions:
The sie state descriptor doesnt have fields for guest ACRS,FPRS,
those registers are simply stored in the host registers. The host
program must copy these away if needed. We do that in vcpu_put/load.

If we now do a store status in KVM code between vcpu_put/load, the
saved values are not up-to-date. Lets collect the ACRS/FPRS before
saving them.

This also fixes some strange problems with hotplug and virtio-ccw,
since the low level machine check handler (on hotplug a machine check
will happen) will revalidate all registers with the content of the
save area.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/s390/kvm/kvm-s390.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index cea9701..62b5053 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -752,6 +752,14 @@ int kvm_s390_vcpu_store_status(struct kvm_vcpu *vcpu, unsigned long addr)
 	} else
 		prefix = 0;
 
+	/*
+	 * The guest FPRS and ACRS are in the host FPRS/ACRS due to the lazy
+	 * copying in vcpu load/put. Lets update our copies before we save
+	 * it into the save area
+	 */
+	save_fp_regs(&vcpu->arch.guest_fpregs);
+	save_access_regs(vcpu->run->s.regs.acrs);
+
 	if (__guestcopy(vcpu, addr + offsetof(struct save_area, fp_regs),
 			vcpu->arch.guest_fpregs.fprs, 128, prefix))
 		return -EFAULT;
-- 
1.8.1.2

