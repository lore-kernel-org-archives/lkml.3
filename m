Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967143Ab3E2XCA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 19:02:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51122 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967080Ab3E2XBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 19:01:52 -0400
Date: Wed, 29 May 2013 16:01:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH] timer: Fix jiffies wrap behavior of round_jiffies*()
Message-Id: <20130529160150.f0a498d188dc790d018200e9@linux-foundation.org>
In-Reply-To: <519BC066.5080600@acm.org>
References: <519BC066.5080600@acm.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 May 2013 20:43:50 +0200 Bart Van Assche <bart.vanassche@gmail.com> wrote:

> Make sure that the round_jiffies*() functions return a time that is
> in the future when the jiffies counter is about to wrap.

Actually "when the jiffies counter has recently wrapped".

I assume this was found by inspection?

> @@ -149,9 +149,7 @@ static unsigned long round_jiffies_common(unsigned long j, int cpu,
>  	/* now that we have rounded, subtract the extra skew again */
>  	j -= cpu * 3;
> -	if (j <= jiffies) /* rounding ate our timeout entirely; */

This used to be a very common bug - we've weeded out many instances but
I'm sure more still remain.  We could perhaps have a checkpatch rule
which looks for comparisons against jiffes (and any other
time-measuring variables we can detect) and tells people to use
time_after() and friends, or time_is_*_jiffies().

> -		return original;
> -	return j;
> +	return time_is_after_jiffies(j) ? j : original;
>  }

Your email client mangles patches, btw.
