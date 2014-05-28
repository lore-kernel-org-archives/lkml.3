Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302AbaE1TXk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 15:23:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39398 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763AbaE1TXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 15:23:38 -0400
Date: Wed, 28 May 2014 12:27:13 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Jingoo Han <jg1.han@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Jiri Slaby <jslaby@suse.cz>,
        linux-serial@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] serial: samsung: Neaten dbg uses
Message-ID: <20140528192713.GA24902@kroah.com>
References: <1400619950.26709.39.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400619950.26709.39.camel@joe-AO725>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 02:05:50PM -0700, Joe Perches wrote:
> Add format and argument checking and fix misuses in the dbg macro.
> 
> Add __printf
> Use %pR for resource
> Add #include guard to samsung.h
> Move static functions from .h to .c
> Use vscnprintf instead of length unguarded vsprintf
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
> 
> compiled (no warnings)/untested.
> 
>  drivers/tty/serial/samsung.c | 35 +++++++++++++++++++++++++++++------
>  drivers/tty/serial/samsung.h | 23 +++--------------------
>  2 files changed, 32 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/tty/serial/samsung.c b/drivers/tty/serial/samsung.c
> index 1f5505e..3293377 100644
> --- a/drivers/tty/serial/samsung.c
> +++ b/drivers/tty/serial/samsung.c
> @@ -53,6 +53,29 @@
>  
>  #include "samsung.h"
>  
> +#if	defined(CONFIG_SERIAL_SAMSUNG_DEBUG) &&	\
> +	defined(CONFIG_DEBUG_LL) &&		\
> +	!defined(MODULE)
> +
> +extern void printascii(const char *);
> +
> +__printf(1, 2)
> +static void dbg(const char *fmt, ...)
> +{
> +	va_list va;
> +	char buff[256];
> +
> +	va_start(va, fmt);
> +	vscnprintf(buff, sizeof(buf), fmt, va);
> +	va_end(va);
> +
> +	printascii(buff);
> +}
> +
> +#else
> +#define dbg(fmt, ...) do { if (0) no_printk(fmt, ##__VA_ARGS__); } while (0)
> +#endif

Ick, what a mess.  I'll take this, but I think I'll just convert this to
dev_dbg() instead of dealing with a config option mess...

thanks,

greg k-h
