Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363AbaCKOJ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 10:09:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8073 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752037AbaCKOJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 10:09:25 -0400
Date: Tue, 11 Mar 2014 14:41:41 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: acme@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        peterz@infradead.org, eranian@google.com, namhyung@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 6/8] perf, tools: Query terminal width and use in perf
 list
Message-ID: <20140311134141.GG22678@krava.redhat.com>
References: <1394048978-15909-1-git-send-email-andi@firstfloor.org>
 <1394048978-15909-7-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394048978-15909-7-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 11:49:36AM -0800, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Automatically adapt the now wider and word wrapped perf list
> output to wider terminals. This requires querying the terminal
> before the auto pager takes over, and exporting this
> information from the pager subsystem.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  tools/perf/util/cache.h |  1 +
>  tools/perf/util/pager.c |  7 ++++++-
>  tools/perf/util/pmu.c   | 12 +++++++-----
>  3 files changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/perf/util/cache.h b/tools/perf/util/cache.h
> index 7b176dd..d40cd4d 100644
> --- a/tools/perf/util/cache.h
> +++ b/tools/perf/util/cache.h
> @@ -31,6 +31,7 @@ extern void setup_pager(void);
>  extern const char *pager_program;
>  extern int pager_in_use(void);
>  extern int pager_use_color;
> +extern int pager_columns;
>  
>  char *alias_lookup(const char *alias);
>  int split_cmdline(char *cmdline, const char ***argv);
> diff --git a/tools/perf/util/pager.c b/tools/perf/util/pager.c
> index 3322b84..5a771ab 100644
> --- a/tools/perf/util/pager.c
> +++ b/tools/perf/util/pager.c
> @@ -1,13 +1,15 @@
>  #include "cache.h"
>  #include "run-command.h"
>  #include "sigchain.h"
> +#include <sys/ioctl.h>
>  
>  /*
>   * This is split up from the rest of git so that we can do
>   * something different on Windows.
>   */
>  
> -static int spawned_pager;
> +int spawned_pager;

this one can stay static

SNIP

> index 5d69c29..a26ec85 100644
> --- a/tools/perf/util/pmu.c
> +++ b/tools/perf/util/pmu.c
> @@ -9,6 +9,7 @@
>  #include "pmu.h"
>  #include "parse-events.h"
>  #include "cpumap.h"
> +#include "cache.h"
>  #include "jevents.h"
>  
>  const char *json_file;
> @@ -791,11 +792,12 @@ static void wordwrap(char *s, int start, int max, int corr)
>  
>  static int get_columns(void)
>  {
> -	/*
> -	 * Should ask the terminal with TIOCGWINSZ here, but we
> -	 * need the original fd before the pager.
> -	 */
> -	return 79;
> +	char *s;
> +
> +	s = getenv("COLUMNS");
> +	if (s)
> +		return atoi(s);
> +	return (pager_columns ? pager_columns : 80) - 2;
>  }

I think this function should move out of pmu.c
to pager.c perhaps

jirka
