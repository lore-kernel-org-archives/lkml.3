Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193Ab3FXJcO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 05:32:14 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46673 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab3FXJcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 05:32:13 -0400
Date: Mon, 24 Jun 2013 11:32:04 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <rric@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@suse.de>,
        Robert Richter <robert.richter@linaro.org>
Subject: Re: [PATCH v2 03/14] perf: Add persistent event facilities
Message-ID: <20130624093204.GN28407@twins.programming.kicks-ass.net>
References: <1370968960-22527-1-git-send-email-rric@kernel.org>
 <1370968960-22527-4-git-send-email-rric@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370968960-22527-4-git-send-email-rric@kernel.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 11, 2013 at 06:42:29PM +0200, Robert Richter wrote:
> +static struct perf_event *
> +add_persistent_event_on_cpu(unsigned int cpu, struct perf_event_attr *attr,
> +			    unsigned nr_pages)
> +{
> +	struct perf_event *event = ERR_PTR(-ENOMEM);
> +	struct pers_event_desc *desc;
> +	struct ring_buffer *buf;
> +
> +	desc = kzalloc(sizeof(*desc), GFP_KERNEL);
> +	if (!desc)
> +		goto out;
> +
> +	buf = rb_alloc(nr_pages, 0, cpu, 0);
> +	if (!buf)
> +		goto err_rb;
> +
> +	event = perf_event_create_kernel_counter(attr, cpu, NULL, NULL, NULL);
> +	if (IS_ERR(event))
> +		goto err_event;
> +
> +	rcu_assign_pointer(event->rb, buf);
> +
> +	desc->event = event;
> +	desc->attr  = attr;
> +
> +	INIT_LIST_HEAD(&desc->plist);
> +	list_add_tail(&desc->plist, &per_cpu(pers_events, cpu));
> +
> +	/* All workie, enable event now */
> +	perf_event_enable(event);
> +
> +	goto out;
> +
> + err_event:
> +	rb_put(buf);
> +
> + err_rb:
> +	kfree(desc);
> +
> + out:
> +	return event;
> +}

I generally disapprove of indented labels. None of the perf code has
that and the tools are easy to 'fix'.

My quiltrc contains:

QUILT_DIFF_OPTS="-F ^[[:alpha:]\$_].*[^:]\$"

my .gitconfig contains:

[diff "default"]
                xfuncname = "^[[:alpha:]$_].*[^:]$"

Both avoid diff thinking labels are function names.
