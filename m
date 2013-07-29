Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362Ab3G2G2J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 02:28:09 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:50007 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722Ab3G2G2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 02:28:07 -0400
X-AuditID: 9c93017e-b7b62ae000000eeb-07-51f60b7571e5
From: Namhyung Kim <namhyung@kernel.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 1/9] perf tools: add test for reading object code
References: <1374760890-30558-1-git-send-email-adrian.hunter@intel.com>
	<1374760890-30558-2-git-send-email-adrian.hunter@intel.com>
Date: Mon, 29 Jul 2013 15:28:04 +0900
In-Reply-To: <1374760890-30558-2-git-send-email-adrian.hunter@intel.com>
	(Adrian Hunter's message of "Thu, 25 Jul 2013 17:01:22 +0300")
Message-ID: <874nbd3mob.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adrian,

Just a few nitpicks below..


On Thu, 25 Jul 2013 17:01:22 +0300, Adrian Hunter wrote:
> Using the information in mmap events, perf tools can read object
> code associated with sampled addresses.  A test is added that
> compares bytes read by perf with the same bytes read using
> objdump.
>
[SNIP]
> +
> +static int read_objdump_line(char *line, size_t line_len, void **buf,
> +			     size_t *len)
> +{
> +	size_t i;
> +
> +	/* Skip to a colon */
> +	for (i = 0; i < line_len; i++) {
> +		if (line[i] == ':')
> +			break;
> +	}
> +	if (line[i++] != ':')
> +		return 0;

strchr() ?

> +
> +	/* Read bytes */
> +	while (*len) {
> +		char c1, c2;
> +
> +		/* Skip spaces */
> +		for (; i < line_len; i++) {
> +			if (!isspace(line[i]))
> +				break;
> +		}
> +		/* Get 2 hex digits */
> +		if (i >= line_len || !isxdigit(line[i]))
> +			break;
> +		c1 = line[i++];
> +		if (i >= line_len || !isxdigit(line[i]))
> +			break;
> +		c2 = line[i++];
> +		/* Followed by a space */
> +		if (i < line_len && line[i] && !isspace(line[i]))
> +			break;
> +		/* Store byte */
> +		*(unsigned char *)*buf = (hex(c1) << 4) | hex(c2);
> +		*buf += 1;
> +		*len -= 1;
> +	}
> +
> +	return 0;

It seems this function always returns 0..


> +}
> +
> +static int read_objdump_output(FILE *f, void **buf, size_t *len)
> +{
> +	char *line = NULL;
> +	size_t line_len;
> +	ssize_t ret;
> +	int err = 0;
> +
> +	while (1) {
> +		ret = getline(&line, &line_len, f);
> +		if (feof(f))
> +			break;
> +		if (ret < 0 || read_objdump_line(line, ret, buf, len)) {

so no need to check the return value.


> +			pr_debug("getline failed\n");
> +			err = -1;
> +			break;
> +		}
> +	}
> +
> +	free(line);
> +
> +	return err;
> +}
> +
[SNIP]
> +
> +static int do_test_code_reading(void)
> +{
> +	struct machines machines;
> +	struct machine *machine;
> +	struct thread *thread;
> +	struct perf_record_opts opts = {
> +		.mmap_pages	     = UINT_MAX,
> +		.user_freq	     = UINT_MAX,
> +		.user_interval	     = ULLONG_MAX,
> +		.freq		     = 40000,

Is it intended to use the freq of 40000 instead of 4000 (default)?


> +		.target		     = {
> +			.uses_mmap   = true,
> +		},
> +	};
> +	struct thread_map *threads = NULL;
> +	struct cpu_map *cpus = NULL;
> +	struct perf_evlist *evlist = NULL;
> +	struct perf_evsel *evsel = NULL;
> +	int err = -1, ret;
> +	pid_t pid;
> +	struct map *map;
> +	bool have_vmlinux, excl_kernel = false;
> +
> +	pid = getpid();
> +
> +	machines__init(&machines);
> +	machine = &machines.host;
> +
> +	ret = machine__create_kernel_maps(machine);
> +	if (ret < 0) {
> +		pr_debug("machine__create_kernel_maps failed\n");
> +		goto out_err;
> +	}
> +
> +	/* Load kernel map */
> +	map = machine->vmlinux_maps[MAP__FUNCTION];
> +	ret = map__load(map, NULL);
> +	if (ret < 0) {
> +		pr_debug("map__load failed\n");
> +		goto out_err;
> +	}
> +	have_vmlinux = map->dso->symtab_type == DSO_BINARY_TYPE__VMLINUX;
> +	/* No point getting kernel events if there is no vmlinux */
> +	if (!have_vmlinux)
> +		excl_kernel = true;
> +
> +	threads = thread_map__new_by_tid(pid);
> +	if (!threads) {
> +		pr_debug("thread_map__new_by_tid failed\n");
> +		goto out_err;
> +	}
> +
> +	ret = perf_event__synthesize_thread_map(NULL, threads,
> +						perf_event__process, machine);
> +	if (ret < 0) {
> +		pr_debug("perf_event__synthesize_thread_map failed\n");
> +		goto out_err;
> +	}
> +
> +	thread = machine__findnew_thread(machine, pid, pid);
> +	if (!thread) {
> +		pr_debug("machine__findnew_thread failed\n");
> +		goto out_err;
> +	}
> +
> +	cpus = cpu_map__new(NULL);
> +	if (!cpus) {
> +		pr_debug("cpu_map__new failed\n");
> +		goto out_err;
> +	}
> +
> +	while (1) {
> +		const char *str;
> +
> +		evlist = perf_evlist__new();
> +		if (!evlist) {
> +			pr_debug("perf_evlist__new failed\n");
> +			goto out_err;
> +		}
> +
> +		perf_evlist__set_maps(evlist, cpus, threads);
> +
> +		if (excl_kernel)
> +			str =  "cycles:u";

A double whitespace.


> +		else
> +			str = "cycles";
> +		pr_debug("Parsing event '%s'\n", str);
> +		ret = parse_events(evlist, str);
> +		if (ret < 0) {
> +			pr_debug("parse_events failed\n");
> +			goto out_err;
> +		}
> +
> +		perf_evlist__config(evlist, &opts);
> +
> +		evsel = perf_evlist__first(evlist);
> +
> +		evsel->attr.comm = 1;
> +		evsel->attr.disabled = 1;
> +		evsel->attr.enable_on_exec = 0;
> +
> +		ret = perf_evlist__open(evlist);
> +		if (ret < 0) {
> +			if (!excl_kernel) {
> +				excl_kernel = true;
> +				continue;

It seems the evlist is leaked.  perf_evlist__delete(evlist) is needed.

Thanks,
Namhyung


> +			}
> +			pr_debug("perf_evlist__open failed\n");
> +			goto out_err;
> +		}
> +		break;
> +	}
> +
> +	ret = perf_evlist__mmap(evlist, UINT_MAX, false);
> +	if (ret < 0) {
> +		pr_debug("perf_evlist__mmap failed\n");
> +		goto out_err;
> +	}
> +
> +	perf_evlist__enable(evlist);
> +
> +	do_something();
> +
> +	perf_evlist__disable(evlist);
> +
> +	ret = process_events(machine, evlist);
> +	if (ret < 0)
> +		goto out_err;
> +
> +	if (!have_vmlinux)
> +		err = TEST_CODE_READING_NO_VMLINUX;
> +	else if (excl_kernel)
> +		err = TEST_CODE_READING_NO_ACCESS;
> +	else
> +		err = TEST_CODE_READING_OK;
> +out_err:
> +	if (evlist) {
> +		perf_evlist__disable(evlist);
> +		perf_evlist__munmap(evlist);
> +		perf_evlist__close(evlist);
> +		perf_evlist__delete(evlist);
> +	}
> +	if (cpus)
> +		cpu_map__delete(cpus);
> +	if (threads)
> +		thread_map__delete(threads);
> +	machines__destroy_kernel_maps(&machines);
> +	machine__delete_threads(machine);
> +	machines__exit(&machines);
> +
> +	return err;
> +}
> +
> +int test__code_reading(void)
> +{
> +	int ret;
> +
> +	ret = do_test_code_reading();
> +
> +	switch (ret) {
> +	case TEST_CODE_READING_OK:
> +		return 0;
> +	case TEST_CODE_READING_NO_VMLINUX:
> +		fprintf(stderr, " (no vmlinux)");
> +		return 0;
> +	case TEST_CODE_READING_NO_ACCESS:
> +		fprintf(stderr, " (no access)");
> +		return 0;
> +	default:
> +		return -1;
> +	};
> +}
> diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
> index 90e3056..fda12266 100644
> --- a/tools/perf/tests/tests.h
> +++ b/tools/perf/tests/tests.h
> @@ -36,5 +36,6 @@ int test__bp_signal_overflow(void);
>  int test__task_exit(void);
>  int test__sw_clock_freq(void);
>  int test__sample_parsing(void);
> +int test__code_reading(void);
>  
>  #endif /* TESTS_H */
