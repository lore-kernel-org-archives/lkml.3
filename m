Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312AbbANH1T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:27:19 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57859 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754267AbbANH1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:27:17 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        David Hildenbrand <dahi@linux.vnet.ibm.com>
Subject: [PATCH 3.18 065/150] KVM: s390: flush CPU on load control
Date: Tue, 13 Jan 2015 23:22:16 -0800
Message-Id: <20150114072058.788565805@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072055.842408181@linuxfoundation.org>
References: <20150114072055.842408181@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Borntraeger <borntraeger@de.ibm.com>

commit 2dca485f8740208604543c3960be31a5dd3ea603 upstream.

some control register changes will flush some aspects of the CPU, e.g.
POP explicitely mentions that for CR9-CR11 "TLBs may be cleared".
Instead of trying to be clever and only flush on specific CRs, let
play safe and flush on all lctl(g) as future machines might define
new bits in CRs. Load control intercept should not happen that often.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Reviewed-by: David Hildenbrand <dahi@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/kvm/priv.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/s390/kvm/priv.c
+++ b/arch/s390/kvm/priv.c
@@ -791,7 +791,7 @@ int kvm_s390_handle_lctl(struct kvm_vcpu
 			break;
 		reg = (reg + 1) % 16;
 	} while (1);
-
+	kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
 	return 0;
 }
 
@@ -863,7 +863,7 @@ static int handle_lctlg(struct kvm_vcpu
 			break;
 		reg = (reg + 1) % 16;
 	} while (1);
-
+	kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
 	return 0;
 }
 


