Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894Ab3FYNFQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 09:05:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13101 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076Ab3FYNFO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 09:05:14 -0400
Date: Tue, 25 Jun 2013 15:04:34 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 02/15] perf tools: fix missing tool parameter
Message-ID: <20130625130434.GB23329@krava.brq.redhat.com>
References: <1372079772-20803-1-git-send-email-adrian.hunter@intel.com>
 <1372079772-20803-3-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372079772-20803-3-git-send-email-adrian.hunter@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 24, 2013 at 04:15:59PM +0300, Adrian Hunter wrote:
> perf inject expects to get a reference to 'struct perf_inject'
> from its 'tool' member.  For that to work, 'tool' needs to be
> a parameter of all tool callbacks.  Make it so.
> 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>  tools/perf/builtin-inject.c | 24 ++++++++++--------------
>  tools/perf/util/header.c    |  6 ++++--
>  tools/perf/util/header.h    |  6 ++++--
>  tools/perf/util/session.c   | 11 +++++++----
>  tools/perf/util/tool.h      |  9 ++++-----
>  5 files changed, 29 insertions(+), 27 deletions(-)
> 
> diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
> index f299ddf..fb341f1 100644
> --- a/tools/perf/builtin-inject.c
> +++ b/tools/perf/builtin-inject.c
> @@ -73,22 +73,17 @@ static int perf_event__repipe_event_type_synth(struct perf_tool *tool,
>  	return perf_event__repipe_synth(tool, event);
>  }
>  
> -static int perf_event__repipe_tracing_data_synth(union perf_event *event,
> -						 struct perf_session *session
> -						 __maybe_unused)
> -{
> -	return perf_event__repipe_synth(NULL, event);
> -}
> -
> -static int perf_event__repipe_attr(union perf_event *event,
> -				   struct perf_evlist **pevlist __maybe_unused)
> +static int perf_event__repipe_attr(struct perf_tool *tool,
> +				   union perf_event *event,
> +				   struct perf_evlist **pevlist)
>  {
>  	int ret;
> -	ret = perf_event__process_attr(event, pevlist);
> +
> +	ret = perf_event__process_attr(tool, event, pevlist);
>  	if (ret)
>  		return ret;
>  
> -	return perf_event__repipe_synth(NULL, event);
> +	return perf_event__repipe_synth(tool, event);
>  }
>  
>  static int perf_event__repipe(struct perf_tool *tool,
> @@ -147,13 +142,14 @@ static int perf_event__repipe_fork(struct perf_tool *tool,
>  	return err;
>  }
>  
> -static int perf_event__repipe_tracing_data(union perf_event *event,
> +static int perf_event__repipe_tracing_data(struct perf_tool *tool,
> +					   union perf_event *event,
>  					   struct perf_session *session)
>  {
>  	int err;
>  
>  	perf_event__repipe_synth(NULL, event);

wouldn't this one cause segfault?

jirka
