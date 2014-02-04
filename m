Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964778AbaBDWGx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 17:06:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56825 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933672AbaBDVJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:09:07 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dominik Dingel <dingel@linux.vnet.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: [PATCH 3.12 068/133] KVM: s390: ioeventfd: ignore leftmost bits
Date: Tue,  4 Feb 2014 13:07:49 -0800
Message-Id: <20140204210738.950099300@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204210737.008598235@linuxfoundation.org>
References: <20140204210737.008598235@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dominik Dingel <dingel@linux.vnet.ibm.com>

commit ff1f3cb4b3ac5d039f02679f34cb1498d110d241 upstream.

The diagnose 500 subcode 3 contains the 32 bit subchannel id in bits 32-63
(counting from the left). As for other I/O instructions, bits 0-31 should be
ignored and thus not be passed to kvm_io_bus_write_cookie().

This fixes a bug where the guest passed non-zero bits 0-31 which the
host tried to interpret, leading to ioeventfd notification failures.

Signed-off-by: Dominik Dingel <dingel@linux.vnet.ibm.com>
Reviewed-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/kvm/diag.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/kvm/diag.c
+++ b/arch/s390/kvm/diag.c
@@ -122,7 +122,7 @@ static int __diag_virtio_hypercall(struc
 	 * - gpr 4 contains the index on the bus (optionally)
 	 */
 	ret = kvm_io_bus_write_cookie(vcpu->kvm, KVM_VIRTIO_CCW_NOTIFY_BUS,
-				      vcpu->run->s.regs.gprs[2],
+				      vcpu->run->s.regs.gprs[2] & 0xffffffff,
 				      8, &vcpu->run->s.regs.gprs[3],
 				      vcpu->run->s.regs.gprs[4]);
 	srcu_read_unlock(&vcpu->kvm->srcu, idx);


