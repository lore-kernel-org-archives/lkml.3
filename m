Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964857AbaE2FI7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 01:08:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58117 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932676AbaE2Eft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:35:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alexey Preobrazhensky <preobr@google.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 127/140] ipv6: fix calculation of option len in ip6_append_data
Date: Wed, 28 May 2014 21:34:26 -0700
Message-Id: <20140529043105.694886641@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Frederic Sowa <hannes@stressinduktion.org>

[ Upstream commit 3a1cebe7e05027a1c96f2fc1a8eddf5f19b78f42 ]

tot_len does specify the size of struct ipv6_txoptions. We need opt_flen +
opt_nflen to calculate the overall length of additional ipv6 extensions.

I found this while auditing the ipv6 output path for a memory corruption
reported by Alexey Preobrazhensky while he fuzzed an instrumented
AddressSanitizer kernel with trinity. This may or may not be the cause
of the original bug.

Fixes: 4df98e76cde7c6 ("ipv6: pmtudisc setting not respected with UFO/CORK")
Reported-by: Alexey Preobrazhensky <preobr@google.com>
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_output.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1229,7 +1229,7 @@ int ip6_append_data(struct sock *sk, int
 		unsigned int maxnonfragsize, headersize;
 
 		headersize = sizeof(struct ipv6hdr) +
-			     (opt ? opt->tot_len : 0) +
+			     (opt ? opt->opt_flen + opt->opt_nflen : 0) +
 			     (dst_allfrag(&rt->dst) ?
 			      sizeof(struct frag_hdr) : 0) +
 			     rt->rt6i_nfheader_len;


