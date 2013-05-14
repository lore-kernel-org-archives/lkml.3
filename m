Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649Ab3ENJwU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 05:52:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2080 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756481Ab3ENJwS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 05:52:18 -0400
Date: Tue, 14 May 2013 17:51:55 +0800
From: Dong Zhu <bluezhudong@gmail.com>
To: Jacob Keller <Jacob.e.keller@intel.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Matthew Vick <matthew.vick@intel.com>,
        Richard Cochran <richardcochran@gmail.com>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        Tushar Dave <tushar.n.dave@intel.com>,
        Akeem G Abodunrin <akeem.g.abodunrin@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: [PATCH] igb: add a method to get the nic hw time stamping
 policy
Message-ID: <20130514095155.GO8399@zhudong.nay.redhat.com>
References: <20130511140219.GG8399@zhudong.nay.redhat.com>
 <518E7723.5010003@cogentembedded.com>
 <20130512142555.GI8399@zhudong.nay.redhat.com>
 <20130512172446.GA2484@netboy>
 <20130513021236.GJ8399@zhudong.nay.redhat.com>
 <20130513043140.GA2567@netboy>
 <20130513100742.GM8399@zhudong.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130513100742.GM8399@zhudong.nay.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> I modified this patch and added the method to igb_get_ts_info function.
> For 82576 nic, through this method we can easily check which type of packets
> are time stamped now, such as (HWTSTAMP_FILTER_PTP_V1_L4_SYNC and
> HWTSTAMP_FILTER_PTP_V1_L4_DELAY_REQ), then change or disable it up to your requests.
> I think it is convenient.The origial GET_TS_INFO method can only show the device’s
> time stamping capabilities which nics supported.

Through this method we can easily check which type of packets are
timestamped currently, it is useful because that we use the hwstamp_ctl 
set time stamping policy first then we could verify what type of packets
does the nic timestamp and then do some other testing(regression) for each
policy.No matter PTP is running or not we can make sure whether timestamp packets 
could cause other general network problems through viewing and setting the
timestamp policy.

My original idea is that:
The implementation of this method is calling the ioctl call, in order
not to break the userland ABI I use the flags field of hwtstamp_config, 
as it has no definition yet.

  - For I350 it only supports two types HWTSTAMP_FILTER_NONE and HWTSTAMP_FILTER_ALL
    for timestamping. It is easy to handle just return the value to flags.

  - For 82576NS it has more individual filters, so I need to do the
    judement in the igb_ptp_hwtstamp_ioctl function for different nics, 
    the code of judgement might be reduplicated with igb_get_ts_info,then do
    the OR operation for filters then return to the flags.

Could tell me whether the above method(ioctl) is feasible and better than this
one (ethtool)?

IMO checking this through the ethtool GET_TS_INFO is so convenient
without breaking any userland ABIs. Do you think so ?

