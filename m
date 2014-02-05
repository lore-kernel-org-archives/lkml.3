Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465AbaBEReh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 12:34:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9892 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753018AbaBERef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 12:34:35 -0500
From: Denys Vlasenko <dvlasenk@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Denys Vlasenko <dvlasenk@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Amerigo Wang <amwang@redhat.com>,
        "Jonathan M. Foote" <jmfoote@cert.org>,
        Roland McGrath <roland@hack.frob.com>, Pedro Alves <palves@redhat.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH] fs: fix d_path() with zero-length input buffer
Date: Wed,  5 Feb 2014 18:34:07 +0100
Message-Id: <1391621647-7905-1-git-send-email-dvlasenk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In prepend_name(), *buflen < dlen + 1 comparison is buggy
because dlen has unsigned data type, and we can reach this location
with *buflen == -1.

The fix casts dlen to int.

Bug reports:
https://bugzilla.redhat.com/show_bug.cgi?id=1050964
https://bugzilla.redhat.com/show_bug.cgi?id=1060384

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: Amerigo Wang <amwang@redhat.com>
Cc: "Jonathan M. Foote" <jmfoote@cert.org>
Cc: Roland McGrath <roland@hack.frob.com>
Cc: Pedro Alves <palves@redhat.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
---
 fs/dcache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 265e0ce..40ded0c 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2833,7 +2833,7 @@ static int prepend_name(char **buffer, int *buflen, struct qstr *name)
 	u32 dlen = ACCESS_ONCE(name->len);
 	char *p;
 
-	if (*buflen < dlen + 1)
+	if (*buflen < (int)dlen + 1)
 		return -ENAMETOOLONG;
 	*buflen -= dlen + 1;
 	p = *buffer -= dlen + 1;
-- 
1.8.1.4

