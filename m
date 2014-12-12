Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965995AbaLLGsQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:48:16 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52598 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759235AbaLLGsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:48:10 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David Matlack" <dmatlack@google.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.824531594@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 028/164] kvm: don't take vcpu mutex for obviously
 invalid vcpu ioctls
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 virt/kvm/kvm_main.c | 4 ++++
 1 file changed, 4 insertions(+)

--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -52,6 +52,7 @@
 
 #include <asm/processor.h>
 #include <asm/io.h>
+#include <asm/ioctl.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 
@@ -1766,6 +1767,9 @@ static long kvm_vcpu_ioctl(struct file *
 	if (vcpu->kvm->mm != current->mm)
 		return -EIO;
 
+	if (unlikely(_IOC_TYPE(ioctl) != KVMIO))
+		return -EINVAL;
+
 #if defined(CONFIG_S390) || defined(CONFIG_PPC)
 	/*
 	 * Special cases: vcpu ioctls that are asynchronous to vcpu execution,

