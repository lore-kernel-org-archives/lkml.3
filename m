Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757748Ab3CULeP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 07:34:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56686 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307Ab3CULeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 07:34:14 -0400
Date: Thu, 21 Mar 2013 04:32:26 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-f3ff40ec8d92b36e60ebbbdb604ffeb5cfe6545f@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, fweisbec@gmail.com,
        rostedt@goodmis.org, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, fweisbec@gmail.com,
        rostedt@goodmis.org, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1363173585-9754-2-git-send-email-namhyung@kernel.org>
References: <1363173585-9754-2-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Remove unused trace_read_data function
Git-Commit-ID: f3ff40ec8d92b36e60ebbbdb604ffeb5cfe6545f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 21 Mar 2013 04:32:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f3ff40ec8d92b36e60ebbbdb604ffeb5cfe6545f
Gitweb:     http://git.kernel.org/tip/f3ff40ec8d92b36e60ebbbdb604ffeb5cfe6545f
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Wed, 13 Mar 2013 20:19:40 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 15 Mar 2013 13:06:08 -0300

perf tools: Remove unused trace_read_data function

And functions that called only from the trace_read_data().

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1363173585-9754-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/trace-event-read.c | 201 -------------------------------------
 1 file changed, 201 deletions(-)

diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
index 3741572..7cb2463 100644
--- a/tools/perf/util/trace-event-read.c
+++ b/tools/perf/util/trace-event-read.c
@@ -41,8 +41,6 @@
 
 static int input_fd;
 
-static int read_page;
-
 int file_bigendian;
 int host_bigendian;
 static int long_size;
@@ -287,205 +285,6 @@ static void read_event_files(struct pevent *pevent)
 	}
 }
 
