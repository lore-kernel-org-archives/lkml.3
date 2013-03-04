Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480Ab3CDDmk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:42:40 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60754 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755350Ab3CDDmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:42:32 -0500
Message-Id: <20130304033709.163804980@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:37:23 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Christian Borntraeger <borntraeger@de.ibm.com>,
        Gleb Natapov <gleb@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [ 016/153] s390/kvm: Fix store status for ACRS/FPRS
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2 as done in 3.0 by Jiri Slaby]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Jiri Slaby <jslaby@suse.cz>
---
 arch/s390/kvm/kvm-s390.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -597,6 +597,14 @@ int kvm_s390_vcpu_store_status(struct kv
 	} else
 		prefix = 0;
 
+	/*
+	 * The guest FPRS and ACRS are in the host FPRS/ACRS due to the lazy
+	 * copying in vcpu load/put. Lets update our copies before we save
+	 * it into the save area
+	 */
+	save_fp_regs(&vcpu->arch.guest_fpregs);
+	save_access_regs(vcpu->arch.guest_acrs);
+
 	if (__guestcopy(vcpu, addr + offsetof(struct save_area, fp_regs),
 			vcpu->arch.guest_fpregs.fprs, 128, prefix))
 		return -EFAULT;


