Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932570AbaCDUez (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:34:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41517 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932107AbaCDUE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:04:56 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sabrina Dubroca <sd@queasysnail.net>,
        Cong Wang <cwang@twopensource.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 25/97] netpoll: fix netconsole IPv6 setup
Date: Tue,  4 Mar 2014 12:03:38 -0800
Message-Id: <20140304200346.885510126@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200345.895517495@linuxfoundation.org>
References: <20140304200345.895517495@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 00fe11b3c67dc670fe6391d22f1fe64e7c99a8ec ]

Currently, to make netconsole start over IPv6, the source address
needs to be specified. Without a source address, netpoll_parse_options
assumes we're setting up over IPv4 and the destination IPv6 address is
rejected.

Check if the IP version has been forced by a source address before
checking for a version mismatch when parsing the destination address.

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Acked-by: Cong Wang <cwang@twopensource.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/netpoll.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -948,6 +948,7 @@ int netpoll_parse_options(struct netpoll
 {
 	char *cur=opt, *delim;
 	int ipv6;
+	bool ipversion_set = false;
 
 	if (*cur != '@') {
 		if ((delim = strchr(cur, '@')) == NULL)
@@ -960,6 +961,7 @@ int netpoll_parse_options(struct netpoll
 	cur++;
 
 	if (*cur != '/') {
+		ipversion_set = true;
 		if ((delim = strchr(cur, '/')) == NULL)
 			goto parse_failed;
 		*delim = 0;
@@ -1002,7 +1004,7 @@ int netpoll_parse_options(struct netpoll
 	ipv6 = netpoll_parse_ip_addr(cur, &np->remote_ip);
 	if (ipv6 < 0)
 		goto parse_failed;
-	else if (np->ipv6 != (bool)ipv6)
+	else if (ipversion_set && np->ipv6 != (bool)ipv6)
 		goto parse_failed;
 	else
 		np->ipv6 = (bool)ipv6;


