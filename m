Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799AbaKSGiF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 01:38:05 -0500
Received: from mail-qc0-f175.google.com ([209.85.216.175]:48482 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494AbaKSGiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 01:38:03 -0500
From: Jon Maxwell <jmaxwell37@gmail.com>
To: davem@davemloft.net
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jmaxwell@redhat.com, Jon Maxwell <jmaxwell37@gmail.com>
Subject: [PATCH net] tcp: fix connect() invalid -EADDRNOTAVAIL error
Date: Wed, 19 Nov 2014 17:37:40 +1100
Message-Id: <1416379060-15685-1-git-send-email-jmaxwell37@gmail.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The connect() routine returns -EADDRNOTAVAIL without doing a 4 
tuple check when the hash buckets were previously allocated by 
bind() and all local ports are used.

The bind() routine creates the local port hash buckets in 
inet_csk_get_port(). Depending on the socket options it sets 
tb->fastreuse and tb->fastreuseport to 0 or 1 in the bucket.

However the __inet_hash_connect() routine initializes the hash 
buckets differently and sets these to -1. The end result is 
that connect() calling into __inet_hash_connect() will 
subsequently ignore the check_established() routine if, here

__inet_hash_connect()
.
.
if (tb->fastreuse >= 0 ||↩
    tb->fastreuseport >= 0)↩
    goto next_port;

and cycle through all local ports until it returns -EADDRNOTAVAIL. 
The 4 tuple check is in check_established() so connect() can fail 
unnecessarily.

Prerequisites for this to happen:
1) The local tcp port range must be exhausted.
2) A process must have called bind() followed by connect() for all 
local ports.
3) A different process calls connect() only which returns -EADDRNOTAVAIL. 
4) The system more than 1 interface configured.

If a system has 2 IP Addresses and all local tcp ports are in use
for connection from IP Address (1). Connecting to the same ports 
via IP Address (2) should work based on the 4 tuple rule. But it 
fails under this condition. 

To fix this make __inet_hash_connect() honour inet_csk_get_port()'s
tb->fastreuse* variables.

Signed-off-by: Jon Maxwell <jmaxwell37@gmail.com>
---
 net/ipv4/inet_hashtables.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 9111a4e..b39e89e 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -513,8 +513,8 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 			inet_bind_bucket_for_each(tb, &head->chain) {
 				if (net_eq(ib_net(tb), net) &&
 				    tb->port == port) {
-					if (tb->fastreuse >= 0 ||
-					    tb->fastreuseport >= 0)
+					if (tb->fastreuse > 0 ||
+					    tb->fastreuseport > 0)
 						goto next_port;
 					WARN_ON(hlist_empty(&tb->owners));
 					if (!check_established(death_row, sk,
@@ -530,8 +530,6 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 				spin_unlock(&head->lock);
 				break;
 			}
-			tb->fastreuse = -1;
-			tb->fastreuseport = -1;
 			goto ok;
 
 		next_port:
-- 
1.8.3.1

