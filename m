Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768Ab3CRErQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 00:47:16 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33447 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751651Ab3CREaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 00:30:20 -0400
Message-Id: <20130318042151.545639263@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 18 Mar 2013 04:22:59 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Sven Eckelmann <sven@narfation.org>,
        Marek Lindner <lindner_marek@yahoo.de>
Subject: [ 75/82] batman-adv: Only write requested number of byte to user buffer
In-Reply-To: <20130318042144.234468645@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d98f:da4e:f620:7bea
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit b5a1eeef04cc7859f34dec9b72ea1b28e4aba07c upstream.

Don't write more than the requested number of bytes of an batman-adv icmp
packet to the userspace buffer. Otherwise unrelated userspace memory might get
overridden by the kernel.

Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Marek Lindner <lindner_marek@yahoo.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/batman-adv/icmp_socket.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/net/batman-adv/icmp_socket.c
+++ b/net/batman-adv/icmp_socket.c
@@ -136,10 +136,9 @@ static ssize_t bat_socket_read(struct fi
 
 	spin_unlock_bh(&socket_client->lock);
 
-	error = copy_to_user(buf, &socket_packet->icmp_packet,
-			     socket_packet->icmp_len);
+	packet_len = min(count, socket_packet->icmp_len);
+	error = copy_to_user(buf, &socket_packet->icmp_packet, packet_len);
 
-	packet_len = socket_packet->icmp_len;
 	kfree(socket_packet);
 
 	if (error)


