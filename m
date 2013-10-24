Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369Ab3JXPC3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 11:02:29 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:58737 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071Ab3JXPC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 11:02:27 -0400
X-Nat-Received: from [202.181.97.72]:52416 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1382626945.920
To: linux-kernel@vger.kernel.org
Subject: [RFC] A logger specialized for receiving from netconsole.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <201310250002.FJI86420.FQHSLFOOOtMJVF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Fri, 25 Oct 2013 00:02:20 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 24102013 #10976307, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Background:

  When troubleshooting system freeze problems, obtaining SysRq messages
  is commonly used. However, sometimes it is impossible to let syslog
  daemon save the messages. In that case, serial console can be used.

  However, in already-deployed enterprise servers, it is difficult to
  reboot the system in order to add the serial console to the list of
  consoles. Also, speak of virtualized servers in the cloud environment,
  it may be difficult to add the virtual serial console which would
  require FTP-like access to the log files saved on the virtualization
  host.

  As I'm working at NTT Open Source Software Center, I'm having
  difficulties with obtaining SysRq messages from already-deployed
  RHEL 3/4/5/6 servers where the serial console is not attached yet.

  I started to consider utilizing the netconsole kernel module which
  can be used without rebooting the system and can be used without access
  to the virtualization host.

  It would be easy to configure the sender side; just load the netconsole
  kernel module with appropriate arguments. However, it is not always easy
  to configure the receiver side.

  Basically, syslog daemon would be able to receive traffic from netconsole
  (e.g. rsyslog can do it by creating a configuration file and restarting
  the rsyslog daemon), there are a few problems.

  ---------- An example /etc/rsyslog.d/netconsole.conf start ----------
  $template NetconsoleFile,"/var/log/netconsole.log"
  $template NetconsoleFormat,"%rawmsg%"
  
  $EscapeControlCharactersOnReceive off
  $DropTrailingLFOnReception off
  
  $RuleSet NetconsoleRuleset
  *.* ?NetconsoleFile;NetconsoleFormat
  $RuleSet RSYSLOG_DefaultRuleset
  
  $ModLoad imudp
  $InputUDPServerBindRuleset NetconsoleRuleset
  $UDPServerRun 6666
  ---------- An example /etc/rsyslog.d/netconsole.conf end ----------

  Problem 1:

  The messages from netconsole is not in the form of syslog format.
  Therefore, syslog daemon cannot assume that there is hostname and/or
  timestamp in the received message, which results in use of %rawmsg%
  format.

  ---------- An example log start ----------
  SysRq : HELP : loglevel(0-9) reBoot Crash terminate-all-tasks(E) memory-full-oom-kill(F) kill-all-tasks(I) thaw-filesystems(J) saK show-backtrace-all-active-cpus(L) \
  show-memory-usage(M) nice-all-RT-tasks(N) powerOff show-registers(P) show-all-timers(Q) unRaw Sync show-task-states(T) Unmount show-blocked-tasks(W) dump-ftrace-buffer(Z)
  ---------- An example log end ----------

  Problem 2:

  On the other hand, in order to determine when a problem occurred, it is
  important that hostname and timestamp are recorded with the messages
  received. Although changing from

    $template NetconsoleFormat,"%rawmsg%"

  to

    $template NetconsoleFormat,"[%timegenerated% %fromhost-ip%] %rawmsg%"

  would record a sort of hostname and timestamp, this format sometimes
  emits unnecessary [ ... ] part because a line of message can be received
  as a several UDP packets. The [ ... ] part should be emitted only once
  per a line.

  ---------- An example log start ----------
  [Oct 23 21:49:19 192.168.0.5] SysRq : [Oct 23 21:49:19 192.168.0.5] HELP : [Oct 23 21:49:19 192.168.0.5] loglevel(0-9) [Oct 23 21:49:19 192.168.0.5] reBoot \
  [Oct 23 21:49:19 192.168.0.5] Crash [Oct 23 21:49:19 192.168.0.5] terminate-all-tasks(E) [Oct 23 21:49:19 192.168.0.5] memory-full-oom-kill(F) \
  [Oct 23 21:49:19 192.168.0.5] kill-all-tasks(I) [Oct 23 21:49:19 192.168.0.5] thaw-filesystems(J) [Oct 23 21:49:19 192.168.0.5] saK \
  [Oct 23 21:49:19 192.168.0.5] show-backtrace-all-active-cpus(L) [Oct 23 21:49:19 192.168.0.5] show-memory-usage(M) [Oct 23 21:49:19 192.168.0.5] \
  nice-all-RT-tasks(N) [Oct 23 21:49:19 192.168.0.5] powerOff [Oct 23 21:49:19 192.168.0.5] show-registers(P) [Oct 23 21:49:19 192.168.0.5] show-all-timers(Q) \
  [Oct 23 21:49:19 192.168.0.5] unRaw [Oct 23 21:49:19 192.168.0.5] Sync [Oct 23 21:49:19 192.168.0.5] show-task-states(T) [Oct 23 21:49:19 192.168.0.5] \
  Unmount [Oct 23 21:49:19 192.168.0.5] show-blocked-tasks(W) [Oct 23 21:49:19 192.168.0.5] dump-ftrace-buffer(Z) [Oct 23 21:49:19 192.168.0.5]
  ---------- An example log end ----------

  Problem 3:

  SysRq-T tends to generate a lot of messages. If the receiver's buffer
  size is not configurable, the receiver program might drop many of lines.

  Speak of my targeted servers, buffer size is not configurable; but
  upgrading the rsyslog daemon to a version which is not supported by the
  distributor in order to enlarge the buffer size will be unacceptable.

  ---------- An example log start ----------
  [Oct 23 21:52:52 192.168.0.5] SysRq : [Oct 23 21:52:52 192.168.0.5] Show State
  [Oct 23 21:52:52 192.168.0.5]   task                        PC stack   pid father
  [Oct 23 21:52:52 192.168.0.5] init          S[Oct 23 21:52:52 192.168.0.5]  0000000000000001 [Oct 23 21:52:52 192.168.0.5]     0     1      0 0x00000000
  (...snipped...)
  [Oct 23 21:52:53 192.168.0.5] md_misc/1     S[Oct 23 21:52:53 192.168.0.5]  0000000000000001 [Oct 23 21:52:53 192.168.0.5]     0    36      2 0x00000000
  [Oct 23 21:52:53 192.168.0.5]  ffff88001d0fde30[Oct 23 21:52:53 192.168.0.5]  0000000000000046[Oct 23 21:52:53 192.168.0.5]  0000000000000000[Oct 23 21:52:53 192.168.0.5]  ffff880002296768[Oct 23 21:52:53 192.168.0.5]
  [Oct 23 21:52:53 192.168.0.5]  0000000000000001[Oct 23 21:52:53 192.168.0.5]  ffff880002296700[Oct 23 21:52:53 192.168.0.5]  ffff88001d0fdde0[Oct 23 21:52:53 192.168.0.5]  ffffffff8106669b[Oct 23 21:52:53 192.168.0.5]
  [Oct 23 21:52:53 192.168.0.5]  ffff88001d0fbab8[Oct 23 21:52:53 192.168.0.5]  ffff88001d0fdfd8[Oct 23 21:52:53 192.168.0.5]  000000000000fb88[Oct 23 21:52:53 192.168.0.5]  ffff88001d0fbab8[Oct 23 21:52:53 192.168.0.5]
  [Oct 23 21:52:53 192.168.0.5] Call Trace:
  [Oct 23 21:52:53 192.168.0.5]  [<ffffffff8106669b>] ? dequeue_task_fair+0x12b/0x130
  [Oct 23 21:52:53 192.168.0.5]  [<ffffffff8109708e>] ? prepare_to_wait+0x4e/0x80
  [Oct 23 21:52:53 192.168.0.5]  [<ffffffff81090a70>] ? worker_thread+0x0/0x2a0
  [Oct 23 21:52:53 192.168.0.5]  [<ffffffff81090c6c>] worker_thread+0x1fc/0x2a0
  (...oops, all subsequent lines are dropped due to burst...)
  ---------- An example log end ----------

