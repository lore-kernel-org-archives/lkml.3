Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095AbaBKQDy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 11:03:54 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:37849 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750779AbaBKQDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 11:03:53 -0500
Date: Tue, 11 Feb 2014 11:03:48 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Qiaowei Ren <qiaowei.ren@intel.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel/trace: fix compiler warning
Message-ID: <20140211110348.492c47b4@gandalf.local.home>
In-Reply-To: <1392133301-17974-1-git-send-email-qiaowei.ren@intel.com>
References: <1392133301-17974-1-git-send-email-qiaowei.ren@intel.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Feb 2014 23:41:41 +0800
Qiaowei Ren <qiaowei.ren@intel.com> wrote:

> The patch fixes the following compiler warning:
>     CC      kernel/trace/trace_events.o
>   kernel/trace/trace_events.c: In function 'event_enable_read'
>   kernel/trace/trace_events.c:693: warning: 'flags' may be used \
>   uninitialized in this function

You don't happen to have the branch profilers enabled?

Is CONFIG_TRACE_BRANCH_PROFILING set?

> 
> Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
> ---
>  kernel/trace/trace_events.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index e71ffd4..b7915f2 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -690,7 +690,7 @@ event_enable_read(struct file *filp, char __user *ubuf, size_t cnt,
>  		  loff_t *ppos)
>  {
>  	struct ftrace_event_file *file;
> -	unsigned long flags;
> +	unsigned long flags = 0;
>  	char buf[4] = "0";
>  
>  	mutex_lock(&event_mutex);


False warning, and most likely because the branch profilers screw up
gcc's ability to figure these things out.

Here's the content of that function:

        mutex_lock(&event_mutex);
        file = event_file_data(filp);
        if (likely(file))
                flags = file->flags;
        mutex_unlock(&event_mutex);

        if (!file)
                return -ENODEV;

        if (flags & FTRACE_EVENT_FL_ENABLED &&


Pretty obvious that flags can not be used uninitialized. If you happen
to have BRANCH profiling enabled, you must ignore all the gcc "might be
used uninitialized" warnings. They are useless.

This is not a bug, sorry.

-- Steve
