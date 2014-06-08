Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612AbaFHMZg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 08:25:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44115 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753313AbaFHMZf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 08:25:35 -0400
Message-ID: <53945633.20702@redhat.com>
Date: Sun, 08 Jun 2014 14:25:23 +0200
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: George Spelvin <linux@horizon.com>
CC: davem@davemloft.net, shemminger@osdl.org, tytso@mit.edu,
        linux-kernel@vger.kernel.org, hannes@stressinduktion.org
Subject: Re: [PATCH 4/7] lib/random32.c: Use <asm/unaligned.h> instead of
 hand-rolling it
References: <20140607082518.9989.qmail@ns.horizon.com>
In-Reply-To: <20140607082518.9989.qmail@ns.horizon.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2014 10:25 AM, George Spelvin wrote:
> The functions exist for a reason; the manual byte-at-a-time code
> is unnecessarily slow (and bloated).
>
> Signed-off-by: George Spelvin <linux@horizon.com>

Seems fine by me, since it's random anyway archs might not care
about the *_le32, though this might yield additional work in some
cases I presume.

> ---
>   lib/random32.c | 23 +++++++++++------------
>   1 file changed, 11 insertions(+), 12 deletions(-)
>
> diff --git a/lib/random32.c b/lib/random32.c
> index e8f3557b..eee60100 100644
> --- a/lib/random32.c
> +++ b/lib/random32.c
> @@ -37,6 +37,7 @@
>   #include <linux/jiffies.h>
>   #include <linux/random.h>
>   #include <linux/sched.h>
> +#include <asm/unaligned.h>
>
>   #ifdef CONFIG_RANDOM32_SELFTEST
>   static void __init prandom_state_selftest(void);
> @@ -97,25 +98,23 @@ EXPORT_SYMBOL(prandom_u32);
>    */
>   void prandom_bytes_state(struct rnd_state *state, void *buf, int bytes)
>   {
> -	unsigned char *p = buf;
> +	u8 *p = buf;
>   	int i;
>
> -	for (i = 0; i < round_down(bytes, sizeof(u32)); i += sizeof(u32)) {
> -		u32 random = prandom_u32_state(state);
> -		int j;
> +	for (i = 0; i < round_down(bytes, sizeof(u32)); i += sizeof(u32))
> +		put_unaligned_le32(prandom_u32_state(state), p+i);

Nit: 'p + i'

>
> -		for (j = 0; j < sizeof(u32); j++) {
> -			p[i + j] = random;
> -			random >>= BITS_PER_BYTE;
> -		}
> -	}
>   	if (i < bytes) {
>   		u32 random = prandom_u32_state(state);
>
> -		for (; i < bytes; i++) {
> -			p[i] = random;
> -			random >>= BITS_PER_BYTE;
> +		if (bytes & 2) {
> +			put_unaligned_le16((u16)random, p+i);

Ditto.

> +			if ((bytes & 1) == 0)
> +				return;
> +			i += 2;
> +			random >>= 16;
>   		}
> +		p[i] = (u8)random;

Nit: '(u8) random'

You could probably use a switch statement with fall-through for
filling the remaining stuff, might simplify it further, perhaps.

>   	}
>   }
>   EXPORT_SYMBOL(prandom_bytes_state);
>
