Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124Ab3HACHw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 22:07:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26206 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428Ab3HACHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 22:07:50 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=0VS4G58IZu0A:10 a=5SG0PmZfjMsA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=laNjaRT52OkA:10 a=mCBIcoLE15QrPcsZyvsA:9 a=QEXdDO2ut3YA:10 a=H4RLYmtiZ8A4XIJiNwQA:9 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1375322866.5418.46.camel@gandalf.local.home>
Subject: Re: [RFC][PATCH 3/4] tracing/kprobes: Fail to unregister if probe
 event files are open
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 31 Jul 2013 22:07:46 -0400
In-Reply-To: <1375310548.5418.21.camel@gandalf.local.home>
References: <20130704033347.807661713@goodmis.org>
	 <20130704034038.819592356@goodmis.org>
	 <1375300192.5418.17.camel@gandalf.local.home>
	 <20130731204003.GA30188@redhat.com>
	 <1375310548.5418.21.camel@gandalf.local.home>
Content-Type: multipart/mixed; boundary="=-F8j94NH7Sjgg2sZSNJp/"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-F8j94NH7Sjgg2sZSNJp/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Wed, 2013-07-31 at 18:42 -0400, Steven Rostedt wrote:
>  
> > This should be fine. Either event_remove() path takes event_mutex
> > first and then ->write() fails, or ftrace_event_enable_disable()
> > actually disables this even successfully.
> 
> Actually I meant while in unregister_trace_probe(), it gets by the
> trace_probe_is_enabled() part first, then the write succeeds (as the
> event_mutex isn't taken till unregister_probe_event()). The the
> unregister_probe_event fails, but the tp was freed. The event files
> still reference the tp and this is where a crash can happen without this
> patch set.

And it's not just theoretical. I worked on a program to try to trigger
this bug, and succeeded :-)  (I've never been so happy being able to
crash my kernel)

[  128.999772] BUG: unable to handle kernel paging request at 00000005000000f9
[  129.000015] IP: [<ffffffff810dee70>] probes_open+0x3b/0xa7
[  129.000015] PGD 7808a067 PUD 0 
[  129.000015] Oops: 0000 [#1] PREEMPT SMP 
[  129.000015] Dumping ftrace buffer:
   <skip>
[  129.000015] ---------------------------------
[  129.000015] Modules linked in: ipt_MASQUERADE sunrpc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables uinput snd_hda_codec_idt kvm_intel snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm kvm snd_page_alloc snd_timer shpchp snd microcode i2c_i801 soundcore pata_acpi firewire_ohci firewire_core crc_itu_t ata_generic i915 drm_kms_helper drm i2c_algo_bit i2c_core video
[  129.000015] CPU: 1 PID: 2070 Comm: test-kprobe-rem Not tainted 3.11.0-rc3-test+ #47
[  129.000015] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./To be filled by O.E.M., BIOS SDBLI944.86P 05/08/2007
[  129.000015] task: ffff880077756440 ti: ffff880076e52000 task.ti: ffff880076e52000
[  129.000015] RIP: 0010:[<ffffffff810dee70>]  [<ffffffff810dee70>] probes_open+0x3b/0xa7
[  129.000015] RSP: 0018:ffff880076e53c38  EFLAGS: 00010203
[  129.000015] RAX: 0000000500000001 RBX: ffff88007844f440 RCX: 0000000000000003
[  129.000015] RDX: 0000000000000003 RSI: 0000000000000003 RDI: ffff880076e52000
[  129.000015] RBP: ffff880076e53c58 R08: ffff880076e53bd8 R09: 0000000000000000
[  129.000015] R10: ffff880077756440 R11: 0000000000000006 R12: ffffffff810dee35
[  129.000015] R13: ffff880079250418 R14: 0000000000000000 R15: ffff88007844f450
[  129.000015] FS:  00007f87a276f700(0000) GS:ffff88007d480000(0000) knlGS:0000000000000000
[  129.000015] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  129.000015] CR2: 00000005000000f9 CR3: 0000000077262000 CR4: 00000000000007e0
[  129.000015] Stack:
[  129.000015]  ffff880076e53c58 ffffffff81219ea0 ffff88007844f440 ffffffff810dee35
[  129.000015]  ffff880076e53ca8 ffffffff81130f78 ffff8800772986c0 ffff8800796f93a0
[  129.000015]  ffffffff81d1b5d8 ffff880076e53e04 0000000000000000 ffff88007844f440
[  129.000015] Call Trace:
[  129.000015]  [<ffffffff81219ea0>] ? security_file_open+0x2c/0x30
[  129.000015]  [<ffffffff810dee35>] ? unregister_trace_probe+0x4b/0x4b
[  129.000015]  [<ffffffff81130f78>] do_dentry_open+0x162/0x226
[  129.000015]  [<ffffffff81131186>] finish_open+0x46/0x54
[  129.000015]  [<ffffffff8113f30b>] do_last+0x7f6/0x996
[  129.000015]  [<ffffffff8113cc6f>] ? inode_permission+0x42/0x44
[  129.000015]  [<ffffffff8113f6dd>] path_openat+0x232/0x496
[  129.000015]  [<ffffffff8113fc30>] do_filp_open+0x3a/0x8a
[  129.000015]  [<ffffffff8114ab32>] ? __alloc_fd+0x168/0x17a
[  129.000015]  [<ffffffff81131f4e>] do_sys_open+0x70/0x102
[  129.000015]  [<ffffffff8108f06e>] ? trace_hardirqs_on_caller+0x160/0x197
[  129.000015]  [<ffffffff81131ffe>] SyS_open+0x1e/0x20
[  129.000015]  [<ffffffff81522742>] system_call_fastpath+0x16/0x1b
[  129.000015] Code: e5 41 54 53 48 89 f3 48 83 ec 10 48 23 56 78 48 39 c2 75 6c 31 f6 48 c7 c7 d0 e6 a4 81 e8 3a 91 43 00 48 8b 05 f2 f8 96 00 eb 0c <f6> 80 f8 00 00 00 03 75 31 48 8b 00 48 3d 60 e7 a4 81 75 ec eb 
[  129.000015] RIP  [<ffffffff810dee70>] probes_open+0x3b/0xa7
[  129.000015]  RSP <ffff880076e53c38>
[  129.000015] CR2: 00000005000000f9
[  130.555521] ---[ end trace 35f17d68fc569897 ]---

