Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932285Ab3FLXeX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 19:34:23 -0400
Received: from mout.gmx.net ([212.227.17.22]:62795 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756961Ab3FLXeW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 19:34:22 -0400
Date: Thu, 13 Jun 2013 09:35:03 +1000
From: Dave Wiltshire <david.wiltshire@gmx.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, eparis@redhat.com, edumazet@google.com
Subject: Re: [PATCH 1/3] skbuff: Update truesize in pskb_expand_head
Message-ID: <20130612233503.GB10989@linux-rbgc.site>
Mail-Followup-To: Eric Dumazet <eric.dumazet@gmail.com>,
	davem@davemloft.net, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
	eparis@redhat.com, edumazet@google.com
References: <1371027934-1955-1-git-send-email-david.wiltshire@gmx.com>
 <1371027934-1955-2-git-send-email-david.wiltshire@gmx.com>
 <1371028618.3252.57.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1371028618.3252.57.camel@edumazet-glaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V03:K0:KdlNwvIardsEB19M0bFwP4hKmm2UYDVgeuCguGBMNKiNI1+5HWo
 9IOxDGQN9NHdp0CybAp65YIUy3h9oMu6D9MCnIn3wehzDlCatUzVEvcPPKA6hJi58P3ZH/A
 VnCvRoA1GyyYwTQjHZD8Le4wyT/OeZu/ZTF51Qyekfo0x+KNbe6mQiErjcaqy7RV71pomYt
 lKEMLonJWYLgDAd9CqIhw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 02:16:58AM -0700, Eric Dumazet wrote:
> On Wed, 2013-06-12 at 19:05 +1000, Dave Wiltshire wrote:
> > Some call sites to pskb_expand_head subsequently update the skb truesize
> > and others don't (even with non-zero arguments). This is likely a memory
> > audit leak. Fixed this up by moving the memory accounting to the
> > skbuff.c file and removing it from the calling sites.
> 
> Ouch.
> 
> Sorry, you cannot do that.
> 
> skb->truesize is really complex, because there is a strong relation
> between skb->truesize and memory accounting on sockets.
> 

Firstly, from my cover letter: "Perhaps I don't understand something,
but I thought it best to generate the change and then ask. So is this
correct?". But secondly, I understand that the only reason for truesize
is for memory accounting on sockets. Indeed that's why I thought this
was incorrect. Something being complex is not a good reason not to do
it.

> So pskb_expand_head() should not touch skb->truesize.
> 
> Only callers can do that when needed, and if possible.
> 
> An example of very careful truesize manipulation can be found in
> tcp_tso_segment()
> 

Perhaps I'm still missing something but I don't think tcp_tso_segment is
a very good example of truesize in skbuffs. That function is reassigning
already allocated memory between different skbuffs, and also it doesn't
touch pskb_expand_head. I don't see how that is similar to calling
pskb_expand_head with non-zero parameters (thus increasing the size of a
skbuff) and _not_ updating truesize as occurs, for instance, in
drivers/atm/solos-pci.c in the function psend.

Now this is a little used driver so perhaps it doesn't matter. But I'm
not sure if this is happening in other places thus meaning that memory
accounting on sockets isn't being performed correctly. Which is the
reason I suggested this as a fix.

Dave W
