Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987Ab3F0PcS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 11:32:18 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:43726 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410Ab3F0PcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 11:32:13 -0400
Message-ID: <1372347124.2436.3.camel@bwh-desktop.uk.level5networks.com>
Subject: Re: [RFC Patch net-next 2/5] net: introduce generic inet_pton()
From: Ben Hutchings <bhutchings@solarflare.com>
To: Cong Wang <amwang@redhat.com>
CC: <netdev@vger.kernel.org>, Daniel Borkmann <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Neil Horman <nhorman@tuxdriver.com>, "Jiri Pirko" <jiri@resnulli.us>,
        Eric Dumazet <edumazet@google.com>, <linux-kernel@vger.kernel.org>
Date: Thu, 27 Jun 2013 16:32:04 +0100
In-Reply-To: <1372315398-19683-3-git-send-email-amwang@redhat.com>
References: <1372315398-19683-1-git-send-email-amwang@redhat.com>
	 <1372315398-19683-3-git-send-email-amwang@redhat.com>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-19978.002
X-TM-AS-Result: No--8.617600-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-27 at 14:43 +0800, Cong Wang wrote:
> Signed-off-by: Cong Wang <amwang@redhat.com>
> ---
>  include/net/inet_addr.h |   20 ++++++++++++++++++++
>  net/core/netpoll.c      |   24 ++----------------------
>  2 files changed, 22 insertions(+), 22 deletions(-)
> 
> diff --git a/include/net/inet_addr.h b/include/net/inet_addr.h
> index 66a16fe..1379287 100644
> --- a/include/net/inet_addr.h
> +++ b/include/net/inet_addr.h
> @@ -4,6 +4,7 @@
>  #include <linux/in.h>
>  #include <linux/in6.h>
>  #include <linux/socket.h>
> +#include <linux/inet.h>
>  #include <net/addrconf.h>
>  
>  union inet_addr {
> @@ -59,4 +60,23 @@ static inline bool inet_addr_multicast(const union inet_addr *ipa)
>  }
>  #endif
>  
> +static inline int inet_pton(const char *str, union inet_addr *addr)
> +{
> +	const char *end;
> +
> +	if (!strchr(str, ':') &&
> +	    in4_pton(str, -1, (void *)addr, -1, &end) > 0) {
> +		if (!*end)
> +			return 0;
> +	}
> +	if (in6_pton(str, -1, addr->sin6.sin6_addr.s6_addr, -1, &end) > 0) {
> +#if IS_ENABLED(CONFIG_IPV6)
> +		if (!*end)
> +			return 1;
> +#else
> +		return -1;
> +#endif
> +	}
> +	return -1;
> +}
[...]

The return values for this are awful.  I think the return value should
be 0 for success or -EINVAL on error.

The caller can then check addr->sa.sa_family if they want to know the
address family immediately.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

