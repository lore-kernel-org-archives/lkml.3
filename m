Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497AbaFEE7l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:59:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43905 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550AbaFEEUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:20:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Steve French <smfrench@gmail.com>, Jeremy Allison <jra@samba.org>,
        Ben Hutchings <ben@decadent.org.uk>, Rui Xiang <rui.xiang@huawei.com>
Subject: [PATCH 3.4 075/214] setfacl removes part of ACL when setting POSIX ACLs to Samba
Date: Wed,  4 Jun 2014 21:17:18 -0700
Message-Id: <20140605041649.630302485@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Rui Xiang <rui.xiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/cifssmb.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -3454,11 +3454,13 @@ static __u16 ACL_to_cifs_posix(char *par
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


