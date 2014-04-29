Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933988AbaD2MLJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 08:11:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:58219 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933447AbaD2MLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 08:11:07 -0400
Date: Tue, 29 Apr 2014 14:11:03 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH v3 2/3] perf record: Propagate exit status of a command
 line workload
Message-ID: <20140429121103.GR11096@twins.programming.kicks-ass.net>
References: <1398346054-3322-1-git-send-email-namhyung@kernel.org>
 <1398346054-3322-2-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398346054-3322-2-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 10:27:33PM +0900, Namhyung Kim wrote:
>  static void record__sig_exit(int exit_status __maybe_unused, void *arg)
>  {
> -	struct record *rec = arg;
> -	int status;
> -
> -	if (rec->evlist->workload.pid > 0) {
> -		if (!child_finished)
> -			kill(rec->evlist->workload.pid, SIGTERM);
> -
> -		wait(&status);
> -		if (WIFSIGNALED(status))
> -			psignal(WTERMSIG(status), rec->progname);
> -	}
> -
> -	if (signr == -1 || signr == SIGUSR1)
> +	if (signr == -1)
>  		return;
>  
>  	signal(signr, SIG_DFL);
>  }


> +out_child:
> +	if (forks) {
> +		int exit_status;
>  
> -	return 0;
> +		if (!child_finished)
> +			kill(rec->evlist->workload.pid, SIGTERM);
> +
> +		wait(&exit_status);
> +
> +		if (err < 0)
> +			status = err;
> +		else if (WIFEXITED(exit_status))
> +			status = WEXITSTATUS(exit_status);
> +		else if (WIFSIGNALED(status))
		{
		signr = WTERMSIG(status);
> +			psignal(WTERMSIG(status), rec->progname);
		}
> +	} else
> +		status = err;
> +
> +	if (!err && !file->is_pipe) {
> +		rec->session->header.data_size += rec->bytes_written;
> +
> +		if (!rec->no_buildid)
> +			process_buildids(rec);
> +		perf_session__write_header(rec->session, rec->evlist,
> +					   file->fd, true);
> +	}

Should do I suppose; not sure why the psignal() muck is in there, but it
don't hurt I suppose.
