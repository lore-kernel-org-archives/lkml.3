Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381AbaKYKxf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:53:35 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59132 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754085AbaKYKn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:43:29 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Daniel Borkmann <dborkman@redhat.com>, Vlad Yasevich <vyasevich@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 222/254] net: sctp: fix memory leak in auth key management
Date: Tue, 25 Nov 2014 10:39:32 +0000
Message-Id: <1416912004-5928-223-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <dborkman@redhat.com>

commit 4184b2a79a7612a9272ce20d639934584a1f3786 upstream.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/sctp/auth.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/sctp/auth.c b/net/sctp/auth.c
index 0e8529113dc5..fb7976aee61c 100644
--- a/net/sctp/auth.c
+++ b/net/sctp/auth.c
@@ -862,8 +862,6 @@ int sctp_auth_set_key(struct sctp_endpoint *ep,
 		list_add(&cur_key->key_list, sh_keys);
 
 	cur_key->key = key;
-	sctp_auth_key_hold(key);
-
 	return 0;
 nomem:
 	if (!replace)
-- 
2.1.0

