Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758059Ab3EFUq7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 16:46:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59336 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757937Ab3EFUq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 16:46:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 089/115] NFSv4: Handle NFS4ERR_DELAY and NFS4ERR_GRACE in nfs4_lock_delegation_recall
Date: Mon,  6 May 2013 13:45:25 -0700
Message-Id: <20130506203104.730053565@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506203055.537199268@linuxfoundation.org>
References: <20130506203055.537199268@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit dbb21c25a35a71baf413f5176f028ee11b88cfbc upstream.

A server shouldn't normally return NFS4ERR_GRACE if the client holds a
delegation, since no conflicting lock reclaims can be granted, however
the spec does not require the server to grant the lock in this
instance.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4proc.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -5025,6 +5025,12 @@ int nfs4_lock_delegation_recall(struct n
 				nfs4_schedule_stateid_recovery(server, state);
 				err = 0;
 				goto out;
+			case -NFS4ERR_DELAY:
+			case -NFS4ERR_GRACE:
+				set_bit(NFS_DELEGATED_STATE, &state->flags);
+				ssleep(1);
+				err = -EAGAIN;
+				goto out;
 			case -ENOMEM:
 			case -NFS4ERR_DENIED:
 				/* kill_proc(fl->fl_pid, SIGLOST, 1); */


