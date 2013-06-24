Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751385Ab3FXMxf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 08:53:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53770 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797Ab3FXMxd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 08:53:33 -0400
Date: Mon, 24 Jun 2013 15:54:12 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jason Wang <jasowang@redhat.com>, Eric Dumazet <edumazet@google.com>,
        Neil Horman <nhorman@tuxdriver.com>, netdev@vger.kernel.org,
        Brad Hubbard <bhubbard@redhat.com>
Subject: Re: [PATCH net] tun: fix recovery from gup errors
Message-ID: <20130624125412.GA690@redhat.com>
References: <20130623141903.GA21029@redhat.com>
 <51C715F5.2050300@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51C715F5.2050300@cogentembedded.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 23, 2013 at 07:36:21PM +0400, Sergei Shtylyov wrote:
> Hello.
> 
> On 23-06-2013 18:19, Michael S. Tsirkin wrote:
> 
> >get user pages might fail partially in tun zero copy
> >mode. To recover we need to put all pages that we got,
> >but code used a wrong index resulting in double-free
> >errors.
> 
> >Reported-by: Brad Hubbard <bhubbard@redhat.com>
> >Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> >---
> 
> >I haven't figured out why do we get failures,
> >but recovery is clearly wrong.
> 
> >This is also -stable material.
> 
> >  drivers/net/tun.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> >diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> >index bfa9bb4..c098b1e 100644
> >--- a/drivers/net/tun.c
> >+++ b/drivers/net/tun.c
> >@@ -1010,8 +1010,9 @@ static int zerocopy_sg_from_iovec(struct sk_buff *skb, const struct iovec *from,
> >  			return -EMSGSIZE;
> >  		num_pages = get_user_pages_fast(base, size, 0, &page[i]);
> >  		if (num_pages != size) {
> >-			for (i = 0; i < num_pages; i++)
> >-				put_page(page[i]);
> >+			int j;
> 
>   Empty line wouldn't hurt here, after declaration.
> 
> >+			for (j = 0; j < num_pages; j++)
> >+				put_page(page[i + j]);

I think it's clearer without: this is the only code
within this block, declaration is really part of
the loop that comes after it.
An empty line would break it up visually.

