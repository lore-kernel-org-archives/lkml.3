Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325Ab3JQP1h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 11:27:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30514 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757229Ab3JQP1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 11:27:35 -0400
Date: Thu, 17 Oct 2013 17:20:27 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] (Was: perf_event_mmap(vma) && !vma->vm_mm)
Message-ID: <20131017152027.GA14098@redhat.com>
References: <20131012192203.GA21738@redhat.com> <20131014102426.GX3081@twins.programming.kicks-ass.net> <20131016200924.GA23214@redhat.com> <20131016202822.GI2675@laptop.programming.kicks-ass.net> <20131016204348.GA25121@redhat.com> <20131016205807.GG10651@twins.programming.kicks-ass.net> <20131016205800.GB26066@redhat.com> <20131016211613.GJ10651@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131016211613.GJ10651@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16, Peter Zijlstra wrote:
>
> On Wed, Oct 16, 2013 at 10:58:00PM +0200, Oleg Nesterov wrote:
> > OK. I'll wait for your review on this series, then send the next patch.
> >
>
> Those two patches look good; thanks.

Thanks, can I have your acks for Ingo ?

> How about something like so on top?
>
> ---
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -5103,18 +5103,16 @@ static void perf_event_mmap_event(struct
>  	struct file *file = vma->vm_file;
>  	int maj = 0, min = 0;
>  	u64 ino = 0, gen = 0;
> -	unsigned int size;
> +	unsigned int size, len;
>  	char tmp[16];
>  	char *buf = NULL;
>  	const char *name;
>  
> -	memset(tmp, 0, sizeof(tmp));
> -
>  	if (file) {
>  		struct inode *inode;
>  		dev_t dev;
>  
> -		buf = kzalloc(PATH_MAX, GFP_KERNEL);
> +		buf = kmalloc(PATH_MAX, GFP_KERNEL);
>  		if (!buf) {
>  			name = strncpy(tmp, "//enomem", sizeof(tmp));
>  			goto got_name;
> @@ -5160,7 +5158,15 @@ static void perf_event_mmap_event(struct
>  	}
>  
>  got_name:
> -	size = ALIGN(strlen(name)+1, sizeof(u64));
> +	/*
> +	 * Since our buffer works in 8 byte units we need to align our string
> +	 * size to a multiple of 8. However, we must guarantee the tail end is
> +	 * zero'd out to avoid leaking random bits to userspace.
> +	 */
> +	len = strlen(name)+1;
> +	size = ALIGN(len, sizeof(u64));
> +	for (; len < size; len++)
> +		name[len] = '\0';

Yes, this is almost what I meant, but:

	- name is "const char *", we need another variable

	- we do not really need "len", we can simply do

		size = strlen(name) + 1;
		while (size % sizeof(u64))
			name[size++] = '\0';

	  although I won't argue if you dislike "size & 7" in while().

	- we can factor out strncpy(tmp, name).

Could you look at 3/2 I'll send in a minute?

Oleg.

