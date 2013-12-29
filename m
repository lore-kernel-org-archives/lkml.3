Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742Ab3L2CbI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:31:08 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55491 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753010Ab3L2CKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:10:50 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Steve French" <smfrench@gmail.com>,
        "Jeremy Allison" <jra@samba.org>
Date: Sun, 29 Dec 2013 03:08:43 +0100
Message-ID: <lsq.1388282923.574249922@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 070/185] setfacl removes part of ACL when setting
 POSIX ACLs to Samba
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/cifs/cifssmb.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -3437,11 +3437,13 @@ static __u16 ACL_to_cifs_posix(char *par
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

