Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440Ab3CRJOL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 05:14:11 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:50076 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412Ab3CRJOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 05:14:07 -0400
X-AuditID: 9c930179-b7c78ae000000e4b-a6-5146dadafa51
From: Namhyung Kim <namhyung@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Robert Richter <rric@kernel.org>, Borislav Petkov <bp@suse.de>
Subject: Re: [RFC PATCH 2/3] perf: Add persistent event facilities
References: <1363352789-17991-1-git-send-email-bp@alien8.de>
	<1363352789-17991-3-git-send-email-bp@alien8.de>
Date: Mon, 18 Mar 2013 18:13:58 +0900
In-Reply-To: <1363352789-17991-3-git-send-email-bp@alien8.de> (Borislav
	Petkov's message of "Fri, 15 Mar 2013 14:06:28 +0100")
Message-ID: <878v5ljcix.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Mar 2013 14:06:28 +0100, Borislav Petkov wrote:
> Add a barebones implementation for registering persistent events with
> perf. For that, we don't destroy the buffers when they're unmapped;
> also, we map them read-only so that multiple agents can access them.
>
> Also, we allocate the event buffers at event init time and not at mmap
> time so that we can log samples into them regardless of whether there
> are readers in userspace or not.
[SNIP]
> -static void ring_buffer_put(struct ring_buffer *rb)
> +void perf_ring_buffer_put(struct ring_buffer *rb)

Why did you rename this function?


>  {
>  	struct perf_event *event, *n;
>  	unsigned long flags;
[SNIP]
> +static struct perf_event *
> +add_persistent_event_on_cpu(unsigned int cpu, struct perf_event_attr *attr,
> +			    unsigned nr_pages)
> +{
> +	struct perf_event *event = ERR_PTR(-EINVAL);

Looks like -ENOMEM is more appropriate code for the below kzalloc.


> +	struct pers_event_desc *desc;
> +	struct ring_buffer *buf;
> +
> +	desc = kzalloc(sizeof(*desc), GFP_KERNEL);
> +	if (!desc)
> +		goto out;
> +
> +	event = perf_event_create_kernel_counter(attr, cpu, NULL, NULL, NULL);
> +	if (IS_ERR(event))
> +		goto err_event;
> +
> +	buf = rb_alloc(nr_pages, 0, cpu, 0);
> +	if (!buf)
> +		goto err_event_file;
> +
> +	rcu_assign_pointer(event->rb, buf);
> +
> +	desc->event = event;
> +	desc->attr  = attr;
> +
> +	INIT_LIST_HEAD(&desc->plist);
> +	list_add_tail(&desc->plist, &per_cpu(pers_events, cpu));
> +
> +	perf_event_enable(event);
> +
> +	goto out;
> +
> + err_event_file:
> +	perf_event_release_kernel(event);

It needs to reset event to ERR_PTR(-ENOMEM) ?

> +
> + err_event:
> +	kfree(desc);
> +
> + out:
> +	return event;
> +}
> +
> +static void rm_persistent_event(int cpu, struct perf_event_attr *attr)
> +{
> +	struct pers_event_desc *desc, *tmp;
> +	struct perf_event *event = NULL;
> +
> +	list_for_each_entry_safe(desc, tmp, &per_cpu(pers_events, cpu), plist) {
> +		if (desc->attr->config == attr->config) {
> +			event = desc->event;
> +			break;
> +		}
> +	}
> +
> +	if (!event)
> +		return;
> +
> +	__list_del(desc->plist.prev, desc->plist.next);

Why not using list_del(&desc->plist) ?

> +
> +	perf_event_disable(event);
> +	if (event->rb) {
> +		perf_ring_buffer_put(event->rb);
> +		rcu_assign_pointer(event->rb, NULL);
> +	}
> +
> +	perf_event_release_kernel(event);
> +	put_unused_fd(desc->fd);
> +	kfree(desc);
> +}
> +
> +int perf_get_persistent_event_fd(unsigned cpu, struct perf_event_attr *attr)
> +{
> +	struct pers_event_desc *desc;
> +	struct file *event_file = NULL;
> +	int event_fd = -1;
> +
> +	list_for_each_entry(desc, &per_cpu(pers_events, cpu), plist) {
> +
> +		if (desc->attr->config != attr->config)
> +			continue;
> +
> +		event_fd = get_unused_fd();
> +		if (event_fd < 0)
> +			goto out;
> +
> +		event_file = anon_inode_getfile("[pers_event]", &perf_fops,
> +						desc->event, O_RDONLY);
> +		if (IS_ERR(event_file))
> +			goto err_event_file;
> +
> +		desc->fd = event_fd;
> +		fd_install(event_fd, event_file);
> +
> +		return event_fd;
> +	}
> +
> + err_event_file:
> +	put_unused_fd(event_fd);

Isn't it safe to have event_fd of -1 in case not found?  Anyway, if it's
returned to the user space directly, it's better having more meaningful
error code IMHO.

> +
> +out:
> +	return event_fd;
> +}

Thanks,
Namhyung
