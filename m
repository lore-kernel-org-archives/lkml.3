Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751450AbaKGFFb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 00:05:31 -0500
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:34567 "HELO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750945AbaKGFF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 00:05:29 -0500
From: Joe Stringer <joestringer@nicira.com>
To: "Vick, Matthew" <matthew.vick@intel.com>
Subject: Re: [PATCH net 3/5] fm10k: Implement ndo_gso_check()
Date: Fri, 7 Nov 2014 18:05:17 +1300
User-Agent: KMail/1.13.7 (Linux/3.2.0-4-amd64; KDE/4.8.4; x86_64; ; )
Cc: "alexander.duyck@gmail.com" <alexander.duyck@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Dept-GELinuxNICDev@qlogic.com" <Dept-GELinuxNICDev@qlogic.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sathya.perla@emulex.com" <sathya.perla@emulex.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        Linux NICS <Linux-nics@intel.com>,
        "amirv@mellanox.com" <amirv@mellanox.com>,
        "shahed.shaikh@qlogic.com" <shahed.shaikh@qlogic.com>,
        "therbert@google.com" <therbert@google.com>
References: <1415138202-1197-1-git-send-email-joestringer@nicira.com> <20141106211522.GA55313@gmail.com> <D0814FB9.5EA7E%matthew.vick@intel.com>
In-Reply-To: <D0814FB9.5EA7E%matthew.vick@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201411071805.18119.joestringer@nicira.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Nov 2014 14:07:36 Vick, Matthew wrote:
> On 11/6/14, 1:15 PM, "Joe Stringer" <joestringer@nicira.com> wrote:
> >Oh, I suppose we need to check the gso_type too. More like this?
> >
> >+static bool fm10k_gso_check(struct sk_buff *skb, struct net_device *dev)
> >+{
> >+       if ((skb_shinfo(skb)->gso_type & (SKB_GSO_UDP_TUNNEL |
> >SKB_GSO_GRE)) &&
> >+           !fm10k_tx_encap_offload(skb))
> >+               return false;
> >+
> >+       return true;
> >+}
> 
> It seems like the skb_shinfo(skb)->gso_type check should be in some more
> generic ndo_gso_check that drivers can default to/extend. Then, we could
> end up with something like
> 
> static bool fm10k_gso_check(struct sk_buff *skb, struct net_device *dev)
> {
> 	if (skb_gso_check(skb, dev) && !fm10k_tx_encap_offload(skb))
> 		return false;
> 
> 	return true;
> }
> 
> This could even be simplified and still legible as
> 
> static bool fm10k_gso_check(struct sk_buff *skb, struct net_device *dev)
> {
> 	return !(skb_gso_check(skb, dev) && !fm10k_tx_encap_offload(skb));
> }
> 
> What do you think of this approach?

Let's merge both discussions into one thread (pick here or there). We have 
this suggestion or the one which simply checks for tunnels and inner+outer 
header lengths. Do you have a preference between them?

We could introduce an "skb_is_gso_encap()" or similar for this purpose. 
Checking for SKB_GSO_UDP_TUNNEL or SKB_GSO_GRE is pretty closely tied to what 
fm10k_tx_encap_offload() checks for though; it might not even make sense to call 
it if some of the other SKB_GSO_* flags are raised.

Joe
