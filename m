Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836Ab3KAWX6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 18:23:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55348 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756226Ab3KAWIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 18:08:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vlad Yasevich <vyasevic@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.11 22/66] bridge: update mdb expiration timer upon reports.
Date: Fri,  1 Nov 2013 15:06:58 -0700
Message-Id: <20131101220640.894444390@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131101220634.605745564@linuxfoundation.org>
References: <20131101220634.605745564@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vlad Yasevich <vyasevic@redhat.com>

[ Upstream commit f144febd93d5ee534fdf23505ab091b2b9088edc ]

commit 9f00b2e7cf241fa389733d41b615efdaa2cb0f5b
	bridge: only expire the mdb entry when query is received
changed the mdb expiration timer to be armed only when QUERY is
received.  Howerver, this causes issues in an environment where
the multicast server socket comes and goes very fast while a client
is trying to send traffic to it.

The root cause is a race where a sequence of LEAVE followed by REPORT
messages can race against QUERY messages generated in response to LEAVE.
The QUERY ends up starting the expiration timer, and that timer can
potentially expire after the new REPORT message has been received signaling
the new join operation.  This leads to a significant drop in multicast
traffic and possible complete stall.

The solution is to have REPORT messages update the expiration timer
on entries that already exist.

Signed-off-by: Vlad Yasevich <vyasevic@redhat.com>
CC: Cong Wang <xiyou.wangcong@gmail.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: Stephen Hemminger <stephen@networkplumber.org>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/br_multicast.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -610,6 +610,9 @@ rehash:
 		break;
 
 	default:
+		/* If we have an existing entry, update it's expire timer */
+		mod_timer(&mp->timer,
+			  jiffies + br->multicast_membership_interval);
 		goto out;
 	}
 
@@ -679,8 +682,12 @@ static int br_multicast_add_group(struct
 	for (pp = &mp->ports;
 	     (p = mlock_dereference(*pp, br)) != NULL;
 	     pp = &p->next) {
-		if (p->port == port)
+		if (p->port == port) {
+			/* We already have a portgroup, update the timer.  */
+			mod_timer(&p->timer,
+				  jiffies + br->multicast_membership_interval);
 			goto out;
+		}
 		if ((unsigned long)p->port < (unsigned long)port)
 			break;
 	}


