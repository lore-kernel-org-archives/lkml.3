Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967586AbaFTODB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 10:03:01 -0400
Received: from server721-han.de-nserver.de ([85.158.180.102]:38907 "EHLO
	server721-han.de-nserver.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965829AbaFTOC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 10:02:59 -0400
X-Fcrdns: No
Message-ID: <53A43F04.9080102@kristov.de>
Date: Fri, 20 Jun 2014 16:02:44 +0200
From: Christoph Schulz <develop@kristov.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Michal Ostrowski <mostrows@earthlink.net>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] net: pppoe: use correct MTU when using Multilink PPP with
 PPPoE
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-User-Auth: Auth by mail@kristov.de through 89.182.48.140
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Schulz <develop@kristov.de>

The PPP channel MTU is used with Multilink PPP when ppp_mp_explode() (see
ppp_generic module) tries to determine how big a fragment might be. If we
don't subtract 2 bytes (which corresponds to the PPP protocol number), the
payload becomes 1-2 bytes too big (1 byte if PPP protocol compression is
used, 2 otherwise), which causes the generated Ethernet packets to be dropped.
This is due to code in ppp_mp_explode() which says:

		/*
		 * hdrlen includes the 2-byte PPP protocol field, but the
		 * MTU counts only the payload excluding the protocol field.
		 * (RFC1661 Section 2)
		 */
		mtu = pch->chan->mtu - (hdrlen - 2);

This is correct, but the pppoe module does not account for it and includes
the 2-byte PPP protocol field into the computed MTU, which is wrong. This
error only manifests itself when using Multilink PPP, as otherwise the channel
MTU is not used anywhere.

The bug was introduced in commit c9aa6895371b2a257401f59d3393c9f7ac5a8698
("[PPPOE]: Advertise PPPoE MTU") from the very beginning. This patch applies
cleanly to 3.10 upwards but the fix can be applied (with minor modifications)
to kernels as old as 2.6.32.

Signed-off-by: Christoph Schulz <develop@kristov.de>
---
This is my second Linux kernel patch. If I made something wrong, please tell
me ;-)

Best regards,

Christoph Schulz

diff -urpN linux-3.15.1.orig/drivers/net/ppp/pppoe.c linux-3.15.1/drivers/net/ppp/pppoe.c
--- linux-3.15.1.orig/drivers/net/ppp/pppoe.c	2014-06-08 20:19:54.000000000 +0200
+++ linux-3.15.1/drivers/net/ppp/pppoe.c	2014-06-19 11:27:13.000000000 +0200
@@ -675,7 +675,7 @@ static int pppoe_connect(struct socket *
 		po->chan.hdrlen = (sizeof(struct pppoe_hdr) +
 				   dev->hard_header_len);
 
-		po->chan.mtu = dev->mtu - sizeof(struct pppoe_hdr);
+		po->chan.mtu = dev->mtu - sizeof(struct pppoe_hdr) - 2;
 		po->chan.private = sk;
 		po->chan.ops = &pppoe_chan_ops;
 
