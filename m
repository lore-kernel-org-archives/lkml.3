Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755731Ab3C0EfS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 00:35:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5800 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755524Ab3C0EfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 00:35:16 -0400
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=h0V-AMAUKnAA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=Cu9V1Ra0JhsA:10 a=VPS0CfSAAAAA:8 a=1XWaLZrsAAAA:8 a=J1Y8HTJGAAAA:8 a=pB-CFhUWWpRnyQKb8F4A:9 a=QEXdDO2ut3YA:10 a=Hb87az3203AA:10 a=UTB_XpHje0EA:10 a=4N9Db7Z2_RYA:10 a=g3bUhKVm6LuDeeHB:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1364358913.6345.204.camel@gandalf.local.home>
Subject: Re: [PATCH 64/86] IP_GRE: Fix kernel panic in IP_GRE with GRE csum.
From: Steven Rostedt <rostedt@goodmis.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Pravin B Shelar <pshelar@nicira.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Wed, 27 Mar 2013 00:35:13 -0400
In-Reply-To: <1364358520.3520.38.camel@deadeye.wl.decadent.org.uk>
References: <20130326172059.136127374@goodmis.org>
	 <20130326173610.108770791@goodmis.org>
	 <1364358520.3520.38.camel@deadeye.wl.decadent.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-27 at 04:28 +0000, Ben Hutchings wrote:
> On Tue, 2013-03-26 at 13:22 -0400, Steven Rostedt wrote:
> 
> > 3.6.11.1 stable review patch.
> > If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Pravin B Shelar <pshelar@nicira.com>
> > 
> > [ Upstream commit d0a7cc630a337b0f56dc145e7eb6232852b14dd4 ]
> > 
> > Due to IP_GRE GSO support, GRE can recieve non linear skb which
> > results in panic in case of GRE_CSUM.  Following patch fixes it by
> > using correct csum API.
> > 
> > Bug introduced in commit 6b78f16e4bdde3936b (gre: add GSO support)
> 
> That commit went into 3.7, so I don't think this fix is needed for 3.6.

Ah, you're saying that because 6b78f16e4bdde3936b wasn't in 3.6, this
isn't needed for 3.6 either.

I created scripts to find the commits that made it into 3.7 and 3.8 that
were not added to 3.6 and just cherry-picked them. Unless they failed
because of a conflict, I really didn't look hard at them.

Thanks, I guess I can remove this change then.

-- Steve

> 
> Ben.
> 
> > Signed-off-by: Pravin B Shelar <pshelar@nicira.com>
> > Acked-by: Eric Dumazet <edumazet@google.com>
> > Signed-off-by: David S. Miller <davem@davemloft.net>
> > ---
> >  net/ipv4/ip_gre.c |    6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> > 
> > diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
> > index b062a98..3ee08ce 100644
> > --- a/net/ipv4/ip_gre.c
> > +++ b/net/ipv4/ip_gre.c
> > @@ -946,8 +946,12 @@ static netdev_tx_t ipgre_tunnel_xmit(struct sk_buff *skb, struct net_device *dev
> >  			ptr--;
> >  		}
> >  		if (tunnel->parms.o_flags&GRE_CSUM) {
> > +			int offset = skb_transport_offset(skb);
> > +
> >  			*ptr = 0;
> > -			*(__sum16 *)ptr = ip_compute_csum((void *)(iph+1), skb->len - sizeof(struct iphdr));
> > +			*(__sum16 *)ptr = csum_fold(skb_checksum(skb, offset,
> > +								 skb->len - offset,
> > +								 0));
> >  		}
> >  	}
> >  
> 


