Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932790AbbA0WDj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 17:03:39 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:44926 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842AbbA0WDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 17:03:37 -0500
Date: Tue, 27 Jan 2015 22:03:32 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: Karl Beldan <karl.beldan@rivierawaves.com>,
        Mike Frysinger <vapier@gentoo.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, Stable <stable@vger.kernel.org>
Subject: Re: [PATCH] lib/checksum.c: fix carry in csum_tcpudp_nofold
Message-ID: <20150127220332.GZ29656@ZenIV.linux.org.uk>
References: <1422372316-25287-1-git-send-email-karl.beldan@rivierawaves.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422372316-25287-1-git-send-email-karl.beldan@rivierawaves.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 04:25:16PM +0100, Karl Beldan wrote:
> The carry from the 64->32bits folding was dropped, e.g with:
> saddr=0xFFFFFFFF daddr=0xFF0000FF len=0xFFFF proto=0 sum=1
> 
> Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
> Cc: Mike Frysinger <vapier@gentoo.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: linux-kernel@vger.kernel.org
> Cc: Stable <stable@vger.kernel.org>
> ---
>  lib/checksum.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/checksum.c b/lib/checksum.c
> index 129775e..4b5adf2 100644
> --- a/lib/checksum.c
> +++ b/lib/checksum.c
> @@ -195,8 +195,8 @@ __wsum csum_tcpudp_nofold(__be32 saddr, __be32 daddr,
>  #else
>  	s += (proto + len) << 8;
>  #endif
> -	s += (s >> 32);
> -	return (__force __wsum)s;
> +	s += (s << 32) + (s >> 32);
> +	return (__force __wsum)(s >> 32);

Umm...  I _think_ it's correct, but it needs a better commit message.  AFAICS,
what we have is that s is guaranteed to be (a << 32) + b, with a being small.
What we want is something congruent to a + b modulo 0xffff.  And yes, in case
when a + b >= 2^32, the original variant fails - it yields a + b - 2^32, which
is one less than what's needed.  New one results first in
(a + b)(2^32+1)mod 2^64, then that divided by 2^32.  If a + b <= 2^32 - 1,
the first product is less than 2^64 and dividing it by 2^32 yields a + b.
If a + b = 2^32 + c, c is guaranteed to be small and we first get
2^32 * c + 2^32 + 1, then c + 1, i.e. a + b - 0xffffffff, i.e.
a + b - 0x10001 * 0xffff, so the congruence holds in all cases.

IOW, I think the fix is correct, but it really needs analysis in the commit
message.
