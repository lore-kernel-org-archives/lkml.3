Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895AbaFGBad (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 21:30:33 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36112 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752678AbaFGBXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 21:23:39 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Ben Greear" <greearb@candelatech.com>,
        "Chuck Lever" <chuck.lever@oracle.com>,
        "Marco Munderloh" <munderl@tnt.uni-hannover.de>,
        "Al Viro" <viro@zeniv.linux.org.uk>, "Christoph Hellwig" <hch@lst.de>
Date: Sat, 07 Jun 2014 02:26:29 +0100
Message-ID: <lsq.1402104389.363183483@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 58/92] posix_acl: handle NULL ACL in posix_acl_equiv_mode
In-Reply-To: <lsq.1402104388.385007124@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.60-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/posix_acl.c | 6 ++++++
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

