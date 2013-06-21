Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946209Ab3FUWYu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 18:24:50 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48780 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161469Ab3FUWYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 18:24:49 -0400
Message-ID: <51C4D294.5060909@infradead.org>
Date: Fri, 21 Jun 2013 15:24:20 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Markus Grabner <grabner@icg.tugraz.at>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: line6: avoid __sync_fetch_and_{and,or}
References: <201306212155.36196.arnd@arndb.de>
In-Reply-To: <201306212155.36196.arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/13 12:55, Arnd Bergmann wrote:
> __sync_fetch_and_and and __sync_fetch_and_or are functions that are provided
> by gcc and depending on the target architecture may be implemented in libgcc,
> which is not always available in the kernel. This leads to a build failure
> on ARMv5:

and on x86_64.

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> 
> drivers/built-in.o: In function `line6_pcm_release':
> :(.text+0x3bfe80): undefined reference to `__sync_fetch_and_and_4'
> drivers/built-in.o: In function `line6_pcm_acquire':
> :(.text+0x3bff30): undefined reference to `__sync_fetch_and_or_4'
> 
> To work around this, we can use the kernel-provided cmpxchg macro.
> 
> Build-tested only.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Markus Grabner <grabner@icg.tugraz.at>
> 
> diff --git a/drivers/staging/line6/pcm.c b/drivers/staging/line6/pcm.c
> index 02f77d7..4795f12 100644
> --- a/drivers/staging/line6/pcm.c
> +++ b/drivers/staging/line6/pcm.c
> @@ -107,11 +107,15 @@ static bool test_flags(unsigned long flags0, unsigned long flags1,
>  
>  int line6_pcm_acquire(struct snd_line6_pcm *line6pcm, int channels)
>  {
> -	unsigned long flags_old =
> -	    __sync_fetch_and_or(&line6pcm->flags, channels);
> -	unsigned long flags_new = flags_old | channels;
> -	unsigned long flags_final = flags_old;
> -	int err = 0;
> +	unsigned long flags_old, flags_new, flags_final;
> +	int err;
> +
> +	do {
> +		flags_old = ACCESS_ONCE(line6pcm->flags);
> +		flags_new = flags_old | channels;
> +	} while (cmpxchg(&line6pcm->flags, flags_old, flags_new) != flags_old);
> +
> +	flags_final = flags_old;
>  
>  	line6pcm->prev_fbuf = NULL;
>  
> @@ -197,9 +201,12 @@ pcm_acquire_error:
>  
>  int line6_pcm_release(struct snd_line6_pcm *line6pcm, int channels)
>  {
> -	unsigned long flags_old =
> -	    __sync_fetch_and_and(&line6pcm->flags, ~channels);
> -	unsigned long flags_new = flags_old & ~channels;
> +	unsigned long flags_old, flags_new;
> +
> +	do {
> +		flags_old = ACCESS_ONCE(line6pcm->flags);
> +		flags_new = flags_old & ~channels;
> +	} while (cmpxchg(&line6pcm->flags, flags_old, flags_new) != flags_old);
>  
>  	if (test_flags(flags_new, flags_old, LINE6_BITS_CAPTURE_STREAM))
>  		line6_unlink_audio_in_urbs(line6pcm);
> --


-- 
~Randy
