Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527AbaIDMd7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 08:33:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:50598 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784AbaIDMd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 08:33:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,465,1406617200"; 
   d="scan'208";a="568275824"
Message-ID: <54085BC8.40403@intel.com>
Date: Thu, 04 Sep 2014 15:32:08 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>
CC: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 04/10] perf record: Filter out POLLHUP'ed file descriptors
References: <1409781604-16778-1-git-send-email-acme@kernel.org> <1409781604-16778-5-git-send-email-acme@kernel.org>
In-Reply-To: <1409781604-16778-5-git-send-email-acme@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2014 12:59 AM, Arnaldo Carvalho de Melo wrote:
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> So that we don't continue polling on vanished file descriptors, i.e.
> file descriptors for events monitoring threads that exited.
> 
> I.e. the following 'perf record' command now exits as expected, instead
> of staying in an eternal loop:
> 
>   $ sleep 5s &
>   $ perf record -p `pidof sleep`
> 
> Reported-by: Jiri Olsa <jolsa@redhat.com>
> Acked-by: Jiri Olsa <jolsa@kernel.org>
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Don Zickus <dzickus@redhat.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Stephane Eranian <eranian@google.com>
> Link: http://lkml.kernel.org/n/tip-ftg46awsyfjc3axb0xm63oig@git.kernel.org
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  tools/perf/builtin-record.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index 87e28a4e33ba..b87708ce09c9 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -467,6 +467,9 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
>  			if (err > 0 || (err < 0 && errno == EINTR))
>  				err = 0;
>  			waking++;
> +
> +			if (perf_evlist__filter_pollfd(rec->evlist, POLLERR | POLLHUP) == 0)

If the poll fds only include the ones mmapped, then mightn't it filter out
ones still in use? e.g. what if you record two processes and one exits?

> +				done = 1;
>  		}
>  
>  		/*
> 

