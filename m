Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909AbbAIJfy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 04:35:54 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:54139 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754505AbbAIJfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 04:35:46 -0500
MIME-Version: 1.0
Date: Fri, 9 Jan 2015 15:05:45 +0530
Message-ID: <CABP0=5f1gtnS_kR2nJC1zkF4dvpPrj02KR3-C+hR2pFZyt1qDg@mail.gmail.com>
Subject: Fix for same server binary but with different labels issue in smack
 ipv6 implementation (kernel ver-3.19)
From: Vishal Goel <goel.cool@gmail.com>
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>
Cc: "vishal.goel@samsung.com" <vishal.goel@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH]  This patch fixes the bug which comes up when one tcp server
 is already running on some ip and port with "test" as SMACK64IPIN label. And
 we try to run the same server again with same port, same protocol, and same
 ip but with different SMACK64IPIN label "server". Then this new server
 process will exit with an error "Address already in use". Now when we try to
 run tcp client with SMACK64IPOUT label as "test", then connection denied
 error comes.It should not happen since both tcp server and client labels are
 same. This happens because new server process updates the existing port entry
  in the list before exiting with an error. This happens because checking for
 same binding address is done after smack hook call
 "security_smack_socket_bind()". Due to which previous port entry gets updated
  in the smack hook before new server process returns with an error.

Now new check has been added before updating the existing port entry in
smk_ipv6_port_label() function.
It checks whether the socket for corresponding port entry is closed or
not. If it is closed then it means no binding error
will come later. So in this case we can update the existing port entry
otherwise return.
For checking whether socket is closed or not, one more field
"smk_can_reuse" has been
added in the "smk_port_label" structure. This field will be marked 1 in
"smack_sk_free_security()" function. This function gets called
to free the socket security blob when the socket gets closed. In this
function,
port entry is searched in the list for the closing socket. If it is
found then "smk_can_reuse" field is set to 1.
"smk_can_reuse" field is set to 0 in smk_ipv6_port_label() function
after creating a new entry in the list.
'0' indicates that socket is being used by someone.

Signed-off-by: Vishal Goel <vishal.goel@samsung.com>
                Himanshu Shukla <himanshu.sh@samsung.com>
---
 security/smack/smack.h     |  1 +
 security/smack/smack_lsm.c | 16 ++++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/security/smack/smack.h b/security/smack/smack.h
index e8c6477..d2530fd 100644
--- a/security/smack/smack.h
+++ b/security/smack/smack.h
@@ -136,6 +136,7 @@ struct smk_port_label {
        struct smack_known      *smk_in;        /* inbound label */
        struct smack_known      *smk_out;       /* outgoing label */
        short                   sock_type;      /*Socket type*/
+       short                   smk_can_reuse;
 };

 /*
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 3d6af90..5b22a4c 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -2086,6 +2086,18 @@ static int smack_sk_alloc_security(struct sock
*sk, int family, gfp_t gfp_flags)
  */
 static void smack_sk_free_security(struct sock *sk)
 {
+       struct smk_port_label *spp;
+
+       if (sk->sk_family == PF_INET6) {
+               rcu_read_lock();
+               list_for_each_entry_rcu(spp, &smk_ipv6_port_list, list) {
+                       if (spp->smk_sock != sk)
+                               continue;
+                       spp->smk_can_reuse = 1;
+                       break;
+               }
+               rcu_read_unlock();
+       }
        kfree(sk->sk_security);
 }

@@ -2267,10 +2279,13 @@ static void smk_ipv6_port_label(struct socket
*sock, struct sockaddr *address)
        list_for_each_entry_rcu(spp, &smk_ipv6_port_list, list) {
                if (spp->smk_port != port || spp->sock_type != sock->type)
                        continue;
+               if (spp->smk_can_reuse != 1)
+                       return;
                spp->smk_port = port;
                spp->smk_sock = sk;
                spp->smk_in = ssp->smk_in;
                spp->smk_out = ssp->smk_out;
+               spp->smk_can_reuse = 0;
                rcu_read_unlock();
                return;
        }
@@ -2287,6 +2302,7 @@ static void smk_ipv6_port_label(struct socket
*sock, struct sockaddr *address)
        spp->smk_in = ssp->smk_in;
        spp->smk_out = ssp->smk_out;
        spp->sock_type = sock->type;
+       spp->smk_can_reuse = 0;

        mutex_lock(&smack_ipv6_lock);
        list_add_rcu(&spp->list, &smk_ipv6_port_list);
-- 
1.8.3.2
