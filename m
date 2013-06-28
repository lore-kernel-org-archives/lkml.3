Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740Ab3F1PWm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 11:22:42 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53696 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab3F1PWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 11:22:41 -0400
Date: Fri, 28 Jun 2013 17:22:24 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 1/5] perf: fix broken union in perf_event_mmap_page
Message-ID: <20130628152224.GG6626@twins.programming.kicks-ass.net>
References: <1372425741-1676-1-git-send-email-adrian.hunter@intel.com>
 <1372425741-1676-2-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372425741-1676-2-git-send-email-adrian.hunter@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28, 2013 at 04:22:17PM +0300, Adrian Hunter wrote:
> The capabilities bits must not be "union'ed" together.
> Put them in a separate struct.
> 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>  include/uapi/linux/perf_event.h | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
> index 0b1df41..19f6ee5 100644
> --- a/include/uapi/linux/perf_event.h
> +++ b/include/uapi/linux/perf_event.h
> @@ -375,9 +375,11 @@ struct perf_event_mmap_page {
>  	__u64	time_running;		/* time event on cpu */
>  	union {
>  		__u64	capabilities;
> -		__u64	cap_usr_time  : 1,
> -			cap_usr_rdpmc : 1,
> -			cap_____res   : 62;
> +		struct {
> +			__u64	cap_usr_time		: 1,
> +				cap_usr_rdpmc		: 1,
> +				cap_____res		: 62;
> +		};
>  	};

Ick, it did that!? and here I thought there was a difference between:

  int foo:1,
      bar:1;

and

  int foo:1;
  int bar:1;

That made all the difference in this particular case. I guess I should
go read the language spec more carefully next time.
