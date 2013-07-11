Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803Ab3GKWE0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 18:04:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43104 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756629Ab3GKWBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 18:01:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stefan Pietsch <stefan.pietsch@lsexperts.de>,
        Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Subject: [ 16/19] KVM: VMX: mark unusable segment as nonpresent
Date: Thu, 11 Jul 2013 15:01:33 -0700
Message-Id: <20130711214832.452194271@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130711214830.611455274@linuxfoundation.org>
References: <20130711214830.611455274@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gleb Natapov <gleb@redhat.com>

commit 03617c188f41eeeb4223c919ee7e66e5a114f2c6 upstream.

Some userspaces do not preserve unusable property. Since usable
segment has to be present according to VMX spec we can use present
property to amend userspace bug by making unusable segment always
nonpresent. vmx_segment_access_rights() already marks nonpresent segment
as unusable.

Reported-by: Stefan Pietsch <stefan.pietsch@lsexperts.de>
Tested-by: Stefan Pietsch <stefan.pietsch@lsexperts.de>
Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/vmx.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -3399,15 +3399,22 @@ static void vmx_get_segment(struct kvm_v
 	var->limit = vmx_read_guest_seg_limit(vmx, seg);
 	var->selector = vmx_read_guest_seg_selector(vmx, seg);
 	ar = vmx_read_guest_seg_ar(vmx, seg);
+	var->unusable = (ar >> 16) & 1;
 	var->type = ar & 15;
 	var->s = (ar >> 4) & 1;
 	var->dpl = (ar >> 5) & 3;
-	var->present = (ar >> 7) & 1;
+	/*
+	 * Some userspaces do not preserve unusable property. Since usable
+	 * segment has to be present according to VMX spec we can use present
+	 * property to amend userspace bug by making unusable segment always
+	 * nonpresent. vmx_segment_access_rights() already marks nonpresent
+	 * segment as unusable.
+	 */
+	var->present = !var->unusable;
 	var->avl = (ar >> 12) & 1;
 	var->l = (ar >> 13) & 1;
 	var->db = (ar >> 14) & 1;
 	var->g = (ar >> 15) & 1;
-	var->unusable = (ar >> 16) & 1;
 }
 
 static u64 vmx_get_segment_base(struct kvm_vcpu *vcpu, int seg)


