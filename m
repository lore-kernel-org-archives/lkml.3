Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751193AbaKFVPl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 16:15:41 -0500
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:36184 "HELO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750706AbaKFVPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 16:15:39 -0500
Date: Thu, 6 Nov 2014 13:15:22 -0800
From: Joe Stringer <joestringer@nicira.com>
To: alexander.duyck@gmail.com, netdev@vger.kernel.org,
        Dept-GELinuxNICDev@qlogic.com, linux-kernel@vger.kernel.org
Cc: Alexander Duyck <alexander.duyck@gmail.com>, sathya.perla@emulex.com,
        jeffrey.t.kirsher@intel.com, linux.nics@intel.com, amirv@mellanox.com,
        shahed.shaikh@qlogic.com, therbert@google.com
Subject: Re: [PATCH net 3/5] fm10k: Implement ndo_gso_check()
Message-ID: <20141106211522.GA55313@gmail.com>
Mail-Followup-To: Joe Stringer <joestringer@nicira.com>,
	alexander.duyck@gmail.com, netdev@vger.kernel.org,
	Dept-GELinuxNICDev@qlogic.com, linux-kernel@vger.kernel.org,
	sathya.perla@emulex.com, jeffrey.t.kirsher@intel.com,
	linux.nics@intel.com, amirv@mellanox.com, shahed.shaikh@qlogic.com,
	therbert@google.com
References: <1415138202-1197-1-git-send-email-joestringer@nicira.com>
 <1415138202-1197-4-git-send-email-joestringer@nicira.com>
 <545AE2C8.3070705@gmail.com>
 <20141106184115.GB18339@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141106184115.GB18339@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 10:41:15AM -0800, Joe Stringer wrote:
> On Wed, Nov 05, 2014 at 06:54:00PM -0800, Alexander Duyck wrote:
> > On 11/04/2014 01:56 PM, Joe Stringer wrote:
> > > ndo_gso_check() was recently introduced to allow NICs to report the
> > > offloading support that they have on a per-skb basis. Add an
> > > implementation for this driver which checks for something that looks
> > > like VXLAN.
> > >
> > > Implementation shamelessly stolen from Tom Herbert:
> > > http://thread.gmane.org/gmane.linux.network/332428/focus=333111
> > >
> > > Signed-off-by: Joe Stringer <joestringer@nicira.com>
> > > ---
> > > Should this driver report support for GSO on packets with tunnel headers
> > > up to 64B like the i40e driver does?
> > > ---
> > >  drivers/net/ethernet/intel/fm10k/fm10k_netdev.c |   12 ++++++++++++
> > >  1 file changed, 12 insertions(+)
> > >
> > > diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c b/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
> > > index 8811364..b9ef622 100644
> > > --- a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
> > > +++ b/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
> > > @@ -1350,6 +1350,17 @@ static void fm10k_dfwd_del_station(struct net_device *dev, void *priv)
> > >  	}
> > >  }
> > >  
> > > +static bool fm10k_gso_check(struct sk_buff *skb, struct net_device *dev)
> > > +{
> > > +	if ((skb_shinfo(skb)->gso_type & SKB_GSO_UDP_TUNNEL) &&
> > > +	    (skb->inner_protocol_type != ENCAP_TYPE_ETHER ||
> > > +	     skb->inner_protocol != htons(ETH_P_TEB) ||
> > > +	     skb_inner_mac_header(skb) - skb_transport_header(skb) != 16))
> > > +		return false;
> > > +
> > > +	return true;
> > > +}
> > > +
> > >  static const struct net_device_ops fm10k_netdev_ops = {
> > >  	.ndo_open		= fm10k_open,
> > >  	.ndo_stop		= fm10k_close,
> > > @@ -1372,6 +1383,7 @@ static const struct net_device_ops fm10k_netdev_ops = {
> > >  	.ndo_do_ioctl		= fm10k_ioctl,
> > >  	.ndo_dfwd_add_station	= fm10k_dfwd_add_station,
> > >  	.ndo_dfwd_del_station	= fm10k_dfwd_del_station,
> > > +	.ndo_gso_check		= fm10k_gso_check,
> > >  };
> > >  
> > >  #define DEFAULT_DEBUG_LEVEL_SHIFT 3
> > 
> > I'm thinking this check is far too simplistic.  If you look the fm10k
> > driver already has fm10k_tx_encap_offload() in the TSO function for
> > verifying if it can support offloading tunnels or not.  I would
> > recommend starting there or possibly even just adapting that function to
> > suit your purpose.
> > 
> > Thanks,
> > 
> > Alex
> 
> Would it be enough to just call fm10k_tx_encap_offload() in a way that echoes fm10k_tso()?
> 
> +static bool fm10k_gso_check(struct sk_buff *skb, struct net_device *dev)
> +{
> +       if (skb->encapsulation && !fm10k_tx_encap_offload(skb))
> +               return false;
> +
> +       return true;
> +}

Oh, I suppose we need to check the gso_type too. More like this?

+static bool fm10k_gso_check(struct sk_buff *skb, struct net_device *dev)
+{
+       if ((skb_shinfo(skb)->gso_type & (SKB_GSO_UDP_TUNNEL | SKB_GSO_GRE)) &&
+           !fm10k_tx_encap_offload(skb))
+               return false;
+
+       return true;
+}
