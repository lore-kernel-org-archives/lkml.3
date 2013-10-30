Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859Ab3J3W7k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 18:59:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49834 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894Ab3J3W7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 18:59:39 -0400
Date: Wed, 30 Oct 2013 15:59:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Nazarewicz <mpn@google.com>
Cc: Evgeniy Polyakov <zbr@ioremap.net>, linux-kernel@vger.kernel.org,
        Michal Nazarewicz <mina86@mina86.com>
Subject: Re: [PATCH] drivers: w1: make w1_slave::flags long to avoid casts
Message-Id: <20131030155938.0f5416fe3c5c2cbd3f9cd319@linux-foundation.org>
In-Reply-To: <5083d6c8452b765cb33acdf03fa9b20b1d15c452.1382788496.git.mina86@mina86.com>
References: <5083d6c8452b765cb33acdf03fa9b20b1d15c452.1382788496.git.mina86@mina86.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Oct 2013 12:56:11 +0100 Michal Nazarewicz <mpn@google.com> wrote:

> From: Michal Nazarewicz <mina86@mina86.com>
> 
> Changing flags field of the w1_slave to unsigned long may on
> some architectures increase the size of the structure, but
> otherwise makes the code more kosher as casting is avoided
> and *_bit family of calls do not attempt to operate on an
> entity of bigger size than realy is available.
> 
> The current behaviour does not introduce any bugs (since any
> bytes past flags field are preserved)

hm, what does this mean....

> --- a/drivers/w1/w1.c
> +++ b/drivers/w1/w1.c
> @@ -709,7 +709,7 @@ static int w1_attach_slave_device(struct w1_master *dev, struct w1_reg_num *rn)
>  
>  	sl->owner = THIS_MODULE;
>  	sl->master = dev;
> -	set_bit(W1_SLAVE_ACTIVE, (long *)&sl->flags);
> +	set_bit(W1_SLAVE_ACTIVE, &sl->flags);

...  I'd have though that running this code on little-endian 64-bit
would result in a scribble over ...

> --- a/drivers/w1/w1.h
> +++ b/drivers/w1/w1.h
> @@ -67,8 +67,8 @@ struct w1_slave
>  	struct w1_reg_num	reg_num;
>  	atomic_t		refcnt;
>  	u8			rom[9];
> -	u32			flags;
>  	int			ttl;

... w1_slave.ttl?

> +	unsigned long		flags;
>  
>  	struct w1_master	*master;
>  	struct w1_family	*family;
>
> ...
>
