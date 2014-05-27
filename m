Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606AbaE0Bgt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 21:36:49 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:36145 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508AbaE0Bgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 21:36:46 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 13/14] perf tests: Add test for caching dso file descriptors
References: <1400174615-2121-1-git-send-email-jolsa@kernel.org>
	<1400174615-2121-14-git-send-email-jolsa@kernel.org>
Date: Tue, 27 May 2014 10:36:44 +0900
In-Reply-To: <1400174615-2121-14-git-send-email-jolsa@kernel.org> (Jiri Olsa's
	message of "Thu, 15 May 2014 19:23:34 +0200")
Message-ID: <87d2f0huj7.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2014 19:23:34 +0200, Jiri Olsa wrote:
> Adding test that setup test_dso_data__fd_limit and test
> dso data file descriptors are cached appropriately.

[SNIP]
> +static long open_files_cnt(void)
> +{
> +	char path[PATH_MAX];
> +	struct dirent *dent;
> +	DIR *dir;
> +	long nr = 0;
> +	int n;
> +
> +	n = scnprintf(path, PATH_MAX, "%s/self/fd", procfs__mountpoint());
> +	TEST_ASSERT_VAL("couldn't get fd path", n < PATH_MAX);

Looks like an unnecessary check since the scnprintf() cannot return more
than (or equal to) PATH_MAX.

> +
> +	pr_debug("fd path: %s\n", path);
> +
> +	dir = opendir(path);
> +	TEST_ASSERT_VAL("failed to open fd directory", dir);
> +
> +	while ((dent = readdir(dir)) != NULL) {
> +		if (!strcmp(dent->d_name, ".") ||
> +		    !strcmp(dent->d_name, ".."))
> +			continue;
> +
> +		nr++;
> +	}
> +
> +	closedir(dir);
> +	return nr - 1;
> +}

[SNIP]
> +static int set_fd_limit(int n)
> +{
> +	struct rlimit rlim;
> +
> +	if (getrlimit(RLIMIT_NOFILE, &rlim))
> +		return -1;
> +
> +	pr_debug("file limit %ld, new %d\n", (long) rlim.rlim_cur, n);
> +
> +	rlim.rlim_cur = n;
> +	return setrlimit(RLIMIT_NOFILE, &rlim);
> +}
> +
> +int test__dso_data_cache(void)
> +{
> +	struct machine machine;
> +	long nr = open_files_cnt();
> +#define BUFSIZE 10
> +	u8 buf[BUFSIZE];
> +	ssize_t n;
> +	int fd;
> +
> +	memset(&machine, 0, sizeof(machine));
> +
> +	/* Make sure we are able to open 3 fds anyway */
> +	TEST_ASSERT_VAL("failed to set file limit",
> +			!set_fd_limit((nr + 6)));

3 or 6?

> +
> +	/*
> +	 * Test scenario:
> +	 * - create 3 dso objects
> +	 * - set the limit of opened data file descriptors to 2
> +	 * - open/close dsos data fds and check for proper
> +	 *   handling of the dso data cache
> +	 */
> +
> +	test_dso_data__fd_limit = 3;

2 or 3?

> +
> +	TEST_ASSERT_VAL("failed to create dsos\n", !dsos__create(TEST_FILE_SIZE));
> +
> +	/* open dso_0 */
> +	fd = dso__data_fd(dso_0, &machine);
> +	TEST_ASSERT_VAL("failed to get fd", fd > 0);
> +
> +	n = dso__data_read_offset(dso_0, &machine, 0, buf, BUFSIZE);
> +	TEST_ASSERT_VAL("failed to read dso", n == BUFSIZE);
> +
> +	/*
> +	 * Close dso_0 data with cache = true,

What does it mean by 'cache = true'?


> +	 * dso_0 should remain open.
> +	 */
> +	dso__data_close(dso_0);
> +	TEST_ASSERT_VAL("failed to not close dso", dso_0->data.fd != -1);
> +
> +	/* open dso_1 */
> +	n = dso__data_read_offset(dso_1, &machine, 0, buf, BUFSIZE);
> +	TEST_ASSERT_VAL("failed to read dso", n == BUFSIZE);
> +
> +	/*
> +	 * Close dso_1 data with cache = true,
> +	 * dso_0 and dso_1 should remain open.
> +	 */
> +	dso__data_close(dso_1);
> +	TEST_ASSERT_VAL("failed to not close dso", dso_0->data.fd != -1);
> +	TEST_ASSERT_VAL("failed to not close dso", dso_1->data.fd != -1);
> +
> +	/* open dso_2 */
> +	fd = dso__data_fd(dso_2, &machine);
> +	TEST_ASSERT_VAL("failed to get fd", fd > 0);
> +
> +	/*
> +	 * Close dso_1 data with cache = true,

You meant dso_2 right? :)

Thanks,
Namhyung


> +	 * dso_0 should get closed now
> +	 */
> +	dso__data_close(dso_2);
> +	TEST_ASSERT_VAL("failed to close dso_0", dso_0->data.fd == -1);
> +
> +	/* reopen dso_0 */
> +	fd = dso__data_fd(dso_0, &machine);
> +	TEST_ASSERT_VAL("failed to get fd", fd > 0);
> +
> +	/*
> +	 * Close dso_0 data with cache = true,
> +	 * dso_1 should get closed now.
> +	 */
> +	dso__data_close(dso_0);
> +	TEST_ASSERT_VAL("failed to close dso_1", dso_1->data.fd == -1);
> +
> +	/* reopen dso_1 */
> +	n = dso__data_read_offset(dso_1, &machine, 0, buf, BUFSIZE);
> +	TEST_ASSERT_VAL("failed to read dso", n == BUFSIZE);
> +
> +	/*
> +	 * Close dso_1 data with cache = true,
> +	 * dso_2 should get closed now.
> +	 */
> +	dso__data_close(dso_1);
> +	TEST_ASSERT_VAL("failed to close dso_2", dso_2->data.fd == -1);
> +
> +	/* dso_0 remains open */
> +	TEST_ASSERT_VAL("failed to keep open dso_0", dso_0->data.fd >= 0);
> +
> +	/* cleanup everything */
> +	dsos__delete();
> +
> +	pr_debug("nr start %ld, nr stop %ld\n", nr, open_files_cnt());
> +
> +	/* Make sure we did not leak any file descriptor. */
> +	TEST_ASSERT_VAL("failed leadking files", nr == open_files_cnt());
> +	return 0;
> +}
> diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
> index a9d7cb0..61e12b6 100644
> --- a/tools/perf/tests/tests.h
> +++ b/tools/perf/tests/tests.h
> @@ -28,6 +28,7 @@ int test__syscall_open_tp_fields(void);
>  int test__pmu(void);
>  int test__attr(void);
>  int test__dso_data(void);
> +int test__dso_data_cache(void);
>  int test__parse_events(void);
>  int test__hists_link(void);
>  int test__python_use(void);
