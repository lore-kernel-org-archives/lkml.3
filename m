Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685AbaJ0TEY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 15:04:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52846 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658AbaJ0TEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 15:04:20 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 041/105] kvm: don't take vcpu mutex for obviously invalid vcpu ioctls
Date: Mon, 27 Oct 2014 11:56:16 -0700
Message-Id: <1414436240-13879-42-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414436240-13879-1-git-send-email-kamal@canonical.com>
References: <1414436240-13879-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Matlack <dmatlack@google.com>

commit 2ea75be3219571d0ec009ce20d9971e54af96e09 upstream.

vcpu ioctls can hang the calling thread if issued while a vcpu is running.
However, invalid ioctls can happen when userspace tries to probe the kind
of file descriptors (e.g. isatty() calls ioctl(TCGETS)); in that case,
we know the ioctl is going to be rejected as invalid anyway and we can
fail before trying to take the vcpu mutex.

This patch does not change functionality, it just makes invalid ioctls
fail faster.

Signed-off-by: David Matlack <dmatlack@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 virt/kvm/kvm_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 44652f2..8d2a98a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -52,6 +52,7 @@
 
 #include <asm/processor.h>
 #include <asm/io.h>
+#include <asm/ioctl.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 
@@ -1994,6 +1995,9 @@ static long kvm_vcpu_ioctl(struct file *filp,
 	if (vcpu->kvm->mm != current->mm)
 		return -EIO;
 
+	if (unlikely(_IOC_TYPE(ioctl) != KVMIO))
+		return -EINVAL;
+
 #if defined(CONFIG_S390) || defined(CONFIG_PPC) || defined(CONFIG_MIPS)
 	/*
 	 * Special cases: vcpu ioctls that are asynchronous to vcpu execution,
-- 
1.9.1

