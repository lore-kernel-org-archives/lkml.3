Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513AbaIKPBN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 11:01:13 -0400
Received: from mail.us.es ([193.147.175.20]:43765 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222AbaIKPBJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 11:01:09 -0400
X-Qmail-Scanner-Diagnostics: from 127.0.0.1 by antivirus4 (envelope-from <pneira@us.es>, uid 501) with qmail-scanner-2.10 
 (clamdscan: 0.98.4/19354. spamassassin: 3.3.2.  
 Clear:RC:1(127.0.0.1):SA:0(-98.8/7.5):. 
 Processed in 5.442674 secs); 11 Sep 2014 15:01:07 -0000
X-Spam-ASN: AS12715 87.221.0.0/16
X-Envelope-From: pneira@us.es
Date: Thu, 11 Sep 2014 17:01:56 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jim Davis <jim.epost@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: randconfig build error with next-20140911, in
 net/ipv6/netfilter/nf_nat_masquerade_ipv6.c
Message-ID: <20140911150156.GA5798@salvia>
References: <CA+r1ZhgA_3eYymnfBbTcBG+KoOW_k0hAqO-Z-JPemJCgOMsR=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="XsQoSWH+UP9D9v3l"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+r1ZhgA_3eYymnfBbTcBG+KoOW_k0hAqO-Z-JPemJCgOMsR=A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Thu, Sep 11, 2014 at 07:41:33AM -0700, Jim Davis wrote:
> Building with the attached random configuration file,
> 
> net/ipv6/netfilter/nf_nat_masquerade_ipv6.c: In function
> ‘nf_nat_masquerade_ipv6’:
> net/ipv6/netfilter/nf_nat_masquerade_ipv6.c:41:14: error: ‘struct
> nf_conn_nat’ has no member named ‘masq_index’
>   nfct_nat(ct)->masq_index = out->ifindex;
>               ^
> net/ipv6/netfilter/nf_nat_masquerade_ipv6.c: In function ‘device_cmp’:
> net/ipv6/netfilter/nf_nat_masquerade_ipv6.c:61:12: error: ‘const
> struct nf_conn_nat’ has no member named ‘masq_index’
>   return nat->masq_index == (int)(long)ifindex;
>             ^
> net/ipv6/netfilter/nf_nat_masquerade_ipv6.c:62:1: warning: control
> reaches end of non-void function [-Wreturn-type]
>  }
>  ^
> make[3]: *** [net/ipv6/netfilter/nf_nat_masquerade_ipv6.o] Error 1

Patch attached, thanks for reporting.

--XsQoSWH+UP9D9v3l
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="0001-netfilter-fix-compilation-of-masquerading-without-IP.patch"
Content-Transfer-Encoding: 8bit

>From bc96cd5a3f47e9a6401bc5fb0f7b26145271f6a0 Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Thu, 11 Sep 2014 16:55:04 +0200
Subject: [PATCH nf-next] netfilter: fix compilation of masquerading without IP_NF_TARGET_MASQUERADE
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

 CONFIG_NF_NAT_MASQUERADE_IPV6=m
 # CONFIG_IP6_NF_TARGET_MASQUERADE is not set

results in:

net/ipv6/netfilter/nf_nat_masquerade_ipv6.c: In function ‘nf_nat_masquerade_ipv6’:
net/ipv6/netfilter/nf_nat_masquerade_ipv6.c:41:14: error: ‘struct nf_conn_nat’ has no member named ‘masq_index’
  nfct_nat(ct)->masq_index = out->ifindex;
              ^
net/ipv6/netfilter/nf_nat_masquerade_ipv6.c: In function ‘device_cmp’:
net/ipv6/netfilter/nf_nat_masquerade_ipv6.c:61:12: error: ‘const struct nf_conn_nat’ has no member named ‘masq_index’
  return nat->masq_index == (int)(long)ifindex;
            ^
net/ipv6/netfilter/nf_nat_masquerade_ipv6.c:62:1: warning: control
reaches end of non-void function [-Wreturn-type]
 }
 ^
make[3]: *** [net/ipv6/netfilter/nf_nat_masquerade_ipv6.o] Error 1

Fix this by using the new NF_NAT_MASQUERADE_IPV4 and _IPV6 symbols
in include/net/netfilter/nf_nat.h.

Reported-by: Jim Davis <jim.epost@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_nat.h |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/include/net/netfilter/nf_nat.h b/include/net/netfilter/nf_nat.h
index a71dd33..344b1ab 100644
--- a/include/net/netfilter/nf_nat.h
+++ b/include/net/netfilter/nf_nat.h
@@ -32,10 +32,8 @@ struct nf_conn_nat {
 	struct hlist_node bysource;
 	struct nf_conn *ct;
 	union nf_conntrack_nat_help help;
-#if defined(CONFIG_IP_NF_TARGET_MASQUERADE) || \
-    defined(CONFIG_IP_NF_TARGET_MASQUERADE_MODULE) || \
-    defined(CONFIG_IP6_NF_TARGET_MASQUERADE) || \
-    defined(CONFIG_IP6_NF_TARGET_MASQUERADE_MODULE)
+#if IS_ENABLED(CONFIG_NF_NAT_MASQUERADE_IPV4) || \
+    IS_ENABLED(CONFIG_NF_NAT_MASQUERADE_IPV6)
 	int masq_index;
 #endif
 };
@@ -68,8 +66,8 @@ static inline bool nf_nat_oif_changed(unsigned int hooknum,
 				      struct nf_conn_nat *nat,
 				      const struct net_device *out)
 {
-#if IS_ENABLED(CONFIG_IP_NF_TARGET_MASQUERADE) || \
-    IS_ENABLED(CONFIG_IP6_NF_TARGET_MASQUERADE)
+#if IS_ENABLED(CONFIG_NF_NAT_MASQUERADE_IPV4) || \
+    IS_ENABLED(CONFIG_NF_NAT_MASQUERADE_IPV6)
 	return nat->masq_index && hooknum == NF_INET_POST_ROUTING &&
 	       CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL &&
 	       nat->masq_index != out->ifindex;
-- 
1.7.10.4


--XsQoSWH+UP9D9v3l--
