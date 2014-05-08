Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703AbaEHKcl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 06:32:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14331 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753022AbaEHKcj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 06:32:39 -0400
Date: Thu, 8 May 2014 12:32:25 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH v5 1/2] perf record: Propagate exit status of a command
 line workload
Message-ID: <20140508103225.GA10851@krava.brq.redhat.com>
References: <1399535994-8027-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399535994-8027-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2014 at 04:59:53PM +0900, Namhyung Kim wrote:

SNIP

> +
> +	if (!err && !file->is_pipe) {
> +		rec->session->header.data_size += rec->bytes_written;
> +
> +		if (!rec->no_buildid)
> +			process_buildids(rec);
> +		perf_session__write_header(rec->session, rec->evlist,
> +					   file->fd, true);
> +	}
> +
> +	if (signr != -1) {
> +		signal(signr, SIG_DFL);
> +		raise(signr);
> +	}

hum.. so we dont call perf_session__delete in case we propagate
the signal.. also the outer function's cleanups are not called:

        perf_evlist__delete(rec->evlist);
        symbol__exit();

the only cleanup I found that actually matters here and won't be
called is 'vdso__exit' which removes the temp vdso library file.

Maybe we could have one on_exit callback raising the signal
if needed.. at the time we are sure we called all out cleanup
functions.

thanks,
jirka
