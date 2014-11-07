Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751263AbaKGBHy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 20:07:54 -0500
Received: from mga01.intel.com ([192.55.52.88]:40674 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750926AbaKGBHw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 20:07:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,329,1413270000"; 
   d="scan'208";a="628044953"
From: "Vick, Matthew" <matthew.vick@intel.com>
To: Joe Stringer <joestringer@nicira.com>,
        "alexander.duyck@gmail.com" <alexander.duyck@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Dept-GELinuxNICDev@qlogic.com" <Dept-GELinuxNICDev@qlogic.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "sathya.perla@emulex.com" <sathya.perla@emulex.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        Linux NICS <Linux-nics@isotope.jf.intel.com>,
        "amirv@mellanox.com" <amirv@mellanox.com>,
        "shahed.shaikh@qlogic.com" <shahed.shaikh@qlogic.com>,
        "therbert@google.com" <therbert@google.com>
Subject: Re: [PATCH net 3/5] fm10k: Implement ndo_gso_check()
Thread-Topic: [PATCH net 3/5] fm10k: Implement ndo_gso_check()
Thread-Index: AQHP+ic3qnzQVNwor0CgR3ZaX8Jh2Q==
Date: Fri, 7 Nov 2014 01:07:36 +0000
Message-ID: <D0814FB9.5EA7E%matthew.vick@intel.com>
References: <1415138202-1197-1-git-send-email-joestringer@nicira.com>
 <1415138202-1197-4-git-send-email-joestringer@nicira.com>
 <545AE2C8.3070705@gmail.com> <20141106184115.GB18339@gmail.com>
 <20141106211522.GA55313@gmail.com>
In-Reply-To: <20141106211522.GA55313@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/14.4.4.140807
x-originating-ip: [10.166.14.15]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BFF876E937C96540B709FDC5D2883580@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/6/14, 1:15 PM, "Joe Stringer" <joestringer@nicira.com> wrote:

>Oh, I suppose we need to check the gso_type too. More like this?
>
>+static bool fm10k_gso_check(struct sk_buff *skb, struct net_device *dev)
>+{
>+       if ((skb_shinfo(skb)->gso_type & (SKB_GSO_UDP_TUNNEL |
>SKB_GSO_GRE)) &&
>+           !fm10k_tx_encap_offload(skb))
>+               return false;
>+
>+       return true;
>+}

It seems like the skb_shinfo(skb)->gso_type check should be in some more
generic ndo_gso_check that drivers can default to/extend. Then, we could
end up with something like

static bool fm10k_gso_check(struct sk_buff *skb, struct net_device *dev)
{
	if (skb_gso_check(skb, dev) && !fm10k_tx_encap_offload(skb))
		return false;

	return true;
}

This could even be simplified and still legible as

static bool fm10k_gso_check(struct sk_buff *skb, struct net_device *dev)
{
	return !(skb_gso_check(skb, dev) && !fm10k_tx_encap_offload(skb));
}

What do you think of this approach?

