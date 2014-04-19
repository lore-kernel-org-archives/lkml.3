Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081AbaDSXOd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 19:14:33 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48858 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbaDSXO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 19:14:28 -0400
Date: Sat, 19 Apr 2014 19:14:00 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH] coredump: fix va_list corruption
Message-ID: <20140419231400.GA13176@localhost.localdomain>
References: <1397927707.19600.20.camel@edumazet-glaptop2.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397927707.19600.20.camel@edumazet-glaptop2.roam.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 19, 2014 at 10:15:07AM -0700, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> A va_list needs to be copied in case it needs to be used twice.
> 
> Thanks to Hugh for debugging this issue, leading to various panics.
> 
> Tested:
> 
> lpq84:~# echo "|/foobar12345 %h %h %h %h %h %h %h %h %h %h %h %h %h %h %
> h %h %h %h %h %h" >/proc/sys/kernel/core_pattern
> 
> 'produce_core' is simply : main() { *(int *)0 = 1;}
> 
> lpq84:~# ./produce_core
> Segmentation fault (core dumped)
> lpq84:~# dmesg | tail -1
> [  614.352947] Core dump to |/foobar12345 lpq84 lpq84 lpq84 lpq84 lpq84
> lpq84 lpq84 lpq84 lpq84 lpq84 lpq84 lpq84 lpq84 lpq84 lpq84 lpq84 lpq84
> lpq84 lpq84 (null) pipe failed
> 
> Notice the last argument was replaced by a NULL (we were lucky enough to
> not crash, but do not try this on your production machine !)
> 
> After fix :
> 
> lpq83:~# echo "|/foobar12345 %h %h %h %h %h %h %h %h %h %h %h %h %h %h %
> h %h %h %h %h %h" >/proc/sys/kernel/core_pattern
> lpq83:~# ./produce_core
> Segmentation fault
> lpq83:~# dmesg | tail -1
> [  740.800441] Core dump to |/foobar12345 lpq83 lpq83 lpq83 lpq83 lpq83
> lpq83 lpq83 lpq83 lpq83 lpq83 lpq83 lpq83 lpq83 lpq83 lpq83 lpq83 lpq83
> lpq83 lpq83 lpq83 pipe failed
> 
> Fixes: 5fe9d8ca21cc ("coredump: cn_vprintf() has no reason to call vsnprintf() twice")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Diagnosed-by: Hugh Dickins <hughd@google.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Neil Horman <nhorman@tuxdriver.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: stable@vger.kernel.org # 3.11+
> ---
> 
> Note: This patch applies cleanly to 3.11+ but might need some
> adjustments for older linux kernels...
> 
>  fs/coredump.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/coredump.c b/fs/coredump.c
> index e3ad709a4232..0b2528fb640e 100644
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
>  	if (need < free) {
>  		cn->used += need;
>  		return 0;
> 
> 
> 

Thanks Eric!
Acked-by: Neil Horman <nhorman@tuxdriver.com>

