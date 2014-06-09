Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272AbaFITZW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 15:25:22 -0400
Received: from mail.kernel.org ([198.145.19.201]:34998 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753699AbaFITZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 15:25:21 -0400
Date: Mon, 9 Jun 2014 16:25:13 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Stanislav Fomichev <stfomichev@yandex-team.ru>
Cc: namhyung@kernel.org, artagnon@gmail.com, jolsa@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] perf timechart: implement IO mode
Message-ID: <20140609192513.GE4246@kernel.org>
References: <1402305672-2630-1-git-send-email-stfomichev@yandex-team.ru>
 <1402305672-2630-3-git-send-email-stfomichev@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402305672-2630-3-git-send-email-stfomichev@yandex-team.ru>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will test the new feature soon, looks useful, thanks for working on
this!

Some coments about the patch below.

- Arnaldo

Em Mon, Jun 09, 2014 at 01:21:12PM +0400, Stanislav Fomichev escreveu:

> @@ -213,7 +245,7 @@ static void pid_fork(struct timechart *tchart, int pid, int ppid, u64 timestamp)
>  		pid_set_comm(tchart, pid, pp->current->comm);
>  
>  	p->start_time = timestamp;
> -	if (p->current) {
> +	if (p->current && !p->current->start_time) {
>  		p->current->start_time = timestamp;
>  		p->current->state_since = timestamp;

Isn't the above a separate fix? I.e. unrelated to io mode?

>  	}
> @@ -682,6 +714,245 @@ static void end_sample_processing(struct timechart *tchart)
>  	}
>  }
>  
> +static int pid_begin_io_sample(struct timechart *tchart, int pid, int type,
> +			       u64 start, int fd)
> +{
> +	struct per_pid *p;
> +	struct per_pidcomm *c;
> +	struct io_sample *sample;
> +	struct io_sample *prev;
> +
> +	p = find_create_pid(tchart, pid);
> +	c = p->current;

Try to reduce the number of lines when you can nicely fit it into the
decl line, i.e.:`

 +	struct per_pid *p = find_create_pid(tchart, pid);
 +	struct per_pidcomm *c = p->current;

> +	if (!c) {
> +		c = zalloc(sizeof(*c));
> +		assert(c != NULL);

And please don't use assert in these cases, just return the error all
the way up.

> +		p->current = c;
> +		c->next = p->all;
> +		p->all = c;
> +	}
> +
> +	prev = c->io_samples;
> +
> +	if (prev && prev->start_time && !prev->end_time) {
> +		fprintf(stderr, "Invalid previous event (duplicate start)!\n");
> +		return -1;
> +	}
> +
> +	sample = zalloc(sizeof(*sample));
> +	assert(sample != NULL);

Ditto.

> +	sample->start_time = start;
> +	sample->type = type;
> +	sample->fd = fd;
> +	sample->next = c->io_samples;
> +	c->io_samples = sample;
> +
> +	if (c->start_time == 0 || c->start_time > start)
> +		c->start_time = start;
> +
> +	return 0;
> +}
> +
> +static int pid_end_io_sample(struct timechart *tchart, int pid, int type,
> +			     u64 end, long ret)
> +{
> +	struct per_pid *p;
> +	struct per_pidcomm *c;
> +	struct io_sample *sample;
> +	struct io_sample *prev;
> +
> +	p = find_create_pid(tchart, pid);
> +	c = p->current;

Ditto, combine with decl, please do it for other cases, if any.

> +	if (!c) {
> +		fprintf(stderr, "Invalid pidcomm!\n");
> +		return -1;
> +	}
> +
> +	sample = c->io_samples;
> +
> +	if (!sample) /* skip partially captured events */
> +		return 0;
> +	prev = sample->next;
> +
> +	if (c->io_samples->end_time) {
> +		fprintf(stderr, "Invalid previous event (non-zero)!\n");

Use pr_err(), there are still a few fprintf(stderr, ) there, but we're
trying to standardize on using similar error reporting functions as with
the kernel proper.

> +		return -1;
> +	}
> +
> +	if (c->io_samples->type != type) {
> +		fprintf(stderr, "Invalid previous event (type)!\n");
> +		return -1;
> +	}
> +
> +	sample->end_time = end;
> +
> +	/* we want to be able to see small and fast transfers, so make them
> +	 * at least min_time long, but don't overlap them */
> +	if (sample->end_time - sample->start_time < tchart->min_time)
> +		sample->end_time = sample->start_time + tchart->min_time;
> +	if (prev && sample->start_time < prev->end_time) {
> +		if (prev->error) /* try to make errors more visible */
> +			sample->start_time = prev->end_time;
> +		else
> +			prev->end_time = sample->start_time;
> +	}
> +
> +	if (ret < 0) {
> +		sample->error = ret;
> +	} else if (type == IOTYPE_READ || type == IOTYPE_WRITE ||
> +		   type == IOTYPE_TX || type == IOTYPE_RX) {
> +
> +		if ((u64)ret > c->max_bytes)
> +			c->max_bytes = ret;
> +
> +		c->total_bytes += ret;
> +		p->total_bytes += ret;
> +		sample->bytes = ret;
> +	}
> +
> +	/* merge two requests to make svg smaller and render-friendly */
> +	if (prev &&
> +	    prev->type == sample->type &&
> +	    prev->error == sample->error &&
> +	    prev->fd == sample->fd &&
> +	    prev->end_time + tchart->merge_dist >= sample->start_time) {
> +
> +		sample->bytes += prev->bytes;
> +		sample->merges += prev->merges + 1;
> +
> +		sample->start_time = prev->start_time;
> +		sample->next = prev->next;
> +		free(prev);
> +
> +		if (!sample->error && sample->bytes > c->max_bytes)
> +			c->max_bytes = sample->bytes;
> +	}
> +
> +	tchart->io_events++;
> +
> +	return 0;
> +}
> +
> +static int
> +process_enter_read(struct timechart *tchart __maybe_unused,
> +		   struct perf_evsel *evsel __maybe_unused,

Why the __maybe_unused if you use tchart and evsel? Ditto for other
functions with same problem.

> +		   struct perf_sample *sample)
> +{
> +	long fd = perf_evsel__intval(evsel, sample, "fd");
> +	return pid_begin_io_sample(tchart, sample->tid, IOTYPE_READ,
> +				   sample->time, fd);
> +}
> +
> +static int
> +process_exit_read(struct timechart *tchart __maybe_unused,
> +		  struct perf_evsel *evsel,
> +		  struct perf_sample *sample)
> +{
> +	long ret = perf_evsel__intval(evsel, sample, "ret");
> +	return pid_end_io_sample(tchart, sample->tid, IOTYPE_READ,
> +				 sample->time, ret);
> +}
> +
> +static int
> +process_enter_write(struct timechart *tchart __maybe_unused,
> +		    struct perf_evsel *evsel __maybe_unused,
> +		    struct perf_sample *sample)
> +{
> +	long fd = perf_evsel__intval(evsel, sample, "fd");
> +	return pid_begin_io_sample(tchart, sample->tid, IOTYPE_WRITE,
> +				   sample->time, fd);
> +}
> +
> +static int
> +process_exit_write(struct timechart *tchart __maybe_unused,
> +		   struct perf_evsel *evsel,
> +		   struct perf_sample *sample)
> +{
> +	long ret = perf_evsel__intval(evsel, sample, "ret");
> +	return pid_end_io_sample(tchart, sample->tid, IOTYPE_WRITE,
> +				 sample->time, ret);
> +}
> +
> +static int
> +process_enter_sync(struct timechart *tchart __maybe_unused,
> +		   struct perf_evsel *evsel __maybe_unused,
> +		   struct perf_sample *sample)
> +{
> +	long fd = perf_evsel__intval(evsel, sample, "fd");
> +	return pid_begin_io_sample(tchart, sample->tid, IOTYPE_SYNC,
> +				   sample->time, fd);
> +}
> +
> +static int
> +process_exit_sync(struct timechart *tchart __maybe_unused,
> +		  struct perf_evsel *evsel,
> +		  struct perf_sample *sample)
> +{
> +	long ret = perf_evsel__intval(evsel, sample, "ret");
> +	return pid_end_io_sample(tchart, sample->tid, IOTYPE_SYNC,
> +				 sample->time, ret);
> +}
> +
> +static int
> +process_enter_tx(struct timechart *tchart __maybe_unused,
> +		 struct perf_evsel *evsel __maybe_unused,
> +		 struct perf_sample *sample)
> +{
> +	long fd = perf_evsel__intval(evsel, sample, "fd");
> +	return pid_begin_io_sample(tchart, sample->tid, IOTYPE_TX,
> +				   sample->time, fd);
> +}
> +
> +static int
> +process_exit_tx(struct timechart *tchart __maybe_unused,
> +		struct perf_evsel *evsel,
> +		struct perf_sample *sample)
> +{
> +	long ret = perf_evsel__intval(evsel, sample, "ret");
> +	return pid_end_io_sample(tchart, sample->tid, IOTYPE_TX,
> +				 sample->time, ret);
> +}
> +
> +static int
> +process_enter_rx(struct timechart *tchart __maybe_unused,
> +		 struct perf_evsel *evsel __maybe_unused,
> +		 struct perf_sample *sample)
> +{
> +	long fd = perf_evsel__intval(evsel, sample, "fd");
> +	return pid_begin_io_sample(tchart, sample->tid, IOTYPE_RX,
> +				   sample->time, fd);
> +}
> +
> +static int
> +process_exit_rx(struct timechart *tchart __maybe_unused,
> +		struct perf_evsel *evsel,
> +		struct perf_sample *sample)
> +{
> +	long ret = perf_evsel__intval(evsel, sample, "ret");
> +	return pid_end_io_sample(tchart, sample->tid, IOTYPE_RX,
> +				 sample->time, ret);
> +}
> +
> +static int
> +process_enter_poll(struct timechart *tchart __maybe_unused,
> +		   struct perf_evsel *evsel __maybe_unused,
> +		   struct perf_sample *sample)
> +{
> +	long fd = perf_evsel__intval(evsel, sample, "fd");
> +	return pid_begin_io_sample(tchart, sample->tid, IOTYPE_POLL,
> +				   sample->time, fd);
> +}
> +
> +static int
> +process_exit_poll(struct timechart *tchart __maybe_unused,
> +		  struct perf_evsel *evsel,
> +		  struct perf_sample *sample)
> +{
> +	long ret = perf_evsel__intval(evsel, sample, "ret");
> +	return pid_end_io_sample(tchart, sample->tid, IOTYPE_POLL,
> +				 sample->time, ret);
> +}
> +
>  /*
>   * Sort the pid datastructure
>   */
> @@ -852,6 +1123,120 @@ static void draw_cpu_usage(struct timechart *tchart)
>  	}
>  }
>  
> +static void draw_io_bars(struct timechart *tchart)
> +{
> +	const char *suf;
> +	double bytes;
> +	char comm[256];
> +	struct per_pid *p;
> +	struct per_pidcomm *c;
> +	struct io_sample *sample;
> +	int Y = 1;
> +
> +	p = tchart->all_data;
> +	while (p) {
> +		c = p->all;
> +		while (c) {
> +			if (!c->display) {
> +				c->Y = 0;
> +				c = c->next;
> +				continue;
> +			}
> +
> +			svg_box(Y, c->start_time, c->end_time, "process3");
> +			sample = c->io_samples;
> +			for (sample = c->io_samples; sample; sample = sample->next) {
> +				double h = (double)sample->bytes / c->max_bytes;
> +
> +				if (tchart->skip_eagain && sample->error == -EAGAIN)
> +					continue;
> +
> +				if (sample->error)
> +					h = 1;
> +
> +				if (sample->type == IOTYPE_SYNC)
> +					svg_fbox(Y,
> +						sample->start_time,
> +						sample->end_time,
> +						1,
> +						sample->error ? "error" : "sync",
> +						sample->fd,
> +						sample->error,
> +						sample->merges);
> +				else if (sample->type == IOTYPE_POLL)
> +					svg_fbox(Y,
> +						sample->start_time,
> +						sample->end_time,
> +						1,
> +						sample->error ? "error" : "poll",
> +						sample->fd,
> +						sample->error,
> +						sample->merges);
> +				else if (sample->type == IOTYPE_READ)
> +					svg_ubox(Y,
> +						sample->start_time,
> +						sample->end_time,
> +						h,
> +						sample->error ? "error" : "disk",
> +						sample->fd,
> +						sample->error,
> +						sample->merges);
> +				else if (sample->type == IOTYPE_WRITE)
> +					svg_lbox(Y,
> +						sample->start_time,
> +						sample->end_time,
> +						h,
> +						sample->error ? "error" : "disk",
> +						sample->fd,
> +						sample->error,
> +						sample->merges);
> +				else if (sample->type == IOTYPE_RX)
> +					svg_ubox(Y,
> +						sample->start_time,
> +						sample->end_time,
> +						h,
> +						sample->error ? "error" : "net",
> +						sample->fd,
> +						sample->error,
> +						sample->merges);
> +				else if (sample->type == IOTYPE_TX)
> +					svg_lbox(Y,
> +						sample->start_time,
> +						sample->end_time,
> +						h,
> +						sample->error ? "error" : "net",
> +						sample->fd,
> +						sample->error,
> +						sample->merges);
> +			}
> +
> +			suf = "";
> +			bytes = c->total_bytes;
> +			if (bytes > 1024) {
> +				bytes = bytes / 1024;
> +				suf = "K";
> +			}
> +			if (bytes > 1024) {
> +				bytes = bytes / 1024;
> +				suf = "M";
> +			}
> +			if (bytes > 1024) {
> +				bytes = bytes / 1024;
> +				suf = "G";
> +			}
> +
> +
> +			sprintf(comm, "%s:%i (%3.1f %sbytes)", c->comm ?: "", p->pid, bytes, suf);
> +			svg_text(Y, c->start_time, comm);
> +
> +			c->Y = Y;
> +			Y++;
> +			c = c->next;
> +		}
> +		p = p->next;
> +	}
> +}
> +
>  static void draw_process_bars(struct timechart *tchart)
>  {
>  	struct per_pid *p;
> @@ -987,9 +1372,6 @@ static int determine_display_tasks(struct timechart *tchart, u64 threshold)
>  	struct per_pidcomm *c;
>  	int count = 0;
>  
> -	if (process_filter)
> -		return determine_display_tasks_filtered(tchart);
> -
>  	p = tchart->all_data;
>  	while (p) {
>  		p->display = 0;
> @@ -1025,15 +1407,46 @@ static int determine_display_tasks(struct timechart *tchart, u64 threshold)
>  	return count;
>  }
>  
> +static int determine_display_io_tasks(struct timechart *timechart, u64 threshold __maybe_unused)
> +{
> +	struct per_pid *p;
> +	struct per_pidcomm *c;
> +	int count = 0;
> +
> +	p = timechart->all_data;
> +	while (p) {
> +		/* no exit marker, task kept running to the end */
> +		if (p->end_time == 0)
> +			p->end_time = timechart->last_time;
> +
> +		c = p->all;
> +
> +		while (c) {
> +			c->display = 0;
> +
> +			if (c->total_bytes >= threshold) {
> +				c->display = 1;
> +				count++;
> +			}
> +
> +			if (c->end_time == 0)
> +				c->end_time = timechart->last_time;
>  
> +			c = c->next;
> +		}
> +		p = p->next;
> +	}
> +	return count;
> +}
>  
> +#define BYTES_THRESH (1 * 1024 * 1024)
>  #define TIME_THRESH 10000000
>  
>  static void write_svg_file(struct timechart *tchart, const char *filename)
>  {
>  	u64 i;
>  	int count;
> -	int thresh = TIME_THRESH;
> +	int thresh = tchart->io_events ? BYTES_THRESH : TIME_THRESH;
>  
>  	if (tchart->power_only)
>  		tchart->proc_num = 0;
> @@ -1041,28 +1454,43 @@ static void write_svg_file(struct timechart *tchart, const char *filename)
>  	/* We'd like to show at least proc_num tasks;
>  	 * be less picky if we have fewer */
>  	do {
> -		count = determine_display_tasks(tchart, thresh);
> +		if (process_filter)
> +			count = determine_display_tasks_filtered(tchart);
> +		else if (tchart->io_events)
> +			count = determine_display_io_tasks(tchart, thresh);
> +		else
> +			count = determine_display_tasks(tchart, thresh);
>  		thresh /= 10;
>  	} while (!process_filter && thresh && count < tchart->proc_num);
>  
>  	if (!tchart->proc_num)
>  		count = 0;
>  
> -	open_svg(filename, tchart->numcpus, count, tchart->first_time, tchart->last_time);
> +	if (tchart->io_events) {
> +		open_svg(filename, 0, count, tchart->first_time, tchart->last_time);
>  
> -	svg_time_grid();
> -	svg_legenda();
> +		svg_time_grid(0.5);
> +		svg_io_legenda();
> +
> +		draw_io_bars(tchart);
> +	} else {
> +		open_svg(filename, tchart->numcpus, count, tchart->first_time, tchart->last_time);
>  
> -	for (i = 0; i < tchart->numcpus; i++)
> -		svg_cpu_box(i, tchart->max_freq, tchart->turbo_frequency);
> +		svg_time_grid(0);
>  
> -	draw_cpu_usage(tchart);
> -	if (tchart->proc_num)
> -		draw_process_bars(tchart);
> -	if (!tchart->tasks_only)
> -		draw_c_p_states(tchart);
> -	if (tchart->proc_num)
> -		draw_wakeups(tchart);
> +		svg_legenda();
> +
> +		for (i = 0; i < tchart->numcpus; i++)
> +			svg_cpu_box(i, tchart->max_freq, tchart->turbo_frequency);
> +
> +		draw_cpu_usage(tchart);
> +		if (tchart->proc_num)
> +			draw_process_bars(tchart);
> +		if (!tchart->tasks_only)
> +			draw_c_p_states(tchart);
> +		if (tchart->proc_num)
> +			draw_wakeups(tchart);
> +	}
>  
>  	svg_close();
>  }
> @@ -1110,6 +1538,56 @@ static int __cmd_timechart(struct timechart *tchart, const char *output_name)
>  		{ "power:power_end",		process_sample_power_end },
>  		{ "power:power_frequency",	process_sample_power_frequency },
>  #endif
> +
> +		{ "syscalls:sys_enter_read",		process_enter_read },
> +		{ "syscalls:sys_enter_pread64",		process_enter_read },
> +		{ "syscalls:sys_enter_readv",		process_enter_read },
> +		{ "syscalls:sys_enter_preadv",		process_enter_read },
> +		{ "syscalls:sys_enter_write",		process_enter_write },
> +		{ "syscalls:sys_enter_pwrite64",	process_enter_write },
> +		{ "syscalls:sys_enter_writev",		process_enter_write },
> +		{ "syscalls:sys_enter_pwritev",		process_enter_write },
> +		{ "syscalls:sys_enter_sync",		process_enter_sync },
> +		{ "syscalls:sys_enter_sync_file_range",	process_enter_sync },
> +		{ "syscalls:sys_enter_fsync",		process_enter_sync },
> +		{ "syscalls:sys_enter_msync",		process_enter_sync },
> +		{ "syscalls:sys_enter_recvfrom",	process_enter_rx },
> +		{ "syscalls:sys_enter_recvmmsg",	process_enter_rx },
> +		{ "syscalls:sys_enter_recvmsg",		process_enter_rx },
> +		{ "syscalls:sys_enter_sendto",		process_enter_tx },
> +		{ "syscalls:sys_enter_sendmsg",		process_enter_tx },
> +		{ "syscalls:sys_enter_sendmmsg",	process_enter_tx },
> +		{ "syscalls:sys_enter_epoll_pwait",	process_enter_poll },
> +		{ "syscalls:sys_enter_epoll_wait",	process_enter_poll },
> +		{ "syscalls:sys_enter_poll",		process_enter_poll },
> +		{ "syscalls:sys_enter_ppoll",		process_enter_poll },
> +		{ "syscalls:sys_enter_pselect6",	process_enter_poll },
> +		{ "syscalls:sys_enter_select",		process_enter_poll },
> +
> +		{ "syscalls:sys_exit_read",		process_exit_read },
> +		{ "syscalls:sys_exit_pread64",		process_exit_read },
> +		{ "syscalls:sys_exit_readv",		process_exit_read },
> +		{ "syscalls:sys_exit_preadv",		process_exit_read },
> +		{ "syscalls:sys_exit_write",		process_exit_write },
> +		{ "syscalls:sys_exit_pwrite64",		process_exit_write },
> +		{ "syscalls:sys_exit_writev",		process_exit_write },
> +		{ "syscalls:sys_exit_pwritev",		process_exit_write },
> +		{ "syscalls:sys_exit_sync",		process_exit_sync },
> +		{ "syscalls:sys_exit_sync_file_range",	process_exit_sync },
> +		{ "syscalls:sys_exit_fsync",		process_exit_sync },
> +		{ "syscalls:sys_exit_msync",		process_exit_sync },
> +		{ "syscalls:sys_exit_recvfrom",		process_exit_rx },
> +		{ "syscalls:sys_exit_recvmmsg",		process_exit_rx },
> +		{ "syscalls:sys_exit_recvmsg",		process_exit_rx },
> +		{ "syscalls:sys_exit_sendto",		process_exit_tx },
> +		{ "syscalls:sys_exit_sendmsg",		process_exit_tx },
> +		{ "syscalls:sys_exit_sendmmsg",		process_exit_tx },
> +		{ "syscalls:sys_exit_epoll_pwait",	process_exit_poll },
> +		{ "syscalls:sys_exit_epoll_wait",	process_exit_poll },
> +		{ "syscalls:sys_exit_poll",		process_exit_poll },
> +		{ "syscalls:sys_exit_ppoll",		process_exit_poll },
> +		{ "syscalls:sys_exit_pselect6",		process_exit_poll },
> +		{ "syscalls:sys_exit_select",		process_exit_poll },
>  	};
>  	struct perf_data_file file = {
>  		.path = input_name,
> @@ -1154,6 +1632,123 @@ out_delete:
>  	return ret;
>  }
>  
> +static int timechart__io_record(int argc, const char **argv)
> +{
> +	unsigned int rec_argc, i;
> +	const char **rec_argv;
> +	const char **p;
> +	char *filter = NULL;
> +
> +	const char * const common_args[] = {
> +		"record", "-a", "-R", "-c", "1",
> +	};
> +	unsigned int common_args_nr = ARRAY_SIZE(common_args);
> +
> +	const char * const disk_events[] = {
> +		"-e", "syscalls:sys_enter_read",
> +		"-e", "syscalls:sys_enter_pread64",
> +		"-e", "syscalls:sys_enter_readv",
> +		"-e", "syscalls:sys_enter_preadv",
> +		"-e", "syscalls:sys_enter_write",
> +		"-e", "syscalls:sys_enter_pwrite64",
> +		"-e", "syscalls:sys_enter_writev",
> +		"-e", "syscalls:sys_enter_pwritev",
> +		"-e", "syscalls:sys_enter_sync",
> +		"-e", "syscalls:sys_enter_sync_file_range",
> +		"-e", "syscalls:sys_enter_fsync",
> +		"-e", "syscalls:sys_enter_msync",
> +
> +		"-e", "syscalls:sys_exit_read",
> +		"-e", "syscalls:sys_exit_pread64",
> +		"-e", "syscalls:sys_exit_readv",
> +		"-e", "syscalls:sys_exit_preadv",
> +		"-e", "syscalls:sys_exit_write",
> +		"-e", "syscalls:sys_exit_pwrite64",
> +		"-e", "syscalls:sys_exit_writev",
> +		"-e", "syscalls:sys_exit_pwritev",
> +		"-e", "syscalls:sys_exit_sync",
> +		"-e", "syscalls:sys_exit_sync_file_range",
> +		"-e", "syscalls:sys_exit_fsync",
> +		"-e", "syscalls:sys_exit_msync",
> +	};
> +	unsigned int disk_events_nr = ARRAY_SIZE(disk_events);
> +
> +	const char * const net_events[] = {
> +		"-e", "syscalls:sys_enter_recvfrom",
> +		"-e", "syscalls:sys_enter_recvmmsg",
> +		"-e", "syscalls:sys_enter_recvmsg",
> +		"-e", "syscalls:sys_enter_sendto",
> +		"-e", "syscalls:sys_enter_sendmsg",
> +		"-e", "syscalls:sys_enter_sendmmsg",
> +
> +		"-e", "syscalls:sys_exit_recvfrom",
> +		"-e", "syscalls:sys_exit_recvmmsg",
> +		"-e", "syscalls:sys_exit_recvmsg",
> +		"-e", "syscalls:sys_exit_sendto",
> +		"-e", "syscalls:sys_exit_sendmsg",
> +		"-e", "syscalls:sys_exit_sendmmsg",
> +	};
> +	unsigned int net_events_nr = ARRAY_SIZE(net_events);
> +
> +	const char * const poll_events[] = {
> +		"-e", "syscalls:sys_enter_epoll_pwait",
> +		"-e", "syscalls:sys_enter_epoll_wait",
> +		"-e", "syscalls:sys_enter_poll",
> +		"-e", "syscalls:sys_enter_ppoll",
> +		"-e", "syscalls:sys_enter_pselect6",
> +		"-e", "syscalls:sys_enter_select",
> +
> +		"-e", "syscalls:sys_exit_epoll_pwait",
> +		"-e", "syscalls:sys_exit_epoll_wait",
> +		"-e", "syscalls:sys_exit_poll",
> +		"-e", "syscalls:sys_exit_ppoll",
> +		"-e", "syscalls:sys_exit_pselect6",
> +		"-e", "syscalls:sys_exit_select",
> +	};
> +	unsigned int poll_events_nr = ARRAY_SIZE(poll_events);
> +
> +	rec_argc = common_args_nr +
> +		disk_events_nr * 4 +
> +		net_events_nr * 4 +
> +		poll_events_nr * 4 +
> +		argc + 1;
> +	rec_argv = calloc(rec_argc + 1, sizeof(char *));
> +
> +	if (rec_argv == NULL)
> +		return -ENOMEM;
> +
> +	if (asprintf(&filter, "common_pid != %d", getpid()) < 0)
> +		return -ENOMEM;
> +
> +	p = rec_argv;
> +	for (i = 0; i < common_args_nr; i++)
> +		*p++ = strdup(common_args[i]);
> +	for (i = 0; i < disk_events_nr; i++) {
> +		*p++ = "-e";
> +		*p++ = strdup(disk_events[i]);
> +		*p++ = "--filter";
> +		*p++ = filter;
> +	}
> +	for (i = 0; i < net_events_nr; i++) {
> +		*p++ = "-e";
> +		*p++ = strdup(net_events[i]);
> +		*p++ = "--filter";
> +		*p++ = filter;
> +	}
> +	for (i = 0; i < poll_events_nr; i++) {
> +		*p++ = "-e";
> +		*p++ = strdup(poll_events[i]);
> +		*p++ = "--filter";
> +		*p++ = filter;
> +	}
> +
> +	for (i = 0; i < (unsigned int)argc; i++)
> +		*p++ = argv[i];
> +
> +	return cmd_record(rec_argc, rec_argv, NULL);
> +}
> +
> +
>  static int timechart__record(struct timechart *tchart, int argc, const char **argv)
>  {
>  	unsigned int rec_argc, i, j;
> @@ -1282,6 +1877,8 @@ int cmd_timechart(int argc, const char **argv,
>  			.ordered_samples = true,
>  		},
>  		.proc_num = 15,
> +		.min_time = 1000000,
> +		.merge_dist = 1000,
>  	};
>  	const char *output_name = "output.svg";
>  	const struct option timechart_options[] = {
> @@ -1303,6 +1900,12 @@ int cmd_timechart(int argc, const char **argv,
>  		    "min. number of tasks to print"),
>  	OPT_BOOLEAN('t', "topology", &tchart.topology,
>  		    "sort CPUs according to topology"),
> +	OPT_BOOLEAN(0, "io-skip-eagain", &tchart.skip_eagain,
> +		    "skip EAGAIN errors"),
> +	OPT_U64(0, "io-min-time", &tchart.min_time,
> +		"all IO faster than min-time will visually appear longer"),
> +	OPT_U64(0, "io-merge-dist", &tchart.merge_dist,
> +		"merge events that are merge-dist us apart"),
>  	OPT_END()
>  	};
>  	const char * const timechart_usage[] = {
> @@ -1314,6 +1917,8 @@ int cmd_timechart(int argc, const char **argv,
>  	OPT_BOOLEAN('P', "power-only", &tchart.power_only, "output power data only"),
>  	OPT_BOOLEAN('T', "tasks-only", &tchart.tasks_only,
>  		    "output processes data only"),
> +	OPT_BOOLEAN('I', "io-only", &tchart.io_only,
> +		    "record only IO data"),
>  	OPT_BOOLEAN('g', "callchain", &tchart.with_backtrace, "record callchain"),
>  	OPT_END()
>  	};
> @@ -1340,7 +1945,10 @@ int cmd_timechart(int argc, const char **argv,
>  			return -1;
>  		}
>  
> -		return timechart__record(&tchart, argc, argv);
> +		if (tchart.io_only)
> +			return timechart__io_record(argc, argv);
> +		else
> +			return timechart__record(&tchart, argc, argv);
>  	} else if (argc)
>  		usage_with_options(timechart_usage, timechart_options);
>  
> diff --git a/tools/perf/util/svghelper.c b/tools/perf/util/svghelper.c
> index 43262b83c541..ba1260590225 100644
> --- a/tools/perf/util/svghelper.c
> +++ b/tools/perf/util/svghelper.c
> @@ -30,6 +30,7 @@ static u64 turbo_frequency, max_freq;
>  
>  #define SLOT_MULT 30.0
>  #define SLOT_HEIGHT 25.0
> +#define SLOT_HALF (SLOT_HEIGHT / 2)
>  
>  int svg_page_width = 1000;
>  u64 svg_highlight;
> @@ -114,8 +115,14 @@ void open_svg(const char *filename, int cpus, int rows, u64 start, u64 end)
>  	fprintf(svgfile, "      rect          { stroke-width: 1; }\n");
>  	fprintf(svgfile, "      rect.process  { fill:rgb(180,180,180); fill-opacity:0.9; stroke-width:1;   stroke:rgb(  0,  0,  0); } \n");
>  	fprintf(svgfile, "      rect.process2 { fill:rgb(180,180,180); fill-opacity:0.9; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
> +	fprintf(svgfile, "      rect.process3 { fill:rgb(180,180,180); fill-opacity:0.5; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
>  	fprintf(svgfile, "      rect.sample   { fill:rgb(  0,  0,255); fill-opacity:0.8; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
>  	fprintf(svgfile, "      rect.sample_hi{ fill:rgb(255,128,  0); fill-opacity:0.8; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
> +	fprintf(svgfile, "      rect.error    { fill:rgb(255,  0,  0); fill-opacity:0.5; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
> +	fprintf(svgfile, "      rect.net      { fill:rgb(  0,128,  0); fill-opacity:0.5; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
> +	fprintf(svgfile, "      rect.disk     { fill:rgb(  0,  0,255); fill-opacity:0.5; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
> +	fprintf(svgfile, "      rect.sync     { fill:rgb(128,128,  0); fill-opacity:0.5; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
> +	fprintf(svgfile, "      rect.poll     { fill:rgb(  0,128,128); fill-opacity:0.2; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
>  	fprintf(svgfile, "      rect.blocked  { fill:rgb(255,  0,  0); fill-opacity:0.5; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
>  	fprintf(svgfile, "      rect.waiting  { fill:rgb(224,214,  0); fill-opacity:0.8; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
>  	fprintf(svgfile, "      rect.WAITING  { fill:rgb(255,214, 48); fill-opacity:0.6; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
> @@ -132,6 +139,75 @@ void open_svg(const char *filename, int cpus, int rows, u64 start, u64 end)
>  	fprintf(svgfile, "    ]]>\n   </style>\n</defs>\n");
>  }
>  
> +static double normalize_height(double height)
> +{
> +	if (height < 0.25)
> +		return 0.25;
> +	else if (height < 0.50)
> +		return 0.50;
> +	else if (height < 0.75)
> +		return 0.75;
> +	else
> +		return 0.100;
> +}
> +
> +void svg_ubox(int Yslot, u64 start, u64 end, double height, const char *type, int fd, int error, int merges)
> +{
> +	double w = time2pixels(end) - time2pixels(start);
> +	height = normalize_height(height);
> +
> +	if (!svgfile)
> +		return;
> +
> +	fprintf(svgfile, "<g>\n");
> +	fprintf(svgfile, "<title>fd=%d error=%d merges=%d</title>\n", fd, error, merges);
> +	fprintf(svgfile, "<rect x=\"%4.8f\" width=\"%4.8f\" y=\"%4.1f\" height=\"%4.1f\" class=\"%s\"/>\n",
> +		time2pixels(start),
> +		w,
> +		Yslot * SLOT_MULT,
> +		SLOT_HALF * height,
> +		type);
> +	fprintf(svgfile, "</g>\n");
> +}
> +
> +void svg_lbox(int Yslot, u64 start, u64 end, double height, const char *type, int fd, int error, int merges)
> +{
> +	double w = time2pixels(end) - time2pixels(start);
> +	height = normalize_height(height);
> +
> +	if (!svgfile)
> +		return;
> +
> +	fprintf(svgfile, "<g>\n");
> +	fprintf(svgfile, "<title>fd=%d error=%d merges=%d</title>\n", fd, error, merges);
> +	fprintf(svgfile, "<rect x=\"%4.8f\" width=\"%4.8f\" y=\"%4.1f\" height=\"%4.1f\" class=\"%s\"/>\n",
> +		time2pixels(start),
> +		w,
> +		Yslot * SLOT_MULT + SLOT_HEIGHT - SLOT_HALF * height,
> +		SLOT_HALF * height,
> +		type);
> +	fprintf(svgfile, "</g>\n");
> +}
> +
> +void svg_fbox(int Yslot, u64 start, u64 end, double height, const char *type, int fd, int error, int merges)
> +{
> +	double w = time2pixels(end) - time2pixels(start);
> +	height = normalize_height(height);
> +
> +	if (!svgfile)
> +		return;
> +
> +	fprintf(svgfile, "<g>\n");
> +	fprintf(svgfile, "<title>fd=%d error=%d merges=%d</title>\n", fd, error, merges);
> +	fprintf(svgfile, "<rect x=\"%4.8f\" width=\"%4.8f\" y=\"%4.1f\" height=\"%4.1f\" class=\"%s\"/>\n",
> +		time2pixels(start),
> +		w,
> +		Yslot * SLOT_MULT + SLOT_HEIGHT - SLOT_HEIGHT * height,
> +		SLOT_HEIGHT * height,
> +		type);
> +	fprintf(svgfile, "</g>\n");
> +}
> +
>  void svg_box(int Yslot, u64 start, u64 end, const char *type)
>  {
>  	if (!svgfile)
> @@ -543,6 +619,20 @@ static void svg_legenda_box(int X, const char *text, const char *style)
>  		X + boxsize + 5, boxsize, 0.8 * boxsize, text);
>  }
>  
> +void svg_io_legenda(void)
> +{
> +	if (!svgfile)
> +		return;
> +
> +	fprintf(svgfile, "<g>\n");
> +	svg_legenda_box(0,	"Disk", "disk");
> +	svg_legenda_box(100,	"Network", "net");
> +	svg_legenda_box(200,	"Sync", "sync");
> +	svg_legenda_box(300,	"Poll", "poll");
> +	svg_legenda_box(400,	"Error", "error");
> +	fprintf(svgfile, "</g>\n");
> +}
> +
>  void svg_legenda(void)
>  {
>  	if (!svgfile)
> @@ -559,7 +649,7 @@ void svg_legenda(void)
>  	fprintf(svgfile, "</g>\n");
>  }
>  
> -void svg_time_grid(void)
> +void svg_time_grid(double min_thickness)
>  {
>  	u64 i;
>  
> @@ -579,8 +669,10 @@ void svg_time_grid(void)
>  			color = 128;
>  		}
>  
> -		fprintf(svgfile, "<line x1=\"%4.8f\" y1=\"%4.2f\" x2=\"%4.8f\" y2=\"%" PRIu64 "\" style=\"stroke:rgb(%i,%i,%i);stroke-width:%1.3f\"/>\n",
> -			time2pixels(i), SLOT_MULT/2, time2pixels(i), total_height, color, color, color, thickness);
> +		if (thickness >= min_thickness)
> +			fprintf(svgfile, "<line x1=\"%4.8f\" y1=\"%4.2f\" x2=\"%4.8f\" y2=\"%" PRIu64 "\" style=\"stroke:rgb(%i,%i,%i);stroke-width:%1.3f\"/>\n",
> +				time2pixels(i), SLOT_MULT/2, time2pixels(i),
> +				total_height, color, color, color, thickness);
>  
>  		i += 10000000;
>  	}
> diff --git a/tools/perf/util/svghelper.h b/tools/perf/util/svghelper.h
> index f7b4d6e699ea..f22ea5e245ac 100644
> --- a/tools/perf/util/svghelper.h
> +++ b/tools/perf/util/svghelper.h
> @@ -4,6 +4,9 @@
>  #include "types.h"
>  
>  extern void open_svg(const char *filename, int cpus, int rows, u64 start, u64 end);
> +extern void svg_ubox(int Yslot, u64 start, u64 end, double height, const char *type, int fd, int error, int merges);
> +extern void svg_lbox(int Yslot, u64 start, u64 end, double height, const char *type, int fd, int error, int merges);
> +extern void svg_fbox(int Yslot, u64 start, u64 end, double height, const char *type, int fd, int error, int merges);
>  extern void svg_box(int Yslot, u64 start, u64 end, const char *type);
>  extern void svg_blocked(int Yslot, int cpu, u64 start, u64 end, const char *backtrace);
>  extern void svg_running(int Yslot, int cpu, u64 start, u64 end, const char *backtrace);
> @@ -16,7 +19,8 @@ extern void svg_cstate(int cpu, u64 start, u64 end, int type);
>  extern void svg_pstate(int cpu, u64 start, u64 end, u64 freq);
>  
>  
> -extern void svg_time_grid(void);
> +extern void svg_time_grid(double min_thickness);
> +extern void svg_io_legenda(void);
>  extern void svg_legenda(void);
>  extern void svg_wakeline(u64 start, int row1, int row2, const char *backtrace);
>  extern void svg_partial_wakeline(u64 start, int row1, char *desc1, int row2, char *desc2, const char *backtrace);
> -- 
> 1.8.3.2
