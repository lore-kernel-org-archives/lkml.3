Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311AbbAIJc3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 04:32:29 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:58812 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754505AbbAIJc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 04:32:27 -0500
MIME-Version: 1.0
Date: Fri, 9 Jan 2015 15:02:25 +0530
Message-ID: <CABP0=5fBZS0xrUZCaPQYhNan0JgxUTTRPGFbWFiaE0KR5L1h9g@mail.gmail.com>
Subject: Fix for different protocol issue in ipv6 implementation in smack
 module(kernel ver- 3.19)
From: Vishal Goel <goel.cool@gmail.com>
To: Casey Schaufler <casey@schaufler-ca.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        "vishal.goel@samsung.com" <vishal.goel@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH]  This patch fixes the issue when 2 servers uses same IP and
 port but different protocols(Udp and tcp). And they are using different
 SMACK64IPIN labels.Tcp server is using "test" and udp server is using
 "test-in". Now when we try to run tcp client with SMACK64IPOUT label as
 "test", then connection denied error comes. It should not happen since both
 tcp server and client labels are same. This happens because there is no check
 for protocol in smk_ipv6_port_label() function.It checks whether there is an
 existing port entry on the basis of port only.So it updates the previous
 port  entry in the list. Due to which smack label gets changed for previous
 entry  in the "smk_ipv6_port_list" list and permission denied error comes.
 Now a  check has been added for socket type also.Now if 2 processes uses same
 port  but different protocols (tcp or udp), then 2 different port entries
 will be  added in the list. Similarly which checking smack access in
 smk_ipv6_port_check() function,  port entry is searched on the basis of both
 port and protocol.

Signed-off-by: Vishal Goel <vishal.goel@samsung.com>
                Himanshu Shukla <himanshu.sh@samsung.com>
---
 security/smack/smack.h     | 1 +
 security/smack/smack_lsm.c | 5 +++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/security/smack/smack.h b/security/smack/smack.h
index b828a37..e8c6477 100644
--- a/security/smack/smack.h
+++ b/security/smack/smack.h
@@ -135,6 +135,7 @@ struct smk_port_label {
        unsigned short          smk_port;       /* the port number */
        struct smack_known      *smk_in;        /* inbound label */
        struct smack_known      *smk_out;       /* outgoing label */
+       short                   sock_type;      /*Socket type*/
 };

 /*
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 87f0f0a..3d6af90 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -2265,7 +2265,7 @@ static void smk_ipv6_port_label(struct socket
*sock, struct sockaddr *address)
         */
        rcu_read_lock();
        list_for_each_entry_rcu(spp, &smk_ipv6_port_list, list) {
-               if (spp->smk_port != port)
+               if (spp->smk_port != port || spp->sock_type != sock->type)
                        continue;
                spp->smk_port = port;
                spp->smk_sock = sk;
@@ -2286,6 +2286,7 @@ static void smk_ipv6_port_label(struct socket
*sock, struct sockaddr *address)
        spp->smk_sock = sk;
        spp->smk_in = ssp->smk_in;
        spp->smk_out = ssp->smk_out;
+       spp->sock_type = sock->type;

        mutex_lock(&smack_ipv6_lock);
        list_add_rcu(&spp->list, &smk_ipv6_port_list);
@@ -2347,7 +2348,7 @@ static int smk_ipv6_port_check(struct sock *sk,
struct sockaddr_in6 *address,

        rcu_read_lock();
        list_for_each_entry_rcu(spp, &smk_ipv6_port_list, list) {
-               if (spp->smk_port != port)
+               if (spp->smk_port != port || spp->sock_type != sk->sk_type)
                        continue;
                object = spp->smk_in;
                if (act == SMK_CONNECTING)
-- 
1.8.3.2
