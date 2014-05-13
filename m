Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761411AbaEMKpz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:45:55 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60735 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759800AbaEMJ2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:55 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 030/182] KVM: s390: Optimize ucontrol path
Date: Tue, 13 May 2014 11:26:22 +0200
Message-Id: <5c1a16ff60910f4ab85e824492c226660ecdb722.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Borntraeger <borntraeger@de.ibm.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 2955c83f72801245afd0fe5c560cc75b82bea9aa upstream.

Since commit 7c470539c95630c1f2a10f109e96f249730b75eb
(s390/kvm: avoid automatic sie reentry) we will run through the C code
of KVM on host interrupts instead of just reentering the guest. This
will result in additional ucontrol exits (at least HZ per second). Let
handle a 0 intercept in the kernel and dont return to userspace,
even if in ucontrol mode.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/s390/kvm/kvm-s390.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 776dafe918db..48bb1c129963 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -788,7 +788,8 @@ rerun_vcpu:
 		if (rc)
 			break;
 		if (kvm_is_ucontrol(vcpu->kvm))
-			rc = -EOPNOTSUPP;
+			/* Don't exit for host interrupts. */
+			rc = vcpu->arch.sie_block->icptcode ? -EOPNOTSUPP : 0;
 		else
 			rc = kvm_handle_sie_intercept(vcpu);
 	} while (!signal_pending(current) && !rc);
-- 
1.9.3