What I did:

  I thought that developing a standalone, trivial logger which is
  dedicated for receiving traffic from netconsole.

  I wrote one and would like to share it with you. Comments are welcome.

Features:

  This utility records timestamp and source IP:port in front of each line,
  allowing you to monitor multiple servers with single log file.
  You can easily pick up specific server's messages using awk(1).

  This utility automatically switches the log file if the latest log
  crosses the midnight, allowing you to rotate log files without
  restarting this utility.

  This utility waits for the newline of each message, allowing you to
  record messages without emitting unnecessary timestamp and IP:port.

  This utility uses larger receive buffer, allowing you to catch
  burst messages like SysRq-T.

  This utility can be run as an unprivileged user provided that the
  receive buffer size is sufficient.

  ---------- An example log start ----------
  2013-10-23 21:54:45 192.168.0.5:6666 SysRq : Show State
  2013-10-23 21:54:45 192.168.0.5:6666   task                        PC stack   pid father
  2013-10-23 21:54:45 192.168.0.5:6666 init          S 0000000000000001     0     1      0 0x00000000
  2013-10-23 21:54:45 192.168.0.5:6666  ffff88001d4a7908 0000000000000082 ffff88001b332cf8 ffff88001db75b38
  2013-10-23 21:54:45 192.168.0.5:6666  0000000000000000 ffff88001b3d9558 ffff88001d4a7958 ffffffffa029f1b4
  2013-10-23 21:54:45 192.168.0.5:6666  ffff88001d4a5ab8 ffff88001d4a7fd8 000000000000fb88 ffff88001d4a5ab8
  2013-10-23 21:54:45 192.168.0.5:6666 Call Trace:
  2013-10-23 21:54:45 192.168.0.5:6666  [<ffffffffa029f1b4>] ? do_get_write_access+0x3b4/0x520 [jbd2]
  2013-10-23 21:54:45 192.168.0.5:6666  [<ffffffff8112a3b1>] ? get_page_from_freelist+0x3d1/0x830
  2013-10-23 21:54:45 192.168.0.5:6666  [<ffffffff8150fb2d>] schedule_hrtimeout_range+0x13d/0x160
  2013-10-23 21:54:45 192.168.0.5:6666  [<ffffffff81097106>] ? add_wait_queue+0x46/0x60
  2013-10-23 21:54:45 192.168.0.5:6666  [<ffffffff811975f5>] ? __pollwait+0x75/0xf0
  2013-10-23 21:54:45 192.168.0.5:6666  [<ffffffff811975f5>] ? __pollwait+0x75/0xf0
  2013-10-23 21:54:45 192.168.0.5:6666  [<ffffffff81197489>] poll_schedule_timeout+0x39/0x60
  2013-10-23 21:54:45 192.168.0.5:6666  [<ffffffff8119854c>] do_select+0x57c/0x6c0
  2013-10-23 21:54:45 192.168.0.5:6666  [<ffffffff81197580>] ? __pollwait+0x0/0xf0
  2013-10-23 21:54:45 192.168.0.5:6666  [<ffffffff81197670>] ? pollwake+0x0/0x60
  2013-10-23 21:54:45 192.168.0.5:6666  [<ffffffff81197670>] ? pollwake+0x0/0x60
  2013-10-23 21:54:45 192.168.0.5:6666  [<ffffffff81197670>] ? pollwake+0x0/0x60
  2013-10-23 21:54:45 192.168.0.5:6666  [<ffffffff81197670>] ? pollwake+0x0/0x60
  2013-10-23 21:54:45 192.168.0.5:6666  [<ffffffff81142db3>] ? do_wp_page+0x493/0x920
  2013-10-23 21:54:45 192.168.0.5:6666  [<ffffffff81075887>] ? current_fs_time+0x27/0x30
  2013-10-23 21:54:45 192.168.0.5:6666  [<ffffffff81143a3d>] ? handle_pte_fault+0x2cd/0xb50
  2013-10-23 21:54:45 192.168.0.5:6666  [<ffffffff8150f61e>] ? mutex_lock+0x1e/0x50
  2013-10-23 21:54:45 192.168.0.5:6666  [<ffffffff8118c207>] ? pipe_read+0x2a7/0x4e0
  2013-10-23 21:54:45 192.168.0.5:6666  [<ffffffff8119881a>] core_sys_select+0x18a/0x2c0
  2013-10-23 21:54:45 192.168.0.5:6666  [<ffffffff8121c356>] ? security_task_wait+0x16/0x20
  2013-10-23 21:54:45 192.168.0.5:6666  [<ffffffff81071e2d>] ? wait_consider_task+0x9d/0xb20
  2013-10-23 21:54:45 192.168.0.5:6666  [<ffffffff8109715c>] ? remove_wait_queue+0x3c/0x50
  2013-10-23 21:54:45 192.168.0.5:6666  [<ffffffff81072a2f>] ? do_wait+0x17f/0x240
  2013-10-23 21:54:45 192.168.0.5:6666  [<ffffffff81198ba7>] sys_select+0x47/0x110
  2013-10-23 21:54:45 192.168.0.5:6666  [<ffffffff81071130>] ? child_wait_callback+0x0/0x70
  2013-10-23 21:54:45 192.168.0.5:6666  [<ffffffff8100b072>] system_call_fastpath+0x16/0x1b
  (...snipped...)
  2013-10-23 21:54:48 192.168.0.5:6666 runnable tasks:
  2013-10-23 21:54:48 192.168.0.5:6666             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
  2013-10-23 21:54:48 192.168.0.5:6666 ----------------------------------------------------------------------------------------------------------
  2013-10-23 21:54:48 192.168.0.5:6666
  (...OK. all lines are recorded...)
  ---------- An example log end ----------

