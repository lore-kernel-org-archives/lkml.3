Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956Ab3EMPsr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 11:48:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:60288 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753078Ab3EMPsq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 11:48:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,662,1363158000"; 
   d="scan'208";a="336373668"
From: "Vick, Matthew" <matthew.vick@intel.com>
To: Dong Zhu <bluezhudong@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
CC: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Allan, Bruce W" <bruce.w.allan@intel.com>,
        "Wyborny, Carolyn" <carolyn.wyborny@intel.com>,
        "Skidmore, Donald C" <donald.c.skidmore@intel.com>,
        "Rose, Gregory V" <gregory.v.rose@intel.com>,
        "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>,
        "Duyck, Alexander H" <alexander.h.duyck@intel.com>,
        "Ronciak, John" <john.ronciak@intel.com>,
        "Dave, Tushar N" <tushar.n.dave@intel.com>,
        "Keller, Jacob E" <jacob.e.keller@intel.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ben Hutchings <bhutchings@solarflare.com>
Subject: Re: [PATCH] igb: add a method to get the nic hw time stamping policy
Thread-Topic: [PATCH] igb: add a method to get the nic hw time stamping
 policy
Thread-Index: AQHOTlAxQl5tJAlMV0aeujdXJiGx/JkAqF6AgAFplICAADH4AIAAk3oAgAAm2gCAAF3jAP//6e2A
Date: Mon, 13 May 2013 15:48:43 +0000
Message-ID: <CDB65511.1CE8D%matthew.vick@intel.com>
In-Reply-To: <20130513100742.GM8399@zhudong.nay.redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/14.3.2.130206
x-originating-ip: [10.24.157.112]
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <AD8DAF99FE7A5E438C558B8D0D72E49B@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/13/13 3:07 AM, "Dong Zhu" <bluezhudong@gmail.com> wrote:

>> You could use the flags field, as it has no definition yet.
>> 
>> But you still need to explain why this new functionality is needed in
>> the first place:
>> 
>> - You can query an interface's time stamping capabilities with the
>>   GET_TS_INFO ethtool command.
>> 
>
>Hi,
>
>I modified this patch and added the method to igb_get_ts_info function.
>For 82576 nic, through this method we can easily check which type of
>packets
>are time stamped now, such as (HWTSTAMP_FILTER_PTP_V1_L4_SYNC and
>HWTSTAMP_FILTER_PTP_V1_L4_DELAY_REQ), then change or disable it up to
>your requests.
>I think it is convenient.The origial GET_TS_INFO method can only show the
>device¹s
>time stamping capabilities which nics supported.
>
>I use the tx_reserved[0] and rx_reserved[0] to restore the
>hwtstamp_tx_types and
>hwtstamp_rx_filters enumeration values.
>
>Due to the limitation of 80 characters one line, I have to move the
>switch out of else judegment.
>
>I test it on I350 and 82576NS nics and it works as expect.
>
>Could help reviewing it again ? Any comments would be appreciated.
>
>
>From 8a12932fd2a3bb5ca904bc72b20140247a5d81be Mon Sep 17 00:00:00 2001
>From: Dong Zhu <bluezhudong@gmail.com>
>Date: Mon, 13 May 2013 17:27:59 +0800
>
>Currently kernel only support setting the hw time stamping policy
>through ioctl,now add a method to check which packets(Outgoing and
>Incoming) are time stamped by nic.
>
>Add this to igb_get_ts_info, we can query this by using the GET_TS_INFO
>ethtool command. Testing on I350 and 82576NS it seems work well.
>
>Signed-off-by: Dong Zhu <bluezhudong@gmail.com>
>---
> drivers/net/ethernet/intel/igb/igb_ethtool.c | 78
>+++++++++++++++++++++++++++-
> include/uapi/linux/ethtool.h                 |  3 ++
> 2 files changed, 79 insertions(+), 2 deletions(-)

[...]

>diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
>index 0c9b448..06cdbc0 100644
>--- a/include/uapi/linux/ethtool.h
>+++ b/include/uapi/linux/ethtool.h
>@@ -772,7 +772,10 @@ struct ethtool_sfeatures {
>  * @so_timestamping: bit mask of the sum of the supported
>SO_TIMESTAMPING flags
>  * @phc_index: device index of the associated PHC, or -1 if there is none
>  * @tx_types: bit mask of the supported hwtstamp_tx_types enumeration
>values
>+ * @tx_reserved[0]: bit mask of the in use hwtstamp_tx_types enumeration
>values
>  * @rx_filters: bit mask of the supported hwtstamp_rx_filters
>enumeration values
>+ * @rx_reserved[0]: bit mask of the in use hwtstamp_rx_filters
>enumeration
>+ * values
>  *
>  * The bits in the 'tx_types' and 'rx_filters' fields correspond to
>  * the 'hwtstamp_tx_types' and 'hwtstamp_rx_filters' enumeration values,
>-- 
>1.7.11.7
>
>
>-- 
>Best Regards,
>Dong Zhu

CCing Ben Hutchings, since now your patch is affecting ethtool.

Dong,

The drivers should already be updating the config.tx_type and
config.rx_filter with what the driver is configuring the device for, so
any userspace application that needs to know what the device is actually
configured for can check those values after the ioctl call. If the
userspace app needs to know for certain that something is going to be
handled, it should just call the ioctl (as Richard suggested).

I'm not sure what you mean by "checking more" with the 82599EB in ixgbe.
It is permissible to timestamp additional packets, as long as the user
gets the packets they requested timestamped. This in mind, it's much more
efficient for the I350 to timestamp all receive packets and prevents other
headaches (for example, failure to timestamp if the device receives two
packets that should be timestamped at once). Because of this, the 82599EB
may have more individual filters, but the driver will be upscaling any
user input request to HWTSTAMP_FILTER_ALL on I350.

Cheers,
Matthew

