Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934605AbaEFJXL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 05:23:11 -0400
Received: from smtp23.services.sfr.fr ([93.17.128.22]:20955 "EHLO
	smtp23.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934441AbaEFJXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 05:23:07 -0400
Authentication-Results: sfrmc.priv.atos.fr; dkim=none (no signature);
	dkim-adsp=none (no policy) header.from=mpeg.blue@free.fr
X-SFR-UUID: 20140506092302870.D477F70000B1@msfrf2317.sfr.fr
Message-ID: <5368A9F8.2070609@free.fr>
Date: Tue, 06 May 2014 11:23:04 +0200
From: Mason <mpeg.blue@free.fr>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:29.0) Gecko/20100101
	Firefox/29.0 SeaMonkey/2.26
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-embedded@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Using ftrace to identify source of excessive latency of USB
 write
References: <535D57CF.50402@free.fr>
In-Reply-To: <535D57CF.50402@free.fr>
Content-Type: multipart/mixed; boundary=------------040806010603070106000000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040806010603070106000000
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit

Mason wrote:

> I'm using Linux on a embedded system similar in spec to a desktop PC
> from 15 years ago (256 MB RAM, 800-MHz CPU, USB). The system's primary
> use is recording high-definition digital television programs.
> 
> Typically, the storage sub-system consists of a recent hard-disk drive
> connected over USB (Hi-Speed, effective throughput ~20-30 MB/s), using
> a single ext4 partition (journal disabled), mounted noexec+noatime
> (trying to minimize metadata interference).
> 
> Typical bit-rate for this HD content ~1-3 MB/s
> 
> Data is accumulated in two 800-kB buffers; when one buffer is full,
> it is written to file (using write(2)), which was opened O_SYNC.
> (Note to self: try O_DSYNC instead of O_SYNC)
> 
> If I plot the latency of the write(2) operation, 99% of them complete
> in under 80 ms. However, in rare cases, there is a huge latency spike
> (up to 800 ms). If several of these rare outliers occur in a row,
> the recording is messed up.
> 
> I am trying to figure out the source of these latency spikes.
> 
> It could be the OS, the USB controller, the HDD controller... I was
> hoping I could use ftrace to determine whether the problem came from
> the OS itself. Is that the best tool for the job?
> 
> Any recommendations on how to proceed?

A few people suggested other tools, which I'll give a try; but
I wanted to share my current measurements, in case someone sees
something obvious I am missing.

First of all, I'm using kernel 3.1.10 with "vendor patches"
(which may or may not alter performance and/or behavior).

I wrote a simple test app (attached) which times and ftraces a
single synchronized write of 786432 bytes.

The program reported a latency of 275 ms for the operation
(run in SCHED_FIFO -50 on an otherwise idle system)

I used a USB analyzer to "spy" on the bus during the transaction.

According to my analyzer, the data write was split into 7 transactions
(6*122880 + 49512)

- The first write command  was issued at 18.307930
- The first write transaction started at 18.310230
- The first write transaction   ended at 18.313567
(3337 µs to transfer 122880 bytes, i.e. 36.8 MB/s)
- The  last write transaction   ended at 18.368911
(58681 µs to transfer 786432 bytes, i.e. 13.4 MB/s not great, but OK)
- Then one more write (4096 bytes, metadata probably) ending at 18.374458

=> so, from the perspective of the bus, the entire transaction
took 66.5 ms, yet from the perspective of the OS, it took 275 ms.

I've attached the (xz compressed) ftrace (trace.one.xz)

