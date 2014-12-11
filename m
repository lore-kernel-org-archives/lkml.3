Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967395AbaLKW5g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 17:57:36 -0500
Received: from smtp2.provo.novell.com ([137.65.250.81]:51479 "EHLO
	smtp2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967047AbaLKW5c (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Thu, 11 Dec 2014 17:57:32 -0500
Message-ID: <1418338641.9432.5.camel@stgolabs.net>
Subject: Re: [PATCH  v3] Perf Bench: Locking Microbenchmark
From: Davidlohr Bueso <dave@stgolabs.net>
To: Tuan Bui <tuan.d.bui@hp.com>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, paulus@samba.org,
        acme@kernel.org, artagnon@gmail.com, jolsa@redhat.com,
        dvhart@linux.intel.com, Aswin Chandramouleeswaran <aswin@hp.com>,
        Jason Low <jason.low2@hp.com>, akpm@linux-foundation.org,
        mingo@kernel.org
Date: Thu, 11 Dec 2014 14:57:21 -0800
In-Reply-To: <1418165693.6540.5.camel@u64>
References: <1418165693.6540.5.camel@u64>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-12-09 at 14:54 -0800, Tuan Bui wrote:
> [root@u64 ~]# perf bench locking vfs
> # Running 'locking/vfs' benchmark:
> 
>    100 processes: throughput = 342506 average opts/sec all processes
>    100 processes: throughput = 3425 average opts/sec per process
> 
>    200 processes: throughput = 341309 average opts/sec all processes
>    200 processes: throughput = 1706 average opts/sec per process
>    ...

What's the point in displaying the ops/sec/process? Could the not mean
be displayed at the end only? Or display it as you do but with a verbose
option?

One thing missing here that really should be addressed is multiple runs
and statistic reports. Take a look and make use of 'perf bench -r <N>'
and how we use it for, say, futexes:

./perf bench -r 5 futex requeue
# Running 'futex/requeue' benchmark:
Run summary [PID 19084]: Requeuing 4 threads (from [private] 0x74459c to 0x744598), 1 at a time.

[Run 1]: Requeued 4 of 4 threads in 0.0090 ms
[Run 2]: Requeued 4 of 4 threads in 0.0100 ms
[Run 3]: Requeued 4 of 4 threads in 0.0090 ms
[Run 4]: Requeued 4 of 4 threads in 0.0110 ms
[Run 5]: Requeued 4 of 4 threads in 0.0120 ms
Requeued 4 of 4 threads in 0.0102 ms (+-5.72%)

[...]

> diff --git a/tools/perf/bench/locking.c b/tools/perf/bench/locking.c
> new file mode 100644
> index 0000000..70222bb
> --- /dev/null
> +++ b/tools/perf/bench/locking.c
> @@ -0,0 +1,336 @@
> +/*
> + * locking.c
> + *
> + * Simple micro benchmark that stress kernel locking contention with
> + * creat(2) system call by spawning multiple processes to call
> + * this system call.
> + *
> + * Results output are average operations/sec for all processes and
> + * average operations/sec per process.
> + *
> + * Tuan Bui <tuan.d.bui@hp.com>
> + */
> +
> +#include "../perf.h"
> +#include "../util/util.h"
> +#include "../util/stat.h"
> +#include "../util/parse-options.h"
> +#include "../util/header.h"
> +#include "bench.h"
> +
> +#include <err.h>
> +#include <stdlib.h>
> +#include <sys/time.h>
> +#include <unistd.h>
> +#include <sys/resource.h>
> +#include <linux/futex.h>
> +#include <sys/mman.h>
> +#include <sys/syscall.h>
> +#include <sys/types.h>
> +#include <signal.h>
> +#include <dirent.h>
> +
> +#define NOTSET -1

You don't need this, just initialize bench_dur and num_jobs to 0, if
nothing is set, its a bogus value anyway.

> +struct worker {
> +	pid_t pid;
> +	unsigned int order_id;
> +	char str[50];
> +};
> +
> +struct timeval start, end, total;
> +static unsigned int start_nr = 100;
> +static unsigned int end_nr = 1100;
> +static unsigned int increment_by = 100;

No, these default values need to be dynamic and scale by number of CPUs
to make sense on different systems. ie:

start_nr = 1;
inc = ncpus/<N>
end_nr = ncpus * <M> + inc

I'll let you see what N and M could be, but in general you want small
increments and a larger end_nr to stress the underlying lock as much as
possible (ie N=2, M=5).


> +static int bench_dur = NOTSET;
> +static int num_jobs = NOTSET;
> +static bool run_jobs;
> +static int n_pro;

As we add more benchmarks to 'bench locking' this can be unified into a
single context structure, or maybe something like 'struct params' like
we do in numa workloads.

> +/* Shared variables between fork processes*/
nit: please allow a space before closing the comment.

> +unsigned int *finished, *setup;
> +unsigned long long *shared_workers;

same suggestion as the context one above.

> +char *tmp_dir;
> +pid_t *p_id;
> +/* all processes will block on the same futex */
> +u_int32_t *futex;

Any reason why you're making it a pointer? you can just pass it to
futex(2) by reference.

> +
> +static const struct option options[] = {
> +	OPT_UINTEGER('s', "start", &start_nr, "Number of processes to start"),
> +	OPT_UINTEGER('e', "end", &end_nr, "Number of processes to end"),
> +	OPT_UINTEGER('i', "increment", &increment_by, "Numbers of processes to increment)"),
> +	OPT_INTEGER('r', "runtime", &bench_dur, "Specify benchmark runtime in seconds"),
> +	OPT_INTEGER('j', "jobs", &num_jobs, "Specify number of jobs per process"),
> +	OPT_END()
> +};
> +
> +static const char * const bench_locking_vfs_usage[] = {
> +	"perf bench locking vfs <options>",
> +	NULL
> +};
> +
> +/* Clean up if SIGINT is raised */
> +static void sigint_handler(int sig __maybe_unused,
> +			siginfo_t *info __maybe_unused,
> +			void *uc __maybe_unused)
> +{
> +	DIR *dir;
> +	struct dirent *file;
> +	char fp[50];
> +	int i;
> +
> +	/* If child process exit*/
> +	if (getpid() != *p_id)
> +		exit(0);
> +	/* if parent process wait for all child processes to exit and then clean up */

nit again: Please be consistent when commenting, either start with a cap
or don't.

> +	else {
> +		/* Wait for all child processes exit before cleaning up the dir */
> +		for (i = 0; i < n_pro; i++)
> +			wait(NULL);
> +
> +		dir = opendir(tmp_dir);
> +		if (dir == NULL)
> +			err(EXIT_FAILURE, "opendir");
> +		while ((file = readdir(dir))) {
> +			sprintf(fp, "%s/%s", tmp_dir, file->d_name);
> +			unlink(fp);
> +		}
> +		if ((rmdir(tmp_dir)) < 0)
> +			err(EXIT_FAILURE, "rmdir");
> +		exit(0);
> +	}
> +}
> +
> +/* Running bench vfs workload */
> +static void *run_bench_vfs(struct worker *workers)
> +{
> +	int fd;
> +	unsigned long long nr_ops = 0;
> +	int jobs = num_jobs;
> +
> +	sprintf(workers->str, "%s/%d-XXXXXX", tmp_dir, getpid());
> +	if ((mkstemp(workers->str)) < 0)
> +		err(EXIT_FAILURE, "mkstemp");
> +
> +	/* Signal to parent process and wait till all processes/ are ready run */
> +	setup[workers->order_id] = 1;
> +	syscall(SYS_futex, futex, FUTEX_WAIT, 0, NULL, NULL, 0);
> +
> +	/* Start of the benchmark keep looping till parent process signal completion */
> +	while ((run_jobs ? (jobs > 0) : (!*finished))) {
> +		fd = creat(workers->str, S_IRWXU);
> +		if (fd < 0)
> +			err(EXIT_FAILURE, "creat");
> +		nr_ops++;
> +		if (run_jobs)
> +			jobs--;
> +		close(fd);
> +	}
> +
> +	if ((unlink(workers->str)) < 0)
> +		err(EXIT_FAILURE, "unlink");
> +	shared_workers[workers->order_id] = nr_ops;
> +	setup[workers->order_id] = 0;
> +	exit(0);
> +}
> +
> +/* Setting shared variable finished and shared_workers */

It would be nice to further expand this comment. Why did you choose to
create so many shared mappings?

> +static void setup_shared(void)
> +{
> +	unsigned int *finished_tmp, *setup_tmp;
> +	unsigned long long *shared_workers_tmp;
> +	u_int32_t *futex_tmp;
> +
> +
> +	/* finished shared var is use to signal start and end of benchmark */
> +	finished_tmp = (void *)mmap(0, sizeof(unsigned int), PROT_READ|PROT_WRITE,
> +			MAP_SHARED|MAP_ANONYMOUS, -1, 0);
> +	if (finished_tmp == (void *) -1)
> +		err(EXIT_FAILURE, "mmap finished");
> +	finished = finished_tmp;
> +
> +	/* shared_workers is an array of ops perform by each process */
> +	shared_workers_tmp = (void *)mmap(0, sizeof(unsigned long long)*end_nr,
> +			PROT_READ|PROT_WRITE, MAP_SHARED|MAP_ANONYMOUS, -1, 0);
> +	if (shared_workers_tmp == (void *) -1)
> +		err(EXIT_FAILURE, "mmap shared_workers");
> +	shared_workers = shared_workers_tmp;
> +
> +	/* setup is use for each processes to signal that it is done
> +	 * setting up for the benchmark and is ready to run */

nit: multi line comments should be in the form:
/*
 * lala
 */

For this kind of style crap, you'll want to run checkpatch ;)

> +	setup_tmp = (void *)mmap(0, sizeof(unsigned int)*end_nr,
> +			PROT_READ|PROT_WRITE, MAP_SHARED|MAP_ANONYMOUS, -1, 0);
> +	if (setup_tmp == (void *) -1)
> +		err(EXIT_FAILURE, "mmap setup");
> +	setup = setup_tmp;
> +
> +	/* Processes will sleep on this futex until all other processes
> +	 * are done setting up and are ready to run */
> +	futex_tmp = (void *)mmap(0, sizeof(u_int32_t), PROT_READ|PROT_WRITE,
> +			MAP_SHARED|MAP_ANONYMOUS, -1, 0);
> +	if (futex_tmp == (void *) -1)
> +		err(EXIT_FAILURE, "mmap futex");
> +	futex = futex_tmp;
> +	(*futex) = 0;

I'm not following, why you need this? I could be missing something, but
it seems you're over complicating things...

> +	/* Setting a tmp dir for all processes to write to */
> +	tmp_dir = (void *)mmap(0, sizeof(char) * 255, PROT_READ|PROT_WRITE,
> +			MAP_SHARED|MAP_ANONYMOUS, -1, 0);
> +	if (tmp_dir == (void *) -1)
> +		err(EXIT_FAILURE, "mmap finished");
> +
> +	/* Setting up parent id to handle sigint */
> +	p_id = (void *)mmap(0, sizeof(pid_t), PROT_READ|PROT_WRITE,
> +			MAP_SHARED|MAP_ANONYMOUS, -1, 0);
> +	if (p_id == (void *) -1)
> +		err(EXIT_FAILURE, "mmap p_id");
> +	*p_id = getpid();
> +
> +	/* Creating tmp dir for all process to write to */
> +	sprintf(tmp_dir, "%d-XXXXXX", *p_id);
> +	if ((mkdtemp(tmp_dir)) == NULL)
> +		err(EXIT_FAILURE, "mkdtemp");
> +}
> +
> +/* Freeing shared variables */
> +static void free_resources(void)
> +{
> +	if ((rmdir(tmp_dir)) == -1)
> +		err(EXIT_FAILURE, "rmdir");
> +
> +	if ((munmap(finished, sizeof(unsigned int)) == -1))
> +		err(EXIT_FAILURE, "munmap finished");
> +
> +	if ((munmap(shared_workers, sizeof(unsigned long long) * end_nr) == -1))
> +		err(EXIT_FAILURE, "munmap shared_workers");
> +
> +	if ((munmap(setup, sizeof(unsigned int) * end_nr) == -1))
> +		err(EXIT_FAILURE, "munmap setup");
> +
> +	if ((munmap(futex, sizeof(u_int32_t))) == -1)
> +		err(EXIT_FAILURE, "munmap futex");
> +
> +	if ((munmap(tmp_dir, sizeof(char) * 50) == -1))
> +		err(EXIT_FAILURE, "munmap tmp_dir");
> +
> +	if ((munmap(p_id, sizeof(pid_t)) == -1))
> +		err(EXIT_FAILURE, "munmap p_id");
> +}
> +
> +/* Start to spawn workers and wait till all workers have been
> + * created before starting workload */
> +static void spawn_workers(void *(*bench_ptr) (struct worker *))
> +{
> +	pid_t child;
> +	unsigned int i, j, k;

Please use meaningful variable names, there are used more than just a
simple loop counter.

> +	struct worker workers;
> +	unsigned long long total_ops;
> +	unsigned int total_workers;
> +
> +	setup_shared();
> +
> +	/* This loop through all the run each is increment by increment_by */
> +	for (i = start_nr; i <= end_nr; i += increment_by) {
> +
> +		for (j = 0; j < i; j++) {
> +			if (!fork())
> +				break;
> +		}
> +
> +		child = getpid();
> +		/* Initialize child worker struct and run benchmark */
> +		if (child != *p_id) {
> +			workers.order_id = j;
> +			workers.pid = child;
> +			bench_ptr(&workers);
> +		}
> +		/* Parent to sleep during the duration of benchmark */
> +		else{
> +			n_pro = i;
> +			/* Make sure all child process are created and setup
> +			 * before starting benchmark for bench_dur durations */
> +			do {
> +				total_workers = 0;
> +				for (k = 0; k < i; k++)
> +					total_workers = total_workers + setup[k];
> +			} while (total_workers != i);
> +
> +			/* Wake up all sleeping process to run the benchmark */
> +			(*futex) = 1;
> +			syscall(SYS_futex, futex, FUTEX_WAKE, i, NULL, NULL, 0);

Please no, we have futex.h wrappers for that. You also need to confirm
that the wakeups did in fact occur (check the return value of
futex_wake()).

> +
> +			/* If run time parameters is set */
> +			if (!run_jobs) {
> +				/* All proccesses are ready signal them to run */
> +				gettimeofday(&start, NULL);
> +				sleep(bench_dur);
> +				(*finished) = 1;
> +				gettimeofday(&end, NULL);
> +				timersub(&end, &start, &total);
> +
> +				for (k = 0; k < i; k++)
> +					wait(NULL);
> +			}
> +			/* If jobs per proccesses is set */
> +			else {
> +				/* All proccesses are ready signal them to run */
> +				gettimeofday(&start, NULL);
> +				/* Wait for all process to terminate before getting outputs */
> +				for (k = 0; k < i; k++)
> +					wait(NULL);
> +				gettimeofday(&end, NULL);
> +				timersub(&end, &start, &total);
> +			}
> +
> +			/* Sum up all the ops by each process and report */
> +			total_ops = 0;
> +			for (k = 0; k < i; k++)
> +				total_ops = total_ops + shared_workers[k];
> +
> +			printf("\n%6d processes: throughput = %llu average opts/sec all processes\n",
> +				i, (total_ops / (!total.tv_sec ? 1 : total.tv_sec)));
> +
> +			printf("%6d processes: throughput = %llu average opts/sec per process\n",
> +				i, ((total_ops/(!total.tv_sec ? 1 : total.tv_sec))/(!i ? 1 : i)));

At this point, its pretty hard to make sense of what on earth this
output represents. Can you break it up a bit?

> +
> +			/* Reset back to 0 for next run */
> +			(*finished) = 0;
> +			(*futex) = 0;

Reporting should be a different function.

> +		}
> +	}
> +	free_resources();
> +}
> +
> +int bench_locking_vfs(int argc, const char **argv,
> +			const char *prefix __maybe_unused)
> +{
> +	struct sigaction sa;
> +
> +	sigfillset(&sa.sa_mask);
> +	sa.sa_sigaction = sigint_handler;
> +	sa.sa_flags = SA_SIGINFO;
> +	sigaction(SIGINT, &sa, NULL);

You probably want to setup signal callbacks once you verify the user
input is correct and ready to fork ;)

> +
> +	argc = parse_options(argc, argv, options, bench_locking_vfs_usage, 0);
> +
> +	/* If errors parsing options */
> +	if (argc || ((bench_dur != NOTSET) && (num_jobs != NOTSET))) {

This should only be if (argc), evaluating bench_dur and num_jobs should
come later.

> +		usage_with_options(bench_locking_vfs_usage, options);
> +		exit(EXIT_FAILURE);
> +	}
> +	/* If both run time and job per process is set */
> +	if (argc || ((bench_dur != NOTSET) && (num_jobs != NOTSET))) {

This condition is the same as the above. Just get rid of the argc check
here.

> +		fprintf(stderr, "\n runtime and jobs options can not both be specified\n");
> +		usage_with_options(bench_locking_vfs_usage, options);
> +		exit(EXIT_FAILURE);
> +	}
> +
> +	/* If both run time and jobs options is not set default to run time only*/
> +	if ((bench_dur == NOTSET) && (num_jobs == NOTSET))
> +		bench_dur = 5;
> +
> +	if (num_jobs != NOTSET)
> +		run_jobs = true;
> +
> +	spawn_workers(run_bench_vfs);
> +	return 0;
> +}

Overall this is shaping up nicely I think, thanks for doing this.

