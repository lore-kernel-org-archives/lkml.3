Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490Ab3F1S77 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 14:59:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42013 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851Ab3F1S6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:58:49 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Igor Mammedov <imammedo@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 060/105] x86: kvmclock: zero initialize pvclock shared memory area
Date: Fri, 28 Jun 2013 11:51:22 -0700
Message-Id: <1372445527-24414-61-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372445527-24414-1-git-send-email-kamal@canonical.com>
References: <1372445527-24414-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Igor Mammedov <imammedo@redhat.com>

commit 07868fc6aaf57847b0f3a3d53086b7556eb83f4a upstream.

kernel might hung in pvclock_clocksource_read() due to
uninitialized memory might contain odd version value in
following cycle:

        do {
                version = __pvclock_read_cycles(src, &ret, &flags);
        } while ((src->version & 1) || version != src->version);

if secondary kvmclock is accessed before it's registered with kvm.

Clear garbage in pvclock shared memory area right after it's
allocated to avoid this issue.

Ref: https://bugzilla.kernel.org/show_bug.cgi?id=59521
Signed-off-by: Igor Mammedov <imammedo@redhat.com>
[See BZ for analysis.  We may want a different fix for 3.11, but
 this is the safest for now - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/kernel/kvmclock.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index 5bedbdd..a855a2e 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -238,6 +238,7 @@ void __init kvmclock_init(void)
 	if (!mem)
 		return;
 	hv_clock = __va(mem);
+	memset(hv_clock, 0, size);
 
 	if (kvm_register_clock("boot clock")) {
 		hv_clock = NULL;
-- 
1.8.1.2

