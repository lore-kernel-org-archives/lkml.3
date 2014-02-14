Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508AbaBNQZr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 11:25:47 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:36929 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751551AbaBNQZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 11:25:43 -0500
Date: Fri, 14 Feb 2014 16:24:58 +0000
From: Will Deacon <will.deacon@arm.com>
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Pavel Machek <pavel@ucw.cz>, Sebastian Reichel <sre@ring0.de>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        kvalo@qca.qualcomm.com, linville@tuxdriver.com
Subject: Re: [BISECTED] ssh - Received disconnect from x.x.x.x: 2: Bad packet
 length 3149594624
Message-ID: <20140214162458.GF21986@mudshark.cambridge.arm.com>
References: <52FD08D1.3030405@gmail.com>
 <20140213182105.GN13576@mudshark.cambridge.arm.com>
 <52FD1243.9040706@gmail.com>
 <20140213192909.GO13576@mudshark.cambridge.arm.com>
 <52FE407C.3080002@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52FE407C.3080002@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 04:12:44PM +0000, Ivaylo Dimitrov wrote:
> On 13.02.2014 21:29, Will Deacon wrote:
> >
> > Can you try hacking crypto/memneq.c so that it doesn't use
> > CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS please? That would at least point the
> > finger at net/mac80211/rx.c or similar.
> >
> 
> Well, I am lazy so I hacked net/mac80211/rx.c first:

No problem, thanks for having a go.

> index c24ca0d..6839c77 100644
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -1963,7 +1963,7 @@ ieee80211_deliver_skb(struct ieee80211_rx_data *rx)
>                  }
>          }
> 
> -#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
> +//#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
>          if (skb) {
>                  /* 'align' will only take the values 0 or 2 here since all
>                   * frames are required to be aligned to 2-byte boundaries
> @@ -1987,7 +1987,7 @@ ieee80211_deliver_skb(struct ieee80211_rx_data *rx)
>                          }
>                  }
>          }
> -#endif
> +//#endif
> 
>          if (skb) {
>                  /* deliver to local stack */
> 
> 
> and that seems to fix the problem.
> 
> I am not sure whom I should forward the problem.

Well, we probably need a bit more to go on, because I doubt that this code
is to blame. More likely, the issue is in the caller.
Looking at drivers/net/wireless/ti/wl1251/rx.c:182

        /* The actual length doesn't include the target's alignment */
        skb->len = desc->length  - PLCP_HEADER_LENGTH;

        fc = (u16 *)skb->data;

        if ((*fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_BEACON)
                beacon = 1;

        wl1251_rx_status(wl, desc, &status, beacon);

        wl1251_debug(DEBUG_RX, "rx skb 0x%p: %d B %s", skb, skb->len,
                     beacon ? "beacon" : "");

        memcpy(IEEE80211_SKB_RXCB(skb), &status, sizeof(status));
        ieee80211_rx_ni(wl->hw, skb);

I wonder whether that first line (with the comment about alignment) is
assuming some behaviour from the mac80211 layer.

You could try putting back the UNALIGNED_ACCESS in net/mac80211/rx.c and
commenting out the skb->len = desc->length  - PLCP_HEADER_LENGTH;  line
above.

Adding the original author (I think) and John Linville, since I'm well out
of my depth in this code!

Will
