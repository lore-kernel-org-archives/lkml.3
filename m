Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507AbaKAXED (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 19:04:03 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60003 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751389AbaKAWj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 18:39:26 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Sergio Gelato" <Sergio.Gelato@astro.su.se>
Date: Sat, 01 Nov 2014 22:28:03 +0000
Message-ID: <lsq.1414880883.999812850@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 100/102] nfsd: Fix ACL null pointer deref
In-Reply-To: <lsq.1414880882.522510247@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.64-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Sergio Gelato <Sergio.Gelato@astro.su.se>

BugLink: http://bugs.launchpad.net/bugs/1348670

Fix regression introduced in pre-3.14 kernels by cherry-picking
aa07c713ecfc0522916f3cd57ac628ea6127c0ec
(NFSD: Call ->set_acl with a NULL ACL structure if no entries).

The affected code was removed in 3.14 by commit
4ac7249ea5a0ceef9f8269f63f33cc873c3fac61
(nfsd: use get_acl and ->set_acl).
The ->set_acl methods are already able to cope with a NULL argument.

Signed-off-by: Sergio Gelato <Sergio.Gelato@astro.su.se>
[bwh: Rewrite the subject]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfsd/vfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 446dc01..fc208e4 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -508,6 +508,9 @@
 	char *buf = NULL;
 	int error = 0;
 
+	if (!pacl)
+		return vfs_setxattr(dentry, key, NULL, 0, 0);
+
 	buflen = posix_acl_xattr_size(pacl->a_count);
 	buf = kmalloc(buflen, GFP_KERNEL);
 	error = -ENOMEM;

