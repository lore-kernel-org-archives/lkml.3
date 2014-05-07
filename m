Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047AbaEGIKt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 04:10:49 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:52852 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbaEGIKr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 04:10:47 -0400
MIME-Version: 1.0
Date: Wed, 7 May 2014 16:10:46 +0800
Message-ID: <CAF-n9KOJWfxic-uB==S0G6NYiVgVq24174NO5GqjD+n4FVDhpw@mail.gmail.com>
Subject: _decode_session6 issue when ipsec packet re routing
From: nickcave <nickcave.zhang@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All:

I am working on android kk4.4 with kernel version 3.10.
I met a problem in IPSec + Ipv6 + Iptables mangle set.

I built a non default network face ccinet0 with ip address
fd00:0:20:1::1:1 and some mangle rules be added (I attached it in the
end ). Then I add an ipsec SA by ip xfrm and try send UDP packet to
fd00:0:20:1::1:4, and I found the packet be send out in plaintext.

Once I delete the mangle rule, It's work well.

So I traced the kernel.

Since the mangle table mark be set.
In ip6t_mangle_out, when the ip6t_do_table be called, the skb need
re-routing by call ip6_route_me_harder.

The result was xfrm policy could not be match in ip6_route_me_harder
and the packet send out in plaintext.

I found it's caused by
    ip6_route_me_harder—>xfrm_decode_session->_decode_session6  the
function get nexthdr from cb ,which is not correct in this case.
    u8 nexthdr = nh[IP6CB(skb)->nhoff]; //in my case, the nexthdr is
always 96,which caused the issue

And I checked the ipv4 code, ipv4 get the protocal info from skb header directly
    const struct iphdr *iph = ip_hdr(skb);

Is it a kernel issue?

Hui Zhang


root@localhost:/ # ip6tables -S -t mangle
ip6tables -S -t mangle
-P PREROUTING ACCEPT
-P INPUT ACCEPT
-P FORWARD ACCEPT
-P OUTPUT ACCEPT
-P POSTROUTING ACCEPT
-N bw_mangle_POSTROUTING
-N idletimer_mangle_POSTROUTING
-N st_mangle_EXEMPT
-N st_mangle_OUTPUT
-N st_mangle_POSTROUTING
-A OUTPUT -j st_mangle_EXEMPT
-A OUTPUT -j st_mangle_OUTPUT
-A POSTROUTING -j bw_mangle_POSTROUTING
-A POSTROUTING -j idletimer_mangle_POSTROUTING
-A POSTROUTING -j st_mangle_POSTROUTING
-A bw_mangle_POSTROUTING -m owner --socket-exists
-A st_mangle_EXEMPT -d fd00:0:20:1::1:4/128 -j MARK --set-xmark 0x1/0xffffffff
-A st_mangle_EXEMPT -d fd00:0:20:1::1:5/128 -j MARK --set-xmark 0x1/0xffffffff
-A st_mangle_OUTPUT -m mark --mark 0x1 -j RETURN
-A st_mangle_OUTPUT -m owner --uid-owner 1016 -j RETURN


root@localhost:/ # ip -6 rule
ip -6 rule
0:      from all lookup local
99:     from all to fd00:0:20:1::1:4 lookup main
99:     from all to fd00:0:20:1::1:5 lookup main
32766:  from all lookup main
32767:  from all lookup default

255|root@localhost:/ # ip -6 route list table all
ip -6 route list table all
default dev ccinet0  table 61  metric 1024
unreachable default dev lo  table 0  proto kernel  metric 4294967295  error -101
unreachable default dev lo  table 0  proto kernel  metric 4294967295  error -101
fd00:0:0:2::/64 dev ccinet0  proto kernel  metric 256
fd00:0:20:1::1:4 dev ccinet0  metric 1024
fd00:0:20:1::1:5 dev ccinet0  metric 1024
fe80::/64 dev ccinet0  proto kernel  metric 256
unreachable default dev lo  table 0  proto kernel  metric 4294967295  error -101
local ::1 dev lo  table local  proto none  metric 0
local fd00:0:0:2::1 dev lo  table local  proto none  metric 0
local fe80::1 dev lo  table local  proto none  metric 0
ff00::/8 dev ccinet0  table local  metric 256
unreachable default dev lo  table 0  proto kernel  metric 4294967295  error -101