How to use:

  Just compile the source code shown below and run the program. This
  program would run on any 2.4.x/2.6.x/3.x kernels with default libc.

    [root@localhost ~]# ./udplogger
    Started at 2013-10-23 21:54:38 from /root/2013-10-23.log
    Options: ip=0.0.0.0 port=6666 dir=/root timeout=10 clients=1024 wbuf=65536 rbuf=16777216

  All parameters has a default value; log file is by default created in the
  current directory; you need to specify only parameters you want to
  override.

  You can test the reachability using "echo h > /proc/sysrq-trigger" from
  the sender side. Be sure to update the iptables rules as needed. ;-)

Source code: (Total 409 lines)

---------- udplogger.c start ----------
/*
 * Simple UDP logger - A utility for receiving output from netconsole.
 *
 *    Written by Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
 */
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>
#include <poll.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#define round_up(size) ((((size) + 4095u) / 4096u) * 4096u)

/* Structure for tracking partially received data. */
static struct client {
	struct sockaddr_in addr; /* Sender's IPv4 address and port. */
	char *buffer; /* Buffer for holding received data. */
	int avail; /* Valid bytes in @buffer . */
	char addr_str[24]; /* String representation of @addr . */
	time_t stamp; /* Timestamp of receiving the first byte in @buffer . */
} *clients = NULL;

