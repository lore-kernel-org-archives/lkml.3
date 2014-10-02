Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138AbaJBNsS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 09:48:18 -0400
Received: from 33.106-14-84.ripe.coltfrance.com ([84.14.106.33]:57419 "EHLO
	proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687AbaJBNsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 09:48:14 -0400
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
To: netdev@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: davem@davemloft.net, ebiederm@xmission.com, stephen@networkplumber.org,
        akpm@linux-foundation.org, luto@amacapital.net, cwang@twopensource.com
Subject: [RFC PATCH net-next v3 0/4] netns: allow to identify peer netns
Date: Thu,  2 Oct 2014 15:48:06 +0200
Message-Id: <1412257690-31253-1-git-send-email-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <542D5726.8070308@6wind.com>
References: <542D5726.8070308@6wind.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The goal of this serie is to be able to multicast netlink messages with an
attribute that identify a peer netns.
This is needed by the userland to interpret some informations contained in
netlink messages (like IFLA_LINK value, but also some other attributes in case
of x-netns netdevice (see also
http://thread.gmane.org/gmane.linux.network/315933/focus=316064 and
http://thread.gmane.org/gmane.linux.kernel.containers/28301/focus=4239)).

Ids of peer netns are set by userland via a new genl messages. These ids are
stored per netns and are local (ie only valid in the netns where they are set).
To avoid allocating an int for each peer netns, I use idr_for_each() to retrieve
the id of a peer netns.

Patch 1/4 introduces the netlink API mechanism to set and get these ids.
Patch 2/4 and 3/4 shows an example of how to use these ids in rtnetlink
messages. And patch 4/4 shows that the netlink messages can be symetric between
a GET and a SET.

iproute2 patches are available, I can send them on demand.

Here is a small screenshot to show how it can be used by userland:
$ ip netns add foo
$ ip netns del foo
$ ip netns
$ touch /var/run/netns/init_net
$ mount --bind /proc/1/ns/net /var/run/netns/init_net
$ ip netns add foo
$ ip netns exec foo ip netns set init_net 0
$ ip netns
foo
init_net
$ ip netns exec foo ip netns
foo
init_net (id: 0)
$ ip netns exec foo ip link add ipip1 link-netnsid 0 type ipip remote 10.16.0.121 local 10.16.0.249
$ ip netns exec foo ip l ls ipip1
6: ipip1@NONE: <POINTOPOINT,NOARP> mtu 1480 qdisc noop state DOWN mode DEFAULT group default 
    link/ipip 10.16.0.249 peer 10.16.0.121 link-netnsid 0

The parameter link-netnsid shows us where the interface sends and receives
packets (and thus we know where encapsulated addresses are set).

RFCv2 -> RFCv3:
  ids are now defined by userland (via netlink). Ids are stored in each netns
  (and they are local to this netns).
  add get_link_net support for ip6 tunnels
  netnsid is now a s32 instead of a u32

RFCv1 -> RFCv2:
  remove useless ()
  ids are now stored in the user ns. It's possible to get an id for a peer netns
  only if the current netns and the peer netns have the same user ns parent.

 MAINTAINERS                  |   1 +
 include/net/ip6_tunnel.h     |   1 +
 include/net/ip_tunnels.h     |   1 +
 include/net/net_namespace.h  |   5 ++
 include/net/rtnetlink.h      |   2 +
 include/uapi/linux/Kbuild    |   1 +
 include/uapi/linux/if_link.h |   1 +
 include/uapi/linux/netns.h   |  31 +++++++
 net/core/net_namespace.c     | 195 +++++++++++++++++++++++++++++++++++++++++++
 net/core/rtnetlink.c         |  38 ++++++++-
 net/ipv4/ip_gre.c            |   2 +
 net/ipv4/ip_tunnel.c         |   8 ++
 net/ipv4/ip_vti.c            |   1 +
 net/ipv4/ipip.c              |   1 +
 net/ipv6/ip6_gre.c           |   1 +
 net/ipv6/ip6_tunnel.c        |   9 ++
 net/ipv6/ip6_vti.c           |   1 +
 net/ipv6/sit.c               |   1 +
 net/netlink/genetlink.c      |   4 +
 19 files changed, 301 insertions(+), 3 deletions(-)

Comments are welcome.

Regards,
Nicolas
