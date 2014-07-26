Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751AbaGZTDI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:03:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33746 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbaGZTDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:03:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 41/56] ipv4: fix buffer overflow in ip_options_compile()
Date: Sat, 26 Jul 2014 12:02:34 -0700
Message-Id: <20140726190201.394760046@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190200.061512159@linuxfoundation.org>
References: <20140726190200.061512159@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 10ec9472f05b45c94db3c854d22581a20b97db41 ]

There is a benign buffer overflow in ip_options_compile spotted by
AddressSanitizer[1] :

Its benign because we always can access one extra byte in skb->head
(because header is followed by struct skb_shared_info), and in this case
this byte is not even used.

[28504.910798] ==================================================================
[28504.912046] AddressSanitizer: heap-buffer-overflow in ip_options_compile
[28504.913170] Read of size 1 by thread T15843:
[28504.914026]  [<ffffffff81802f91>] ip_options_compile+0x121/0x9c0
[28504.915394]  [<ffffffff81804a0d>] ip_options_get_from_user+0xad/0x120
[28504.916843]  [<ffffffff8180dedf>] do_ip_setsockopt.isra.15+0x8df/0x1630
[28504.918175]  [<ffffffff8180ec60>] ip_setsockopt+0x30/0xa0
[28504.919490]  [<ffffffff8181e59b>] tcp_setsockopt+0x5b/0x90
[28504.920835]  [<ffffffff8177462f>] sock_common_setsockopt+0x5f/0x70
[28504.922208]  [<ffffffff817729c2>] SyS_setsockopt+0xa2/0x140
[28504.923459]  [<ffffffff818cfb69>] system_call_fastpath+0x16/0x1b
[28504.924722]
[28504.925106] Allocated by thread T15843:
[28504.925815]  [<ffffffff81804995>] ip_options_get_from_user+0x35/0x120
[28504.926884]  [<ffffffff8180dedf>] do_ip_setsockopt.isra.15+0x8df/0x1630
[28504.927975]  [<ffffffff8180ec60>] ip_setsockopt+0x30/0xa0
[28504.929175]  [<ffffffff8181e59b>] tcp_setsockopt+0x5b/0x90
[28504.930400]  [<ffffffff8177462f>] sock_common_setsockopt+0x5f/0x70
[28504.931677]  [<ffffffff817729c2>] SyS_setsockopt+0xa2/0x140
[28504.932851]  [<ffffffff818cfb69>] system_call_fastpath+0x16/0x1b
[28504.934018]
[28504.934377] The buggy address ffff880026382828 is located 0 bytes to the right
[28504.934377]  of 40-byte region [ffff880026382800, ffff880026382828)
[28504.937144]
[28504.937474] Memory state around the buggy address:
[28504.938430]  ffff880026382300: ........ rrrrrrrr rrrrrrrr rrrrrrrr
[28504.939884]  ffff880026382400: ffffffff rrrrrrrr rrrrrrrr rrrrrrrr
[28504.941294]  ffff880026382500: .....rrr rrrrrrrr rrrrrrrr rrrrrrrr
[28504.942504]  ffff880026382600: ffffffff rrrrrrrr rrrrrrrr rrrrrrrr
[28504.943483]  ffff880026382700: ffffffff rrrrrrrr rrrrrrrr rrrrrrrr
[28504.944511] >ffff880026382800: .....rrr rrrrrrrr rrrrrrrr rrrrrrrr
[28504.945573]                         ^
[28504.946277]  ffff880026382900: ffffffff rrrrrrrr rrrrrrrr rrrrrrrr
[28505.094949]  ffff880026382a00: ffffffff rrrrrrrr rrrrrrrr rrrrrrrr
[28505.096114]  ffff880026382b00: ffffffff rrrrrrrr rrrrrrrr rrrrrrrr
[28505.097116]  ffff880026382c00: ffffffff rrrrrrrr rrrrrrrr rrrrrrrr
[28505.098472]  ffff880026382d00: ffffffff rrrrrrrr rrrrrrrr rrrrrrrr
[28505.099804] Legend:
[28505.100269]  f - 8 freed bytes
[28505.100884]  r - 8 redzone bytes
[28505.101649]  . - 8 allocated bytes
[28505.102406]  x=1..7 - x allocated bytes + (8-x) redzone bytes
[28505.103637] ==================================================================

[1] https://code.google.com/p/address-sanitizer/wiki/AddressSanitizerForKernel

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ip_options.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/ipv4/ip_options.c
+++ b/net/ipv4/ip_options.c
@@ -288,6 +288,10 @@ int ip_options_compile(struct net *net,
 			optptr++;
 			continue;
 		}
+		if (unlikely(l < 2)) {
+			pp_ptr = optptr;
+			goto error;
+		}
 		optlen = optptr[1];
 		if (optlen<2 || optlen>l) {
 			pp_ptr = optptr;


