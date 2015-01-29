Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758712AbbA2KnU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 05:43:20 -0500
Received: from mga11.intel.com ([192.55.52.93]:12932 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758253AbbA2KnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 05:43:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,485,1418112000"; 
   d="scan'208";a="669630914"
Message-ID: <1422528195.31903.307.camel@linux.intel.com>
Subject: Re: [PATCH v2 1/3] lib/vsprintf.c: Fix potential NULL deref in
 hex_string
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>,
        Randy Dunlap <rdunlap@infradead.org>,
        Fabian Frederick <fabf@skynet.be>, Bjorn Helgaas <bhelgaas@google.com>,
        Ryan Mallon <rmallon@gmail.com>, Masanari Iida <standby24x7@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 29 Jan 2015 12:43:15 +0200
In-Reply-To: <1422525801-26560-2-git-send-email-linux@rasmusvillemoes.dk>
References: <1422451543-12401-1-git-send-email-linux@rasmusvillemoes.dk>
	 <1422525801-26560-1-git-send-email-linux@rasmusvillemoes.dk>
	 <1422525801-26560-2-git-send-email-linux@rasmusvillemoes.dk>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.9-1+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2015-01-29 at 11:03 +0100, Rasmus Villemoes wrote:
> The helper hex_string() is broken in two ways. First, it doesn't
> increment buf regardless of whether there is room to print, so callers
> such as kasprintf() that try to probe the correct storage to allocate
> will get a too small return value. But even worse, kasprintf() (and
> likely anyone else trying to find the size of the result) pass NULL
> for buf and 0 for size, so we also have end == NULL. But this means
> that the end-1 in hex_string() is (char*)-1, so buf < end-1 is true
> and we get a NULL pointer deref. I double-checked this with a trivial
> kernel module that just did a kasprintf(GFP_KERNEL, "%14ph",
> "CrashBoomBang").
> 
> Nobody seems to be using %ph with kasprintf, but we might as well fix
> it before it hits someone.
> 
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>

Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

> ---
>  lib/vsprintf.c | 16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> index ec337f64f52d..3568e3906777 100644
> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -782,11 +782,19 @@ char *hex_string(char *buf, char *end, u8 *addr, struct printf_spec spec,
>  	if (spec.field_width > 0)
>  		len = min_t(int, spec.field_width, 64);
>  
> -	for (i = 0; i < len && buf < end - 1; i++) {
> -		buf = hex_byte_pack(buf, addr[i]);
> +	for (i = 0; i < len; ++i) {
> +		if (buf < end)
> +			*buf = hex_asc_hi(addr[i]);
> +		++buf;
> +		if (buf < end)
> +			*buf = hex_asc_lo(addr[i]);
> +		++buf;
>  
> -		if (buf < end && separator && i != len - 1)
> -			*buf++ = separator;
> +		if (separator && i != len - 1) {
> +			if (buf < end)
> +				*buf = separator;
> +			++buf;
> +		}
>  	}
>  
>  	return buf;


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy

