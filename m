Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932315AbbAHQl5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 11:41:57 -0500
Received: from mail-wi0-f195.google.com ([209.85.212.195]:54698 "EHLO
	mail-wi0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932264AbbAHQly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 11:41:54 -0500
MIME-Version: 1.0
Date: Thu, 8 Jan 2015 22:11:52 +0530
Message-ID: <CABP0=5eXSCW=yp8iqyXNzXMsYNM7L0T0TFefrOZsj2wpbakfXQ@mail.gmail.com>
Subject: Fix for synchronization issue in IPV6 implementation in smack module(v3.18)
From: Vishal Goel <goel.cool@gmail.com>
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        casey@schaufler-ca.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 [PATCH] This patch fixes the synchronization issue in IPv6
 implementation. Previously there was no synchronization mechanism used while
 accessing(adding/reading/deletion) smk_ipv6_port_list. It could be possible
 that when one thread is reading the list, at the same time another thread is
 adding/deleting in the list.So it is possible that reader thread will read
 the inaccurate or incomplete list. So to make sure that reader thread will
 read the accurate list, rcu mechanism has been used while accessing the
 list.RCU allows readers to access a data structure even when it is in the
 process of being updated

Signed-off-by: Vishal Goel <vishal.goel@samsung.com>
            Himanshu Shukla <himanshu.sh@samsung.com>
---
 security/smack/smack_lsm.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index d515ec2..b3427ee 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -52,6 +52,7 @@
 #define SMK_RECEIVING  1
 #define SMK_SENDING    2

+DEFINE_MUTEX(smack_ipv6_lock);
 LIST_HEAD(smk_ipv6_port_list);

 #ifdef CONFIG_SECURITY_SMACK_BRINGUP
@@ -2232,17 +2233,20 @@ static void smk_ipv6_port_label(struct socket
*sock, struct sockaddr *address)
             * on the bound socket. Take the changes to the port
             * as well.
             */
-           list_for_each_entry(spp, &smk_ipv6_port_list, list) {
+           rcu_read_lock();
+           list_for_each_entry_rcu(spp, &smk_ipv6_port_list, list) {
                  if (sk != spp->smk_sock)
                        continue;
                  spp->smk_in = ssp->smk_in;
                  spp->smk_out = ssp->smk_out;
+                 rcu_read_unlock();
                  return;
            }
            /*
             * A NULL address is only used for updating existing
             * bound entries. If there isn't one, it's OK.
             */
+           rcu_read_unlock();
            return;
      }

@@ -2258,16 +2262,18 @@ static void smk_ipv6_port_label(struct socket
*sock, struct sockaddr *address)
       * Look for an existing port list entry.
       * This is an indication that a port is getting reused.
       */
-     list_for_each_entry(spp, &smk_ipv6_port_list, list) {
+     rcu_read_lock();
+     list_for_each_entry_rcu(spp, &smk_ipv6_port_list, list) {
            if (spp->smk_port != port)
                  continue;
            spp->smk_port = port;
            spp->smk_sock = sk;
            spp->smk_in = ssp->smk_in;
            spp->smk_out = ssp->smk_out;
+           rcu_read_unlock();
            return;
      }
-
+     rcu_read_unlock();
      /*
       * A new port entry is required.
       */
@@ -2280,7 +2286,9 @@ static void smk_ipv6_port_label(struct socket
*sock, struct sockaddr *address)
      spp->smk_in = ssp->smk_in;
      spp->smk_out = ssp->smk_out;

-     list_add(&spp->list, &smk_ipv6_port_list);
+     mutex_lock(&smack_ipv6_lock);
+     list_add_rcu(&spp->list, &smk_ipv6_port_list);
+     mutex_unlock(&smack_ipv6_lock);
      return;
 }

@@ -2335,8 +2343,8 @@ static int smk_ipv6_port_check(struct sock *sk,
struct sockaddr_in6 *address,
            skp = &smack_known_web;
            goto auditout;
      }
-
-     list_for_each_entry(spp, &smk_ipv6_port_list, list) {
+     rcu_read_lock();
+     list_for_each_entry_rcu(spp, &smk_ipv6_port_list, list) {
            if (spp->smk_port != port)
                  continue;
            object = spp->smk_in;
@@ -2344,6 +2352,7 @@ static int smk_ipv6_port_check(struct sock *sk,
struct sockaddr_in6 *address,
                  ssp->smk_packet = spp->smk_out;
            break;
      }
+     rcu_read_unlock();

 auditout:

--
1.8.3.2
