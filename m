Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608Ab3B0U2z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 15:28:55 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:35240 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab3B0U2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 15:28:54 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: kvm@vger.kernel.org
Cc: Marcelo Tosatti <mtosatti@redhat.com>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@linux.intel.com>, Gleb Natapov <gleb@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH] x86/kvm: Fix pvclock vsyscall fixmap
Date: Wed, 27 Feb 2013 15:28:28 -0500
Message-Id: <1361996908-11064-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <20130227194336.GA17324@amt.cnet>
References: <20130227194336.GA17324@amt.cnet>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The physical memory fixmapped for the pvclock clock_gettime vsyscall
was allocated, and thus is not a kernel symbol. __pa() is the proper
method to use in this case.

Fixes the crash below when booting a next-20130204+ smp guest on a
3.8-rc5+ KVM host.

[    0.666410] udevd[97]: starting version 175
[    0.674043] udevd[97]: udevd:[97]: segfault at ffffffffff5fd020
     ip 00007fff069e277f sp 00007fff068c9ef8 error d

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 arch/x86/kernel/pvclock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/pvclock.c b/arch/x86/kernel/pvclock.c
index 85c3959..2cb9470 100644
--- a/arch/x86/kernel/pvclock.c
+++ b/arch/x86/kernel/pvclock.c
@@ -185,7 +185,7 @@ int __init pvclock_init_vsyscall(struct pvclock_vsyscall_time_info *i,
 
 	for (idx = 0; idx <= (PVCLOCK_FIXMAP_END-PVCLOCK_FIXMAP_BEGIN); idx++) {
 		__set_fixmap(PVCLOCK_FIXMAP_BEGIN + idx,
-			     __pa_symbol(i) + (idx*PAGE_SIZE),
+			     __pa(i) + (idx*PAGE_SIZE),
 			     PAGE_KERNEL_VVAR);
 	}
 
-- 
1.8.1.2

