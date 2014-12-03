Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147AbaLCMDg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 07:03:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54457 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751537AbaLCL1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:06 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Daniel Borkmann <dborkman@redhat.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 007/101] net: sctp: fix memory leak in auth key management
Date: Wed,  3 Dec 2014 12:25:29 +0100
Message-Id: <7e9acaf571479dce19aad5a2ab45a64db1d69c4a.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
References: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Borkmann <dborkman@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 4184b2a79a7612a9272ce20d639934584a1f3786 ]

A very minimal and simple user space application allocating an SCTP
socket, setting SCTP_AUTH_KEY setsockopt(2) on it and then closing
the socket again will leak the memory containing the authentication
key from user space:

unreferenced object 0xffff8800837047c0 (size 16):
  comm "a.out", pid 2789, jiffies 4296954322 (age 192.258s)
  hex dump (first 16 bytes):
    01 00 00 00 04 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff816d7e8e>] kmemleak_alloc+0x4e/0xb0
    [<ffffffff811c88d8>] __kmalloc+0xe8/0x270
    [<ffffffffa0870c23>] sctp_auth_create_key+0x23/0x50 [sctp]
    [<ffffffffa08718b1>] sctp_auth_set_key+0xa1/0x140 [sctp]
    [<ffffffffa086b383>] sctp_setsockopt+0xd03/0x1180 [sctp]
    [<ffffffff815bfd94>] sock_common_setsockopt+0x14/0x20
    [<ffffffff815beb61>] SyS_setsockopt+0x71/0xd0
    [<ffffffff816e58a9>] system_call_fastpath+0x12/0x17
    [<ffffffffffffffff>] 0xffffffffffffffff

This is bad because of two things, we can bring down a machine from
user space when auth_enable=1, but also we would leave security sensitive
keying material in memory without clearing it after use. The issue is
that sctp_auth_create_key() already sets the refcount to 1, but after
allocation sctp_auth_set_key() does an additional refcount on it, and
thus leaving it around when we free the socket.

Fixes: 65b07e5d0d0 ("[SCTP]: API updates to suport SCTP-AUTH extensions.")
Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Cc: Vlad Yasevich <vyasevich@gmail.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/sctp/auth.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/sctp/auth.c b/net/sctp/auth.c
index 43b871f6cddf..4b842e9618ad 100644
--- a/net/sctp/auth.c
+++ b/net/sctp/auth.c
@@ -868,8 +868,6 @@ int sctp_auth_set_key(struct sctp_endpoint *ep,
 		list_add(&cur_key->key_list, sh_keys);
 
 	cur_key->key = key;
-	sctp_auth_key_hold(key);
-
 	return 0;
 nomem:
 	if (!replace)
-- 
2.1.3

