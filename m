Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166AbaFESLs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 14:11:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55005 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293AbaFESLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 14:11:46 -0400
Date: Thu, 5 Jun 2014 11:15:28 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mathias Krause <minipli@googlemail.com>
Cc: Luis Henriques <luis.henriques@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH 3.4 022/214] filter: prevent nla extensions to peek
 beyond the end of the message
Message-ID: <20140605181528.GF4121@kroah.com>
References: <20140605041639.638675216@linuxfoundation.org>
 <20140605041642.768058331@linuxfoundation.org>
 <20140605133331.GB6020@hercules>
 <CA+rthh_xdM-i7QiJ7QLayz+n42msL9nORV5mQh4qtJX66uXWWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+rthh_xdM-i7QiJ7QLayz+n42msL9nORV5mQh4qtJX66uXWWA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2014 at 03:49:48PM +0200, Mathias Krause wrote:
> On 5 June 2014 15:33, Luis Henriques <luis.henriques@canonical.com> wrote:
> > On Wed, Jun 04, 2014 at 09:16:25PM -0700, Greg Kroah-Hartman wrote:
> >> 3.4-stable review patch.  If anyone has any objections, please let me know.
> >> [...]
> >> --- a/net/core/filter.c
> >> +++ b/net/core/filter.c
> >> @@ -338,11 +338,15 @@ load_b:
> >>
> >>                       if (skb_is_nonlinear(skb))
> >>                               return 0;
> >> +                     if (skb->len < sizeof(struct nlattr))
> >> +                             return 0;
> >> +                     if (skb->len < sizeof(struct nlattr))
> >> +                             return 0;
> >
> > There above code is duplicated this backport.  The same comment
> > applies to the 3.2.y backport (I've added Ben to the CC list).
> >
> 
> Good catch! The diff should look more like the the one in the
> attachment. I guess patch(1) just failed here to find the right place
> to apply the hunk to.
> 
> Thanks,
> Mathias

> diff --git a/net/core/filter.c b/net/core/filter.c
> index 6f755cc..3b7398a 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -322,6 +322,8 @@ load_b:
>  
>  			if (skb_is_nonlinear(skb))
>  				return 0;
> +			if (skb->len < sizeof(struct nlattr))
> +				return 0;
>  			if (A > skb->len - sizeof(struct nlattr))
>  				return 0;
>  
> @@ -338,11 +340,13 @@ load_b:
>  
>  			if (skb_is_nonlinear(skb))
>  				return 0;
> +			if (skb->len < sizeof(struct nlattr))
> +				return 0;
>  			if (A > skb->len - sizeof(struct nlattr))
>  				return 0;
>  
>  			nla = (struct nlattr *)&skb->data[A];
> -			if (nla->nla_len > A - skb->len)
> +			if (nla->nla_len > skb->len - A)
>  				return 0;
>  
>  			nla = nla_find_nested(nla, X);


Thanks, I've fixed up the patch in the 3.4-stable queue to match this
version instead.

greg k-h
