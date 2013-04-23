Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932066Ab3DWTT4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 15:19:56 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:54791 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757028Ab3DWTTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 15:19:54 -0400
Date: Tue, 23 Apr 2013 15:19:49 -0400 (EDT)
Message-Id: <20130423.151949.1174398672200053405.davem@davemloft.net>
To: rdunlap@infradead.org
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: linux-next: Tree for Apr 23 (netlink)
From: David Miller <davem@davemloft.net>
In-Reply-To: <5176CD22.6070906@infradead.org>
References: <20130423180028.e08f92e6cc72105f67b77491@canb.auug.org.au>
	<5176CD22.6070906@infradead.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Tue, 23 Apr 2013 12:19:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Date: Tue, 23 Apr 2013 11:04:18 -0700

> On 04/23/13 01:00, Stephen Rothwell wrote:
>> Hi all,
>> 
>> Changes since 20130422:
>> 
>> The net-next tree lost its build failure but gained another for which I
>> applied a patch.
>> 
> 
> 
> when CONFIG_NETLINK_MMAP is not enabled:
> 
> net/netlink/diag.c: In function 'sk_diag_put_rings_cfg':
> net/netlink/diag.c:28:17: error: 'struct netlink_sock' has no member named 'pg_vec_lock'
> net/netlink/diag.c:29:29: error: 'struct netlink_sock' has no member named 'rx_ring'
> net/netlink/diag.c:31:30: error: 'struct netlink_sock' has no member named 'tx_ring'
> net/netlink/diag.c:33:19: error: 'struct netlink_sock' has no member named 'pg_vec_lock'

Thanks Randy, I'm testing out the following fix:

diff --git a/net/netlink/diag.c b/net/netlink/diag.c
index 4e4aa47..1af2962 100644
--- a/net/netlink/diag.c
+++ b/net/netlink/diag.c
@@ -7,6 +7,7 @@
 
 #include "af_netlink.h"
 
+#ifdef CONFIG_NETLINK_MMAP
 static int sk_diag_put_ring(struct netlink_ring *ring, int nl_type,
 			    struct sk_buff *nlskb)
 {
@@ -34,6 +35,12 @@ static int sk_diag_put_rings_cfg(struct sock *sk, struct sk_buff *nlskb)
 
 	return ret;
 }
+#else
+static int sk_diag_put_rings_cfg(struct sock *sk, struct sk_buff *nlskb)
+{
+	return 0;
+}
+#endif
 
 static int sk_diag_dump_groups(struct sock *sk, struct sk_buff *nlskb)
 {
