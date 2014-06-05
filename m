Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720AbaFEFIq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 01:08:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43785 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbaFEEUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:20:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Ben Greear <greearb@candelatech.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 3.4 057/214] posix_acl: handle NULL ACL in posix_acl_equiv_mode
Date: Wed,  4 Jun 2014 21:17:00 -0700
Message-Id: <20140605041647.127225470@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

commit 50c6e282bdf5e8dabf8d7cf7b162545a55645fd9 upstream.

Various filesystems don't bother checking for a NULL ACL in
posix_acl_equiv_mode, and thus can dereference a NULL pointer when it
gets passed one. This usually happens from the NFS server, as the ACL tools
never pass a NULL ACL, but instead of one representing the mode bits.

Instead of adding boilerplat to all filesystems put this check into one place,
which will allow us to remove the check from other filesystems as well later
on.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reported-by: Ben Greear <greearb@candelatech.com>
Reported-by: Marco Munderloh <munderl@tnt.uni-hannover.de>,
Cc: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/posix_acl.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/posix_acl.c
+++ b/fs/posix_acl.c
@@ -155,6 +155,12 @@ posix_acl_equiv_mode(const struct posix_
 	umode_t mode = 0;
 	int not_equiv = 0;
 
+	/*
+	 * A null ACL can always be presented as mode bits.
+	 */
+	if (!acl)
+		return 0;
+
 	FOREACH_ACL_ENTRY(pa, acl, pe) {
 		switch (pa->e_tag) {
 			case ACL_USER_OBJ:


