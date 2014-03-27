Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724AbaC0AuU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 20:50:20 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:60935 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755783AbaC0AuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 20:50:13 -0400
Message-ID: <533375C1.5060904@mit.edu>
Date: Wed, 26 Mar 2014 17:50:09 -0700
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Torsten Duwe <duwe@lst.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>, Rusty Russell <rusty@rustcorp.com.au>,
        Satoru Takeuchi <satoru.takeuchi@gmail.com>
CC: ingo.tuchscherer@de.ibm.com, linux-kernel@vger.kernel.org,
        Hans-Georg Markgraf <MGRF@de.ibm.com>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH v2 02/03]: hwrng: create filler thread
References: <20140321142950.GI1763@lst.de> <20140321143342.GK1763@lst.de>
In-Reply-To: <20140321143342.GK1763@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2014 07:33 AM, Torsten Duwe wrote:
> This can be viewed as the in-kernel equivalent of hwrngd;
> like FUSE it is a good thing to have a mechanism in user land,
> but for some reasons (simplicity, secrecy, integrity, speed)
> it may be better to have it in kernel space.

Nice.


[...]

>  
>  static struct hwrng *current_rng;
> +static struct task_struct *hwrng_fill;
>  static LIST_HEAD(rng_list);
>  static DEFINE_MUTEX(rng_mutex);
>  static int data_avail;
> -static u8 *rng_buffer;
> +static u8 *rng_buffer, *rng_fillbuf;
> +static unsigned short derating_current = 700; /* an arbitrary 70% */
> +
> +module_param(derating_current, ushort, 0644);
> +MODULE_PARM_DESC(derating_current,
> +		 "current hwrng entropy estimation per mill");

As an electrical engineer (sort of), I can't read this without thinking
you're talking about the amount by which the current is derated.  For
example, a 14-50 electrical outlet is rated to 50 Amps.  If you use it
continuously for a long time, though, the current is derated to 40 Amps.

Shouldn't this be called credit_derating or, even better,
credit_per_1000bits?

Also, "per mill" is just obscure enough that someone might think it
means "per million".


> +
> +static void start_khwrngd(void);
>  
>  static size_t rng_buffer_size(void)
>  {
> @@ -62,9 +71,18 @@ static size_t rng_buffer_size(void)
>  
>  static inline int hwrng_init(struct hwrng *rng)
>  {
> +	int err;
> +
>  	if (!rng->init)
>  		return 0;
> -	return rng->init(rng);
> +	err = rng->init(rng);
> +	if (err)
> +		return err;
> +
> +	if (derating_current > 0 && !hwrng_fill)
> +		start_khwrngd();
> +

Why the check for derating > 0?  Paranoid users may want zero credit,
but they probably still want the thing to run.

> +	return 0;
>  }
>  
>  static inline void hwrng_cleanup(struct hwrng *rng)
> @@ -300,6 +318,36 @@ err_misc_dereg:
>  	goto out;
>  }
>  
> +static int hwrng_fillfn(void *unused)
> +{
> +	long rc;
> +
> +	while (!kthread_should_stop()) {
> +		if (!current_rng)
> +			break;
> +		rc = rng_get_data(current_rng, rng_fillbuf,
> +				  rng_buffer_size(), 1);
> +		if (rc <= 0) {
> +			pr_warn("hwrng: no data available\n");

ratelimit (heavily), please.

Also, would it make sense to round-robin all hwrngs?  Even better:
collect entropy from each one and add them to the pool all at once.  If
so, would it make sense for the derating to be a per-rng parameter.  For
example, if there's a sysfs class, it could go in there.

Finally, there may be hwrngs like TPMs that are amazingly slow.  What
happens if the RNG is so slow that it becomes the bottleneck?  Should
this thing back off?  Using the TPM at 100% utilization seems silly when
there's a heavy entropy consumer, especially since reading 256 bits from
the TPM once is probably just about as secure as reading from it
continuously.


Also, with my quantum hat on, thanks for doing this in a way that isn't
gratuitously insecure against quantum attack.  128-bit reseeds are
simply too small if your adversary has a large quantum computer :)


--Andy
