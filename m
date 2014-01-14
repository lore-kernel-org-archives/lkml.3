Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751712AbaANSOq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 13:14:46 -0500
Received: from mail-gg0-f169.google.com ([209.85.161.169]:60054 "EHLO
	mail-gg0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503AbaANSOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 13:14:43 -0500
X-Greylist: delayed 455 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Jan 2014 13:14:43 EST
Message-ID: <1389722825.31367.260.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH RFC] reciprocal_divide: correction/update of the
 algorithm
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Hannes Frederic Sowa <hannes@stressinduktion.org>
Cc: netdev@vger.kernel.org, dborkman@redhat.com, linux-kernel@vger.kernel.org,
        darkjames-ws@darkjames.pl
Date: Tue, 14 Jan 2014 10:07:05 -0800
In-Reply-To: <20140113214249.GK6586@order.stressinduktion.org>
References: <20140113214249.GK6586@order.stressinduktion.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-01-13 at 22:42 +0100, Hannes Frederic Sowa wrote:
> This patch is a RFC and part of a series Daniel Borkmann and me want to
> do when introducing prandom_u32_range{,_ro} and prandom_u32_max{,_ro}
> helpers later this week.

> -static inline u32 reciprocal_divide(u32 A, u32 R)
> +struct reciprocal_value reciprocal_value(u32 d);
> +
> +static inline u32 reciprocal_divide(u32 a, struct reciprocal_value R)
>  {
> -	return (u32)(((u64)A * R) >> 32);
> +	u32 t = (u32)(((u64)a * R.m) >> 32);
> +	return (t + ((a - t) >> R.sh1)) >> R.sh2;
>  }

I would rather introduce new helpers and convert users that really need
them.

For instance, just use a divide in BPF, because doing this on JIT might
be too complex for the gains. Strangely, libpcap doesn't seem to
optimize any divide, like divides by a power of two...

Reciprocal were added 7 years ago, for very specific uses, but current
cpus have reasonably fast dividers.



