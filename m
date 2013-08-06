Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786Ab3HFSc3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 14:32:29 -0400
Received: from mail-vb0-f43.google.com ([209.85.212.43]:39680 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756633Ab3HFSc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 14:32:28 -0400
MIME-Version: 1.0
Date: Tue, 6 Aug 2013 11:32:27 -0700
Message-ID: <CAFErB3XkXnFDeXtd11qJaxkDU10VrPEp=9LAEUqO9FmBRyNHkg@mail.gmail.com>
Subject: Unwanted "Frag needed and DF set" IPSEC ping response due to code
 change in xfrm_policy.c from 2.6.38.8 to 2.6.39
From: Xiachen Dong <xiachendong@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Recently we moved from the 2.6 kernel to the 3.0 kernel. While testing
the branch office vpn with the new kernel, we notice that the new
3.0.xx kernel generates the following response when ping through the
branch office vpn:

ping 3.3.3.100

PING 3.3.3.100 (3.3.3.100) 56(84) bytes of data.

>From 4.4.4.1 icmp_seq=1 Frag needed and DF set (mtu = 552)
64 bytes from 3.3.3.100: icmp_seq=2 ttl=62 time=6.48 ms
64 bytes from 3.3.3.100: icmp_seq=3 ttl=62 time=6.48 ms
...

Please note the message "icmp_seq=1 Frag needed and DF set (mtu =
552)". It occurs for the 1st ping packet. However, such message never
occurs under the 2.6.3[0-8] kernel.

We spent some time trying to figure out how such message comes into
being under the 3.0.xx kernel. Here is the call trace:

ip_forward() in ip_forward.c --> xfrm4_route_forward() in xfrm.h -->
xfrm_route_forward() in xfrm.h --> __xfrm_route_forward() in
xfrm_policy.c --> xfrm_lookup() in xfrm_policy.c

Within xfrm_lookup(), we reach "return make_blackhole(net, family,
dst_orgi);". The make_blackhole() returns a "fake" blackhole route and
the whole call trace returns back to ip_forward() in ip_forward.c:

ipv4/ip_forward.c:

int ip_forward(struct sk_buff *skb)
{
    ...

    if (!xfrm4_route_forward(skb))
        goto drop;

     rt = skb_rtable(skb);

    if (opt->is_strictroute && ip_hdr(skb)->daddr != rt->rt_gateway)
        goto sr_failed;

    if (unlikely(skb->len > dst_mtu(&rt->dst) && !skb_is_gso(skb) &&
             (ip_hdr(skb)->frag_off & htons(IP_DF))) && !skb->local_df) {
        IP_INC_STATS(dev_net(rt->dst.dev), IPSTATS_MIB_FRAGFAILS);
        icmp_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED,
              htonl(dst_mtu(&rt->dst)));
        goto drop;
    }
    ...

}

Since xfrm_lookup() returns a "fake" balckhole rout (!IS_ERR),
__xfrm_route_forward() returns 1. As a result, xfrm4_route_forward()
returns 1. So the packet is not dropped.

Then the code falls through and hits "unlikely(skb->len >
dst_mtu(&rt->dst) ...). Since it is a blackhole route
(dst_mtu(&rt->dst) == 0), "skb->len > dst_mtu(&rt->dst)" is true, so
the kernel calls

 icmp_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED, ...)

That's how mesaage "icmp_seq=1 Frag needed and DF set (mtu = 552)" is generated.

In contrast, in 2.6.3[0-8] kernel, __xfrm_lookup() does not return
make_blackhole(), it returns -EREMOTE instead. Since -EREMOTE is
returned, xfrm_lookup() returns -EAGAIN. As a result, the packet is
dropped in ip_forward() in ipv4/ip_forward.c. That's why we don't see
the same message in 2.6.3[0-8].

Such code change about xfrm_policy.c first occurs in 2.6.39 kernel
(from 2.6.38.8). It appears that the corresponding GIT change are the
following:

http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/net/xfrm/xfrm_policy.c?id=2774c131b1d19920b4587db1cfbd6f0750ad1f15

http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/net/xfrm/xfrm_policy.c?id=452edd598f60522c11f7f88fdbab27eb36509d1a

Our question is, is the message "Frag needed" an expected behavior? If
not, are there any suggestions about the walk around?

Thanks,

Xiachen
