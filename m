Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381AbaA0XLK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 18:11:10 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:56968 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbaA0XLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 18:11:09 -0500
Message-ID: <52E6E786.80301@gmail.com>
Date: Tue, 28 Jan 2014 10:11:02 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>,
        Joe Perches <joe@perches.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Olof Johansson <olof@lixom.net>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Daniel Borkmann <dborkman@redhat.com>
Subject: Re: [PATCH] vsprintf: BUG on %n
References: <20140127230326.GA877@www.outflux.net>
In-Reply-To: <20140127230326.GA877@www.outflux.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/01/14 10:03, Kees Cook wrote:
> Now that there has been a full release of the kernel, and all users
> of %n have been dropped, switch to %n use triggering a BUG. Ignoring
> arguments could be used to assist in information leaks if an arbitrary
> format string was under the control of an attacker.

Not sure I follow the reasoning. %n no longer does anything in the
kernel, so there is no risk if it does manage to find its way into a
printed string. BUG() is for unrecoverable errors, which this clearly isn't.

Information leaks via injectable strings are still possible if an
attacker can insert %x, %d, etc. %n is more problematic since it allows
for code injection, which is why it got removed. %n is not however,
required to get an infoleak via a format string, so I think the summary
is also a bit misleading.

~Ryan

> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  lib/vsprintf.c |   13 +++++--------
>  1 file changed, 5 insertions(+), 8 deletions(-)
> 
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> index 185b6d300ebc..a27fd7f61325 100644
> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -1735,15 +1735,12 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
>  		case FORMAT_TYPE_NRCHARS: {
>  			/*
>  			 * Since %n poses a greater security risk than
> -			 * utility, ignore %n and skip its argument.
> +			 * utility, it should not be implemented. Instead,
> +			 * BUG when encountering %n, since there are no
> +			 * legitimate users and skipping arguments could
> +			 * assist information leak attacks.
>  			 */
> -			void *skip_arg;
> -
> -			WARN_ONCE(1, "Please remove ignored %%n in '%s'\n",
> -					old_fmt);
> -
> -			skip_arg = va_arg(args, void *);
> -			break;
> +			BUG();
>  		}
>  
>  		default:
> 

