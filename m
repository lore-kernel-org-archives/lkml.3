Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357Ab3COFFn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 01:05:43 -0400
Received: from ozlabs.org ([203.10.76.45]:59204 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751669Ab3COFFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 01:05:41 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc: Satoru Takeuchi <satoru.takeuchi@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Aurelien Jarno <aurelien@aurel32.net>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: Re: [PATCH] hw_random: free rng_buffer at module exit
In-Reply-To: <87k3pagllu.wl%satoru.takeuchi@gmail.com>
References: <20130312223211.492954675@linuxfoundation.org> <20130312223212.790278686@linuxfoundation.org> <874ngeykp6.wl%satoru.takeuchi@gmail.com> <87txoetre6.fsf@rustcorp.com.au> <87k3pagllu.wl%satoru.takeuchi@gmail.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Fri, 15 Mar 2013 15:35:07 +1030
Message-ID: <87d2v1tfr0.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Satoru Takeuchi <satoru.takeuchi@gmail.com> writes:
> At Thu, 14 Mar 2013 17:11:21 +1030,
> Rusty Russell wrote:
>> 
>> Satoru Takeuchi <satoru.takeuchi@gmail.com> writes:
>> > Hi Rusty,
>> >
>> > At Tue, 12 Mar 2013 15:43:33 -0700,
>> > Greg Kroah-Hartman wrote:
>> >> @@ -307,6 +312,14 @@ int hwrng_register(struct hwrng *rng)
>> >>  
>> >>  	mutex_lock(&rng_mutex);
>> >>  
>> >> +	/* kmalloc makes this safe for virt_to_page() in virtio_rng.c */
>> >> +	err = -ENOMEM;
>> >> +	if (!rng_buffer) {
>> >> +		rng_buffer = kmalloc(rng_buffer_size(), GFP_KERNEL);
>> >
>> > rng_buffer is now kmalloc-ed, but not kfree-ed. Shoudn't it be kfree-ed
>> > at hwrng_unregister()? If my suspect is correct, the same problem is
>> > in 3.8.3-rc1 and 3.0.69-rc1. I'm OK to make a patch, but it'll be after
>> > some hours.
>> >
>> > Corecct me if I'm wrong.
>> 
>> Yes, it would be nice to free it, but it really makes sense to free it
>> in module_cleanup() (which would have to be written, as the module
>> currently doesn't have one).
>> 
>> Cheers,
>> Rusty.
>
> From: Satoru Takeuchi <satoru.takeuchi@gmail.com>
>
> rng-core module allocates rng_buffer by kmalloc() since commit
> f7f154f1246ccc5a0a7e9ce50932627d60a0c878. But this buffer won't be
> freed and there is a memory leak possibility at module exit.
>
> Signed-off-by: Satoru Takeuchi <satoru.takeuchi@gmail.com>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Matt Mackall <mpm@selenic.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Aurelien Jarno <aurelien@aurel32.net>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: stable@vger.kernel.org

Cc: stable might be overkill, but I've tested it and put it in my patch
queue, and will push it to Linus once it's survived linux-next.

Thanks,
Rusty.
