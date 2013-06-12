Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095Ab3FLJRI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 05:17:08 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:36417 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179Ab3FLJRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 05:17:06 -0400
Message-ID: <1371028618.3252.57.camel@edumazet-glaptop>
Subject: Re: [PATCH 1/3] skbuff: Update truesize in pskb_expand_head
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Dave Wiltshire <david.wiltshire@gmx.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        nsujir@broadcom.com, mchan@broadcom.com, rmody@brocade.com,
        jcliburn@gmail.com, chris.snook@gmail.com, jeffrey.t.kirsher@intel.com,
        bruce.w.allan@intel.com, alexander.h.duyck@intel.com,
        cooldavid@cooldavid.org, linux-driver@qlogic.com,
        linux-wimax@intel.com, wimax@linuxwimax.org,
        linux-wireless@vger.kernel.org, viro@zeniv.linux.org.uk,
        eparis@redhat.com, edumazet@google.com, dev@openvswitch.org,
        jhs@mojatatu.com
Date: Wed, 12 Jun 2013 02:16:58 -0700
In-Reply-To: <1371027934-1955-2-git-send-email-david.wiltshire@gmx.com>
References: <1371027934-1955-1-git-send-email-david.wiltshire@gmx.com>
	 <1371027934-1955-2-git-send-email-david.wiltshire@gmx.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-12 at 19:05 +1000, Dave Wiltshire wrote:
> Some call sites to pskb_expand_head subsequently update the skb truesize
> and others don't (even with non-zero arguments). This is likely a memory
> audit leak. Fixed this up by moving the memory accounting to the
> skbuff.c file and removing it from the calling sites.
> 
> Signed-off-by: Dave Wiltshire <david.wiltshire@gmx.com>
> ---
>  drivers/net/wireless/mwl8k.c |    1 -
>  kernel/audit.c               |    2 --
>  net/core/skbuff.c            |    1 +
>  net/netlink/af_netlink.c     |    3 +--
>  net/wireless/util.c          |    2 --
>  5 files changed, 2 insertions(+), 7 deletions(-)

Ouch.

Sorry, you cannot do that.

skb->truesize is really complex, because there is a strong relation
between skb->truesize and memory accounting on sockets.

So pskb_expand_head() should not touch skb->truesize.

Only callers can do that when needed, and if possible.

An example of very careful truesize manipulation can be found in
tcp_tso_segment()