Attached is the program I used. It took lots of tweaks and doesn't
always trigger the bug on the first run. It can take several runs to
trigger. Each bug I've seen has been rather random. Twice it crashed due
to memory errors, once it just screwed up the kprobes, but the system
still ran fine. I had another kprobes error bug, when when I went to do
more tracing, it crashed.

What my program does is creates two threads (well, one thread and the
main thread). They place themselves onto CPU 0 and 1. Then the following
occurs:

	CPU 0			CPU 1
	-----			-----
  create sigprocmask probe

loop:			loop:

			fd = open(events/kprobes/sigprocmask/enable)

			pthread_barrier_wait()

  nanosleep(interval)

  pthread_barrier_wait()

			write(fd, "1", 1);

			write(fd, "0", 1);

  truncate kprobe_events
  // deletes all probes

			pthread_barrier_wait();
  pthread_barrier_wait();


			write(fd, "0", 1); // just in case

  create sigprocmask probe

			pthread_barrier_wait()

  pthread_barrier_wait()

  update interval

  goto loop		goto loop



I had to tweak the interval times to see where it would most likely
cause a race. When I found where it started to conflict, I placed the
range around that time and incremented it in steps related to 7/5
(~e/2). That eventually triggered the bug.

Now with this patch, I had to modify the test to give it a negative
number to place the pause before the write. That's because the switch to
removing the events slowed down the deletion and allowed the write to
always succeed (without the delay).

Anyway, I ran this in a while loop with the patch for an hour (and still
running) and it seems to keep it from crashing.

I'll update the change log to reflect this.

Thanks!

-- Steve


--=-F8j94NH7Sjgg2sZSNJp/
Content-Disposition: attachment; filename="test-kprobe-removal.c"
Content-Type: text/x-csrc; name="test-kprobe-removal.c"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/syscall.h>
#include <fcntl.h>
#include <sched.h>
#include <unistd.h>
#include <pthread.h>

#define gettid() syscall(__NR_gettid)

#define KPROBE_FILE "/debug/tracing/kprobe_events"
#define KPROBE_ENABLE "/debug/tracing/events/kprobes/sigprocmask/enable"
#define PROBE "p:sigprocmask sigprocmask"

#define INTERVALS	1000
#define INTERVAL_START	60000
#define INTERVAL_STOP	92000
#define INTERVAL_STEP	(((INTERVAL_STOP - INTERVAL_START) * 7) / (INTERVALS * 5))

#define nano2sec(nan) (nan / 1000000000ULL)
#define ms2nano(ms) (ms * 1000000ULL)
#define sec2nano(sec) (sec * 1000000000ULL)