/* Current clients. */
static int num_clients = 0;
/* Max clients. */
static int max_clients = 1024;
/* Max write buffer per a client. */
static int wbuf_size = 65536;
/* Max seconds to wait for new line. */
static int wait_timeout = 10;
/* Try to release unused memory? */
static _Bool try_drop_memory_usage = 0;
/* Name of today's log file. */
static char filename[16] = { };
/* Handle for today's log file. */
static FILE *log_fp = NULL;
/* Previous time. */
static struct tm last_tm = { .tm_year = 70, .tm_mday = 1 };

/**
 * switch_logfile - Close yesterday's log file and open today's log file.
 *
 * @tm: Pointer to "struct tm" holding current time.
 *
 * Returns nothing.
 */
static void switch_logfile(struct tm *tm)
{
	FILE *fp = log_fp;
	snprintf(filename, sizeof(filename) - 1, "%04u-%02u-%02u.log",
		 tm->tm_year + 1900, tm->tm_mon + 1, tm->tm_mday);
	log_fp = fopen(filename, "a");
	if (!fp)
		return;
	/* If open() failed, continue using old one. */
	if (log_fp)
		fclose(fp);
	else
		log_fp = fp;
	try_drop_memory_usage = 1;
}

/**
 * write_logfile - Write to today's log file.
 *
 * @ptr:    Pointer to "struct client".
 * @forced: True if the partial line should be written.
 *
 * Returns nothing.
 */
