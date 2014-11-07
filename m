Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361AbaKGTua (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 14:50:30 -0500
Received: from mga02.intel.com ([134.134.136.20]:59930 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753134AbaKGTu1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 14:50:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,334,1413270000"; 
   d="scan'208";a="633489400"
From: "Vick, Matthew" <matthew.vick@intel.com>
To: Joe Stringer <joestringer@nicira.com>
CC: "alexander.duyck@gmail.com" <alexander.duyck@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Dept-GELinuxNICDev@qlogic.com" <Dept-GELinuxNICDev@qlogic.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sathya.perla@emulex.com" <sathya.perla@emulex.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        Linux NICS <Linux-nics@intel.com>,
        "amirv@mellanox.com" <amirv@mellanox.com>,
        "shahed.shaikh@qlogic.com" <shahed.shaikh@qlogic.com>,
        "therbert@google.com" <therbert@google.com>,
        "Or Gerlitz" <gerlitz.or@gmail.com>
Subject: Re: [PATCH net 3/5] fm10k: Implement ndo_gso_check()
Thread-Topic: [PATCH net 3/5] fm10k: Implement ndo_gso_check()
Thread-Index: AQHP+ic3qnzQVNwor0CgR3ZaX8Jh2ZxVIqWAgABw+IA=
Date: Fri, 7 Nov 2014 19:49:38 +0000
Message-ID: <D0825758.5EC90%matthew.vick@intel.com>
References: <1415138202-1197-1-git-send-email-joestringer@nicira.com>
 <20141106211522.GA55313@gmail.com> <D0814FB9.5EA7E%matthew.vick@intel.com>
 <201411071805.18119.joestringer@nicira.com>
In-Reply-To: <201411071805.18119.joestringer@nicira.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/14.4.4.140807
x-originating-ip: [10.166.14.15]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8E06E28C207F6F4E9947B547F6FCFBF5@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/6/14, 9:05 PM, "Joe Stringer" <joestringer@nicira.com> wrote:

>Let's merge both discussions into one thread (pick here or there). We
>have 
>this suggestion or the one which simply checks for tunnels and
>inner+outer 
>header lengths. Do you have a preference between them?

Agreed with merging the thread--consider it merged!

Reflecting on this some more, I prefer the latter option (checking tunnels
and header lengths). I'm leaning towards pushing the header length check
into fm10k_tx_encap_offload and then making fm10k_gso_check call that with
the gso_type. So, it's really the most recent version of the patch you
proposed:

static bool fm10k_gso_check(struct sk_buff *skb, struct net_device *dev)
{
	if ((skb_shinfo(skb)->gso_type & (SKB_GSO_UDP_TUNNEL | SKB_GSO_GRE)) &&
	    !fm10k_tx_encap_offload(skb))
		return false;

	return true;
}


plus the header length being checked in fm10k_tx_encap_offload. The only
nit would be that I'd just return the conditional instead of having
"return true" or "return false" lines.

The tunnel length check really should be there in fm10k_tx_encap_offload
anyway, so I'll get a patch together for that one.

>We could introduce an "skb_is_gso_encap()" or similar for this purpose.
>Checking for SKB_GSO_UDP_TUNNEL or SKB_GSO_GRE is pretty closely tied to
>what 
>fm10k_tx_encap_offload() checks for though; it might not even make sense
>to call 
>it if some of the other SKB_GSO_* flags are raised.

A fair point. On the other hand, we have to check the header length both
in the GSO and non-GSO cases anyway, so only having the check in
fm10k_tx_encap_offload and calling it from fm10k_gso_check wouldn't be as
duplicative. What do you think about that approach?

As an aside: the more I think about this, the more I think Tom's right and
that each driver really should have it's own ndo_gso_check() for this.
With fm10k and i40e being different, we're already at 40% of the current
drivers being different. I'll leave it to Or to comment on whether the
other drivers could share the check in some manner.

Cheers,
Matthew

