Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759401Ab3DBXAP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 19:00:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33977 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758237Ab3DBWuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:50:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sven Eckelmann <sven@narfation.org>,
        Marek Lindner <lindner_marek@yahoo.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [ 22/56] batman-adv: Only write requested number of byte to user buffer
Date: Tue,  2 Apr 2013 15:49:49 -0700
Message-Id: <20130402224714.460411537@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402224711.840825715@linuxfoundation.org>
References: <20130402224711.840825715@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Sven Eckelmann <sven@narfation.org>

commit b5a1eeef04cc7859f34dec9b72ea1b28e4aba07c upstream.

Don't write more than the requested number of bytes of an batman-adv icmp
packet to the userspace buffer. Otherwise unrelated userspace memory might get
overridden by the kernel.

Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Marek Lindner <lindner_marek@yahoo.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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


