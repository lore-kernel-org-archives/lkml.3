Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463Ab3H2VVQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 17:21:16 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:60144 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570Ab3H2VVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 17:21:10 -0400
MIME-Version: 1.0
Date: Thu, 29 Aug 2013 23:21:09 +0200
X-Google-Sender-Auth: aKfCTyDovMFK7NMMvqVb--EScSk
Message-ID: <CAMuHMdVG9FmZNayrf7HMz4kC4X5QELeXUFjjzpAM80ND_QOm8A@mail.gmail.com>
Subject: [-next] openvswitch BUILD_BUG_ON failed
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andy Zhou <azhou@nicira.com>, Jesse Gross <jesse@nicira.com>
Cc: dev@openvswitch.org, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Next <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On m68k, where the alignment of 32-bit words is 2 bytes:

net/openvswitch/flow.c:1984:2: error: call to
'__compiletime_assert_1984' declared with attribute error:
BUILD_BUG_ON failed: sizeof(struct sw_flow_key) % sizeof(long)

(http://kisskb.ellerman.id.au/kisskb/buildresult/9422860/)

This was introduced by commit 5828cd9a68873df1340b420371c02c47647878fb
Author: Andy Zhou <azhou@nicira.com>
Date:   Tue Aug 27 13:02:21 2013 -0700

    openvswitch: optimize flow compare and mask functions

    Make sure the sw_flow_key structure and valid mask boundaries are always
    machine word aligned. Optimize the flow compare and mask operations
    using machine word size operations. This patch improves throughput on
    average by 15% when CPU is the bottleneck of forwarding packets.

    This patch is inspired by ideas and code from a patch submitted by Peter
    Klausler titled "replace memcmp() with specialized comparator".
    However, The original patch only optimizes for architectures
    support unaligned machine word access. This patch optimizes for all
    architectures.

A quick fix to satisfy the build check is to make the padding explicit
(gmail-whitespace-damaged diff):

diff --git a/net/openvswitch/flow.h b/net/openvswitch/flow.h
index b65f885..15f08d9 100644
--- a/net/openvswitch/flow.h
+++ b/net/openvswitch/flow.h
@@ -78,6 +78,7 @@ struct sw_flow_key {
                u32     priority;       /* Packet QoS priority. */
                u32     skb_mark;       /* SKB mark. */
                u16     in_port;        /* Input switch port (or DP_MAX_PORTS).
+               u16     pad;
        } phy;
        struct {
                u8     src[ETH_ALEN];   /* Ethernet source address. */

However, I have some doubts about other alignment "enforcements":

"__aligned(__alignof__(long))" makes the whole struct aligned to the
alignment rule for "long":
   1. This is only 2 bytes on m68k, i.e. != sizeof(long).
   2. This is 4 bytes on many 32-bit platforms, which may be less than the
      default alignment for "__be64" (cfr. some members of struct
      ovs_key_ipv4_tunnel), so this may make those 64-bit members unaligned.
I guess you want (at least) 4 byte alignment on 32-bit, and prefer 8 byte
alignment on 64-bit?
Not specifying any alignment constraint will give you most of that (except
on 64-bit platforms where 64-bit words must be only 4-byte aligned).

There's another build check "BUILD_BUG_ON(sizeof(long) % sizeof(u32))".
Isn't this always true on Linux, as "long" is never smaller than 4 bytes?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
