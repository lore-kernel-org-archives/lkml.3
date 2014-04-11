Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759636AbaDKQpP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 12:45:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56598 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759583AbaDKQJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 12:09:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jan Stancek <jstancek@redhat.com>,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@web.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.13 24/65] bridge: multicast: add sanity check for general query destination
Date: Fri, 11 Apr 2014 09:10:56 -0700
Message-Id: <20140411161001.037644495@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140411160957.714773410@linuxfoundation.org>
References: <20140411160957.714773410@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@web.de>

[ Upstream commit 9ed973cc40c588abeaa58aea0683ea665132d11d ]

General IGMP and MLD queries are supposed to have the multicast
link-local all-nodes address as their destination according to RFC2236
section 9, RFC3376 section 4.1.12/9.1, RFC2710 section 8 and RFC3810
section 5.1.15.

Without this check, such malformed IGMP/MLD queries can result in a
denial of service: The queries are ignored by most IGMP/MLD listeners
therefore they will not respond with an IGMP/MLD report. However,
without this patch these malformed MLD queries would enable the
snooping part in the bridge code, potentially shutting down the
according ports towards these hosts for multicast traffic as the
bridge did not learn about these listeners.

Reported-by: Jan Stancek <jstancek@redhat.com>
Signed-off-by: Linus Lüssing <linus.luessing@web.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/br_multicast.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1181,6 +1181,14 @@ static int br_ip4_multicast_query(struct
 			    IGMPV3_MRC(ih3->code) * (HZ / IGMP_TIMER_SCALE) : 1;
 	}
 
+	/* RFC2236+RFC3376 (IGMPv2+IGMPv3) require the multicast link layer
+	 * all-systems destination addresses (224.0.0.1) for general queries
+	 */
+	if (!group && iph->daddr != htonl(INADDR_ALLHOSTS_GROUP)) {
+		err = -EINVAL;
+		goto out;
+	}
+
 	br_multicast_query_received(br, port, &br->ip4_querier, !!iph->saddr,
 				    max_delay);
 
@@ -1228,6 +1236,7 @@ static int br_ip6_multicast_query(struct
 	unsigned long max_delay;
 	unsigned long now = jiffies;
 	const struct in6_addr *group = NULL;
+	bool is_general_query;
 	int err = 0;
 
 	spin_lock(&br->multicast_lock);
@@ -1262,6 +1271,16 @@ static int br_ip6_multicast_query(struct
 		max_delay = max(msecs_to_jiffies(mldv2_mrc(mld2q)), 1UL);
 	}
 
+	is_general_query = group && ipv6_addr_any(group);
+
+	/* RFC2710+RFC3810 (MLDv1+MLDv2) require the multicast link layer
+	 * all-nodes destination address (ff02::1) for general queries
+	 */
+	if (is_general_query && !ipv6_addr_is_ll_all_nodes(&ip6h->daddr)) {
+		err = -EINVAL;
+		goto out;
+	}
+
 	br_multicast_query_received(br, port, &br->ip6_querier,
 				    !ipv6_addr_any(&ip6h->saddr), max_delay);
 


