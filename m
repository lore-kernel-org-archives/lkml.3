Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991Ab3HTD2h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 23:28:37 -0400
Received: from ozlabs.org ([203.10.76.45]:42825 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751757Ab3HTD2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 23:28:35 -0400
From: Michael Neuling <mikey@neuling.org>
To: penberg@kernel.org
cc: kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        michael@ellerman.id.au, Ian Munsie <ianmunsi@au1.ibm.com>
X-GPG-Fingerprint: 9B25 DC2A C58D 2C8D 47C2  457E 0887 E86F 32E6 BE16
X-GPG-Fingerprint: 9365 87D7 A7EF 4721 420B  91D9 CD5B 874B EAC1 B3F5
MIME-Version: 1.0
Subject: [PATCH] kvm tools: powerpc: Fix init order for xics
X-Mailer: MH-E 8.2; nmh 1.5; GNU Emacs 23.4.1
Date: Tue, 20 Aug 2013 13:28:34 +1000
Message-ID: <32637.1376969314@ale.ozlabs.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xics_init() assumes kvm->nrcpus is already setup.  kvm->nrcpus is setup
in kvm_cpu_init()

Unfortunately xics_init() and kvm_cpu_init() both use base_init().  So
depending on the order randomly determined by the compiler, xics_init()
may initialised see kvm->nrcpus as 0 and not setup any of the icp VCPU
pointers.  This manifests itself later in boot when trying to raise an
IRQ resulting in a null pointer deference/segv.

This moves xics_init() to use dev_base_init() to ensure it happens after
kvm_cpu_init().

Signed-off-by: Michael Neuling <mikey@neuling.org>

diff --git a/tools/kvm/powerpc/xics.c b/tools/kvm/powerpc/xics.c
index cf64a08..c1ef35b 100644
--- a/tools/kvm/powerpc/xics.c
+++ b/tools/kvm/powerpc/xics.c
@@ -505,7 +505,7 @@ static int xics_init(struct kvm *kvm)
 
 	return 0;
 }
-base_init(xics_init);
+dev_base_init(xics_init);
 
 
 void kvm__irq_line(struct kvm *kvm, int irq, int level)
