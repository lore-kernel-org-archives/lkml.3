Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751220AbaKXW5c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 17:57:32 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56605 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbaKXW5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 17:57:31 -0500
Date: Mon, 24 Nov 2014 14:57:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan@kernel.org>, Dave Hansen <dave@sr71.net>,
        Michal Nazarewicz <mina86@mina86.com>,
        Jungsoo Son <jungsoo.son@lge.com>, Ingo Molnar <mingo@redhat.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 5/8] stacktrace: introduce snprint_stack_trace for
 buffer output
Message-Id: <20141124145752.ab64fd85.akpm@linux-foundation.org>
In-Reply-To: <1416816926-7756-6-git-send-email-iamjoonsoo.kim@lge.com>
References: <1416816926-7756-1-git-send-email-iamjoonsoo.kim@lge.com>
	<1416816926-7756-6-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Nov 2014 17:15:23 +0900 Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:

> Current stacktrace only have the function for console output.
> page_owner that will be introduced in following patch needs to print
> the output of stacktrace into the buffer for our own output format
> so so new function, snprint_stack_trace(), is needed.
> 
> ...
>
> +int snprint_stack_trace(char *buf, size_t size,
> +			struct stack_trace *trace, int spaces)
> +{
> +	int i;
> +	unsigned long ip;
> +	int generated;
> +	int total = 0;
> +
> +	if (WARN_ON(!trace->entries))
> +		return 0;
> +
> +	for (i = 0; i < trace->nr_entries; i++) {
> +		ip = trace->entries[i];
> +		generated = snprintf(buf, size, "%*c[<%p>] %pS\n",
> +				1 + spaces, ' ', (void *) ip, (void *) ip);
> +
> +		total += generated;
> +
> +		/* Assume that generated isn't a negative number */
> +		if (generated >= size) {
> +			buf += size;
> +			size = 0;

Seems strange to keep looping around doing nothing.  Would it be better
to `break' here?

> +		} else {
> +			buf += generated;
> +			size -= generated;
> +		}
> +	}
> +
> +	return total;
> +}
> +EXPORT_SYMBOL_GPL(snprint_stack_trace);
> +
