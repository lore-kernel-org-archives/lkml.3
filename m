Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759609Ab3LFXS6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:18:58 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48802 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759573Ab3LFXSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:18:54 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Steve French <smfrench@gmail.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 135/152] setfacl removes part of ACL when setting POSIX ACLs to Samba
Date: Fri,  6 Dec 2013 15:10:59 -0800
Message-Id: <1386371476-2477-136-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386371476-2477-1-git-send-email-kamal@canonical.com>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve French <smfrench@gmail.com>

commit b1d93356427be6f050dc55c86eb019d173700af6 upstream.

setfacl over cifs mounts can remove the default ACL when setting the
(non-default part of) the ACL and vice versa (we were leaving at 0
rather than setting to -1 the count field for the unaffected
half of the ACL.  For example notice the setfacl removed
the default ACL in this sequence:

steven@steven-GA-970A-DS3:~/cifs-2.6$ getfacl /mnt/test-dir ; setfacl
-m default:user:test:rwx,user:test:rwx /mnt/test-dir
getfacl: Removing leading '/' from absolute path names
user::rwx
group::r-x
other::r-x
default:user::rwx
default:user:test:rwx
default:group::r-x
default:mask::rwx
default:other::r-x

steven@steven-GA-970A-DS3:~/cifs-2.6$ getfacl /mnt/test-dir
getfacl: Removing leading '/' from absolute path names
user::rwx
user:test:rwx
group::r-x
mask::rwx
other::r-x

Signed-off-by: Steve French <smfrench@gmail.com>
Acked-by: Jeremy Allison <jra@samba.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/cifs/cifssmb.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 76d0d29..2b280d9 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -3296,11 +3296,13 @@ static __u16 ACL_to_cifs_posix(char *parm_data, const char *pACL,
 		return 0;
 	}
 	cifs_acl->version = cpu_to_le16(1);
-	if (acl_type == ACL_TYPE_ACCESS)
+	if (acl_type == ACL_TYPE_ACCESS) {
 		cifs_acl->access_entry_count = cpu_to_le16(count);
-	else if (acl_type == ACL_TYPE_DEFAULT)
+		cifs_acl->default_entry_count = __constant_cpu_to_le16(0xFFFF);
+	} else if (acl_type == ACL_TYPE_DEFAULT) {
 		cifs_acl->default_entry_count = cpu_to_le16(count);
-	else {
+		cifs_acl->access_entry_count = __constant_cpu_to_le16(0xFFFF);
+	} else {
 		cFYI(1, "unknown ACL type %d", acl_type);
 		return 0;
 	}
-- 
1.8.3.2

