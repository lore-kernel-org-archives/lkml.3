Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592Ab3KLRpk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 12:45:40 -0500
Received: from mga11.intel.com ([192.55.52.93]:36902 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752664Ab3KLRpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 12:45:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,686,1378882800"; 
   d="scan'208";a="432201971"
Date: Tue, 12 Nov 2013 09:45:01 -0800
From: Greg Rose <gregory.v.rose@intel.com>
To: Jason Wang <jasowang@redhat.com>
CC: <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <mst@redhat.com>,
        <stefanha@redhat.com>
Subject: Re: [PATCH net 2/2] macvtap: limit head length of skb allocated
Message-ID: <20131112094501.0000358d@unknown>
In-Reply-To: <1384250577-20330-2-git-send-email-jasowang@redhat.com>
References: <1384250577-20330-1-git-send-email-jasowang@redhat.com>
	<1384250577-20330-2-git-send-email-jasowang@redhat.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.8cvs47 (GTK+ 2.16.6; i586-pc-mingw32msvc)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.22.254.140]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Nov 2013 18:02:57 +0800
Jason Wang <jasowang@redhat.com> wrote:

> We currently use hdr_len as a hint of head length which is advertised
> by guest. But when guest advertise a very big value, it can lead to
> an 64K+ allocating of kmalloc() which has a very high possibility of
> failure when host memory is fragmented or under heavy stress. The
> huge hdr_len also reduce the effect of zerocopy or even disable if a
> gso skb is linearized in guest.
> 
> To solves those issues, this patch introduces an upper limit
> (PAGE_SIZE) of the head, which guarantees an order 0 allocation each
> time.
> 
> Cc: Stefan Hajnoczi <stefanha@redhat.com>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
> The patch was needed for stable.
> ---
>  drivers/net/macvtap.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
> index 9dccb1e..7ee6f9d 100644
> --- a/drivers/net/macvtap.c
> +++ b/drivers/net/macvtap.c
> @@ -523,6 +523,11 @@ static inline struct sk_buff
> *macvtap_alloc_skb(struct sock *sk, size_t prepad, int noblock, int
> *err) {
>  	struct sk_buff *skb;
> +	int good_linear = SKB_MAX_HEAD(prepad);
> +
> +	/* Don't use huge linear part */
> +	if (linear > good_linear)
> +		linear = good_linear;
>  
>  	/* Under a page?  Don't bother with paged skb. */
>  	if (prepad + len < PAGE_SIZE || !linear)

I see no problem with this or the tuntap patch except that in both
cases kernel coding style would prefer that you align the local
variable declarations in a reverse pyramid, longest at the beginning,
shortest at the end.

- Greg
