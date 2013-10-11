Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933204Ab3JKUQZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 16:16:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46024 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932298Ab3JKTk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:40:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Daniel Borkmann <dborkman@redhat.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 011/135] net: sctp: fix bug in sctp_poll for SOCK_SELECT_ERR_QUEUE
Date: Fri, 11 Oct 2013 12:38:12 -0700
Message-Id: <20131011193946.455367478@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193945.181603934@linuxfoundation.org>
References: <20131011193945.181603934@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <dborkman@redhat.com>

[ Upstream commit a0fb05d1aef0f5df936f80b726d1b3bfd4275f95 ]

If we do not add braces around ...

  mask |= POLLERR |
          sock_flag(sk, SOCK_SELECT_ERR_QUEUE) ? POLLPRI : 0;

... then this condition always evaluates to true as POLLERR is
defined as 8 and binary or'd with whatever result comes out of
sock_flag(). Hence instead of (X | Y) ? A : B, transform it into
X | (Y ? A : B). Unfortunatelty, commit 8facd5fb73 ("net: fix
smatch warnings inside datagram_poll") forgot about SCTP. :-(

Introduced by 7d4c04fc170 ("net: add option to enable error queue
packets waking select").

Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Cc: Jacob Keller <jacob.e.keller@intel.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Acked-by: Vlad Yasevich <vyasevich@gmail.com>
Acked-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/socket.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -6182,7 +6182,7 @@ unsigned int sctp_poll(struct file *file
 	/* Is there any exceptional events?  */
 	if (sk->sk_err || !skb_queue_empty(&sk->sk_error_queue))
 		mask |= POLLERR |
-			sock_flag(sk, SOCK_SELECT_ERR_QUEUE) ? POLLPRI : 0;
+			(sock_flag(sk, SOCK_SELECT_ERR_QUEUE) ? POLLPRI : 0);
 	if (sk->sk_shutdown & RCV_SHUTDOWN)
 		mask |= POLLRDHUP | POLLIN | POLLRDNORM;
 	if (sk->sk_shutdown == SHUTDOWN_MASK)