static int pause_main = 1;

static unsigned long long interval = INTERVAL_START;

static pthread_barrier_t initiate;
static pthread_barrier_t finish;
static pthread_barrier_t restart;

static int done;

static void *write_it(void *ignore)
{
	struct timespec intv;
	cpu_set_t cpumask;
	int ret;
	int fd;

	CPU_ZERO(&cpumask);
	CPU_SET(1, &cpumask);

	sched_setaffinity(gettid(), sizeof(long), &cpumask);

	while (!done) {
		intv.tv_sec = nano2sec(interval);
		intv.tv_nsec = interval % sec2nano(1);

		fd = open(KPROBE_ENABLE, O_WRONLY);
		if (fd < 0) {
			fprintf(stderr, "Can't open '%s'\n", KPROBE_ENABLE);
			exit(-1);
		}
		pthread_barrier_wait(&initiate);

		if (!pause_main)
			nanosleep(&intv, NULL);
		ret = write(fd, "1", 1);
		if (ret >= 0)
			printf("Enabled event! (%lld)\n", interval);
		write(fd, "0", 1);
		pthread_barrier_wait(&finish);
		write(fd, "0", 1);
		close(fd);
		pthread_barrier_wait(&restart);
	}

	return NULL;
}

static int open_kprobe(int trunc)
{
	int fd;
	int flags = O_WRONLY;

	if (trunc)
		flags |=  O_TRUNC;

	fd = open(KPROBE_FILE, flags);

	return fd;
}

static void create_probe(int fd)
{
	if (write(fd, PROBE, strlen(PROBE)) < 0) {
		fprintf(stderr, "Failed to write to '%s'\n", KPROBE_FILE);
		exit(-1);
	}
}

int main (int argc, char **argv)
{
	struct timespec intv;
	unsigned int intervals = INTERVALS;
	int start = INTERVAL_START;
	unsigned int stop = INTERVAL_STOP;
	unsigned int step = INTERVAL_STEP;
	cpu_set_t cpumask;
	pthread_t writer;
	int ret;
	int fd;
	int i;

	if (argc > 1)
		start = atoi(argv[1]);
	if (argc > 2)
		stop = atoi(argv[2]);
	if (argc > 3)
		intervals = atoi(argv[3]);

	if (start < 0) {
		pause_main = 0;
		start = start * -1;
		printf("PAUSING WRITE\n");
	}

	/* Check for bad input (also 0 skips parameters) */
	if (!start)
		start = INTERVAL_START;
	if (!stop)
		stop = INTERVAL_STOP;
	if (stop < start)
		stop = start + INTERVALS;
	if (!intervals)
		intervals = INTERVALS;

	if (argc > 1) {
		step = (((stop - start) * 7) / (intervals * 5));
		interval = start;
		if (!step)
			step = 1;
	}

	printf("interval:\t%d\n", intervals);
	printf("start:\t%d\n", start);
	printf("stop:\t%d\n", stop);
	printf("step:\t%d\n", step);

	CPU_ZERO(&cpumask);
	CPU_SET(0, &cpumask);

	pthread_barrier_init(&initiate, NULL, 2);
	pthread_barrier_init(&finish, NULL, 2);
	pthread_barrier_init(&restart, NULL, 2);

	fd = open_kprobe(1);
	if (fd < 0) {
		fprintf(stderr, "Can't open '%s'\n", KPROBE_FILE);
		exit(-1);
	}
	create_probe(fd);
	close(fd);

	ret = pthread_create(&writer, NULL, write_it, NULL);
	if (ret < 0)
		exit(-1);

	sched_setaffinity(gettid(), sizeof(long), &cpumask);

	for (i = 0; i < intervals; i++) {
		if (pause_main) {
			intv.tv_sec = nano2sec(interval);
			intv.tv_nsec = interval % sec2nano(1);
		} else {
			intv.tv_sec = 0;
			intv.tv_nsec = 1;
		}

		pthread_barrier_wait(&initiate);
		nanosleep(&intv, NULL);

		while ((fd = open_kprobe(1)) < 0)
		       ;
		pthread_barrier_wait(&finish);
		create_probe(fd);
		close(fd);
		pthread_barrier_wait(&restart);

		interval += step;
		if (interval > stop)
			interval = start + interval - stop;
	}
	done = 1;

	pthread_join(writer, NULL);
	fd = open_kprobe(1);
	close(fd);

	return 0;
}

--=-F8j94NH7Sjgg2sZSNJp/--

