Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756990Ab3KYTbq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 14:31:46 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:57616 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883Ab3KYTbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 14:31:43 -0500
Date: Mon, 25 Nov 2013 16:31:37 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Stephane Eranian <eranian@google.com>, David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH 2/3] perf record: Use perf_data_file__write for output
 file
Message-ID: <20131125193137.GB27323@ghostprotocols.net>
References: <1385130268-10664-1-git-send-email-jolsa@redhat.com>
 <1385130268-10664-3-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385130268-10664-3-git-send-email-jolsa@redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Nov 22, 2013 at 03:24:27PM +0100, Jiri Olsa escreveu:
> Changing the file output code to use the newly
> added perf_data_file__write interface.

So I like renaming write_output() to perf_record__write(), but then
you're lumping together this change and the other, which is to make
write_output, now renamed to perf_record__write() to use perf_data_file.

Can you please split it like that?

- Arnaldo
 
> No functional change intended.
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Stephane Eranian <eranian@google.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> ---
>  tools/perf/builtin-record.c | 42 +++++++++++++-----------------------------
>  1 file changed, 13 insertions(+), 29 deletions(-)
> 
> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index 65615a8..bc3c7be 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -76,42 +76,27 @@ struct perf_record {
>  	long			samples;
>  };
>  
> -static int do_write_output(struct perf_record *rec, void *buf, size_t size)
> +static ssize_t perf_record__write(struct perf_record *rec,
> +				  void *buf, size_t size)
>  {
> -	struct perf_data_file *file = &rec->file;
> -
> -	while (size) {
> -		ssize_t ret = write(file->fd, buf, size);
> -
> -		if (ret < 0) {
> -			pr_err("failed to write perf data, error: %m\n");
> -			return -1;
> -		}
> -
> -		size -= ret;
> -		buf += ret;
> +	struct perf_session *session = rec->session;
> +	ssize_t ret;
>  
> -		rec->bytes_written += ret;
> -	}
> +	ret = perf_data_file__write(session->file, buf, size);
> +	if (ret < 0)
> +		return -1;
>  
> +	rec->bytes_written += ret;
>  	return 0;
>  }
>  
> -static int write_output(struct perf_record *rec, void *buf, size_t size)
> -{
> -	return do_write_output(rec, buf, size);
> -}
> -
>  static int process_synthesized_event(struct perf_tool *tool,
>  				     union perf_event *event,
>  				     struct perf_sample *sample __maybe_unused,
>  				     struct machine *machine __maybe_unused)
>  {
>  	struct perf_record *rec = container_of(tool, struct perf_record, tool);
> -	if (write_output(rec, event, event->header.size) < 0)
> -		return -1;
> -
> -	return 0;
> +	return perf_record__write(rec, event, event->header.size);
>  }
>  
>  static int perf_record__mmap_read(struct perf_record *rec,
> @@ -136,7 +121,7 @@ static int perf_record__mmap_read(struct perf_record *rec,
>  		size = md->mask + 1 - (old & md->mask);
>  		old += size;
>  
> -		if (write_output(rec, buf, size) < 0) {
> +		if (perf_record__write(rec, buf, size) < 0) {
>  			rc = -1;
>  			goto out;
>  		}
> @@ -146,7 +131,7 @@ static int perf_record__mmap_read(struct perf_record *rec,
>  	size = head - old;
>  	old += size;
>  
> -	if (write_output(rec, buf, size) < 0) {
> +	if (perf_record__write(rec, buf, size) < 0) {
>  		rc = -1;
>  		goto out;
>  	}
> @@ -322,8 +307,7 @@ static struct perf_event_header finished_round_event = {
>  
>  static int perf_record__mmap_read_all(struct perf_record *rec)
>  {
> -	int i;
> -	int rc = 0;
> +	int i, rc = 0;
>  
>  	for (i = 0; i < rec->evlist->nr_mmaps; i++) {
>  		if (rec->evlist->mmap[i].base) {
> @@ -335,7 +319,7 @@ static int perf_record__mmap_read_all(struct perf_record *rec)
>  	}
>  
>  	if (perf_header__has_feat(&rec->session->header, HEADER_TRACING_DATA))
> -		rc = write_output(rec, &finished_round_event,
> +		rc = perf_record__write(rec, &finished_round_event,
>  				  sizeof(finished_round_event));
>  
>  out:
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
