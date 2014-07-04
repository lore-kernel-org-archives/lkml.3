Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030367AbaGDWRH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 18:17:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57138 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030233AbaGDWRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 18:17:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Scott Mayhew <smayhew@redhat.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>
Subject: [PATCH 3.15 40/66] nfs: Fix cache_validity check in nfs_write_pageuptodate()
Date: Fri,  4 Jul 2014 15:14:39 -0700
Message-Id: <20140704221424.631860703@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140704221422.813435485@linuxfoundation.org>
References: <20140704221422.813435485@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Scott Mayhew <smayhew@redhat.com>

commit 18dd78c427513fb0f89365138be66e6ee8700d1b upstream.

NFS_INO_INVALID_DATA cannot be ignored, even if we have a delegation.

We're still having some problems with data corruption when multiple
clients are appending to a file and those clients are being granted
write delegations on open.

To reproduce:

Client A:
vi /mnt/`hostname -s`
while :; do echo "XXXXXXXXXXXXXXX" >>/mnt/file; sleep $(( $RANDOM % 5 )); done

Client B:
vi /mnt/`hostname -s`
while :; do echo "YYYYYYYYYYYYYYY" >>/mnt/file; sleep $(( $RANDOM % 5 )); done

What's happening is that in nfs_update_inode() we're recognizing that
the file size has changed and we're setting NFS_INO_INVALID_DATA
accordingly, but then we ignore the cache_validity flags in
nfs_write_pageuptodate() because we have a delegation.  As a result,
in nfs_updatepage() we're extending the write to cover the full page
even though we've not read in the data to begin with.

Signed-off-by: Scott Mayhew <smayhew@redhat.com>
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/write.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -913,12 +913,14 @@ static bool nfs_write_pageuptodate(struc
 
 	if (nfs_have_delegated_attributes(inode))
 		goto out;
-	if (nfsi->cache_validity & (NFS_INO_INVALID_DATA|NFS_INO_REVAL_PAGECACHE))
+	if (nfsi->cache_validity & NFS_INO_REVAL_PAGECACHE)
 		return false;
 	smp_rmb();
 	if (test_bit(NFS_INO_INVALIDATING, &nfsi->flags))
 		return false;
 out:
+	if (nfsi->cache_validity & NFS_INO_INVALID_DATA)
+		return false;
 	return PageUptodate(page) != 0;
 }
 


