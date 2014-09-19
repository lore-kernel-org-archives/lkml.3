Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722AbaISXDd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 19:03:33 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:63315 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755372AbaISXDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 19:03:31 -0400
From: David Matlack <dmatlack@google.com>
To: Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: David Matlack <dmatlack@google.com>
Subject: [PATCH] kvm: don't take vcpu mutex for obviously invalid vcpu ioctls
Date: Fri, 19 Sep 2014 16:03:25 -0700
Message-Id: <1411167805-2458-1-git-send-email-dmatlack@google.com>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vcpu ioctls can hang the calling thread if issued while a vcpu is
running. If we know ioctl is going to be rejected as invalid anyway,
we can fail before trying to take the vcpu mutex.

This patch does not change functionality, it just makes invalid ioctls
fail faster.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 virt/kvm/kvm_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 96ec622..f9234e5 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -52,6 +52,7 @@
 
 #include <asm/processor.h>
 #include <asm/io.h>
+#include <asm/ioctl.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 
@@ -1975,6 +1976,9 @@ static long kvm_vcpu_ioctl(struct file *filp,
 	if (vcpu->kvm->mm != current->mm)
 		return -EIO;
 
+	if (unlikely(_IOC_TYPE(ioctl) != KVMIO))
+		return -EINVAL;
+
 #if defined(CONFIG_S390) || defined(CONFIG_PPC) || defined(CONFIG_MIPS)
 	/*
 	 * Special cases: vcpu ioctls that are asynchronous to vcpu execution,
-- 
2.1.0.rc2.206.gedb03e5

