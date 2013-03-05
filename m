Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828Ab3CERNi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 12:13:38 -0500
Received: from webmail.solarflare.com ([12.187.104.25]:44746 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262Ab3CERNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 12:13:36 -0500
Message-ID: <1362503593.2791.36.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [RFC PATCH 2/5] tcp: add TCP support for low latency receive
 poll.
From: Ben Hutchings <bhutchings@solarflare.com>
To: Eliezer Tamir <eliezer.tamir@linux.jf.intel.com>
CC: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        Dave Miller <davem@davemloft.net>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        <e1000-devel@lists.sourceforge.net>,
        Willem de Bruijn <willemb@google.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Date: Tue, 5 Mar 2013 17:13:13 +0000
In-Reply-To: <20130227175601.10611.99536.stgit@gitlad.jf.intel.com>
References: <20130227175549.10611.82188.stgit@gitlad.jf.intel.com>
	 <20130227175601.10611.99536.stgit@gitlad.jf.intel.com>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-19688.000
X-TM-AS-Result: No--13.342000-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-02-27 at 09:56 -0800, Eliezer Tamir wrote:
> an example of how one could add support for ndo_ll_poll to TCP.
[...]
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -279,6 +279,7 @@
>  
>  #include <asm/uaccess.h>
>  #include <asm/ioctls.h>
> +#include <net/ll_poll.h>
>  
>  int sysctl_tcp_fin_timeout __read_mostly = TCP_FIN_TIMEOUT;
>  
> @@ -1475,6 +1476,17 @@ int tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
>  
>  	if (sk->sk_state == TCP_LISTEN)
>  		return -ENOTCONN;
> +
> +#ifdef CONFIG_INET_LL_TCP_POLL
> +/* TODO: what do we do if the state changes after sk_poll_ll()? */

Maybe this bit should be a separate function that the callers can use
(or not) before calling tcp_read_sock().  Then they must take care of
re-locking and revalidating if it decides to poll.

Ben.

> +	if (sk_valid_ll(sk) && skb_queue_empty(&sk->sk_receive_queue)
> +		&& (sk->sk_state == TCP_ESTABLISHED)) {
> +
> +		release_sock(sk);
> +		sk_poll_ll(sk);
> +		lock_sock(sk);
> +	}
> +#endif
>  	while ((skb = tcp_recv_skb(sk, seq, &offset)) != NULL) {
>  		if (offset < skb->len) {
>  			int used;
[...]

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

