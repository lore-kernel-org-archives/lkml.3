Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757707Ab3FLTru (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 15:47:50 -0400
Received: from ja.ssi.bg ([178.16.129.10]:47003 "EHLO ja.ssi.bg"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754764Ab3FLTrt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 15:47:49 -0400
X-Greylist: delayed 517 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Jun 2013 15:47:48 EDT
Date: Wed, 12 Jun 2013 22:43:46 +0300 (EEST)
From: Julian Anastasov <ja@ssi.bg>
To: Alexander Frolkin <avf@eldamar.org.uk>
cc: lvs-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipvs: sloppy TCP and SCTP
In-Reply-To: <20130612104754.GA29327@eldamar.org.uk>
Message-ID: <alpine.LFD.2.00.1306122229120.1773@ja.ssi.bg>
References: <20130612104754.GA29327@eldamar.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


	Hello,

On Wed, 12 Jun 2013, Alexander Frolkin wrote:

> This adds support for sloppy TCP and SCTP mode to IPVS.
> 
> When enabled (sysctls net.ipv4.vs.sloppy_tcp and
> net.ipv4.vs.sloppy_sctp), allows IPVS to create connection state on any
> packet, not just a TCP SYN (or SCTP INIT).
> 
> This allows connections to fail over from one IPVS director to another
> mid-flight.
> 
> Signed-off-by: Alexander Frolkin <avf@eldamar.org.uk>

	extra empty line here

> 
> ---

> diff --git a/net/netfilter/ipvs/ip_vs_proto_sctp.c b/net/netfilter/ipvs/ip_vs_proto_sctp.c
> index 8646488..fd8f587 100644
> --- a/net/netfilter/ipvs/ip_vs_proto_sctp.c
> +++ b/net/netfilter/ipvs/ip_vs_proto_sctp.c

> @@ -27,13 +28,14 @@ sctp_conn_schedule(int af, struct sk_buff *skb, struct ip_vs_proto_data *pd,
>  	if (sch == NULL)
>  		return 0;
>  	net = skb_net(skb);
> +	ipvs = net_ipvs(net);
>  	rcu_read_lock();
> -	if ((sch->type == SCTP_CID_INIT) &&
> +	if ((sysctl_sloppy_sctp(ipvs) || (sch->type == SCTP_CID_INIT)) &&

	Can you change the above line to:

	if ((sch->type == SCTP_CID_INIT || sysctl_sloppy_sctp(ipvs)) &&

	i.e.

1. No () around sch->type == SCTP_CID_INIT

2. Check for sch->type == SCTP_CID_INIT is usually true,
so lets try it first

> diff --git a/net/netfilter/ipvs/ip_vs_proto_tcp.c b/net/netfilter/ipvs/ip_vs_proto_tcp.c
> index 50a1594..3fd23fa 100644
> --- a/net/netfilter/ipvs/ip_vs_proto_tcp.c
> +++ b/net/netfilter/ipvs/ip_vs_proto_tcp.c

> @@ -46,14 +47,15 @@ tcp_conn_schedule(int af, struct sk_buff *skb, struct ip_vs_proto_data *pd,
>  		return 0;
>  	}
>  	net = skb_net(skb);
> +	ipvs = net_ipvs(net);
>  	/* No !th->ack check to allow scheduling on SYN+ACK for Active FTP */
>  	rcu_read_lock();
> -	if (th->syn &&
> +	if ((sysctl_sloppy_tcp(ipvs) || th->syn) && !th->rst &&

	Same here:

	if ((th->syn || sysctl_sloppy_tcp(ipvs)) && !th->rst &&

	Also, you can check the "IPVS" entry in the
MAINTAINERS file for actual list of addresses to use (M and L)
when submitting patches.

Regards

--
Julian Anastasov <ja@ssi.bg>
