Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260AbaJ1DiO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 23:38:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44482 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237AbaJ1DiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:38:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@primarydata.com>
Subject: [PATCH 3.17 059/146] NFSv4: Fix lock recovery when CREATE_SESSION/SETCLIENTID_CONFIRM fails
Date: Tue, 28 Oct 2014 11:33:21 +0800
Message-Id: <20141028033345.945583415@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033343.441992423@linuxfoundation.org>
References: <20141028033343.441992423@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@primarydata.com>

commit a4339b7b686b4acc8b6de2b07d7bacbe3ae44b83 upstream.

If a NFSv4.x server returns NFS4ERR_STALE_CLIENTID in response to a
CREATE_SESSION or SETCLIENTID_CONFIRM in order to tell us that it rebooted
a second time, then the client will currently take this to mean that it must
declare all locks to be stale, and hence ineligible for reboot recovery.

RFC3530 and RFC5661 both suggest that the client should instead rely on the
server to respond to inelegible open share, lock and delegation reclaim
requests with NFS4ERR_NO_GRACE in this situation.

Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4state.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -1761,7 +1761,6 @@ static int nfs4_handle_reclaim_lease_err
 		break;
 	case -NFS4ERR_STALE_CLIENTID:
 		clear_bit(NFS4CLNT_LEASE_CONFIRM, &clp->cl_state);
-		nfs4_state_clear_reclaim_reboot(clp);
 		nfs4_state_start_reclaim_reboot(clp);
 		break;
 	case -NFS4ERR_CLID_INUSE:


