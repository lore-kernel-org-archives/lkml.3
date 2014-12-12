Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760064AbaLLFeK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 00:34:10 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:44726 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754461AbaLLFeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 00:34:08 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: davem@davemloft.net
Cc: ast@plumgrid.com, dborkman@redhat.com, hannes@stressinduktion.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] net: sock: correctly handle failed prog retrieval from fd
Date: Fri, 12 Dec 2014 00:33:48 -0500
Message-Id: <1418362428-15067-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 2.1.0
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit "net: sock: allow eBPF programs to be attached to sockets" didn't
correctly handle the case where there is a failure getting the prog from
a given fd.

This allows for easy NULL ptr deref from userspace.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 net/core/filter.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 8cc3c03..ec9baea 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -1103,8 +1103,8 @@ int sk_attach_bpf(u32 ufd, struct sock *sk)
 		return -EPERM;
 
 	prog = bpf_prog_get(ufd);
-	if (!prog)
-		return -EINVAL;
+	if (IS_ERR(prog))
+		return PTR_ERR(prog);
 
 	if (prog->aux->prog_type != BPF_PROG_TYPE_SOCKET_FILTER) {
 		/* valid fd, but invalid program type */
-- 
2.1.0

