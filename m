Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264AbaCEO0K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:26:10 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41049 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757235AbaCEO0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:26:05 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sabrina Dubroca <sd@queasysnail.net>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 071/131] netpoll: fix netconsole IPv6 setup
Date: Wed,  5 Mar 2014 14:23:15 +0000
Message-Id: <1394029455-23128-72-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
References: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sabrina Dubroca <sd@queasysnail.net>

commit 00fe11b3c67dc670fe6391d22f1fe64e7c99a8ec upstream.

Currently, to make netconsole start over IPv6, the source address
needs to be specified. Without a source address, netpoll_parse_options
assumes we're setting up over IPv4 and the destination IPv6 address is
rejected.

Check if the IP version has been forced by a source address before
checking for a version mismatch when parsing the destination address.

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Acked-by: Cong Wang <cwang@twopensource.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/core/netpoll.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index 0c1482c..462cdc9 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -943,6 +943,7 @@ int netpoll_parse_options(struct netpoll *np, char *opt)
 {
 	char *cur=opt, *delim;
 	int ipv6;
+	bool ipversion_set = false;
 
 	if (*cur != '@') {
 		if ((delim = strchr(cur, '@')) == NULL)
@@ -955,6 +956,7 @@ int netpoll_parse_options(struct netpoll *np, char *opt)
 	cur++;
 
 	if (*cur != '/') {
+		ipversion_set = true;
 		if ((delim = strchr(cur, '/')) == NULL)
 			goto parse_failed;
 		*delim = 0;
@@ -997,7 +999,7 @@ int netpoll_parse_options(struct netpoll *np, char *opt)
 	ipv6 = netpoll_parse_ip_addr(cur, &np->remote_ip);
 	if (ipv6 < 0)
 		goto parse_failed;
-	else if (np->ipv6 != (bool)ipv6)
+	else if (ipversion_set && np->ipv6 != (bool)ipv6)
 		goto parse_failed;
 	else
 		np->ipv6 = (bool)ipv6;
-- 
1.9.0

