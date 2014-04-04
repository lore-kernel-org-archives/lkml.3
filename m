Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180AbaDDXGW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 19:06:22 -0400
Received: from na3sys009aog138.obsmtp.com ([74.125.149.19]:47215 "HELO
	na3sys009aog138.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751879AbaDDXGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 19:06:20 -0400
MIME-Version: 1.0
In-Reply-To: <1396398194-4163-1-git-send-email-asuka.com@163.com>
References: <1396398194-4163-1-git-send-email-asuka.com@163.com>
From: Jesse Gross <jesse@nicira.com>
Date: Fri, 4 Apr 2014 16:05:59 -0700
Message-ID: <CAEP_g=9WRyaSmRKHDZmWXwzjDyex8NheyveGzfH4qmMbhgGHdQ@mail.gmail.com>
Subject: Re: [PATCH v2] openvswitch: supply a dummy err_handler of
 gre_cisco_protocol to prevent kernel crash
To: Wei Zhang <asuka.com@163.com>
Cc: David Miller <davem@davemloft.net>,
        "dev@openvswitch.org" <dev@openvswitch.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 1, 2014 at 5:23 PM, Wei Zhang <asuka.com@163.com> wrote:
> When use gre vport, openvswitch register a gre_cisco_protocol but does not
> supply a err_handler with it. The gre_cisco_err() in net/ipv4/gre_demux.c expect
> err_handler be provided with the gre_cisco_protocol implementation, and call
> ->err_handler() without existence check, cause the kernel crash.
>
> This patch provide a err_handler to fix this bug.
>
> v2 -> v1: use the same logic of the gre_rcv() to distinguish which packet is
> intended to us!

As a tip on kernel process: if you put the version information after
three dashes below the signed-off-by line then git will automatically
remove it when the final patch is applied.

> diff --git a/net/openvswitch/vport-gre.c b/net/openvswitch/vport-gre.c
> index a3d6951..f391df1 100644
> --- a/net/openvswitch/vport-gre.c
> +++ b/net/openvswitch/vport-gre.c
> @@ -110,6 +110,21 @@ static int gre_rcv(struct sk_buff *skb,
>         return PACKET_RCVD;
>  }
>
> +/* Called with rcu_read_lock and BH disabled. */
> +static int gre_err(struct sk_buff *skb, u32 info,
> +                  const struct tnl_ptk_info *tpi)
> +{
> +       struct ovs_net *ovs_net;
> +       struct vport *vport;
> +
> +       ovs_net = net_generic(dev_net(skb->dev), ovs_net_id);
> +       vport = rcu_dereference(ovs_net->vport_net.gre_vport);
> +       if (unlikely(!vport))
> +               return PACKET_REJECT;
> +       else
> +               return PACKET_RCVD;

Sorry, I forgot to say this before - if we receive the packet then we
should also call consume_skb() on it.