-struct cpu_data {
-	unsigned long long	offset;
-	unsigned long long	size;
-	unsigned long long	timestamp;
-	struct pevent_record	*next;
-	char			*page;
-	int			cpu;
-	int			index;
-	int			page_size;
-};
-
-static struct cpu_data *cpu_data;
-
-static void update_cpu_data_index(int cpu)
-{
-	cpu_data[cpu].offset += page_size;
-	cpu_data[cpu].size -= page_size;
-	cpu_data[cpu].index = 0;
-}
-
-static void get_next_page(int cpu)
-{
-	off_t save_seek;
-	off_t ret;
-
-	if (!cpu_data[cpu].page)
-		return;
-
-	if (read_page) {
-		if (cpu_data[cpu].size <= page_size) {
-			free(cpu_data[cpu].page);
-			cpu_data[cpu].page = NULL;
-			return;
-		}
-
-		update_cpu_data_index(cpu);
-
-		/* other parts of the code may expect the pointer to not move */
-		save_seek = lseek(input_fd, 0, SEEK_CUR);
-
-		ret = lseek(input_fd, cpu_data[cpu].offset, SEEK_SET);
-		if (ret == (off_t)-1)
-			die("failed to lseek");
-		ret = read(input_fd, cpu_data[cpu].page, page_size);
-		if (ret < 0)
-			die("failed to read page");
-
-		/* reset the file pointer back */
-		lseek(input_fd, save_seek, SEEK_SET);
-
-		return;
-	}
-
-	munmap(cpu_data[cpu].page, page_size);
-	cpu_data[cpu].page = NULL;
-
-	if (cpu_data[cpu].size <= page_size)
-		return;
-
-	update_cpu_data_index(cpu);
-
-	cpu_data[cpu].page = mmap(NULL, page_size, PROT_READ, MAP_PRIVATE,
-				  input_fd, cpu_data[cpu].offset);
-	if (cpu_data[cpu].page == MAP_FAILED)
-		die("failed to mmap cpu %d at offset 0x%llx",
-		    cpu, cpu_data[cpu].offset);
-}
-
-static unsigned int type_len4host(unsigned int type_len_ts)
-{
-	if (file_bigendian)
-		return (type_len_ts >> 27) & ((1 << 5) - 1);
-	else
-		return type_len_ts & ((1 << 5) - 1);
-}
-
-static unsigned int ts4host(unsigned int type_len_ts)
-{
-	if (file_bigendian)
-		return type_len_ts & ((1 << 27) - 1);
-	else
-		return type_len_ts >> 5;
-}
-
-static int calc_index(void *ptr, int cpu)
-{
-	return (unsigned long)ptr - (unsigned long)cpu_data[cpu].page;
-}
-
-struct pevent_record *trace_peek_data(struct pevent *pevent, int cpu)
-{
-	struct pevent_record *data;
-	void *page = cpu_data[cpu].page;
-	int idx = cpu_data[cpu].index;
-	void *ptr = page + idx;
-	unsigned long long extend;
-	unsigned int type_len_ts;
-	unsigned int type_len;
-	unsigned int delta;
-	unsigned int length = 0;
-
-	if (cpu_data[cpu].next)
-		return cpu_data[cpu].next;
-
-	if (!page)
-		return NULL;
-
-	if (!idx) {
-		/* FIXME: handle header page */
-		if (header_page_ts_size != 8)
-			die("expected a long long type for timestamp");
-		cpu_data[cpu].timestamp = data2host8(pevent, ptr);
-		ptr += 8;
-		switch (header_page_size_size) {
-		case 4:
-			cpu_data[cpu].page_size = data2host4(pevent, ptr);
-			ptr += 4;
-			break;
-		case 8:
-			cpu_data[cpu].page_size = data2host8(pevent, ptr);
-			ptr += 8;
-			break;
-		default:
-			die("bad long size");
-		}
-		ptr = cpu_data[cpu].page + header_page_data_offset;
-	}
-
-read_again:
-	idx = calc_index(ptr, cpu);
-
-	if (idx >= cpu_data[cpu].page_size) {
-		get_next_page(cpu);
-		return trace_peek_data(pevent, cpu);
-	}
-
-	type_len_ts = data2host4(pevent, ptr);
-	ptr += 4;
-
-	type_len = type_len4host(type_len_ts);
-	delta = ts4host(type_len_ts);
-
-	switch (type_len) {
-	case RINGBUF_TYPE_PADDING:
-		if (!delta)
-			die("error, hit unexpected end of page");
-		length = data2host4(pevent, ptr);
-		ptr += 4;
-		length *= 4;
-		ptr += length;
-		goto read_again;
-
-	case RINGBUF_TYPE_TIME_EXTEND:
-		extend = data2host4(pevent, ptr);
-		ptr += 4;
-		extend <<= TS_SHIFT;
-		extend += delta;
-		cpu_data[cpu].timestamp += extend;
-		goto read_again;
-
-	case RINGBUF_TYPE_TIME_STAMP:
-		ptr += 12;
-		break;
-	case 0:
-		length = data2host4(pevent, ptr);
-		ptr += 4;
-		die("here! length=%d", length);
-		break;
-	default:
-		length = type_len * 4;
-		break;
-	}
-
-	cpu_data[cpu].timestamp += delta;
-
-	data = malloc_or_die(sizeof(*data));
-	memset(data, 0, sizeof(*data));
-
-	data->ts = cpu_data[cpu].timestamp;
-	data->size = length;
-	data->data = ptr;
-	ptr += length;
-
-	cpu_data[cpu].index = calc_index(ptr, cpu);
-	cpu_data[cpu].next = data;
-
-	return data;
-}
-
-struct pevent_record *trace_read_data(struct pevent *pevent, int cpu)
-{
-	struct pevent_record *data;
-
-	data = trace_peek_data(pevent, cpu);
-	cpu_data[cpu].next = NULL;
-
-	return data;
-}
-
 ssize_t trace_report(int fd, struct pevent **ppevent, bool __repipe)
 {
 	char buf[BUFSIZ];
