Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757327Ab3DANFj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 09:05:39 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:59030 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492Ab3DANFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 09:05:37 -0400
X-Nat-Received: from [202.181.97.72]:59589 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1364821513.10765
To: tglx@linutronix.de, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, fernando_b1@lab.ntt.co.jp
Subject: Re: [RFC] iowait/idle time accounting hiccups in NOHZ kernels
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201301152014.AAD52192.FOOHQVtSFMFOJL@I-love.SAKURA.ne.jp>
	<alpine.LFD.2.02.1301151313170.7475@ionos>
	<201301180857.r0I8vK7c052791@www262.sakura.ne.jp>
	<1363660703.4993.3.camel@nexus>
In-Reply-To: <1363660703.4993.3.camel@nexus>
Message-Id: <201304012205.DFC60784.HVOMJSFFLFtOOQ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Mon, 1 Apr 2013 22:05:10 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 01042013 #9816358, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fernando Luis V痙quez Cao wrote:
> (Moving discussion to LKML)
> 
> Hi Thomas, Frederic,
> 
> Tetsuo Handa reported that the iowait time obtained through /proc/stat
> is not monotonic.
> 

Hello.

The following instructions are steps for observing this problem.
It is recommended to use a machine with 4 CPUs, for it is difficult to
observe this problem with 2 CPUs.



[Approach 1] Steps for observing this problem from user space.

Compile readstat.c which reports only when this problem occurs

# cc -Wall -O2 -o readstat readstat.c

---------- readstat.c start ----------
#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <poll.h>

#define MAX_CPUS 17

int main(int argc, char *argv[])
{
	const int fd = open("/proc/stat", O_RDONLY);
	static unsigned long long prev[MAX_CPUS][10];
	static unsigned long long cur[10];
	static const char * const array[10] = {
		"user", "nice", "system", "idle", "iowait", "irq", "softirq",
		"steal", "guest", "guest_nice"
	};
	memset(prev, 0, sizeof(prev));
	while (1) {
		static char buffer[1048576];
		char *buf = buffer;
		int i = pread(fd, buffer, sizeof(buffer) - 1, 0);
		if (i <= 0)
			break;
		buffer[i] = '\0';
		for (i = 0; i < MAX_CPUS; i++) {
			char *eol = strchr(buf, '\n');
			int j;
			if (!eol)
				break;
			*eol++ = '\0';
			if (strncmp(buf, "cpu", 3))
				break;
			while (*buf && *buf != ' ')
				buf++;
			memset(cur, 0, sizeof(cur));
			sscanf(buf, "%llu %llu %llu %llu %llu %llu %llu %llu "
			       "%llu %llu", &cur[0], &cur[1], &cur[2], &cur[3],
			       &cur[4], &cur[5], &cur[6], &cur[7], &cur[8],
			       &cur[9]);
			for (j = 0; j < 10; j++) {
				if (prev[i][j] > cur[j])
					printf("cpu[%d].%-10s : "
					       "%llu -> %llu\n", i - 1,
					       array[j], prev[i][j], cur[j]);
				prev[i][j] = cur[j];
			}
			buf = eol;
		}
	}
	return 0;
}
---------- readstat.c end ----------

and run command 1 and command 2 in parallel using two consoles.
We assume that the file written by command 2 is located on a filesystem
on disk devices (e.g. /dev/sda ).

(Command 1) # ./readstat
(Command 2) # dd if=/dev/zero of=/tmp/file bs=10485760 count=1024

You will see output like below.
Depending on situation, cpu[x].idle lines will also be printed.

---------- readstat output start ----------
cpu[-1].iowait     : 72373 -> 72370
cpu[1].iowait     : 21146 -> 21143
cpu[-1].iowait     : 72402 -> 72399
cpu[3].iowait     : 21033 -> 21030
cpu[-1].iowait     : 72502 -> 72499
cpu[1].iowait     : 21196 -> 21193
cpu[-1].iowait     : 72532 -> 72529
cpu[3].iowait     : 21047 -> 21044
cpu[-1].iowait     : 72623 -> 72612
cpu[2].iowait     : 4220 -> 4209
cpu[-1].iowait     : 72696 -> 72680
cpu[1].iowait     : 21269 -> 21253
cpu[2].iowait     : 4227 -> 4226
cpu[1].iowait     : 21290 -> 21289
cpu[-1].iowait     : 72930 -> 72924
cpu[1].iowait     : 21325 -> 21320
---------- readstat output end ----------

If you don't have C compiler installed, you may instead try

# watch -n 0.1 cat /proc/stat

for command 1, though it may be difficult for you to
confirm this problem since the output by watch goes away immediately.

If you don't get output, you can try different workload like

# dd if=/dev/zero of=dump1 bs=1M count=1000 conv=sync & dd if=/dev/zero of=dump2 bs=1M count=1000 conv=sync &

for command 2.



[Approach 2] Steps for observing this problem from kernel space.

Locate iowait/iowait.c and iowait/Makefile at the root directory of
kernel source tree

---------- iowait/iowait.c start ----------
#include <linux/module.h>
#include <linux/sched.h>
#include <linux/tick.h>

static int __init check_init(void)
{
	static u64 last_iowait[NR_CPUS];
	static u64 last_idle[NR_CPUS];
	while (!signal_pending(current)) {
		int i;
		for_each_online_cpu(i) {
			u64 now = get_cpu_iowait_time_us(i, NULL);
			if (last_iowait[i] > now)
				printk(KERN_WARNING "iowait(%d): %llu -> %llu\n", i, last_iowait[i], now);
			last_iowait[i] = now;
			now = get_cpu_idle_time_us(i, NULL);
			if (last_idle[i] > now)
				printk(KERN_WARNING "idle(%d): %llu -> %llu\n", i, last_idle[i], now);
			last_idle[i] = now;
		}
		cond_resched();
	}
	return -EINVAL;
}

module_init(check_init);
MODULE_LICENSE("GPL");
---------- iowait/iowait.c end ----------

---------- iowait/Makefile start ----------
obj-m += iowait.o
---------- iowait/Makefile end ----------

and build iowait/iowait.ko module by

# make SUBDIRS=iowait modules

and run command 3 and command 4 in parallel using two consoles.

(Command 3) # insmod iowait/iowait.ko
(Command 4) # dd if=/dev/zero of=/tmp/file bs=10485760 count=1024

After dd process by command 4 terminates, kill insmod process by command 3
using Ctrl-C and run dmesg command. You will see output like below.

---------- dmesg output start ----------
iowait(1): 356464315 -> 356464314
idle(3): 482443634 -> 482443633
idle(0): 396026944 -> 396026943
idle(0): 396028152 -> 396028151
idle(0): 396029290 -> 396029289
idle(1): 280770309 -> 280770308
iowait(3): 237239882 -> 237239881
iowait(3): 237240830 -> 237240829
idle(1): 280770416 -> 280770415
iowait(3): 237244241 -> 237244240
idle(1): 280770746 -> 280770745
iowait(0): 397554152 -> 397554151
iowait(0): 397556611 -> 397556610
iowait(0): 397558355 -> 397558354
idle(1): 280771891 -> 280771890
idle(0): 396039655 -> 396039654
---------- dmesg output end ----------



> The patch below fixes the problem that the delta becomes negative, but
> this is not enough. Fixing the whole problem properly may require some
> major plumbing so I would like to know your take on this before going
> ahead.

Any ideas on how to handle this problem?

Regards.
