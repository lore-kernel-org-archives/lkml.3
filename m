Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932361Ab3FQIPm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 04:15:42 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:49534 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880Ab3FQIPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 04:15:40 -0400
Message-ID: <1371456935.3252.177.camel@edumazet-glaptop>
Subject: Re: [PATCH] tcp: Modify the condition for the first skb to collapse
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jun Chen <jun.d.chen@intel.com>
Cc: ycheng@google.com, ncardwell@google.com, edumazet@google.com,
        netdev@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Date: Mon, 17 Jun 2013 01:15:35 -0700
In-Reply-To: <1371478739.10495.5.camel@chenjun-workstation>
References: <1371478739.10495.5.camel@chenjun-workstation>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-06-17 at 10:18 -0400, Jun Chen wrote:
> When search the first skb to collapse,the condition of overlap to the next one have been
> reached,but the start is less than TCP_SKB_CB(skb)->seq at this time, then followed process
> will trigger the BUG_ON of the offset(start - TCP_SKB_CB(skb)->seq).
> So this patch add one check (! before(start,TCP_SKB_CB(skb)->seq)) to avoid this ipanic.
> 
> Signed-off-by: Chen Jun <jun.d.chen@intel.com>
> ---
>  net/ipv4/tcp_input.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index 9c62257..4c745c5 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -4465,7 +4465,8 @@ restart:
>  		 *   overlaps to the next one.
>  		 */
>  		if (!tcp_hdr(skb)->syn && !tcp_hdr(skb)->fin &&
> -		    (tcp_win_from_space(skb->truesize) > skb->len ||
> +			((tcp_win_from_space(skb->truesize) > skb->len &&
> +			!before(start, TCP_SKB_CB(skb)->seq)) ||
>  		     before(TCP_SKB_CB(skb)->seq, start))) {
>  			end_of_skbs = false;
>  			break;

Hmm... I must say I do not understand this patch.

If we find a skb with before(TCP_SKB_CB(skb)->seq, start), then the
final condition will be true.

Let's rewrite your code to equivalent one :

 if (!tcp_hdr(skb)->syn && !tcp_hdr(skb)->fin &&
     (before(TCP_SKB_CB(skb)->seq, start) ||
      tcp_win_from_space(skb->truesize) > skb->len)) {

So it seems your patch would not solve the problem for all
possible skbs (aka not bloated) ?

Please tell us how you trigger this bug, and send the stack trace.

Thanks


