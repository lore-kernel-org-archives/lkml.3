Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274Ab3EURaY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 13:30:24 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:60062 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764Ab3EURaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 13:30:23 -0400
Message-ID: <1369157418.2615.30.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [PATCH v4 net-next 2/4] tcp: add TCP support for low latency
 receive poll.
From: Ben Hutchings <bhutchings@solarflare.com>
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
CC: Dave Miller <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        <e1000-devel@lists.sourceforge.net>,
        Willem de Bruijn <willemb@google.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Or Gerlitz <or.gerlitz@gmail.com>,
        Eilon Greenstien <eilong@broadcom.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Date: Tue, 21 May 2013 18:30:18 +0100
In-Reply-To: <20130521142659.18498.1984.stgit@ladj378.jer.intel.com>
References: <20130521142641.18498.52856.stgit@ladj378.jer.intel.com>
	 <20130521142659.18498.1984.stgit@ladj378.jer.intel.com>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-19882.005
X-TM-AS-Result: No--3.499400-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-05-21 at 17:27 +0300, Eliezer Tamir wrote:
> adds busy-poll support for TCP.
> 
> Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
> Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> Tested-by: Willem de Bruijn <willemb@google.com>
> Signed-off-by: Eliezer Tamir <eliezer.tamir@linux.intel.com>
> ---
> 
>  net/ipv4/tcp.c       |    9 +++++++++
>  net/ipv4/tcp_input.c |    4 ++++
>  2 files changed, 13 insertions(+), 0 deletions(-)
> 
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index dcb116d..b9cc512 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
[...]
> @@ -1551,6 +1553,12 @@ int tcp_recvmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
>  	struct sk_buff *skb;
>  	u32 urg_hole = 0;
>  
> +#ifdef CONFIG_INET_LL_RX_POLL
> +	if (sk_valid_ll(sk) && skb_queue_empty(&sk->sk_receive_queue)
> +	    && (sk->sk_state == TCP_ESTABLISHED))
> +		sk_poll_ll(sk, nonblock);
> +#endif
[...]

I don't think the #ifdef is needed; this should compile down to nothing
if the config option is disabled.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

