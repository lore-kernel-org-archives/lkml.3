Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161078AbaDSSEa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 14:04:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59664 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161043AbaDSSE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 14:04:28 -0400
Date: Sat, 19 Apr 2014 20:04:21 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH] coredump: fix va_list corruption
Message-ID: <20140419180421.GA982@redhat.com>
References: <1397927707.19600.20.camel@edumazet-glaptop2.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397927707.19600.20.camel@edumazet-glaptop2.roam.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19, Eric Dumazet wrote:
>
> A va_list needs to be copied in case it needs to be used twice.

OOPS :/

> --- a/fs/coredump.c
> +++ b/fs/coredump.c
> @@ -73,10 +73,15 @@ static int expand_corename(struct core_name *cn, int size)
>  static int cn_vprintf(struct core_name *cn, const char *fmt, va_list arg)
>  {
>  	int free, need;
> +	va_list arg_copy;
>
>  again:
>  	free = cn->size - cn->used;
> -	need = vsnprintf(cn->corename + cn->used, free, fmt, arg);
> +
> +	va_copy(arg_copy, arg);
> +	need = vsnprintf(cn->corename + cn->used, free, fmt, arg_copy);
> +	va_end(arg_copy);
> +

Thanks!

Acked-by: Oleg Nesterov <oleg@redhat.com>

