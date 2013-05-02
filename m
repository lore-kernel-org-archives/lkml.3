Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861Ab3EBEzk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 00:55:40 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:35866 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab3EBEzj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 00:55:39 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzinZSQAS6GW6vYOyQ06+GSMqkCGb8Fu829s_MxY0L0QA@mail.gmail.com>
References: <20130501.164755.1859264969403837546.davem@davemloft.net>
	<CA+55aFzsvyQLLKbuETBqfhpgkSaXH9cvT0O-cQ-mTTXXxcMqwg@mail.gmail.com>
	<CA+55aFzinZSQAS6GW6vYOyQ06+GSMqkCGb8Fu829s_MxY0L0QA@mail.gmail.com>
Date: Wed, 1 May 2013 21:55:38 -0700
X-Google-Sender-Auth: YEeIiJyCXgf7BgvJSig66oFkzw4
Message-ID: <CA+55aFxoP1vybnqdDwGmd-m0j=x=KDm7GHV6J1i8wGOaU0=5qw@mail.gmail.com>
Subject: Re: [GIT] Networking
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Miller <davem@davemloft.net>, hayeswang <hayeswang@realtek.com>,
        Patrick McHardy <kaber@trash.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 1, 2013 at 9:37 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I don't see what could be broken in that commit, and I'd *like* to
> just revert it on top of current -git, but that causes problems
> ("error: ‘NETIF_F_HW_VLAN_STAG_TX_BIT’ undeclared"), so I can't just
> do a straight revert to double-check with the current tree state. But
> the bisection was very straightforward, and as mentioned, I checked
> that boundary several times just because it looked so odd.

Ok, this is just f*cking odd.

So I first tried to revert commit 8ad227ff89a7 but leave the new
*_HW_VLAN_STAG_* bit definitions in place so that it would compile
without that error. That still resulted in a non-working network.

So then I start getting desperate, and say to myself "maybe the bit
positions matter". So do a full revert (so that those bits are no
longer enumerated), and then to make things compile for me I comment
out the uses I hit in my build:

diff --git a/net/core/ethtool.c b/net/core/ethtool.c
index 5a934ef90f8b..df019a7ab51e 100644
--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@ -64,9 +64,11 @@ static const char
netdev_features_strings[NETDEV_FEATURE_COUNT][ETH_GST

        [NETIF_F_HW_VLAN_CTAG_RX_BIT] =  "rx-vlan-ctag-hw-parse",
        [NETIF_F_HW_VLAN_CTAG_FILTER_BIT] = "rx-vlan-ctag-filter",
+#if 0
        [NETIF_F_HW_VLAN_STAG_TX_BIT] =  "tx-vlan-stag-hw-insert",
        [NETIF_F_HW_VLAN_STAG_RX_BIT] =  "rx-vlan-stag-hw-parse",
        [NETIF_F_HW_VLAN_STAG_FILTER_BIT] = "rx-vlan-stag-filter",
+#endif
        [NETIF_F_VLAN_CHALLENGED_BIT] =  "vlan-challenged",
        [NETIF_F_GSO_BIT] =              "tx-generic-segmentation",
        [NETIF_F_LLTX_BIT] =             "tx-lockless",

and guess what? I have working networking again.

So either this is some very odd heisenbug (but quite frankly, it
bisected perfectly, and reverting it *does* fix it with the above
addition), or the bit positions for those NETIF constants matter.

I think the positions of those bits matter, and adding
NETIF_F_HW_VLAN_STAG_*_BIT randomly in the middle broke things. That's
backed up by the fact that we have things like

      __UNUSED_NETIF_F_1

and

          /**/NETIF_F_GSO_SHIFT,          /* keep the order of SKB_GSO_* bits */
        NETIF_F_TSO_BIT                 /* ... TCPv4 segmentation */
                = NETIF_F_GSO_SHIFT,

in that array. There is some ordering, and there is some meaning to
the bit numbers, and adding the *_STAG_* bits in the middle broke some
subtle dependency.

That's as far as I'm going to be able to debug this. I've pinpointed
the commit, and I think I've pinpointed the approximate cause. Pls get
my networking going again without my disgusting local hack..

               Linus
