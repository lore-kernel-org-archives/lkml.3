Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759351Ab3BXRKE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 12:10:04 -0500
Received: from mail-oa0-f45.google.com ([209.85.219.45]:51792 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759315Ab3BXRKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 12:10:00 -0500
From: Nishanth Menon <nm@ti.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Nishanth Menon <nm@ti.com>, Fengguang Wu <fengguang.wu@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2] scripts/kernel-doc: handle struct member __aligned without numbers
Date: Sun, 24 Feb 2013 11:09:47 -0600
Message-Id: <1361725787-18470-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit ef5da59f12602815baa8fad98241b77dedea3b31
(scripts/kernel-doc: handle struct member __aligned)
char something [123] __aligned(8);

However, by using \d we constraint ourselves with integers.
This is not always the case. In fact, it might be better to do
char something[123] __aligned(sizeof(u16));

For example, With wireless_dev defining:
u8 address[ETH_ALEN] __aligned(sizeof(u16));
With \d, scripts/kernel-doc erroneously says:
Warning(include/net/cfg80211.h:2618): Excess struct/union/enum/typedef member 'address' description in 'wireless_dev'
This is because the regex __aligned\s*\(\d+\) fails match at \d as
sizeof is used.

So replace \d with . to indicate "something" in kernel-doc
to ignore __aligned(SOMETHING) in structs. With this change,
we can use integers OR sizeof() or macros as we please.

Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Johannes Berg <johannes.berg@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kernel@vger.kernel.org (open list)

Signed-off-by: Nishanth Menon <nm@ti.com>

---
Based on 
master              9e2d59a Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/signal

Rev1: I have seen Johannes' patch here:
http://permalink.gmane.org/gmane.linux.documentation/9271

Rev 2: instead of using prm_clean, we use members which Randy had tried to cleanup

We already have an holder to cleanup aligned, why add another, so just fix it.

 scripts/kernel-doc |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index f565536..4305b2f 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -1750,7 +1750,7 @@ sub dump_struct($$) {
 	# strip kmemcheck_bitfield_{begin,end}.*;
 	$members =~ s/kmemcheck_bitfield_.*?;//gos;
 	# strip attributes
-	$members =~ s/__aligned\s*\(\d+\)//gos;
+	$members =~ s/__aligned\s*\(.+\)//gos;
 
 	create_parameterlist($members, ';', $file);
 	check_sections($file, $declaration_name, "struct", $sectcheck, $struct_actual, $nested);
-- 
1.7.9.5

