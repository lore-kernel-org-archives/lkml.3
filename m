Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131AbaJCWtQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:49:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47422 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755128AbaJCWYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:24:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        James Drews <drews@engr.wisc.edu>,
        Trond Myklebust <trond.myklebust@primarydata.com>
Subject: [PATCH 3.10 063/143] NFSv4: Fix another bug in the close/open_downgrade code
Date: Fri,  3 Oct 2014 14:34:18 -0700
Message-Id: <20141003213316.412496160@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003213314.470709810@linuxfoundation.org>
References: <20141003213314.470709810@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@primarydata.com>

commit cd9288ffaea4359d5cfe2b8d264911506aed26a4 upstream.

James Drew reports another bug whereby the NFS client is now sending
an OPEN_DOWNGRADE in a situation where it should really have sent a
CLOSE: the client is opening the file for O_RDWR, but then trying to
do a downgrade to O_RDONLY, which is not allowed by the NFSv4 spec.

Reported-by: James Drews <drews@engr.wisc.edu>
Link: http://lkml.kernel.org/r/541AD7E5.8020409@engr.wisc.edu
Fixes: aee7af356e15 (NFSv4: Fix problems with close in the presence...)
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4proc.c |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -2299,23 +2299,23 @@ static void nfs4_close_prepare(struct rp
 	is_rdwr = test_bit(NFS_O_RDWR_STATE, &state->flags);
 	is_rdonly = test_bit(NFS_O_RDONLY_STATE, &state->flags);
 	is_wronly = test_bit(NFS_O_WRONLY_STATE, &state->flags);
-	/* Calculate the current open share mode */
-	calldata->arg.fmode = 0;
-	if (is_rdonly || is_rdwr)
-		calldata->arg.fmode |= FMODE_READ;
-	if (is_wronly || is_rdwr)
-		calldata->arg.fmode |= FMODE_WRITE;
 	/* Calculate the change in open mode */
+	calldata->arg.fmode = 0;
 	if (state->n_rdwr == 0) {
-		if (state->n_rdonly == 0) {
-			call_close |= is_rdonly || is_rdwr;
-			calldata->arg.fmode &= ~FMODE_READ;
-		}
-		if (state->n_wronly == 0) {
-			call_close |= is_wronly || is_rdwr;
-			calldata->arg.fmode &= ~FMODE_WRITE;
-		}
-	}
+		if (state->n_rdonly == 0)
+			call_close |= is_rdonly;
+		else if (is_rdonly)
+			calldata->arg.fmode |= FMODE_READ;
+		if (state->n_wronly == 0)
+			call_close |= is_wronly;
+		else if (is_wronly)
+			calldata->arg.fmode |= FMODE_WRITE;
+	} else if (is_rdwr)
+		calldata->arg.fmode |= FMODE_READ|FMODE_WRITE;
+
+	if (calldata->arg.fmode == 0)
+		call_close |= is_rdwr;
+
 	if (!nfs4_valid_open_stateid(state))
 		call_close = 0;
 	spin_unlock(&state->owner->so_lock);


