Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758532AbbA0MSN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:18:13 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35065 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758498AbbA0MSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:18:07 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johannes Berg <johannes.berg@intel.com>, Nishanth Menon <nm@ti.com>,
        Randy Dunlap <rdunlap@infradead.org>, Michal Marek <mmarek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 046/126] scripts/kernel-doc: don't eat struct members with __aligned
Date: Tue, 27 Jan 2015 12:15:51 +0000
Message-Id: <1422361031-19364-47-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 7b990789a4c3420fa57596b368733158e432d444 upstream.

The change from \d+ to .+ inside __aligned() means that the following
structure:

  struct test {
        u8 a __aligned(2);
        u8 b __aligned(2);
  };

essentially gets modified to

  struct test {
        u8 a;
  };

for purposes of kernel-doc, thus dropping a struct member, which in
turns causes warnings and invalid kernel-doc generation.

Fix this by replacing the catch-all (".") with anything that's not a
semicolon ("[^;]").

Fixes: 9dc30918b23f ("scripts/kernel-doc: handle struct member __aligned without numbers")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Cc: Nishanth Menon <nm@ti.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 scripts/kernel-doc | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index 16a07cfa4d34..f2b1bf2f0608 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -1753,7 +1753,7 @@ sub dump_struct($$) {
 	# strip kmemcheck_bitfield_{begin,end}.*;
 	$members =~ s/kmemcheck_bitfield_.*?;//gos;
 	# strip attributes
-	$members =~ s/__aligned\s*\(.+\)//gos;
+	$members =~ s/__aligned\s*\([^;]*\)//gos;
 
 	create_parameterlist($members, ';', $file);
 	check_sections($file, $declaration_name, "struct", $sectcheck, $struct_actual, $nested);
-- 
2.1.4

