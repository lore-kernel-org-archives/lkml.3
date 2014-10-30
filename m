Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760798AbaJ3SmF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 14:42:05 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:57261 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759077AbaJ3SmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 14:42:02 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc: netdev@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        davem@davemloft.net, stephen@networkplumber.org,
        akpm@linux-foundation.org, luto@amacapital.net, cwang@twopensource.com
References: <1412257690-31253-1-git-send-email-nicolas.dichtel@6wind.com>
	<1414682728-4532-1-git-send-email-nicolas.dichtel@6wind.com>
Date: Thu, 30 Oct 2014 11:41:03 -0700
In-Reply-To: <1414682728-4532-1-git-send-email-nicolas.dichtel@6wind.com>
	(Nicolas Dichtel's message of "Thu, 30 Oct 2014 16:25:24 +0100")
Message-ID: <871tpph03k.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/CxYbzDghMP3hf8hymelgBMVbb8pF52Dk=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Nicolas Dichtel <nicolas.dichtel@6wind.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 1592 ms - load_scoreonly_sql: 0.06 (0.0%),
	signal_user_changed: 3.5 (0.2%), b_tie_ro: 2.5 (0.2%), parse: 0.77 (0.0%),
	extract_message_metadata: 17 (1.1%), get_uri_detail_list: 3.0 (0.2%),
	tests_pri_-1000: 7 (0.5%), tests_pri_-950: 1.31 (0.1%), tests_pri_-900: 1.13
	(0.1%), tests_pri_-400: 29 (1.8%), check_bayes: 27 (1.7%), b_tokenize: 9
	(0.5%), b_tok_get_all: 10 (0.6%), b_comp_prob: 2.7 (0.2%), b_tok_touch_all:
	3.2 (0.2%), b_finish: 0.73 (0.0%), tests_pri_0: 448 (28.1%), tests_pri_500:
	1081 (67.9%), poll_dns_idle: 1070 (67.2%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH net-next v4 0/4] netns: allow to identify peer netns
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Dichtel <nicolas.dichtel@6wind.com> writes:

> The goal of this serie is to be able to multicast netlink messages with an
> attribute that identify a peer netns.
> This is needed by the userland to interpret some informations contained in
> netlink messages (like IFLA_LINK value, but also some other attributes in case
> of x-netns netdevice (see also
> http://thread.gmane.org/gmane.linux.network/315933/focus=316064 and
> http://thread.gmane.org/gmane.linux.kernel.containers/28301/focus=4239)).
>
> Ids of peer netns are set by userland via a new genl messages. These ids are
> stored per netns and are local (ie only valid in the netns where they are set).
> To avoid allocating an int for each peer netns, I use idr_for_each() to retrieve
> the id of a peer netns. Note that it will be possible to add a table (struct net
> -> id) later to optimize this lookup if needed.
>
> Patch 1/4 introduces the netlink API mechanism to set and get these ids.
> Patch 2/4 and 3/4 implements an example of how to use these ids in rtnetlink
> messages. And patch 4/4 shows that the netlink messages can be symetric between
> a GET and a SET.
>
> iproute2 patches are available, I can send them on demand.

A quick reply.  I think this patchset is in the right general direction.
There are some oddball details that seem odd/awkward to me such as using
genetlink instead of rtnetlink to get and set the ids, and not having
ids if they are not set (that feels like a maintenance/usability challenge).

I would like to give your patches a deep review, but I won't be able to
do that for a couple of weeks.  I am deep in the process of moving,
and will be mostly offline until about the Nov 11th.

Eric


> Here is a small screenshot to show how it can be used by userland.
>
> First, setup netns and required ids:
> $ ip netns add foo
> $ ip netns del foo
> $ ip netns
> $ touch /var/run/netns/init_net
> $ mount --bind /proc/1/ns/net /var/run/netns/init_net
> $ ip netns add foo
> $ ip netns exec foo ip netns set init_net 0
> $ ip netns
> foo
> init_net
> $ ip netns exec foo ip netns
> foo
> init_net (id: 0)
>
> Now, add and display an ipip tunnel, with its link part in init_net (id 0 in
> netns foo) and the netdevice in foo:
> $ ip netns exec foo ip link add ipip1 link-netnsid 0 type ipip remote 10.16.0.121 local 10.16.0.249
> $ ip netns exec foo ip l ls ipip1
> 6: ipip1@NONE: <POINTOPOINT,NOARP> mtu 1480 qdisc noop state DOWN mode DEFAULT group default 
>     link/ipip 10.16.0.249 peer 10.16.0.121 link-netnsid 0
>
> The parameter link-netnsid shows us where the interface sends and receives
> packets (and thus we know where encapsulated addresses are set).
>
> RFCv3 -> v4:
>   rebase on net-next
>   add copyright text in the new netns.h file
>
> RFCv2 -> RFCv3:
>   ids are now defined by userland (via netlink). Ids are stored in each netns
>   (and they are local to this netns).
>   add get_link_net support for ip6 tunnels
>   netnsid is now a s32 instead of a u32
>
> RFCv1 -> RFCv2:
>   remove useless ()
>   ids are now stored in the user ns. It's possible to get an id for a peer netns
>   only if the current netns and the peer netns have the same user ns parent.
>
>  MAINTAINERS                  |   1 +
>  include/net/ip6_tunnel.h     |   1 +
>  include/net/ip_tunnels.h     |   1 +
>  include/net/net_namespace.h  |   5 ++
>  include/net/rtnetlink.h      |   2 +
>  include/uapi/linux/Kbuild    |   1 +
>  include/uapi/linux/if_link.h |   1 +
>  include/uapi/linux/netns.h   |  38 +++++++++
>  net/core/net_namespace.c     | 195 +++++++++++++++++++++++++++++++++++++++++++
>  net/core/rtnetlink.c         |  38 ++++++++-
>  net/ipv4/ip_gre.c            |   2 +
>  net/ipv4/ip_tunnel.c         |   8 ++
>  net/ipv4/ip_vti.c            |   1 +
>  net/ipv4/ipip.c              |   1 +
>  net/ipv6/ip6_gre.c           |   1 +
>  net/ipv6/ip6_tunnel.c        |   9 ++
>  net/ipv6/ip6_vti.c           |   1 +
>  net/ipv6/sit.c               |   1 +
>  net/netlink/genetlink.c      |   4 +
>  19 files changed, 308 insertions(+), 3 deletions(-)
>
> Comments are welcome.
>
> Regards,
> Nicolas
