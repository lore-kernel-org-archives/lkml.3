Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758269AbaHZOEz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 10:04:55 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:62094 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755879AbaHZOEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 10:04:54 -0400
Message-ID: <53FC9402.8080008@gmail.com>
Date: Tue, 26 Aug 2014 08:04:50 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>
CC: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 08/10] perf kvm stat live: Use perf_evlist__add_pollfd()
 instead of local equivalent
References: <1408741190-5123-1-git-send-email-acme@kernel.org> <1408741190-5123-9-git-send-email-acme@kernel.org>
In-Reply-To: <1408741190-5123-9-git-send-email-acme@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/22/14, 2:59 PM, Arnaldo Carvalho de Melo wrote:
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
>
> Since we can add file descriptors to the evlist pollfd and it will
> autogrow, no need to copy all events to a local pollfd array, just add
> the timer and stdin file descriptors.
>
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Jean Pihet <jean.pihet@linaro.org>
> Cc: Jiri Olsa <jolsa@kernel.org>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Link: http://lkml.kernel.org/n/tip-2hvp9iromiheh6rl4oaa08x5@git.kernel.org
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>   tools/perf/builtin-kvm.c | 22 +++++++++-------------
>   1 file changed, 9 insertions(+), 13 deletions(-)
>
> diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
> index 1a4ef9cd9d5f..b192234096b6 100644
> --- a/tools/perf/builtin-kvm.c
> +++ b/tools/perf/builtin-kvm.c
> @@ -921,15 +921,8 @@ static int kvm_events_live_report(struct perf_kvm_stat *kvm)
>   	signal(SIGINT, sig_handler);
>   	signal(SIGTERM, sig_handler);
>
> -	/* copy pollfds -- need to add timerfd and stdin */
> +	/* use pollfds -- need to add timerfd and stdin */
>   	nr_fds = kvm->evlist->nr_fds;
> -	pollfds = zalloc(sizeof(struct pollfd) * (nr_fds + 2));
> -	if (!pollfds) {
> -		err = -ENOMEM;
> -		goto out;
> -	}
> -	memcpy(pollfds, kvm->evlist->pollfd,
> -		sizeof(struct pollfd) * kvm->evlist->nr_fds);
>
>   	/* add timer fd */
>   	if (perf_kvm__timerfd_create(kvm) < 0) {
> @@ -937,17 +930,21 @@ static int kvm_events_live_report(struct perf_kvm_stat *kvm)
>   		goto out;
>   	}
>
> -	pollfds[nr_fds].fd = kvm->timerfd;
> -	pollfds[nr_fds].events = POLLIN;
> +	if (perf_evlist__add_pollfd(kvm->evlist, kvm->timerfd))
> +		goto out;
> +
>   	nr_fds++;
>
> -	pollfds[nr_fds].fd = fileno(stdin);
> -	pollfds[nr_fds].events = POLLIN;
> +	if (perf_evlist__add_pollfd(kvm->evlist, fileno(stdin)))
> +		goto out;
> +
>   	nr_stdin = nr_fds;
>   	nr_fds++;
>   	if (fd_set_nonblock(fileno(stdin)) != 0)
>   		goto out;
>
> +	pollfds	 = kvm->evlist->pollfd;
> +
>   	/* everything is good - enable the events and process */
>   	perf_evlist__enable(kvm->evlist);
>
> @@ -981,7 +978,6 @@ out:
>   		close(kvm->timerfd);
>
>   	tcsetattr(0, TCSAFLUSH, &save);
> -	free(pollfds);
>   	return err;
>   }
>
>

Much simpler. Looks ok to me.

Reviewed-by: David Ahern <dsahern@gmail.com>

David
