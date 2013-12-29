Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042Ab3L2CJx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:09:53 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55002 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751814Ab3L2CJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:09:49 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Avi Kivity" <avi@redhat.com>,
        "Marcelo Tosatti" <mtosatti@redhat.com>
Date: Sun, 29 Dec 2013 03:08:44 +0100
Message-ID: <lsq.1388282924.742226929@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 174/185] KVM: perform an invalid memslot step for gpa
 base change
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Marcelo Tosatti <mtosatti@redhat.com>

commit 12d6e7538e2d418c08f082b1b44ffa5fb7270ed8 upstream.

PPC must flush all translations before the new memory slot
is visible.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 virt/kvm/kvm_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -774,7 +774,7 @@ skip_lpage:
 		new.userspace_addr = mem->userspace_addr;
 #endif /* not defined CONFIG_S390 */
 
-	if (!npages) {
+	if (!npages || base_gfn != old.base_gfn) {
 		r = -ENOMEM;
 		slots = kzalloc(sizeof(struct kvm_memslots), GFP_KERNEL);
 		if (!slots)
@@ -788,8 +788,8 @@ skip_lpage:
 		old_memslots = kvm->memslots;
 		rcu_assign_pointer(kvm->memslots, slots);
 		synchronize_srcu_expedited(&kvm->srcu);
-		/* From this point no new shadow pages pointing to a deleted
-		 * memslot will be created.
+		/* From this point no new shadow pages pointing to a deleted,
+		 * or moved, memslot will be created.
 		 *
 		 * validation of sp->gfn happens in:
 		 * 	- gfn_to_hva (kvm_read_guest, gfn_to_pfn)

