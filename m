Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849AbaANApZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 19:45:25 -0500
Received: from webmail.solarflare.com ([12.187.104.25]:14376 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074AbaANApU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:45:20 -0500
Message-ID: <1389660315.2025.169.camel@bwh-desktop.uk.level5networks.com>
Subject: Re: [PATCH 3.12 40/77] sfc: Add length checks to
 efx_xmit_with_hwtstamp() and efx_ptp_is_ptp_tx()
From: Ben Hutchings <bhutchings@solarflare.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        linux-net-drivers <linux-net-drivers@solarflare.com>
Date: Tue, 14 Jan 2014 00:45:15 +0000
In-Reply-To: <20140114002753.640936297@linuxfoundation.org>
References: <20140114002752.497010554@linuxfoundation.org>
	 <20140114002753.640936297@linuxfoundation.org>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-20424.000
X-TM-AS-Result: No--21.273700-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-01-13 at 16:28 -0800, Greg Kroah-Hartman wrote:
> 3.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Ben Hutchings <bhutchings@solarflare.com>
> 
> [ Upstream commit e5a498e943fbc497f236ab8cf31366c75f337ce6 ]
> 
> efx_ptp_is_ptp_tx() must be robust against skbs from raw sockets that
> have invalid IPv4 and UDP headers.
> 
> Add checks that:
> - the transport header has been found
> - there is enough space between network and transport header offset
>   for an IPv4 header
> - there is enough space after the transport header offset for a
>   UDP header
> 
> Fixes: 7c236c43b838 ('sfc: Add support for IEEE-1588 PTP')

All the PTP fixes for sfc (40-44 in this series) logically apply to
3.10.y as well.  David, did you find conflicts there?

Ben.

> Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/net/ethernet/sfc/ptp.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> --- a/drivers/net/ethernet/sfc/ptp.c
> +++ b/drivers/net/ethernet/sfc/ptp.c
> @@ -989,7 +989,11 @@ bool efx_ptp_is_ptp_tx(struct efx_nic *e
>  		skb->len >= PTP_MIN_LENGTH &&
>  		skb->len <= MC_CMD_PTP_IN_TRANSMIT_PACKET_MAXNUM &&
>  		likely(skb->protocol == htons(ETH_P_IP)) &&
> +		skb_transport_header_was_set(skb) &&
> +		skb_network_header_len(skb) >= sizeof(struct iphdr) &&
>  		ip_hdr(skb)->protocol == IPPROTO_UDP &&
> +		skb_headlen(skb) >=
> +		skb_transport_offset(skb) + sizeof(struct udphdr) &&
>  		udp_hdr(skb)->dest == htons(PTP_EVENT_PORT);
>  }
>  
> 
> 

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

