Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935395Ab3DHSNs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 14:13:48 -0400
Received: from mga03.intel.com ([143.182.124.21]:44226 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934719Ab3DHSNr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 14:13:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,432,1363158000"; 
   d="scan'208";a="224682993"
From: "Rustad, Mark D" <mark.d.rustad@intel.com>
To: Michael Riesch <michael.riesch@omicron.at>
CC: "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Benc <jbenc@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rtnetlink: Call nlmsg_parse() with correct header length
Thread-Topic: [PATCH] rtnetlink: Call nlmsg_parse() with correct header
 length
Thread-Index: AQHONHFFYz6bF+X44UGK1FzxpiedMpjNFgYA
Date: Mon, 8 Apr 2013 18:13:36 +0000
Message-ID: <CD31A507-C3E1-4499-9F06-2F83B3FBFE61@intel.com>
References: <e04bc546-fcf6-41d2-a585-5fddff388e06@mary.at.omicron.at>
In-Reply-To: <e04bc546-fcf6-41d2-a585-5fddff388e06@mary.at.omicron.at>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [134.134.170.158]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2C017A33302C9E4DB393DD3D46112705@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 8, 2013, at 8:45 AM, Michael Riesch <michael.riesch@omicron.at> wrote:

> 
> Signed-off-by: Michael Riesch <michael.riesch@omicron.at>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Jiri Benc <jbenc@redhat.com>
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Cc: linux-kernel@vger.kernel.org
> ---
> Habidere,
> 
> I encountered a netlink kernel warning when running avahi 0.6.31 on my system
> with kernel v3.4.35 (it appears several times):
> 
> 	netlink: 12 bytes leftover after parsing attributes.
> 
> Searching the web showed that commit "115c9b81928360d769a76c632bae62d15206a94a 
> rtnetlink: Fix problem with buffer allocation" introduced this behaviour[1].
> 
> Now I - knowing nothing about netlink whatsoever - assume that the nlmsg_parse
> function is called with the wrong header length. In user space the request
> message consists out of the message header (struct nlmsghdr, 16 bytes) and an
> ifinfomsg (struct ifinfomsg, 16 bytes). After that, request attributes could
> follow. nlmsg_parse checks for this attributes after a given header length. In
> rtnl_get_link() this header length is sizeof(struct ifinfomsg), but in
> rtnl_calcit() as well as in rntl_dump_ifinfo() the header length is
> sizeof(struct rtgenmsg), which is 1 byte.
> 
> With this patch I got rid of these warnings. However, I do not know whether
> this is the correct solution, so I am looking forward to your comments.
> Regards, Michael
> 
> [1] http://lists.infradead.org/pipermail/libnl/2012-April/000515.html
> 
> net/core/rtnetlink.c |    4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> index 900fc61..ebf6ace 100644
> --- a/net/core/rtnetlink.c
> +++ b/net/core/rtnetlink.c
> @@ -1065,7 +1065,7 @@ static int rtnl_dump_ifinfo(struct sk_buff *skb, struct netlink_callback *cb)
> 	rcu_read_lock();
> 	cb->seq = net->dev_base_seq;
> 
> -	if (nlmsg_parse(cb->nlh, sizeof(struct rtgenmsg), tb, IFLA_MAX,
> +	if (nlmsg_parse(cb->nlh, sizeof(struct ifinfomsg), tb, IFLA_MAX,
> 			ifla_policy) >= 0) {
> 
> 		if (tb[IFLA_EXT_MASK])
> @@ -1909,7 +1909,7 @@ static u16 rtnl_calcit(struct sk_buff *skb, struct nlmsghdr *nlh)
> 	u32 ext_filter_mask = 0;
> 	u16 min_ifinfo_dump_size = 0;
> 
> -	if (nlmsg_parse(nlh, sizeof(struct rtgenmsg), tb, IFLA_MAX,
> +	if (nlmsg_parse(nlh, sizeof(struct ifinfomsg), tb, IFLA_MAX,
> 			ifla_policy) >= 0) {
> 		if (tb[IFLA_EXT_MASK])
> 			ext_filter_mask = nla_get_u32(tb[IFLA_EXT_MASK]);
> -- 
> 1.7.9.5


I found that fcoemon has also been triggering these messages for some time. I found the same problem and arrived at exactly the same solution. I would have already sent it, but it is still in validation. As far as I am concerned:

Acked-by: Mark Rustad <mark.d.rustad@intel.com>

-- 
Mark Rustad, Networking Division, Intel Corporation