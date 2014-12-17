Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbaLQNYR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 08:24:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32779 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbaLQNYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 08:24:16 -0500
Date: Wed, 17 Dec 2014 14:23:30 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Borislav Petkov <bp@suse.de>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 05/18] perf evlist: Do not use hard coded value for a
 mmap_pages default
Message-ID: <20141217132330.GB18257@krava.brq.redhat.com>
References: <1418749040-31807-1-git-send-email-acme@kernel.org>
 <1418749040-31807-6-git-send-email-acme@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418749040-31807-6-git-send-email-acme@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 01:57:07PM -0300, Arnaldo Carvalho de Melo wrote:
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> So far what is in there by default is what we were using: 512KB + the
> control page, but the admin may change that, and if it does to a smaller
> value, all calls to tooling for non root users start failing, requiring
> that the user manually set --mmap_pages/-m.
> 
> Use instead what is in /proc/sys/kernel/perf_event_mlock_kb.
> 
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Don Zickus <dzickus@redhat.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Stephane Eranian <eranian@google.com>
> Link: http://lkml.kernel.org/n/tip-2f6mtm8xu3wo5lhkql6jdblh@git.kernel.org
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  tools/perf/util/evlist.c | 20 ++++++++++++++++----
>  1 file changed, 16 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
> index 7847f3885081..ac808680e61c 100644
> --- a/tools/perf/util/evlist.c
> +++ b/tools/perf/util/evlist.c
> @@ -893,10 +893,22 @@ out_unmap:
>  
>  static size_t perf_evlist__mmap_size(unsigned long pages)
>  {
> -	/* 512 kiB: default amount of unprivileged mlocked memory */
> -	if (pages == UINT_MAX)
> -		pages = (512 * 1024) / page_size;
> -	else if (!is_power_of_2(pages))
> +	if (pages == UINT_MAX) {
> +		int max;
> +
> +		if (sysctl__read_int("kernel/perf_event_mlock_kb", &max) < 0) {
> +			/*
> +			 * Pick a once upon a time good value, i.e. things look
> +			 * strange since we can't read a sysctl value, but lets not
> +			 * die yet...
> +			 */
> +			max = 512;
> +		} else {
> +			max -= (page_size / 1024);
> +		}

so this way you depend on value in perf_event_mlock_kb being power 2,
otherwise:

# echo 1000 > /proc/sys/kernel/perf_event_mlock_kb
$ perf record ls
failed to mmap with 22 (Invalid argument)

maybe you could use the logic/code from parse_pages_arg function

jirka
