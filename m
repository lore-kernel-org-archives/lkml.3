Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269Ab3C1SPX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 14:15:23 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:52795 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876Ab3C1SPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 14:15:21 -0400
Date: Thu, 28 Mar 2013 19:15:16 +0100
From: Robert Richter <rric@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Borislav Petkov <bp@suse.de>
Subject: Re: [RFC PATCH 2/3] perf: Add persistent event facilities
Message-ID: <20130328181516.GR11449@rric.localhost>
References: <1363352789-17991-1-git-send-email-bp@alien8.de>
 <1363352789-17991-3-git-send-email-bp@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363352789-17991-3-git-send-email-bp@alien8.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boris,

in general your approach looks good. Just a question and some comments
below.

On 15.03.13 14:06:28, Borislav Petkov wrote:
> Add a barebones implementation for registering persistent events with
> perf. For that, we don't destroy the buffers when they're unmapped;
> also, we map them read-only so that multiple agents can access them.
> 
> Also, we allocate the event buffers at event init time and not at mmap
> time so that we can log samples into them regardless of whether there
> are readers in userspace or not.

The mmap'ed region is already allocated by the kernel. How does a user
know the buffer size of the mmap'ed region?

Comments below of what I found so far.

Also, I wouldn't make too much use of -EINVAL, this should only be
used if the syscall contains *wrong* data.

-Robert

> +static struct perf_event *
> +add_persistent_event_on_cpu(unsigned int cpu, struct perf_event_attr *attr,
> +			    unsigned nr_pages)
> +{
> +	struct perf_event *event = ERR_PTR(-EINVAL);
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

event must be set to an error code here.

Better swap order of rb_alloc() and perf_event_create_kernel_
counter(). Makes things easier.

> +
> + err_event:
> +	kfree(desc);
> +
> + out:
> +	return event;
> +}
> +
> +static void rm_persistent_event(int cpu, struct perf_event_attr *attr)

Would rather prefer del_... as this is actually used for deleting
events in perf.

[...]

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

Umm, the attr->config is not sufficient as a selector since it must be
unique which is not granted (of course it works for one event only).

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
> +
> +out:
> +	return event_fd;
> +}
> +
> +/*
> + * Create and enable the persistent version of the perf event described by
> + * @attr.
> + *
> + * @attr: perf event descriptor
> + * @nr_pages: size in pages
> + */
> +int perf_add_persistent_event(struct perf_event_attr *attr, unsigned nr_pages)
> +{
> +	struct perf_event *event;
> +	int i;
> +
> +	for_each_possible_cpu(i) {
> +		event = add_persistent_event_on_cpu(i, attr, nr_pages);
> +		if (IS_ERR(event)) {
> +			pr_err("%s: Error adding persistent event on cpu %d\n",
> +				__func__, i);
> +			goto unwind;
> +		}
> +	}
> +	return 0;
> +
> +unwind:
> +	while (--i >= 0)
> +		rm_persistent_event(i, attr);
> +
> +	return -EINVAL;

Should return the actual error.

> +}
