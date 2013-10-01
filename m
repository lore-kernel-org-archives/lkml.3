Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751564Ab3JAHQv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 03:16:51 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:48473 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239Ab3JAHQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 03:16:50 -0400
Date: Tue, 1 Oct 2013 09:16:46 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Sonny Rao <sonnyrao@chromium.org>
Subject: Re: [PATCH] perf session: Fix infinite loop on invalid perf.data file
Message-ID: <20131001071646.GA20023@gmail.com>
References: <1380529188-27193-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380529188-27193-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Namhyung Kim <namhyung@kernel.org> wrote:

> --- a/tools/perf/util/header.c
> +++ b/tools/perf/util/header.c
> @@ -2753,6 +2753,15 @@ int perf_session__read_header(struct perf_session *session)
>  	if (perf_file_header__read(&f_header, header, fd) < 0)
>  		return -EINVAL;
>  
> +	/*
> +	 * Sanity check that perf.data was written cleanly; data size is
> +	 * initialized to 0 and updated only if the on_exit function is run.
> +	 * If data size is still 0 then the file contains only partial
> +	 * information.  Just warn user and process it as much as it can.
> +	 */
> +	if (f_header.data.size == 0)
> +		pr_warning("Data size is 0. Was the record command properly terminated?\n");

Just a detail: it would be nice to make all the user facing messages in 
tools/perf/util/header.c more specific and more structured. For example 
prefixing it with 'perf header:' would be fine:

	WARNING: perf/header: Data size is 0. Was the 'perf record' command properly terminated?

or something like that.

etc.

	Ingo
