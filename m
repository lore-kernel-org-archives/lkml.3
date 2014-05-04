Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653AbaEDQk4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:40:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36083 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926AbaEDPlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:41:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mark Lord <mlord@pobox.com>, Jeff Layton <jlayton@redhat.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 3.14 070/158] nfsd: revert v2 half of "nfsd: dont return high mode bits"
Date: Sun,  4 May 2014 11:39:39 -0400
Message-Id: <20140504154039.436259543@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit 082f31a2169bd639785e45bf252f3d5bce0303c6 upstream.

This reverts the part of commit 6e14b46b91fee8a049b0940333ce13a820beaaa5
that changes NFSv2 behavior.

Mark Lord found that it broke nfs-root for Linux clients, because it
broke NFSv2.

In fact, from RFC 1094:

	"Notice that the file type is specified both in the mode bits
	and in the file type.  This is really a bug in the protocol and
	will be fixed in future versions."

So NFSv2 clients really are expected to depend on the high bits of the
mode.

Reported-by: Mark Lord <mlord@pobox.com>
Reviewed-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Cc: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/nfsxdr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfsd/nfsxdr.c
+++ b/fs/nfsd/nfsxdr.c
@@ -152,7 +152,7 @@ encode_fattr(struct svc_rqst *rqstp, __b
 	type = (stat->mode & S_IFMT);
 
 	*p++ = htonl(nfs_ftypes[type >> 12]);
-	*p++ = htonl((u32) (stat->mode & S_IALLUGO));
+	*p++ = htonl((u32) stat->mode);
 	*p++ = htonl((u32) stat->nlink);
 	*p++ = htonl((u32) from_kuid(&init_user_ns, stat->uid));
 	*p++ = htonl((u32) from_kgid(&init_user_ns, stat->gid));


