Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809AbaHLOrk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 10:47:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31189 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752546AbaHLOrj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 10:47:39 -0400
Date: Tue, 12 Aug 2014 10:46:55 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Daniel Walter <sahne@0x90.at>, Richard Weinberger <richard@nod.at>,
        Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
        user-mode-linux-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH] resource: Fix the case of null pointer access
Message-ID: <20140812144655.GB16961@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard and Daniel reported that UML is broken due to changes to resource
traversal functions. Problem is that iomem_resource.child can be null
and new code does not consider that possibility. Old code used a for loop
and that loop will not even execute if p was null.

Revert back to for() loop logic and bail out if p is null.

I also moved sibling_only check out of resource_lock. There is no
reason to keep it inside the lock.

Following is backtrace of the UML crash.

RIP: 0033:[<0000000060039b9f>]
RSP: 0000000081459da0  EFLAGS: 00010202
RAX: 0000000000000000 RBX: 00000000219b3fff RCX: 000000006010d1d9
RDX: 0000000000000001 RSI: 00000000602dfb94 RDI: 0000000081459df8
RBP: 0000000081459de0 R08: 00000000601b59f4 R09: ffffffff0000ff00
R10: ffffffff0000ff00 R11: 0000000081459e88 R12: 0000000081459df8
R13: 00000000219b3fff R14: 00000000602dfb94 R15: 0000000000000000
Kernel panic - not syncing: Segfault with no mm
CPU: 0 PID: 1 Comm: swapper Not tainted 3.16.0-10454-g58d08e3 #13
Stack:
 00000000 000080d0 81459df0 219b3fff
 81459e70 6010d1d9 ffffffff 6033e010
 81459e50 6003a269 81459e30 00000000
Call Trace:
 [<6010d1d9>] ? kclist_add_private+0x0/0xe7
 [<6003a269>] walk_system_ram_range+0x61/0xb7
 [<6000e859>] ? proc_kcore_init+0x0/0xf1
 [<6010d574>] kcore_update_ram+0x4c/0x168
 [<6010d72e>] ? kclist_add+0x0/0x2e
 [<6000e943>] proc_kcore_init+0xea/0xf1
 [<6000e859>] ? proc_kcore_init+0x0/0xf1
 [<6000e859>] ? proc_kcore_init+0x0/0xf1
 [<600189f0>] do_one_initcall+0x13c/0x204
 [<6004ca46>] ? parse_args+0x1df/0x2e0
 [<6004c82d>] ? parameq+0x0/0x3a
 [<601b5990>] ? strcpy+0x0/0x18
 [<60001e1a>] kernel_init_freeable+0x240/0x31e
 [<6026f1c0>] kernel_init+0x12/0x148
 [<60019fad>] new_thread_handler+0x81/0xa3

Reported-by: Daniel Walter <sahne@0x90.at>
Tested-by: Richard Weinberger <richard@nod.at>
Tested-by: Toralf Förster <toralf.foerster@gmx.de>
Tested-by: Daniel Walter <sahne@0x90.at> 
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 kernel/resource.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

Index: linux-2.6/kernel/resource.c
===================================================================
--- linux-2.6.orig/kernel/resource.c	2014-08-12 08:45:15.389969995 -0400
+++ linux-2.6/kernel/resource.c	2014-08-12 08:45:23.572009211 -0400
@@ -351,15 +351,12 @@ static int find_next_iomem_res(struct re
 	end = res->end;
 	BUG_ON(start >= end);
 
-	read_lock(&resource_lock);
-
-	if (first_level_children_only) {
-		p = iomem_resource.child;
+	if (first_level_children_only)
 		sibling_only = true;
-	} else
-		p = &iomem_resource;
 
-	while ((p = next_resource(p, sibling_only))) {
+	read_lock(&resource_lock);
+
+	for (p = iomem_resource.child; p; p = next_resource(p, sibling_only)) {
 		if (p->flags != res->flags)
 			continue;
 		if (name && strcmp(p->name, name))
