Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239AbaLDUR1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 15:17:27 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:50159 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbaLDURZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 15:17:25 -0500
MIME-Version: 1.0
In-Reply-To: <1417718366-14310-1-git-send-email-joestringer@nicira.com>
References: <1417718366-14310-1-git-send-email-joestringer@nicira.com>
Date: Thu, 4 Dec 2014 12:17:24 -0800
Message-ID: <CA+mtBx_BiJ526jop1tLhx1ji4beRufQRhiN9nfFBWLnr25DMww@mail.gmail.com>
Subject: Re: [PATCHv3 net] i40e: Implement ndo_gso_check()
From: Tom Herbert <therbert@google.com>
To: Joe Stringer <joestringer@nicira.com>
Cc: Linux Netdev List <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jesse Gross <jesse@nicira.com>,
        Shannon Nelson <shannon.nelson@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "linux.nics" <linux.nics@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 4, 2014 at 10:39 AM, Joe Stringer <joestringer@nicira.com> wrote:
> ndo_gso_check() was recently introduced to allow NICs to report the
> offloading support that they have on a per-skb basis. Add an
> implementation for this driver which checks for IPIP, GRE, UDP tunnels.
>
> Signed-off-by: Joe Stringer <joestringer@nicira.com>
> ---
> v3: Drop IPIP and GRE (no driver support even though hw supports it).
>     Check for UDP outer protocol for UDP tunnels.
> v2: Expand to include IP in IP and IPv4/IPv6 inside GRE/UDP tunnels.
>     Add MAX_INNER_LENGTH (as 80).
> ---
>  drivers/net/ethernet/intel/i40e/i40e_main.c |   26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
>
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
> index c3a7f4a..0d6493a 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_main.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
> @@ -7447,6 +7447,31 @@ static int i40e_ndo_fdb_dump(struct sk_buff *skb,
>
>  #endif /* USE_DEFAULT_FDB_DEL_DUMP */
>  #endif /* HAVE_FDB_OPS */
> +static bool i40e_gso_check(struct sk_buff *skb, struct net_device *dev)
> +{
> +       if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_TUNNEL) {
> +               unsigned char *ihdr;
> +
> +               if (skb->protocol != IPPROTO_UDP ||
> +                   skb->inner_protocol_type != ENCAP_TYPE_ETHER)
> +                       return false;
> +
> +               if (skb->inner_protocol == htons(ETH_P_TEB))
> +                       ihdr = skb_inner_mac_header(skb);
> +               else if (skb->inner_protocol == htons(ETH_P_IP) ||
> +                        skb->inner_protocol == htons(ETH_P_IPV6))
> +                       ihdr = skb_inner_network_header(skb);
> +               else
> +                       return false;
> +

Wow, this is getting complicated! :-( It's not clear that the protocol
specific checks are needed here since it looks like the header length
is being passed to the device later on. Also, I think we need
skb_inner_mac_header(skb) - skb_transport_header(skb) to always work
to give the length of the encapsulation headers (in case there is no
real inner mac header, then that offset should be for the network
header).

So would a simple check like this work:

if (skb->encapsulation &&
    (skb_inner_mac_header(skb) - skb_transport_header(skb)) >
MAX_TUNNEL_HDR_LEN)
       return false;

> +#define MAX_TUNNEL_HDR_LEN     80
> +               if (ihdr - skb_transport_header(skb) > MAX_TUNNEL_HDR_LEN)
> +                       return false;
> +       }
> +
> +       return true;
> +}
> +
>  static const struct net_device_ops i40e_netdev_ops = {
>         .ndo_open               = i40e_open,
>         .ndo_stop               = i40e_close,
> @@ -7487,6 +7512,7 @@ static const struct net_device_ops i40e_netdev_ops = {
>         .ndo_fdb_dump           = i40e_ndo_fdb_dump,
>  #endif
>  #endif
> +       .ndo_gso_check          = i40e_gso_check,
>  };
>
>  /**
> --
> 1.7.10.4
>
