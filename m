Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760374AbaGRH1k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 03:27:40 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:45600 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754037AbaGRH1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 03:27:32 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: Alex Smith <alex.smith@imgtec.com>, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [patch added to the 3.12 stable tree] recordmcount/MIPS: Fix possible incorrect mcount_loc table entries in modules
Date: Fri, 18 Jul 2014 09:25:00 +0200
Message-Id: <1405668451-13298-19-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1405668451-13298-1-git-send-email-jslaby@suse.cz>
References: <1405668451-13298-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Smith <alex.smith@imgtec.com>

This patch has been added to the 3.12 stable tree. If you have any
objections, please let us know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 scripts/recordmcount.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/recordmcount.h b/scripts/recordmcount.h
index 9d1421e63ff8..49b582a225b0 100644
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
2.0.0