> 
> I use the tx_reserved[0] and rx_reserved[0] to restore the hwtstamp_tx_types and
> hwtstamp_rx_filters enumeration values.
> 
> I test it on I350 and 82576NS nics and it works as expect.
> 
> Could help reviewing it again ? Any comments would be appreciated.
> 
> 
> From 8a12932fd2a3bb5ca904bc72b20140247a5d81be Mon Sep 17 00:00:00 2001
> From: Dong Zhu <bluezhudong@gmail.com>
> Date: Mon, 13 May 2013 17:27:59 +0800
> 
> Currently kernel only support setting the hw time stamping policy
> through ioctl,now add a method to check which packets(Outgoing and
> Incoming) are time stamped by nic.
> 
> Add this to igb_get_ts_info, we can query this by using the GET_TS_INFO
> ethtool command. Testing on I350 and 82576NS it seems work well.
> 
> Signed-off-by: Dong Zhu <bluezhudong@gmail.com>
> ---
>  drivers/net/ethernet/intel/igb/igb_ethtool.c | 78 +++++++++++++++++++++++++++-
>  include/uapi/linux/ethtool.h                 |  3 ++
>  2 files changed, 79 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c b/drivers/net/ethernet/intel/igb/igb_ethtool.c
> index 7876240..49486b8 100644
> --- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
> +++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
> @@ -2327,6 +2327,8 @@ static int igb_get_ts_info(struct net_device *dev,
>  			   struct ethtool_ts_info *info)
>  {
>  	struct igb_adapter *adapter = netdev_priv(dev);
> +	struct e1000_hw *hw = &adapter->hw;
> +	u32 regval;
>  
>  	switch (adapter->hw.mac.type) {
>  	case e1000_82575:
> @@ -2360,10 +2362,29 @@ static int igb_get_ts_info(struct net_device *dev,
>  
>  		info->rx_filters = 1 << HWTSTAMP_FILTER_NONE;
>  
> +		regval = rd32(E1000_TSYNCTXCTL);
> +		if (regval & E1000_TSYNCTXCTL_ENABLED)
> +			info->tx_reserved[0] = 1 << HWTSTAMP_TX_ON;
> +		else
> +			info->tx_reserved[0] = 1 << HWTSTAMP_TX_OFF;
> +
> +		regval = rd32(E1000_TSYNCRXCTL);
> +
>  		/* 82576 does not support timestamping all packets. */
> -		if (adapter->hw.mac.type >= e1000_82580)
> +		if (adapter->hw.mac.type >= e1000_82580) {
>  			info->rx_filters |= 1 << HWTSTAMP_FILTER_ALL;
> -		else
> +
> +			if (!(regval & E1000_TSYNCRXCTL_ENABLED))
> +				info->rx_reserved[0] =
> +					1 << HWTSTAMP_FILTER_NONE;
> +			else if (E1000_TSYNCRXCTL_TYPE_ALL ==
> +					(regval & E1000_TSYNCRXCTL_TYPE_MASK))
> +				info->rx_reserved[0] = 1 << HWTSTAMP_FILTER_ALL;
> +			else
> +				return -ERANGE;
> +
> +			return 0;
> +		} else {
>  			info->rx_filters |=
>  				(1 << HWTSTAMP_FILTER_PTP_V1_L4_SYNC) |
>  				(1 << HWTSTAMP_FILTER_PTP_V1_L4_DELAY_REQ) |
> @@ -2373,6 +2394,59 @@ static int igb_get_ts_info(struct net_device *dev,
>  				(1 << HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ) |
>  				(1 << HWTSTAMP_FILTER_PTP_V2_EVENT);
>  
> +			if (!(regval & E1000_TSYNCRXCTL_ENABLED)) {
> +				info->rx_reserved[0] =
> +					1 << HWTSTAMP_FILTER_NONE;
> +				return 0;
> +			}
> +		}
> +
> +		switch (regval & E1000_TSYNCRXCTL_TYPE_MASK) {
> +		case E1000_TSYNCRXCTL_TYPE_L4_V1:
> +			regval = rd32(E1000_TSYNCRXCFG);
> +			if (E1000_TSYNCRXCFG_PTP_V1_SYNC_MESSAGE ==
> +					(regval &
> +					 E1000_TSYNCRXCFG_PTP_V1_CTRLT_MASK))
> +				info->rx_reserved[0] =
> +					(1 << HWTSTAMP_FILTER_PTP_V1_L4_SYNC);
> +			else if (E1000_TSYNCRXCFG_PTP_V1_DELAY_REQ_MESSAGE
> +					== (regval &
> +					E1000_TSYNCRXCFG_PTP_V1_CTRLT_MASK))
> +				info->rx_reserved[0] =
> +					(1 <<
> +					 HWTSTAMP_FILTER_PTP_V1_L4_DELAY_REQ);
> +			else
> +				return -ERANGE;
> +			break;
> +		case E1000_TSYNCRXCTL_TYPE_L2_L4_V2:
> +			regval = rd32(E1000_TSYNCRXCFG);
> +			if (E1000_TSYNCRXCFG_PTP_V2_SYNC_MESSAGE ==
> +					(regval &
> +					 E1000_TSYNCRXCFG_PTP_V2_MSGID_MASK))
> +				info->rx_reserved[0] =
> +					(1 << HWTSTAMP_FILTER_PTP_V2_L2_SYNC) |
> +					(1 << HWTSTAMP_FILTER_PTP_V2_L4_SYNC);
> +			else if (E1000_TSYNCRXCFG_PTP_V2_DELAY_REQ_MESSAGE ==
> +					(regval &
> +					 E1000_TSYNCRXCFG_PTP_V2_MSGID_MASK))
> +				info->rx_reserved[0] =
> +					(1 <<
> +					 HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ) |
> +					(1 <<
> +					 HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ);
> +			else
> +				return -ERANGE;
> +			break;
> +		case E1000_TSYNCRXCTL_TYPE_EVENT_V2:
> +			info->rx_reserved[0] =
> +				(1 << HWTSTAMP_FILTER_PTP_V2_EVENT) |
> +				(1 << HWTSTAMP_FILTER_PTP_V2_SYNC) |
> +				(1 << HWTSTAMP_FILTER_PTP_V2_DELAY_REQ);
> +			break;
> +		default:
> +			return -ERANGE;
> +		}
> +
>  		return 0;
>  	default:
>  		return -EOPNOTSUPP;
> diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
> index 0c9b448..06cdbc0 100644
> --- a/include/uapi/linux/ethtool.h
> +++ b/include/uapi/linux/ethtool.h
> @@ -772,7 +772,10 @@ struct ethtool_sfeatures {
>   * @so_timestamping: bit mask of the sum of the supported SO_TIMESTAMPING flags
>   * @phc_index: device index of the associated PHC, or -1 if there is none
>   * @tx_types: bit mask of the supported hwtstamp_tx_types enumeration values
> + * @tx_reserved[0]: bit mask of the in use hwtstamp_tx_types enumeration values
>   * @rx_filters: bit mask of the supported hwtstamp_rx_filters enumeration values
> + * @rx_reserved[0]: bit mask of the in use hwtstamp_rx_filters enumeration
> + * values
>   *
>   * The bits in the 'tx_types' and 'rx_filters' fields correspond to
>   * the 'hwtstamp_tx_types' and 'hwtstamp_rx_filters' enumeration values,
> -- 
> 1.7.11.7


-- 
Best Regards,
Dong Zhu
