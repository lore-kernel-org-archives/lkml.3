Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759679Ab3EBNk3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 09:40:29 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49232 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286Ab3EBNk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 09:40:28 -0400
Date: Thu, 2 May 2013 15:38:49 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH 02/11] perf: Add PERF_EVENT_IOC_ID ioctl to return
 event ID
Message-ID: <20130502133848.GI13837@dyad.programming.kicks-ass.net>
References: <1359981185-16819-1-git-send-email-jolsa@redhat.com>
 <1359981185-16819-3-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359981185-16819-3-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2013 at 01:32:56PM +0100, Jiri Olsa wrote:
> From: "jolsa@redhat.com" <jolsa@redhat.com>
> 
> The only way to get the event ID is by reading the event fd,
> followed by parsing the ID value out of the returned data.
> 
> While this is ok for current read format used by perf tool,
> it is not ok when we use PERF_FORMAT_GROUP format.
> 
> With this format the data are returned for the whole group
> and there's no way to find out what ID belongs to our fd
> (if we are not group leader event).
> 
> Adding a simple ioctl that returns event primary ID for given fd.
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> ---
>  include/uapi/linux/perf_event.h | 1 +
>  kernel/events/core.c            | 9 +++++++++
>  2 files changed, 10 insertions(+)
> 
> diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
> index 9fa9c62..b4ea8ed 100644
> --- a/include/uapi/linux/perf_event.h
> +++ b/include/uapi/linux/perf_event.h
> @@ -316,6 +316,7 @@ struct perf_event_attr {
>  #define PERF_EVENT_IOC_PERIOD		_IOW('$', 4, __u64)
>  #define PERF_EVENT_IOC_SET_OUTPUT	_IO ('$', 5)
>  #define PERF_EVENT_IOC_SET_FILTER	_IOW('$', 6, char *)
> +#define PERF_EVENT_IOC_ID		_IOR('$', 7, u64 *)
>  
>  enum perf_event_ioc_flags {
>  	PERF_IOC_FLAG_GROUP		= 1U << 0,
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 301079d..4081261 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -3277,6 +3277,15 @@ static long perf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>  	case PERF_EVENT_IOC_PERIOD:
>  		return perf_event_period(event, (u64 __user *)arg);
>  
> +	case PERF_EVENT_IOC_ID:
> +	{
> +		u64 id = primary_event_id(event);
> +
> +		if (copy_to_user((void __user *)arg, &id, sizeof(id)))
> +			return -EFAULT;
> +		return 0;
> +	}
> +
>  	case PERF_EVENT_IOC_SET_OUTPUT:
>  	{
>  		int ret;
> -- 
> 1.7.11.7
> 
