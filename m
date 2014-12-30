Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868AbaL3VFw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 16:05:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39118 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486AbaL3VFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 16:05:51 -0500
Message-ID: <54A313A0.7050807@redhat.com>
Date: Tue, 30 Dec 2014 16:05:36 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC: Steven Rostedt <rostedt@goodmis.org>,
        Clark Williams <clark.williams@gmail.com>,
        Luiz Capitulino <lcapitulino@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -rt] timer: upper bound on loops of __run_timers processing
References: <20141230195228.GA3057@amt.cnet>
In-Reply-To: <20141230195228.GA3057@amt.cnet>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 12/30/2014 02:52 PM, Marcelo Tosatti wrote:
> 
> Commit "timers: do not raise softirq unconditionally", allows for
> timer wheel processing (__run_timers) to be delayed for long
> periods of time.
> 
> The effect is that
> 
> loops = jiffies - base->timer_jiffies
> 
> Can grow to very large values resulting in __run_timers taking
> hundreds of milliseconds to execute.
> 
> Fix by creating an upper bound on the number of loops to be
> processed. This allows a nohz=off kernel to achieve desired
> latencies.
> 
> Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
> 
> diff --git a/kernel/timer.c b/kernel/timer.c index f59e18c..c128416
> 100644 --- a/kernel/timer.c +++ b/kernel/timer.c @@ -1488,6
> +1488,12 @@ void run_local_timers(void) } #endif
> 
> +	if (time_after_eq(jiffies, base->timer_jiffies)) { +		unsigned
> long jiffies_delta = jiffies - base->timer_jiffies; +		if
> (jiffies_delta > TVR_SIZE) +			raise_softirq(TIMER_SOFTIRQ); +	}

It certainly looks like cascading the timers over and over and
over again could be a lot of work.

Acked-by: Rik van Riel <riel@redhat.com>

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUoxOfAAoJEM553pKExN6DO+0H/i2TXS2DJ6cObGZytYhsRz/U
4oqH4eCjwK5JczFMsyoUh/kXIkEQukMudj74katoP0TARlcnZF2G+R/Hj4XccCpz
X84DI7SCFZIwl3gpiuOoR81mosd1VkLBouwYj1Aglt+5Sh63yq91lreX20Tw/swF
jlorAWAAblQdt2zC5smjtbbhfKMuPC8qJFGoiGmLLPC/1l9XmGmfymB2WfN8IZm4
DrqAlCSm8+xxGdwUwAZTuHuHX15VOpGuUuEV2E8BM+6G93HI8iJe5E7g5hRymcNp
NPCe+BFgZ9AxHqNokC1cSWrqaS3koBbTJRDKAqxSEptmYQMZ/a61ydYJQmBtImw=
=uqAv
-----END PGP SIGNATURE-----