If I'm reading the trace right (which is unlikely) the system spent
64 ms in __filemap_fdatawrite_range
(which is close to the "actual" latency of the bus transactions)
212 ms (??) in schedule

 0)               |  schedule() {
 0)               |    __schedule() {
 0)               |      add_preempt_count() {
 0)   0.000 us    |      } /* add_preempt_count */
 0)               |      rcu_note_context_switch() {
 0)   0.000 us    |      } /* rcu_note_context_switch */
 0)               |      _raw_spin_lock_irq() {
 0)               |        add_preempt_count() {
 0)   0.000 us    |        } /* add_preempt_count */
 0)   0.000 us    |      } /* _raw_spin_lock_irq */
 0)               |      put_prev_task_idle() {
 0)   0.000 us    |      } /* put_prev_task_idle */
 0)               |      pick_next_task_fair() {
 0)   0.000 us    |      } /* pick_next_task_fair */
 0)               |      pick_next_task_stop() {
 0)   0.000 us    |      } /* pick_next_task_stop */
 0)               |      pick_next_task_rt() {
 0)   0.000 us    |      } /* pick_next_task_rt */
 0)               |      pick_next_task_fair() {
 0)   0.000 us    |      } /* pick_next_task_fair */
 0)               |      pick_next_task_idle() {
 0)   0.000 us    |      } /* pick_next_task_idle */
 0)               |      _raw_spin_unlock_irq() {
 0)               |        sub_preempt_count() {
 0)   0.000 us    |        } /* sub_preempt_count */
 0)   0.000 us    |      } /* _raw_spin_unlock_irq */
 0)               |      sub_preempt_count() {
 0)   0.000 us    |      } /* sub_preempt_count */
 0)   0.000 us    |    } /* __schedule */
 0) ! 212000.0 us |  } /* schedule */

Am I reading this right? 212 ms doing nothing?

212+64 is close to the 275 reported by my application.

How can I "drill down" to understand what is happening
inside schedule?

[I would be grateful if you could CC me in your replies. Thanks!]

-- 
Regards.


--------------040806010603070106000000
Content-Type: text/plain; charset=windows-1252;
 name="bench2.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="bench2.c"

#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#include <unistd.h>
#include <fcntl.h>
#include <sched.h>
#include <time.h>

#define ENABLE_TRACING 1
#define BUFSIZE (192 << 12)

static void clear_trace(void)
{
#if ENABLE_TRACING
  int fd = open("/sys/kernel/debug/tracing/trace", O_WRONLY);
  if (fd < 0) perror("open trace");

  int res = write(fd, &fd, sizeof fd);
  if (res != sizeof fd) perror("clear trace");

  close(fd);
#endif
}

static void dump_trace(char *save)
{
#if ENABLE_TRACING
  int fd = open("/sys/kernel/debug/tracing/trace", O_RDONLY);
  if (fd < 0) perror("open trace");

  int fd_out = open(save, O_WRONLY | O_CREAT | O_TRUNC, 0600);
  if (fd_out < 0) perror("open save");
  while ( 1 )
  {
    char buf[8000];
    int res = read(fd, buf, sizeof buf);
    if (res <= 0) break;
    write(fd_out, buf, res);
  }
  close(fd_out); close(fd);
#endif
}

static void toggle_tracing(char val)
{
  (void)val;
#if ENABLE_TRACING
  int fd = open("/sys/kernel/debug/tracing/tracing_on", O_WRONLY);
  if (fd < 0) perror("open toggle");

  int res = write(fd, &val, 1);
  if (res != 1) perror(__func__);
  close(fd);
#endif
}

static int64_t now(void)
{
  struct timespec spec;
  clock_gettime(CLOCK_MONOTONIC, &spec);
  return spec.tv_sec*1000000000LL + spec.tv_nsec;
}

int main(void)
{
  struct sched_param param = { .sched_priority = 50 };
  int err = sched_setscheduler(0, SCHED_FIFO, &param);
  printf("sched_setscheduler=%d\n", err);

  char *buf = malloc(BUFSIZE);
  if (buf == NULL) return 2;
  memset(buf, '+', BUFSIZE);

  int flags = O_WRONLY | O_CREAT | O_TRUNC | O_SYNC;
  int fd = open("foob", flags, 0600);
  if (fd < 0) return 3;

  clear_trace();
  strcpy(buf, "WARM UP");
  write(fd, buf, 4096);
  strcpy(buf, "SHOW TIME");

  int64_t t0 = now();
  toggle_tracing('1');
  write(fd, buf, BUFSIZE);
  toggle_tracing('0');
  int64_t t1 = now();

  close(fd);
  printf("LAT = %9lld\n", t1-t0);
  dump_trace("/tmp/trace.one");
  return 0;
}

--------------040806010603070106000000
Content-Type: application/octet-stream;
 name="trace.one.xz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="trace.one.xz"

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
rqcBjKirAQAAAJEWF0QUFzswAwAAAAAEWVo=
--------------040806010603070106000000--
