Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156AbaLRHu1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 02:50:27 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:59247 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbaLRHu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 02:50:26 -0500
From: Arnd Bergmann <arnd@linaro.org>
To: Chunyan Zhang <zhang.chunyan@linaro.org>
Cc: m.chehab@samsung.com, david@hardeman.nu, uli-lirc@uli-eckhardt.de,
        hans.verkuil@cisco.com, julia.lawall@lip6.fr, himangi774@gmail.com,
        khoroshilov@ispras.ru, joe@perches.com, john.stultz@linaro.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        zhang.lyra@gmail.com
Subject: Re: [PATCH] media: rc: Replace timeval with ktime_t in imon.c
Date: Thu, 18 Dec 2014 08:50:14 +0100
Message-ID: <1685288.Gd2P1eSoIW@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1418873833-5084-1-git-send-email-zhang.chunyan@linaro.org>
References: <1418873833-5084-1-git-send-email-zhang.chunyan@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:iovZsJtBM2QXgeRavMkItL3rI/CjYcsYottqn6U6AUct6CQOPiV
 +gQeZaxrwah11mX0YS0SPKlJMB4rEM6E7g8kUy3IS7fQP4ga2wz9zyK7FO5GF1gqskFT4JB
 3p2ZyTcDSxc2NSYQfGSA1zeHLcawiH7OSz4fV4SCZF1XQ6laQGJ3hE1MZ46WyE80IdjuVEv
 gSSxpqO1kkawoQNrUZqyA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 December 2014 11:37:13 Chunyan Zhang wrote:
> This patch changes the 32-bit time type (timeval) to the 64-bit one
> (ktime_t), since 32-bit time types will break in the year 2038.
> 
> I use ktime_t instead of all uses of timeval in imon.c
> 
> This patch also changes do_gettimeofday() to ktime_get() accordingly,
> since ktime_get returns a ktime_t, but do_gettimeofday returns a
> struct timeval, and the other reason is that ktime_get() uses
> the monotonic clock.
> 
> This patch use a new function which is provided by another patch listed below
> to get the millisecond time difference.

The patch looks great. Just a few small details that could still be
improved:

> http://lkml.iu.edu//hypermail/linux/kernel/1412.2/00625.html
> 
> Signed-off-by: Chunyan Zhang <zhang.chunyan@linaro.org>

In general, when you give a mailing list link, use the 'Link' tag
under your Signed-off-by line, like

Link: http://lkml.iu.edu//hypermail/linux/kernel/1412.2/00625.html

It's not used much yet, but getting more popular and seems useful to me.

In this particular case, when you have patches that depend on one
another, you can make do it even better by sending all three patches
as a series with a [PATCH 0/3] cover letter.

If the media maintainers can provide an Ack for this patch, I would
suggest to queue it up in the y2038 branch together with your first
patch that it depends on.

> @@ -1191,16 +1168,16 @@ static inline int tv2int(const struct timeval *a, const struct timeval *b)
>   */
>  static int stabilize(int a, int b, u16 timeout, u16 threshold)
>  {
> -	struct timeval ct;
> -	static struct timeval prev_time = {0, 0};
> -	static struct timeval hit_time  = {0, 0};
> +	ktime_t ct;
> +	static ktime_t prev_time = {0};
> +	static ktime_t hit_time  = {0};
>  	static int x, y, prev_result, hits;
>  	int result = 0;

The "= {0}" part here is redundant, since static variables are always
initialized to zero. Normally, adding the explicit initializer can
help readability, but in this case I would leave it out because it shows
implementation details of ktime_t that are better hidden from drivers.

> @@ -1596,9 +1573,9 @@ static void imon_incoming_packet(struct imon_context *ictx,
>  	int i;
>  	u64 scancode;
>  	int press_type = 0;
> -	int msec;
> -	struct timeval t;
> -	static struct timeval prev_time = { 0, 0 };
> +	long msec;
> +	ktime_t t;
> +	static ktime_t prev_time = {0};
>  	u8 ktype;

Same thing here of course.

	Arnd
