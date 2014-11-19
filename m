Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041AbaKSS2P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 13:28:15 -0500
Received: from s3.sipsolutions.net ([5.9.151.49]:40228 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759AbaKSS2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 13:28:14 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Nishanth Menon <nm@ti.com>, Randy Dunlap <rdunlap@infradead.org>,
        Michal Marek <mmarek@suse.cz>, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] scripts/kernel-doc: don't eat struct members with __aligned
Date: Wed, 19 Nov 2014 19:28:02 +0100
Message-Id: <1416421682-16646-1-git-send-email-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

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

for purposes of kernel-doc, thus dropping a struct member, which
in turns causes warnings and invalid kernel-doc generation.

Fix this by replacing the catch-all (".") with anything that's not a
semicolon ("[^;]").

Cc: Nishanth Menon <nm@ti.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Michal Marek <mmarek@suse.cz>
Fixes: 9dc30918b23f ("scripts/kernel-doc: handle struct member __aligned without numbers")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 scripts/kernel-doc | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index 70bea942b413..9922e66883a5 100755
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
2.1.1

