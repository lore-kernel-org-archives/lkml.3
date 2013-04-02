Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758324Ab3DBWun (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:50:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33964 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758208Ab3DBWui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:50:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Matthew Daley <mattjd@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Andrew Hendry <andrew.hendry@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [ 19/56] x25: Validate incoming call user data lengths
Date: Tue,  2 Apr 2013 15:49:46 -0700
Message-Id: <20130402224714.113356130@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402224711.840825715@linuxfoundation.org>
References: <20130402224711.840825715@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Matthew Daley <mattjd@gmail.com>

commit c7fd0d48bde943e228e9c28ce971a22d6a1744c4 upstream.

X.25 call user data is being copied in its entirety from incoming messages
without consideration to the size of the destination buffers, leading to
possible buffer overflows. Validate incoming call user data lengths before
these copies are performed.

It appears this issue was noticed some time ago, however nothing seemed to
come of it: see http://www.spinics.net/lists/linux-x25/msg00043.html and
commit 8db09f26f912f7c90c764806e804b558da520d4f.

Signed-off-by: Matthew Daley <mattjd@gmail.com>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Tested-by: Andrew Hendry <andrew.hendry@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/x25/af_x25.c |    6 ++++++
 net/x25/x25_in.c |    3 +++
 2 files changed, 9 insertions(+)

--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -960,6 +960,12 @@ int x25_rx_call_request(struct sk_buff *
 	skb_pull(skb,len);
 
 	/*
+	 *	Ensure that the amount of call user data is valid.
+	 */
+	if (skb->len > X25_MAX_CUD_LEN)
+		goto out_clear_request;
+
+	/*
 	 *	Find a listener for the particular address/cud pair.
 	 */
 	sk = x25_find_listener(&source_addr,skb);
--- a/net/x25/x25_in.c
+++ b/net/x25/x25_in.c
@@ -127,6 +127,9 @@ static int x25_state1_machine(struct soc
 			 *	Copy any Call User Data.
 			 */
 			if (skb->len > 0) {
+				if (skb->len > X25_MAX_CUD_LEN)
+					goto out_clear;
+
 				skb_copy_from_linear_data(skb,
 					      x25->calluserdata.cuddata,
 					      skb->len);


