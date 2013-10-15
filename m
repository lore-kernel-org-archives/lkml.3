Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049Ab3JOGCG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 02:02:06 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:63885 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768Ab3JOGCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 02:02:05 -0400
Date: Tue, 15 Oct 2013 08:02:00 +0200
From: Ingo Molnar <mingo@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf record: mmap output file - v2
Message-ID: <20131015060200.GA3866@gmail.com>
References: <1381805731-10398-1-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381805731-10398-1-git-send-email-dsahern@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> +	/* for MMAP based file writes */
> +	void			*mmap_addr;
> +	u64			bytes_at_mmap_start; /* bytes in file when mmap use starts */
> +	u64			mmap_offset;    /* current location within mmap */
> +	size_t			mmap_size;      /* size of mmap segments */
> +	bool			use_mmap;

> +	if (!rec->opts.pipe_output && stat(output_name, &st) == 0) {
> +		rec->use_mmap = true;
> +		rec->bytes_at_mmap_start = st.st_size - rec->bytes_written;
> +	}

1)

I think __cmd_record() has become way too large, nearly 300 lines of code. 
It would be nice to split it into 2-3 helpers that operate on 'struct 
perf_record' or so.

2)

The stat() seems superfluous, here in __cmd_record() we've just checked 
the output_name and made sure it exists. Can that stat() call ever fail?

3)

The rec->bytes_at_mmap_start field feels a bit weird. If I read the code 
correctly, in every 'perf record' invocation, rec->bytes_written starts at 
0 - i.e. we don't have repeat invocations of cmd_record().

That means that this:

		rec->bytes_at_mmap_start = st.st_size - rec->bytes_written;

is really:

		rec->bytes_at_mmap_start = st.st_size;

furthermore, since we don't allow appends anymore, st.st_size ought to be 
zero as well.

Which means that ->bytes_at_mmap_start is always zero - and could be 
eliminated altogether.

Thanks,

	Ingo
