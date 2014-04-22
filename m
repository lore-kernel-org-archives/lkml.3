Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367AbaDVT6i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 15:58:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:56014 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756678AbaDVT62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 15:58:28 -0400
Date: Tue, 22 Apr 2014 16:27:59 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jean Pihet <jean.pihet@linaro.org>
Cc: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Robert Richter <robert.richter@linaro.org>
Subject: Re: [PATCH 04/16] perf, mmap: Factor out perf_get_fd()
Message-ID: <20140422142759.GM11182@twins.programming.kicks-ass.net>
References: <1396883078-25320-1-git-send-email-jean.pihet@linaro.org>
 <1396883078-25320-5-git-send-email-jean.pihet@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396883078-25320-5-git-send-email-jean.pihet@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 07, 2014 at 05:04:26PM +0200, Jean Pihet wrote:
> From: Robert Richter <robert.richter@linaro.org>
> 
> This new function creates a new fd for an event. We need this later to
> get a fd from a persistent event.
> 
> Signed-off-by: Robert Richter <robert.richter@linaro.org>
> Signed-off-by: Robert Richter <rric@kernel.org>
> Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
> ---
>  kernel/events/core.c     | 14 ++++++++------
>  kernel/events/internal.h |  1 +
>  2 files changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 22ec8f0..9857475 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -4206,6 +4206,11 @@ static const struct file_operations perf_fops = {
>  	.fasync			= perf_fasync,
>  };
>  
> +int perf_get_fd(struct perf_event *event, int f_flags)
> +{
> +	return anon_inode_getfd("[perf_event]", &perf_fops, event, f_flags);
> +}
> +
>  /*
>   * Perf event wakeup
>   *
> @@ -7028,7 +7033,6 @@ SYSCALL_DEFINE5(perf_event_open,
>  	struct perf_event *event, *sibling;
>  	struct perf_event_attr attr;
>  	struct perf_event_context *ctx;
> -	struct file *event_file = NULL;
>  	struct fd group = {NULL, 0};
>  	struct task_struct *task = NULL;
>  	struct pmu *pmu;
> @@ -7189,10 +7193,9 @@ SYSCALL_DEFINE5(perf_event_open,
>  			goto err_context;
>  	}
>  
> -	event_file = anon_inode_getfile("[perf_event]", &perf_fops, event,
> -					f_flags);
> -	if (IS_ERR(event_file)) {
> -		err = PTR_ERR(event_file);
> +	event_fd = perf_get_fd(event, f_flags);
> +	if (event_fd < 0) {
> +		err = event_fd;
>  		goto err_context;
>  	}
>  
> @@ -7257,7 +7260,6 @@ SYSCALL_DEFINE5(perf_event_open,
>  	 * perf_group_detach().
>  	 */
>  	fdput(group);
> -	fd_install(event_fd, event_file);
>  	return event_fd;
>  
>  err_context:

ISTR there being a good reason we only install the FD at the very last
moment. Of course I cannot quite recall it :/

I suspect it had something to do with not being able to fudge the state
while its being set-up or somesuch.