static void write_logfile(struct client *ptr, const _Bool forced)
{
	static time_t last_time = 0;
	static char stamp[24] = { };
	char *buffer = ptr->buffer;
	int avail = ptr->avail;
	const time_t now_time = ptr->stamp;
	if (last_time != now_time) {
		struct tm *tm = localtime(&now_time);
		if (!tm)
			tm = &last_tm;
		snprintf(stamp, sizeof(stamp) - 1, "%04u-%02u-%02u "
			 "%02u:%02u:%02u ", tm->tm_year + 1900, tm->tm_mon + 1,
			 tm->tm_mday, tm->tm_hour, tm->tm_min, tm->tm_sec);
		/*
		 * Switch log file if the day has changed. We can't use
		 * (last_time / 86400 != now_time / 86400) in order to allow
		 * switching at 00:00:00 of the local time.
		 */
		if (tm->tm_mday != last_tm.tm_mday ||
		    tm->tm_mon != last_tm.tm_mon ||
		    tm->tm_year != last_tm.tm_year) {
			last_tm = *tm;
			switch_logfile(tm);
		}
		last_time = now_time;
	}
	/* Write the completed lines. */
	while (1) {
		char *cp = memchr(buffer, '\n', avail);
		const int len = cp - buffer + 1;
		if (!cp)
			break;
		fprintf(log_fp, "%s%s", stamp, ptr->addr_str);
		fwrite(buffer, 1, len, log_fp);
		avail -= len;
		buffer += len;
	}
	/* Write the incomplete line if forced. */
	if (forced && avail) {
		fprintf(log_fp, "%s%s", stamp, ptr->addr_str);
		fwrite(buffer, 1, avail, log_fp);
		fprintf(log_fp, "\n");
		avail = 0;
	}
	/* Discard the written data. */
	if (ptr->buffer != buffer)
		memmove(ptr->buffer, buffer, avail);
	ptr->avail = avail;
}

/**
 * drop_memory_usage - Try to reduce memory usage.
 *
 * Returns nothing.
 */
static void drop_memory_usage(void)
{
	struct client *ptr;
	int i = 0;
	if (!try_drop_memory_usage)
		return;
	try_drop_memory_usage = 0;
	while (i < num_clients) {
		ptr = &clients[i];
		if (ptr->avail) {
			char *tmp = realloc(ptr->buffer, round_up(ptr->avail));
			if (tmp)
				ptr->buffer = tmp;
			i++;
			continue;
		}
		free(ptr->buffer);
		num_clients--;
		memmove(ptr, ptr + 1, (num_clients - i) * sizeof(*ptr));
	}
	if (num_clients) {
		ptr = realloc(clients, round_up(sizeof(*ptr) * num_clients));
		if (ptr)
			clients = ptr;
	} else {
		free(clients);
		clients = NULL;
	}
}

/**
 * flush_all_and_abort - Clean up upon out of memory.
 *
 * This function does not return.
 */
static void flush_all_and_abort(void)
{
	int i;
	for (i = 0; i < num_clients; i++)
		if (clients[i].avail) {
			write_logfile(&clients[i], 1);
			free(clients[i].buffer);
		}
	fprintf(log_fp, "[aborted due to memory allocation failure]\n");
	fflush(log_fp);
	exit(1);
}

/**
 * find_client - Find the structure for given address.
 *
 * @addr: Pointer to "struct sockaddr_in".
 *
 * Returns "struct client" for @addr on success, NULL otherwise.
 */
