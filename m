Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259AbaGVWSB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:18:01 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44244 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755978AbaGVWR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:17:57 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: Alex Smith <alex.smith@imgtec.com>
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        Ralf Baechle <ralf@linux-mips.org>,
        Kamal Mostafa <kamal@canonical.com>, kernel-team@lists.ubuntu.com
Subject: [3.8.y.z extended stable] Patch "recordmcount/MIPS: Fix possible incorrect mcount_loc table entries in modules" has been added to staging queue
Date: Tue, 22 Jul 2014 15:17:53 -0700
Message-Id: <1406067473-19124-1-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a note to let you know that I have just added a patch titled

    recordmcount/MIPS: Fix possible incorrect mcount_loc table entries in modules

to the linux-3.8.y-queue branch of the 3.8.y.z extended stable tree 
which can be found at:

 http://kernel.ubuntu.com/git?p=ubuntu/linux.git;a=shortlog;h=refs/heads/linux-3.8.y-queue

This patch is scheduled to be released in version 3.8.13.27.

If you, or anyone else, feels it should not be added to this tree, please 
reply to this email.

For more information about the 3.8.y.z tree, see
https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

Thanks.
-Kamal

------

>From 18180c861e7313693350caaabb944bb91432bde3 Mon Sep 17 00:00:00 2001
From: Alex Smith <alex.smith@imgtec.com>
Date: Tue, 17 Jun 2014 10:39:53 +0100
Subject: recordmcount/MIPS: Fix possible incorrect mcount_loc table entries in
 modules

commit 91ad11d7cc6f4472ebf177a6252fbf0fd100d798 upstream.

On MIPS calls to _mcount in modules generate 2 instructions to load
the _mcount address (and therefore 2 relocations). The mcount_loc
table should only reference the first of these, so the second is
filtered out by checking the relocation offset and ignoring ones that
immediately follow the previous one seen.

However if a module has an _mcount call at offset 0, the second
relocation would not be filtered out due to old_r_offset == 0
being taken to mean that the current relocation is the first one
seen, and both would end up in the mcount_loc table.

This results in ftrace_make_nop() patching both (adjacent)
instructions to branches over the _mcount call sequence like so:

  0xffffffffc08a8000:  04 00 00 10     b       0xffffffffc08a8014
  0xffffffffc08a8004:  04 00 00 10     b       0xffffffffc08a8018
  0xffffffffc08a8008:  2d 08 e0 03     move    at,ra
  ...

The second branch is in the delay slot of the first, which is
defined to be unpredictable - on the platform on which this bug was
encountered, it triggers a reserved instruction exception.

Fix by initializing old_r_offset to ~0 and using that instead of 0
to determine whether the current relocation is the first seen.

Signed-off-by: Alex Smith <alex.smith@imgtec.com>
Cc: linux-kernel@vger.kernel.org
Cc: linux-mips@linux-mips.org
Patchwork: https://patchwork.linux-mips.org/patch/7098/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 scripts/recordmcount.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/recordmcount.h b/scripts/recordmcount.h
index 9d1421e..49b582a 100644
--- a/scripts/recordmcount.h
+++ b/scripts/recordmcount.h
@@ -163,11 +163,11 @@ static int mcount_adjust = 0;

 static int MIPS_is_fake_mcount(Elf_Rel const *rp)
 {
-	static Elf_Addr old_r_offset;
+	static Elf_Addr old_r_offset = ~(Elf_Addr)0;
 	Elf_Addr current_r_offset = _w(rp->r_offset);
 	int is_fake;

-	is_fake = old_r_offset &&
+	is_fake = (old_r_offset != ~(Elf_Addr)0) &&
 		(current_r_offset - old_r_offset == MIPS_FAKEMCOUNT_OFFSET);
 	old_r_offset = current_r_offset;

--
1.9.1

