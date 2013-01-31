Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab3AaXng (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 18:43:36 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42147 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752Ab3AaXnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 18:43:33 -0500
Date: Thu, 31 Jan 2013 15:43:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ming Lei <ming.lei@canonical.com>
Cc: balbi@ti.com, Linux USB Mailing List <linux-usb@vger.kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: Page allocation failure on v3.8-rc5
Message-Id: <20130131154331.09d157a3.akpm@linux-foundation.org>
In-Reply-To: <CACVXFVOATzTJq+-5M9j3G3y_WUrWKJt=naPkjkLwGDmT0H8gog@mail.gmail.com>
References: <20130128091039.GG6871@arwen.pp.htv.fi>
	<CACVXFVOATzTJq+-5M9j3G3y_WUrWKJt=naPkjkLwGDmT0H8gog@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jan 2013 19:53:22 +0800
Ming Lei <ming.lei@canonical.com> wrote:

> The allocation failure is caused by the big sizeof(struct parsed_partitions),
> which is 64K in my 32bit box,

Geeze.

We could fix that nicely by making parsed_partitions.parts an array of
pointers to a single `struct parsed_partition' and allocating those
on-demand.

But given the short-lived nature of this storage and the infrequency of
check_partition(), that isn't necessary.

> could you test the blow patch to see
> if it can fix the allocation failure?

(The patch is wordwrapped)

> ...
>
> @@ -106,18 +107,43 @@ static int (*check_part[])(struct parsed_partitions *) = {
>  	NULL
>  };
> 
> +struct parsed_partitions *allocate_partitions(int nr)
> +{
> +	struct parsed_partitions *state;
> +
> +	state = kzalloc(sizeof(struct parsed_partitions), GFP_KERNEL);

I personally prefer sizefo(*state) here.  It means the reader doesn't
have to scroll back to check things.

> +	if (!state)
> +		return NULL;
> +
> +	state->parts = vzalloc(nr * sizeof(state->parts[0]));
> +	if (!state->parts) {
> +		kfree(state);
> +		return NULL;
> +	}

It doesn't really need to be this complex - we could just vmalloc the
entire `struct parsed_partitions'.  But I see that your change will
cause us to allcoate much less memory in many situations, which is
good.  It should be mentioned in the changelog!


