Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106Ab3IUNgK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 09:36:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32171 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807Ab3IUNgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 09:36:08 -0400
Date: Sat, 21 Sep 2013 15:35:57 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] perf: potential underflow in perf_sample_ustack_size()
Message-ID: <20130921133556.GB8304@krava.brq.redhat.com>
References: <20130920113736.GB8655@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130920113736.GB8655@elgon.mountain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 20, 2013 at 02:37:36PM +0300, Dan Carpenter wrote:
> The code here is trying to ensure that we don't have a
> "header_size + stack_size" which is more than USHRT_MAX.  I changed
> the overflow check a little to make it more clear.
> 
> My concern here is that if "header_size + sizeof(u64)" is very large
> then we could end up with underflow doing the subtraction and end up
> with a "stack_size" larger than intended.
> 
> I don't know perf well enough to say if this is possible.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index dd236b6..eec9e683 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -4217,11 +4217,13 @@ perf_sample_ustack_size(u16 stack_size, u16 header_size,
>  	header_size += 2 * sizeof(u64);
>  
>  	/* Do we fit in with the current stack dump size? */
> -	if ((u16) (header_size + stack_size) < header_size) {
> +	if (header_size > USHRT_MAX - stack_size) {

hum, the original check looks clear enough to me

>  		/*
>  		 * If we overflow the maximum size for the sample,
>  		 * we customize the stack dump size to fit in.
>  		 */
> +		if (header_size + sizeof(u64) > USHRT_MAX)
> +			return 0;

ok, I wonder if we could practically reach header size
this big, but it's safer to check

thanks,
jirka

>  		stack_size = USHRT_MAX - header_size - sizeof(u64);
>  		stack_size = round_up(stack_size, sizeof(u64));
>  	}
