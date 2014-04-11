Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423006AbaDKQ4k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 12:56:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56509 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422754AbaDKQIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 12:08:54 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Anton Nayshtut <anton@swortex.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.13 12/65] ipv6: Fix exthdrs offload registration.
Date: Fri, 11 Apr 2014 09:10:44 -0700
Message-Id: <20140411160959.406136998@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140411160957.714773410@linuxfoundation.org>
References: <20140411160957.714773410@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Nayshtut <anton@swortex.com>

[ Upstream commit d2d273ffabd315eecefce21a4391d44b6e156b73 ]

Without this fix, ipv6_exthdrs_offload_init doesn't register IPPROTO_DSTOPTS
offload, but returns 0 (as the IPPROTO_ROUTING registration actually succeeds).

This then causes the ipv6_gso_segment to drop IPv6 packets with IPPROTO_DSTOPTS
header.

The issue detected and the fix verified by running MS HCK Offload LSO test on
top of QEMU Windows guests, as this test sends IPv6 packets with
IPPROTO_DSTOPTS.

Signed-off-by: Anton Nayshtut <anton@swortex.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/exthdrs_offload.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/ipv6/exthdrs_offload.c
+++ b/net/ipv6/exthdrs_offload.c
@@ -25,11 +25,11 @@ int __init ipv6_exthdrs_offload_init(voi
 	int ret;
 
 	ret = inet6_add_offload(&rthdr_offload, IPPROTO_ROUTING);
-	if (!ret)
+	if (ret)
 		goto out;
 
 	ret = inet6_add_offload(&dstopt_offload, IPPROTO_DSTOPTS);
-	if (!ret)
+	if (ret)
 		goto out_rt;
 
 out:


