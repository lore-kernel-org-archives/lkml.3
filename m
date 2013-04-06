Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423230Ab3DFPxY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 11:53:24 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:45058 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423208Ab3DFPxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 11:53:22 -0400
Date: Sat, 6 Apr 2013 17:53:17 +0200
From: Robert Richter <rric@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Borislav Petkov <bp@suse.de>
Subject: Re: [RFC PATCH 1/3] perf: Add persistent events
Message-ID: <20130406155317.GE11652@rric.localhost>
References: <1363352789-17991-1-git-send-email-bp@alien8.de>
 <1363352789-17991-2-git-send-email-bp@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363352789-17991-2-git-send-email-bp@alien8.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boris,

On 15.03.13 14:06:27, Borislav Petkov wrote:
> Add the needed pieces for persistent events which makes them
> process-agnostic. Also, make their buffers read-only when mmaping them
> from userspace.

> diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
> index 9fa9c622a7f4..4a4ae56195e1 100644
> --- a/include/uapi/linux/perf_event.h
> +++ b/include/uapi/linux/perf_event.h
> @@ -270,8 +270,9 @@ struct perf_event_attr {
>  
>  				exclude_callchain_kernel : 1, /* exclude kernel callchains */
>  				exclude_callchain_user   : 1, /* exclude user callchains */
> +				persistent     :  1, /* always-on event */

based on the discussion we have had a couple of days ago I got the
idea that we do not necessarily need the persistent flag. The purpose
of the persistent flag is to indicate that an existing event buffer
that is already enabled should be used. This means the buffer is
shared by multiple consumers. Enabled events with the following
conditions allow this too:

 * buffer mappings are readonly,
 * event is systemwide,
 * struct perf_event_attr is identical.

This means that an event with readonly buffers (PROT_WRITE unset,
over-write unread data) and the same struct perf_event_attr can be
simply reused. So, we don't need the flag: When setting up a
systemwide and readonly event we just check if there is already one
event running. If so we increment the use count of that event and
share its buffer, otherwise we create a new event.

This also has the advantage that the syscall i/f does not change. We
simply setup the event in the same way as we do already. Maybe the
only thing we need is a sysfs extension to report existing systemwide
events to userland.

Now, to have persistent events in the sense that the event is running
since system startup, we simply enable an in-kernel-counter. If
userland later sets up the same event, the kernel is aware of the
already running counter and redirects it to its buffer and all
(persistent) samples of the current buffer are now available to
userland.

The above also has the advantage of sharing systemwide events which
saves system resources, e.g. hardware counters. Suppose two processes
are collecting cpu-clocks, currently there are two hw counters and
buffers used for this, but only one counter would be sufficient.

I currently see the following problem with the approach. If we map to
an already running counter, there might be samples in the buffer that
had been collected before the syscall was setup. But the profiling
tool might be interested only in newer samples. So userland must be
aware of this and might be able to drop those samples. This should be
also backward compatible with the existing syscall i/f.

Another problem is different buffer size. I don't know if it is
possible to simply resize mmap'ed regions to the biggest buffer
requested. Though this problem already exist with your code.

Maybe it's worth to look at this approach. I need to review more perf
code for this.

-Robert
