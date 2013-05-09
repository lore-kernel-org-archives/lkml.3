Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766Ab3EIW1u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:27:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45916 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756573Ab3EIW05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:26:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chuck Lever <Chuck.Lever@oracle.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 72/73] NFSv4.x: Fix handling of partially delegated locks
Date: Thu,  9 May 2013 15:26:02 -0700
Message-Id: <20130509222533.700036592@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130509222526.480204972@linuxfoundation.org>
References: <20130509222526.480204972@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit c5a2a15f8146fdfe45078df7873a6dc1006b3869 upstream.

If a NFS client receives a delegation for a file after it has taken
a lock on that file, we can currently end up in a situation where
we mistakenly skip unlocking that file.

The following patch swaps an erroneous check in nfs4_proc_unlck for
whether or not the file has a delegation to one which checks whether
or not we hold a lock stateid for that file.

Reported-by: Chuck Lever <Chuck.Lever@oracle.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Tested-by: Chuck Lever <Chuck.Lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4proc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -4553,9 +4553,9 @@ static int nfs4_proc_unlck(struct nfs4_s
 	if (status != 0)
 		goto out;
 	/* Is this a delegated lock? */
-	if (test_bit(NFS_DELEGATED_STATE, &state->flags))
-		goto out;
 	lsp = request->fl_u.nfs4_fl.owner;
+	if (test_bit(NFS_LOCK_INITIALIZED, &lsp->ls_flags) == 0)
+		goto out;
 	seqid = nfs_alloc_seqid(&lsp->ls_seqid, GFP_KERNEL);
 	status = -ENOMEM;
 	if (seqid == NULL)