static struct client *find_client(struct sockaddr_in *addr)
{
	struct client *ptr;
	int i;
	for (i = 0; i < num_clients; i++)
		if (!memcmp(&clients[i].addr, addr, sizeof(*addr)))
			return &clients[i];
	if (i >= max_clients) {
		try_drop_memory_usage = 1;
		drop_memory_usage();
		if (i >= max_clients)
			return NULL;
	}
	ptr = realloc(clients, round_up(sizeof(*ptr) * (num_clients + 1)));
	if (!ptr)
		return NULL;
	clients = ptr;
	ptr = &clients[num_clients++];
	memset(ptr, 0, sizeof(*ptr));
	ptr->addr = *addr;
	snprintf(ptr->addr_str, sizeof(ptr->addr_str) - 1, "%s:%u ",
		 inet_ntoa(addr->sin_addr), htons(addr->sin_port));
	return ptr;
}

/**
 * do_main - The main loop.
 *
 * @fd: Receiver socket's file descriptor.
 *
 * Returns nothing.
 */
static void do_main(const int fd)
{
	static char buf[65536];
	struct sockaddr_in addr;
	while (1) {
		struct pollfd pfd = { fd, POLLIN, 0 };
		socklen_t size = sizeof(addr);
		int i;
		time_t now;
		/* Don't wait forever if checking for timeout. */
		for (i = 0; i < num_clients; i++)
			if (clients[i].avail)
				break;
		/* Flush log file and wait for data. */
		fflush(log_fp);
		poll(&pfd, 1, i < num_clients ? 1000 : -1);
		now = time(NULL);
		/* Check for timeout. */
		for (i = 0; i < num_clients; i++)
			if (clients[i].avail &&
			    now - clients[i].stamp >= wait_timeout)
				write_logfile(&clients[i], 1);
		/* Don't receive forever in order to check for timeout. */
		while (now == time(NULL)) {
			struct client *ptr;
			char *tmp;
			int len = recvfrom(fd, buf, sizeof(buf), MSG_DONTWAIT,
					   (struct sockaddr *) &addr, &size);
			if (len <= 0 || size != sizeof(addr))
				break;
			ptr = find_client(&addr);
			if (!ptr)
				continue;
			/* Save current time if receiving the first byte. */
			if (!ptr->avail)
				ptr->stamp = now;
			/* Append data to the line. */
			tmp = realloc(ptr->buffer, round_up(ptr->avail + len));
			if (!tmp)
				flush_all_and_abort();
			memmove(tmp + ptr->avail, buf, len);
			ptr->avail += len;
			ptr->buffer = tmp;
			/* Write if at least one line completed. */
			if (memchr(buf, '\n', len))
				write_logfile(ptr, 0);
			/* Write if the line is too long. */
			if (ptr->avail >= wbuf_size)
				write_logfile(ptr, 1);
		}
		drop_memory_usage();
	}
}

/**
 * usage - Print usage and exit.
 *
 * @name: Program's name.
 *
 * This function does not return.
 */
static void usage(const char *name)
{
	fprintf(stderr, "Simple UDP logger\n\n"
		"Usage:\n  %s [ip=$listen_ip] [port=$listen_port] "
		"[dir=$log_dir] [timeout=$seconds_waiting_for_newline] "
		"[clients=$max_clients] [wbuf=$write_buffer_size] "
		"[rbuf=$receive_buffer_size]\n\n"
		"The value of $seconds_waiting_for_newline should be between "
		"5 and 600.\nThe value of $max_clients should be between 10 "
		"and 65536.\nThe value of $write_buffer_size should be "
		"between 1024 and 1048576.\nThe value of $receive_buffer_size "
		"should be 65536 and 1073741824 (though actual size might be "
		"adjusted by the kernel).\n", name);
	exit (1);
}

/**
 * do_init - Initialization function.
 *
 * @argc: Number of arguments.
 * @argv: Arguments.
 *
 * Returns the listener socket's file descriptor.
 */
