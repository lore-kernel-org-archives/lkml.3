Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757852Ab3HMGw3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 02:52:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60545 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756602Ab3HMGdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 02:33:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nix <nix@esperi.org.uk>, Trond Myklebust <Trond.Myklebust@netapp.com>,
        Jeff Layton <jlayton@redhat.com>
Subject: [ 30/60] SUNRPC: Dont auto-disconnect from the local rpcbind socket
Date: Mon, 12 Aug 2013 23:33:57 -0700
Message-Id: <20130813063336.322322070@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130813063331.950321483@linuxfoundation.org>
References: <20130813063331.950321483@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 00326ed6442c66021cd4b5e19e80f3e2027d5d42 upstream.

There is no need for the kernel to time out the AF_LOCAL connection to
the rpcbind socket, and doing so is problematic because when it is
time to reconnect, our process may no longer be using the same mount
namespace.

Reported-by: Nix <nix@esperi.org.uk>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sunrpc/rpcb_clnt.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/net/sunrpc/rpcb_clnt.c
+++ b/net/sunrpc/rpcb_clnt.c
@@ -238,6 +238,14 @@ static int rpcb_create_local_unix(struct
 		.program	= &rpcb_program,
 		.version	= RPCBVERS_2,
 		.authflavor	= RPC_AUTH_NULL,
+		/*
+		 * We turn off the idle timeout to prevent the kernel
+		 * from automatically disconnecting the socket.
+		 * Otherwise, we'd have to cache the mount namespace
+		 * of the caller and somehow pass that to the socket
+		 * reconnect code.
+		 */
+		.flags		= RPC_CLNT_CREATE_NO_IDLE_TIMEOUT,
 	};
 	struct rpc_clnt *clnt, *clnt4;
 	int result = 0;


