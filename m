Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993Ab3FXJpJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 05:45:09 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46929 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718Ab3FXJpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 05:45:08 -0400
Date: Mon, 24 Jun 2013 11:44:58 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <rric@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@suse.de>,
        Robert Richter <robert.richter@linaro.org>
Subject: Re: [PATCH v2 03/14] perf: Add persistent event facilities
Message-ID: <20130624094458.GO28407@twins.programming.kicks-ass.net>
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

> +static void del_persistent_event(int cpu, struct perf_event_attr *attr)
> +{
> +	struct pers_event_desc *desc, *tmp;
> +	struct perf_event *event = NULL;
> +
> +	list_for_each_entry_safe(desc, tmp, &per_cpu(pers_events, cpu), plist) {
> +		if (desc->attr->config == attr->config) {

attr->config might not be enough; you might also want to compare type,
config1, config2, and possible bp_type as well; although I think we want
to avoid having hwbp style persistent events, but then what do I know.

> +			event = desc->event;
> +			break;
> +		}
> +	}
> +
> +	if (!event)
> +		return;
> +
> +	list_del(&desc->plist);
> +
> +	perf_event_disable(event);
> +	if (event->rb) {
> +		rb_put(event->rb);
> +		rcu_assign_pointer(event->rb, NULL);
> +	}
> +
> +	perf_event_release_kernel(event);
> +	put_unused_fd(desc->fd);
> +	kfree(desc->attr);
> +	kfree(desc);
> +}
