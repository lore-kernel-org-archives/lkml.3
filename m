Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315AbaA1QnL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 11:43:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27273 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754685AbaA1QnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 11:43:08 -0500
Date: Tue, 28 Jan 2014 17:43:20 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Do we really need curr_target in signal_struct ?
Message-ID: <20140128164320.GB7596@redhat.com>
References: <1390895840.8373.2.camel@beeld>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390895840.8373.2.camel@beeld>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28, Rakib Mullick wrote:
>
> As an alternative of using curr_target we can use get_nr_thread() count

We do not even need get_nr_thread() if we want to kill curr_target,

> @@ -961,21 +962,16 @@ static void complete_signal(int sig, struct task_struct *p, int group)
>  		 */
>  		return;
>  	else {
> -		/*
> -		 * Otherwise try to find a suitable thread.
> -		 */
> -		t = signal->curr_target;
> -		while (!wants_signal(sig, t)) {
> +		i = get_nr_threads(p);
> +		t = p;
> +		do {
> +			--i;
>  			t = next_thread(t);
> -			if (t == signal->curr_target)
> -				/*
> -				 * No thread needs to be woken.
> -				 * Any eligible threads will see
> -				 * the signal in the queue soon.
> -				 */
> +			if (!i)
>  				return;
> -		}
> -		signal->curr_target = t;
> +		} while (!wants_signal(sig, t));

You could simply do while_each_thread(p, t) to find a thread which
wants_signal(..).

But I guess ->curr_target was added exactly to avoid this loop if
possible, assuming that wants_signal(->current_targer) should be
likely true. Although perhaps this optimization is too simple.

Oleg.

