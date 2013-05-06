Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760675Ab3EFXOJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 19:14:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36940 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760655Ab3EFXOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 19:14:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 084/104] NFSv4: Handle NFS4ERR_DELAY and NFS4ERR_GRACE in nfs4_open_delegation_recall
Date: Mon,  6 May 2013 16:12:43 -0700
Message-Id: <20130506230052.303820146@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506230043.526528358@linuxfoundation.org>
References: <20130506230043.526528358@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 8b6cc4d6f841d31f72fe7478453759166d366274 upstream.

A server shouldn't normally return NFS4ERR_GRACE if the client holds a
delegation, since no conflicting lock reclaims can be granted, however
the spec does not require the server to grant the open in this
instance

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4proc.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1374,6 +1374,12 @@ int nfs4_open_delegation_recall(struct n
 			case -ENOMEM:
 				err = 0;
 				goto out;
+			case -NFS4ERR_DELAY:
+			case -NFS4ERR_GRACE:
+				set_bit(NFS_DELEGATED_STATE, &state->flags);
+				ssleep(1);
+				err = -EAGAIN;
+				goto out;
 		}
 		err = nfs4_handle_exception(server, err, &exception);
 	} while (exception.retry);


