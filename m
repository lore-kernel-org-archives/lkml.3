Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931AbaEWMwm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 08:52:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35422 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752893AbaEWMwk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 08:52:40 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 2/4] AFS: Part of afs_end_call() is identical to code
 elsewhere, so split it
From: David Howells <dhowells@redhat.com>
To: torvalds@linux-foundation.org
Cc: dhowells@redhat.com, Nathaniel Wesley Filardo <nwf@cs.jhu.edu>,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Fri, 23 May 2014 13:52:15 +0100
Message-ID: <20140523125214.25385.24405.stgit@warthog.procyon.org.uk>
In-Reply-To: <20140523125200.25385.8586.stgit@warthog.procyon.org.uk>
References: <20140523125200.25385.8586.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nathaniel Wesley Filardo <nwf@cs.jhu.edu>

Split afs_end_call() into two pieces, one of which is identical to code in
afs_process_async_call().  Replace the latter with a call to the first part of
afs_end_call().

Signed-off-by: Nathaniel Wesley Filardo <nwf@cs.jhu.edu>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/afs/rxrpc.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/fs/afs/rxrpc.c b/fs/afs/rxrpc.c
index 9226a6674d7f..1a1110b1a7ff 100644
--- a/fs/afs/rxrpc.c
+++ b/fs/afs/rxrpc.c
@@ -184,15 +184,24 @@ static void afs_free_call(struct afs_call *call)
 }
 
 /*
- * End a call
+ * End a call but do not free it
  */
-static void afs_end_call(struct afs_call *call)
+static void afs_end_call_nofree(struct afs_call *call)
 {
 	if (call->rxcall) {
 		rxrpc_kernel_end_call(call->rxcall);
 		call->rxcall = NULL;
 	}
-	call->type->destructor(call);
+	if (call->type->destructor)
+		call->type->destructor(call);
+}
+
+/*
+ * End a call and free it
+ */
+static void afs_end_call(struct afs_call *call)
+{
+	afs_end_call_nofree(call);
 	afs_free_call(call);
 }
 
@@ -640,10 +649,7 @@ static void afs_process_async_call(struct work_struct *work)
 		call->reply = NULL;
 
 		/* kill the call */
-		rxrpc_kernel_end_call(call->rxcall);
-		call->rxcall = NULL;
-		if (call->type->destructor)
-			call->type->destructor(call);
+		afs_end_call_nofree(call);
 
 		/* we can't just delete the call because the work item may be
 		 * queued */

