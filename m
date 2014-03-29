Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751425AbaC2EXT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 00:23:19 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:34682 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbaC2EXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 00:23:17 -0400
MIME-Version: 1.0
In-Reply-To: <14017949.8501396063313587.JavaMail.weblogic@epml02>
References: <14017949.8501396063313587.JavaMail.weblogic@epml02>
Date: Fri, 28 Mar 2014 21:23:17 -0700
Message-ID: <CAM_iQpVwimkp4f5afZZ+16bupMJ-dE2zPrrTJA2EF5-SPZksRQ@mail.gmail.com>
Subject: Re: latest 3.14.0-rc8+ : "INFO: inconsistent lock state "
From: Cong Wang <xiyou.wangcong@gmail.com>
To: jongman.heo@samsung.com
Cc: linux-net@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2014 at 8:21 PM, Jongman Heo <jongman.heo@samsung.com> wrote:
>
> Hi, guys,
>
> With today's linus git tree, I got following messages;
>
> [   97.426196] =================================
> [   97.426198] [ INFO: inconsistent lock state ]
> [   97.426221] 3.14.0-rc8+ #45 Tainted: G        W
> [   97.426224] ---------------------------------
> [   97.426227] inconsistent {IN-SOFTIRQ-W} -> {SOFTIRQ-ON-W} usage.
> [   97.426229] kworker/7:1/101 [HC0[0]:SC0[0]:HE1:SE1] takes:
> [   97.426231]  (&addrconf_stats->syncp.seq){+.?...}, at: [<c0ac9c81>] mld_send_initial_cr.part.30+0x81/0xa0
> [   97.426255] {IN-SOFTIRQ-W} state was registered at:
> [   97.426258]   [<c04a8514>] __lock_acquire+0x414/0x18e0
> [   97.426265]   [<c04a9a78>] lock_acquire+0x98/0x120
> [   97.426268]   [<c0ac91cf>] mld_sendpack+0xdf/0x5b0
> [   97.426270]   [<c0acaaf1>] mld_ifc_timer_expire+0x191/0x2c0
> [   97.426272]   [<c0465a35>] call_timer_fn+0x75/0x160
> [   97.426276]   [<c0466762>] run_timer_softirq+0x192/0x230
> [   97.426281]   [<c045fcbb>] __do_softirq+0xfb/0x2b0
> [   97.426286] irq event stamp: 33365
> [   97.426289] hardirqs last  enabled at (33365): [<c045ffcb>] __local_bh_enable_ip+0x6b/0xc0
> [   97.426292] hardirqs last disabled at (33363): [<c045fd05>] __do_softirq+0x145/0x2b0
> [   97.426294] softirqs last  enabled at (33364): [<c045fd64>] __do_softirq+0x1a4/0x2b0
> [   97.426297] softirqs last disabled at (33341): [<c0414335>] do_softirq_own_stack+0x35/0x40
> [   97.426303]
> other info that might help us debug this:
> [   97.426305]  Possible unsafe locking scenario:
>
> [   97.426306]        CPU0
> [   97.426307]        ----
> [   97.426308]   lock(&addrconf_stats->syncp.seq);
> [   97.426310]   <Interrupt>
> [   97.426311]     lock(&addrconf_stats->syncp.seq);
> [   97.426313]
>  *** DEADLOCK ***

Does the following patch help?

diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index e1e4735..74a774a 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -1588,7 +1588,7 @@ static void mld_sendpack(struct sk_buff *skb)

        rcu_read_lock();
        idev = __in6_dev_get(skb->dev);
-       IP6_UPD_PO_STATS(net, idev, IPSTATS_MIB_OUT, skb->len);
+       IP6_UPD_PO_STATS_BH(net, idev, IPSTATS_MIB_OUT, skb->len);

        payload_len = (skb_tail_pointer(skb) - skb_network_header(skb)) -
                sizeof(*pip6);
