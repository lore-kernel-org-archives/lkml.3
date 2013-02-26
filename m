Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760105Ab3BZX5Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 18:57:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41829 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760067Ab3BZX5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:57:21 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Gleb Natapov <gleb@redhat.com>
Subject: [ 034/150] s390/kvm: Fix store status for ACRS/FPRS
Date: Tue, 26 Feb 2013 15:54:51 -0800
Message-Id: <20130226235527.728894036@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235523.930663721@linuxfoundation.org>
References: <20130226235523.930663721@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/kvm/kvm-s390.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -766,6 +766,14 @@ int kvm_s390_vcpu_store_status(struct kv
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


