Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642AbaAPKvD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 05:51:03 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44780 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429AbaAPKuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 05:50:35 -0500
Date: Thu, 16 Jan 2014 10:50:26 +0000
From: Luis Henriques <luis.henriques@canonical.com>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        linux-net-drivers <linux-net-drivers@solarflare.com>
Subject: Re: [PATCH 3.12 40/77] sfc: Add length checks to
 efx_xmit_with_hwtstamp() and efx_ptp_is_ptp_tx()
Message-ID: <20140116105026.GA6429@hercules>
References: <20140114002752.497010554@linuxfoundation.org>
 <20140114002753.640936297@linuxfoundation.org>
 <1389660315.2025.169.camel@bwh-desktop.uk.level5networks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389660315.2025.169.camel@bwh-desktop.uk.level5networks.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 12:45:15AM +0000, Ben Hutchings wrote:
> On Mon, 2014-01-13 at 16:28 -0800, Greg Kroah-Hartman wrote:
> > 3.12-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Ben Hutchings <bhutchings@solarflare.com>
> > 
> > [ Upstream commit e5a498e943fbc497f236ab8cf31366c75f337ce6 ]
> > 
> > efx_ptp_is_ptp_tx() must be robust against skbs from raw sockets that
> > have invalid IPv4 and UDP headers.
> > 
> > Add checks that:
> > - the transport header has been found
> > - there is enough space between network and transport header offset
> >   for an IPv4 header
> > - there is enough space after the transport header offset for a
> >   UDP header
> > 
> > Fixes: 7c236c43b838 ('sfc: Add support for IEEE-1588 PTP')
> 
> All the PTP fixes for sfc (40-44 in this series) logically apply to
> 3.10.y as well.  David, did you find conflicts there?
> 
> Ben.

Thank you Ben, I am queuing these 5 commits for the 3.11 kernel.

Cheers,
--
Luis


> > Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
> > Signed-off-by: David S. Miller <davem@davemloft.net>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  drivers/net/ethernet/sfc/ptp.c |    4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > --- a/drivers/net/ethernet/sfc/ptp.c
> > +++ b/drivers/net/ethernet/sfc/ptp.c
> > @@ -989,7 +989,11 @@ bool efx_ptp_is_ptp_tx(struct efx_nic *e
> >  		skb->len >= PTP_MIN_LENGTH &&
> >  		skb->len <= MC_CMD_PTP_IN_TRANSMIT_PACKET_MAXNUM &&
> >  		likely(skb->protocol == htons(ETH_P_IP)) &&
> > +		skb_transport_header_was_set(skb) &&
> > +		skb_network_header_len(skb) >= sizeof(struct iphdr) &&
> >  		ip_hdr(skb)->protocol == IPPROTO_UDP &&
> > +		skb_headlen(skb) >=
> > +		skb_transport_offset(skb) + sizeof(struct udphdr) &&
> >  		udp_hdr(skb)->dest == htons(PTP_EVENT_PORT);
> >  }
> >  
> > 
> > 
> 
> -- 
> Ben Hutchings, Staff Engineer, Solarflare
> Not speaking for my employer; that's the marketing department's job.
> They asked us to note that Solarflare product names are trademarked.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