static int do_init(int argc, char *argv[])
{
	struct sockaddr_in addr = { };
	char pwd[4096];
	/* Max receive buffer size. */
	int rbuf_size = 8 * 1048576;
	socklen_t size;
	int fd;
	int i;
	/* Directory to save logs. */
	const char *log_dir = ".";
	addr.sin_family = AF_INET;
	addr.sin_addr.s_addr = htonl(INADDR_ANY);
	addr.sin_port = htons(6666);
	for (i = 1; i < argc; i++) {
		char *arg = argv[i];
		if (!strncmp(arg, "ip=", 3))
			addr.sin_addr.s_addr = inet_addr(arg + 3);
		else if (!strncmp(arg, "port=", 5))
			addr.sin_port = htons(atoi(arg + 5));
		else if (!strncmp(arg, "dir=", 4))
			log_dir = arg + 4;
		else if (!strncmp(arg, "timeout=", 8))
			wait_timeout = atoi(arg + 8);
		else if (!strncmp(arg, "clients=", 8))
			max_clients = atoi(arg + 8);
		else if (!strncmp(arg, "wbuf=", 5))
			wbuf_size = atoi(arg + 5);
		else if (!strncmp(arg, "rbuf=", 5))
			rbuf_size = atoi(arg + 5);
		else
			usage(argv[0]);
	}
	/* Sanity check. */
	if (max_clients < 10)
		max_clients = 10;
	if (max_clients > 65536)
		max_clients = 65536;
	if (wait_timeout < 5)
		wait_timeout = 5;
	if (wait_timeout > 600)
		wait_timeout = 600;
	if (wbuf_size < 1024)
		wbuf_size = 1024;
	if (wbuf_size > 1048576)
		wbuf_size = 1048576;
	if (rbuf_size < 65536)
		rbuf_size = 65536;
	if (rbuf_size > 1024 * 1048576)
		rbuf_size = 1024 * 1048576;
	/* Create the listener socket and configure it. */
	fd = socket(AF_INET, SOCK_DGRAM, 0);
#ifdef SO_RCVBUFFORCE
	if (setsockopt(fd, SOL_SOCKET, SO_RCVBUFFORCE, &rbuf_size,
		       sizeof(rbuf_size))) {
#endif
		if (setsockopt(fd, SOL_SOCKET, SO_RCVBUF, &rbuf_size,
			       sizeof(rbuf_size))) {
			fprintf(stderr, "Can't set receive buffer size.\n");
			exit(1);
		}
#ifdef SO_RCVBUFFORCE
	}
#endif
	size = sizeof(rbuf_size);
	if (getsockopt(fd, SOL_SOCKET, SO_RCVBUF, &rbuf_size, &size)) {
		fprintf(stderr, "Can't get receive buffer size.\n");
		exit(1);
	}
	size = sizeof(addr);
	if (bind(fd, (struct sockaddr *) &addr, sizeof(addr)) ||
	    getsockname(fd, (struct sockaddr *) &addr, &size) ||
	    size != sizeof(addr)) {
		fprintf(stderr, "Can't bind to %s:%u .\n",
			inet_ntoa(addr.sin_addr), htons(addr.sin_port));
		exit(1);
	}
	/* Open the initial log file. */
	memset(pwd, 0, sizeof(pwd));
	if (chdir(log_dir) || !getcwd(pwd, sizeof(pwd) - 1)) {
		fprintf(stderr, "Can't change directory to %s .\n", log_dir);
		exit(1);
	} else {
		const time_t now = time(NULL);
		struct tm *tm = localtime(&now);
		if (!tm)
			tm = &last_tm;
		switch_logfile(tm);
		if (!log_fp) {
			fprintf(stderr, "Can't create log file.\n");
			exit(1);
		}
		printf("Started at %04u-%02u-%02u %02u:%02u:%02u from %s/%s\n",
		       tm->tm_year + 1900, tm->tm_mon + 1, tm->tm_mday,
		       tm->tm_hour, tm->tm_min, tm->tm_sec, pwd, filename);
	}
	/* Successfully initialized. */
	printf("Options: ip=%s port=%u dir=%s timeout=%u clients=%u wbuf=%u "
	       "rbuf=%u\n", inet_ntoa(addr.sin_addr), htons(addr.sin_port),
	       pwd, wait_timeout, max_clients, wbuf_size, rbuf_size);
	return fd;
}

int main(int argc, char *argv[])
{
	const int fd = do_init(argc, argv);
	do_main(fd);
	return 0;
}
---------- udplogger.c end ----------
