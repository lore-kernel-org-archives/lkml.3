Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab3I0Sy7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 14:54:59 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:49157 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203Ab3I0Sy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 14:54:58 -0400
Date: Fri, 27 Sep 2013 15:54:50 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [BUG/RFC 3/3] perf tools: Add missing GTK2_SUPPORT ifdefs
Message-ID: <20130927185450.GB3943@infradead.org>
References: <1380221754-29865-1-git-send-email-jolsa@redhat.com>
 <1380292332-6518-1-git-send-email-jolsa@redhat.com>
 <1380292332-6518-3-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380292332-6518-3-git-send-email-jolsa@redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Sep 27, 2013 at 04:32:12PM +0200, Jiri Olsa escreveu:
> When building minimal perf via:
>   NO_LIBPERL=1 NO_LIBPYTHON=1 NO_NEWT=1 NO_GTK2=1 NO_DEMANGLE=1
>   NO_LIBELF=1 NO_LIBUNWIND=1 NO_BACKTRACE=1 NO_LIBNUMA=1 NO_LIBAUDIT=1
>   NO_LIBBIONIC=1
> 
> We dont link -ldl and that's causing error for gtk2 related code,
> which is disabled on command line (NO_GTK2), but not in the code
> (GTK2_SUPPORT).
> 
> We probably need some global fix/change for this browser
> enabled/disable code.

But for now what you did is enough, since the only module that uses
the dl mechanism is the GTK+ one, so I'm applying it.

I should have detected this before pushing out perf/core with the
changes that introduced this problem, that is what:

  make -C tools/perf -f tests/make

was made to catch, my bad, Namhyung, please use those tests next time
too :-)

> Tested just by building it corretly.

Yeah, now tests/make completes without problems.

Thanks,

- Arnaldo
 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: David Ahern <dsahern@gmail.com>
> ---
>  tools/perf/builtin-annotate.c | 6 ++++++
>  tools/perf/builtin-report.c   | 2 ++
>  2 files changed, 8 insertions(+)
> 
> diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
> index 577c3a1..ddde407 100644
> --- a/tools/perf/builtin-annotate.c
> +++ b/tools/perf/builtin-annotate.c
> @@ -142,6 +142,7 @@ find_next:
>  		}
>  
>  		if (use_browser == 2) {
> +#ifdef GTK2_SUPPORT
>  			int ret;
>  			int (*annotate)(struct hist_entry *he,
>  					struct perf_evsel *evsel,
> @@ -161,6 +162,9 @@ find_next:
>  			/* skip missing symbols */
>  			nd = rb_next(nd);
>  		} else if (use_browser == 1) {
> +#else
> +			use_browser = 1;
> +#endif
>  			key = hist_entry__tui_annotate(he, evsel, NULL);
>  			switch (key) {
>  			case -1:
> @@ -258,6 +262,7 @@ static int __cmd_annotate(struct perf_annotate *ann)
>  		goto out_delete;
>  	}
>  
> +#ifdef GTK2_SUPPORT
>  	if (use_browser == 2) {
>  		void (*show_annotations)(void);
>  
> @@ -269,6 +274,7 @@ static int __cmd_annotate(struct perf_annotate *ann)
>  		}
>  		show_annotations();
>  	}
> +#endif
>  
>  out_delete:
>  	/*
> diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
> index 295025e..c902229 100644
> --- a/tools/perf/builtin-report.c
> +++ b/tools/perf/builtin-report.c
> @@ -591,6 +591,7 @@ static int __cmd_report(struct perf_report *rep)
>  				ret = 0;
>  
>  		} else if (use_browser == 2) {
> +#ifdef GTK2_SUPPORT
>  			int (*hist_browser)(struct perf_evlist *,
>  					    const char *,
>  					    struct hist_browser_timer *,
> @@ -604,6 +605,7 @@ static int __cmd_report(struct perf_report *rep)
>  			}
>  			hist_browser(session->evlist, help, NULL,
>  				     rep->min_percent);
> +#endif
>  		}
>  	} else
>  		perf_evlist__tty_browse_hists(session->evlist, rep, help);
> -- 
> 1.7.11.7
