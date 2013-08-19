Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751349Ab3HSJmt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 05:42:49 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:48444 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311Ab3HSJmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 05:42:32 -0400
X-AuditID: 85900ec0-d1328b9000001514-48-5211e885c51d
Subject: [RFC PATCH 11/11] trace-cmd: Add --virt option for record mode
To: Steven Rostedt <rostedt@goodmis.org>
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Date: Mon, 19 Aug 2013 18:46:47 +0900
Message-ID: <20130819094647.26597.8902.stgit@yunodevel>
In-Reply-To: <20130819094620.26597.79499.stgit@yunodevel>
References: <20130819094620.26597.79499.stgit@yunodevel>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add --virt option for record mode for a virtualization environment.
If we use this option on a guest, we can send trace data in low overhead.
This is because guests can send trace data to a host without copying the data
by using splice(2).

The format is:

   trace-cmd record --virt -e sched*

<Restriction>
This feature can use from kernel-3.6 which supports splice_read for ftrace
and splice_write for virtio-serial.

Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
---
 Documentation/trace-cmd-record.1.txt |   11 +++++-
 trace-cmd.h                          |    3 +-
 trace-msg.c                          |   35 ++++++++++++++++--
 trace-msg.h                          |    4 ++
 trace-record.c                       |   66 ++++++++++++++++++++++++++++++++--
 5 files changed, 110 insertions(+), 9 deletions(-)

diff --git a/Documentation/trace-cmd-record.1.txt b/Documentation/trace-cmd-record.1.txt
index 832a257..7eb8ac9 100644
--- a/Documentation/trace-cmd-record.1.txt
+++ b/Documentation/trace-cmd-record.1.txt
@@ -240,6 +240,15 @@ OPTIONS
     timestamp to gettimeofday which will allow wall time output from the
     timestamps reading the created 'trace.dat' file.
 
+*--virt*::
+    This option is usded on a guest in a virtualization environment. If a host
+    is running "trace-cmd virt-server", this option is used to have the data
+    sent to the host with virtio-serial like *-N* option. (see also
+    trace-cmd-virt-server(1))
+
+    Note: This option is not supported with latency tracer plugins:
+      wakeup, wakeup_rt, irqsoff, preemptoff and preemptirqsoff
+
 EXAMPLES
 --------
 
@@ -302,7 +311,7 @@ SEE ALSO
 --------
 trace-cmd(1), trace-cmd-report(1), trace-cmd-start(1), trace-cmd-stop(1),
 trace-cmd-extract(1), trace-cmd-reset(1), trace-cmd-split(1),
-trace-cmd-list(1), trace-cmd-listen(1)
+trace-cmd-list(1), trace-cmd-listen(1), trace-cmd-virt-server(1)
 
 AUTHOR
 ------
diff --git a/trace-cmd.h b/trace-cmd.h
index b4c2267..5d895ff 100644
--- a/trace-cmd.h
+++ b/trace-cmd.h
@@ -251,7 +251,8 @@ void tracecmd_stat_cpu(struct trace_seq *s, int cpu);
 long tracecmd_flush_recording(struct tracecmd_recorder *recorder);
 
 /* for clients */
-int tracecmd_msg_connect_to_server(int fd);
+int tracecmd_msg_connect_to_server_nw(int fd);
+int tracecmd_msg_connect_to_server_virt(int fd);
 int tracecmd_msg_metadata_send(int fd, char *buf, int size);
 int tracecmd_msg_finish_sending_metadata(int fd);
 void tracecmd_msg_send_close_msg();
diff --git a/trace-msg.c b/trace-msg.c
index 251e99c..cdeeed3 100644
--- a/trace-msg.c
+++ b/trace-msg.c
@@ -30,6 +30,7 @@
 #include <stdio.h>
 #include <unistd.h>
 #include <arpa/inet.h>
+#include <sys/stat.h>
 #include <sys/types.h>
 #include <linux/types.h>
 
@@ -503,11 +504,12 @@ static int tracecmd_msg_wait_for_msg(int fd, struct tracecmd_msg **msg)
 	return 0;
 }
 
-int tracecmd_msg_connect_to_server(int fd)
+static int tracecmd_msg_connect_to_server(int fd, bool nw)
 {
 	struct tracecmd_msg *msg;
 	u32 reply_cmd, cmd;
 	int i, ret, cpus;
+	char buf[PATH_MAX];
 
 	/* connect to a server */
 	cmd = MSG_TCONNECT;
@@ -529,9 +531,24 @@ int tracecmd_msg_connect_to_server(int fd)
 	} while (reply_cmd != MSG_RINIT);
 
 	cpus = ntohl(msg->data.rinit.cpus);
-	client_ports = malloc_or_die(sizeof(int) * cpus);
-	for (i = 0; i < cpus; i++)
-		client_ports[i] = ntohl(msg->data.rinit.port_array[i]);
+	if (nw) {
+		client_ports = malloc_or_die(sizeof(int) * cpus);
+		for (i = 0; i < cpus; i++)
+			client_ports[i] =
+					ntohl(msg->data.rinit.port_array[i]);
+	} else {
+		virt_sfds = malloc_or_die(sizeof(int) * cpus);
+
+		/* Open data paths of virtio-serial */
+		for (i = 0; i < cpus; i++) {
+			snprintf(buf, PATH_MAX, TRACE_PATH_CPU, i);
+			virt_sfds[i] = open(buf, O_WRONLY);
+			if (virt_sfds[i] < 0) {
+				warning("Cannot open %s", TRACE_PATH_CPU, i);
+				return -errno;
+			}
+		}
+	}
 
 	/* Next, send meta data */
 	send_metadata = true;
@@ -543,6 +560,16 @@ error:
 	return ret;
 }
 
+int tracecmd_msg_connect_to_server_nw(int fd)
+{
+	return tracecmd_msg_connect_to_server(fd, true);
+}
+
+int tracecmd_msg_connect_to_server_virt(int fd)
+{
+	return tracecmd_msg_connect_to_server(fd, false);
+}
+
 static bool process_option(struct tracecmd_msg_opt *opt)
 {
 	/* currently the only option we have is to us TCP */
diff --git a/trace-msg.h b/trace-msg.h
index 9ec95e5..d1f7321 100644
--- a/trace-msg.h
+++ b/trace-msg.h
@@ -2,6 +2,9 @@
 #define _TRACE_MSG_H_
 
 #include <stdbool.h>
+#define VIRTIO_PORTS	"/dev/virtio-ports/"
+#define AGENT_CTL_PATH	VIRTIO_PORTS "agent-ctl-path"
+#define TRACE_PATH_CPU	VIRTIO_PORTS "trace-path-cpu%d"
 
 /* for both clients and server */
 bool use_tcp;
@@ -11,6 +14,7 @@ int cpu_count;
 unsigned int page_size;
 int *client_ports;
 bool send_metadata;
+int *virt_sfds;
 
 /* for server */
 bool done;
diff --git a/trace-record.c b/trace-record.c
index ef30e31..df9e786 100644
--- a/trace-record.c
+++ b/trace-record.c
@@ -80,6 +80,9 @@ static int sfd;
 /* Max size to let a per cpu file get */
 static int max_kb;
 
+struct tracecmd_output *virt_handle;
+static bool virt;
+
 static int do_ptrace;
 
 static int filter_task;
@@ -1576,6 +1579,9 @@ static int create_recorder(struct buffer_instance *instance, int cpu, int extrac
 	if (client_ports) {
 		connect_port(cpu);
 		recorder = tracecmd_create_recorder_fd(client_ports[cpu], cpu, recorder_flags);
+	} else if (virt_sfds) {
+		recorder = tracecmd_create_recorder_fd(virt_sfds[cpu], cpu,
+						       recorder_flags);
 	} else {
 		file = get_temp_file(instance, cpu);
 		recorder = create_recorder_instance(instance, file, cpu);
@@ -1600,9 +1606,15 @@ static int create_recorder(struct buffer_instance *instance, int cpu, int extrac
 	exit(0);
 }
 
-static void communicate_with_listener(int fd)
+static void communicate_with_listener_nw(int fd)
+{
+	if (tracecmd_msg_connect_to_server_nw(fd) < 0)
+		die("Cannot communicate with server");
+}
+
+static void communicate_with_listener_virt(int fd)
 {
-	if (tracecmd_msg_connect_to_server(fd) < 0)
+	if (tracecmd_msg_connect_to_server_virt(fd) < 0)
 		die("Cannot communicate with server");
 }
 
@@ -1654,7 +1666,7 @@ static void setup_network(void)
 
 	freeaddrinfo(result);
 
-	communicate_with_listener(sfd);
+	communicate_with_listener_nw(sfd);
 
 	/* Now create the handle through this socket */
 	handle = tracecmd_create_init_fd_glob(sfd, listed_events);
@@ -1663,6 +1675,21 @@ static void setup_network(void)
 	/* OK, we are all set, let'r rip! */
 }
 
+static void setup_virtio(void)
+{
+	int fd;
+
+	fd = open(AGENT_CTL_PATH, O_RDWR);
+	if (fd < 0)
+		die("Cannot open %s", AGENT_CTL_PATH);
+
+	communicate_with_listener_virt(fd);
+
+	/* Now create the handle through this socket */
+	virt_handle = tracecmd_create_init_fd_glob(fd, listed_events);
+	tracecmd_msg_finish_sending_metadata(fd);
+}
+
 static void finish_network(void)
 {
 	tracecmd_msg_send_close_msg();
@@ -1670,6 +1697,13 @@ static void finish_network(void)
 	free(host);
 }
 
+static void finish_virt(void)
+{
+	tracecmd_msg_send_close_msg();
+	free(virt_handle);
+	free(virt_sfds);
+}
+
 static void start_threads(void)
 {
 	struct buffer_instance *instance;
@@ -1677,6 +1711,8 @@ static void start_threads(void)
 
 	if (host)
 		setup_network();
+	else if (virt)
+		setup_virtio();
 
 	/* make a thread for every CPU we have */
 	pids = malloc_or_die(sizeof(*pids) * cpu_count * (buffers + 1));
@@ -1721,6 +1757,9 @@ static void record_data(char *date2ts, struct trace_seq *s)
 	if (host) {
 		finish_network();
 		return;
+	} else if (virt) {
+		finish_virt();
+		return;
 	}
 
 	if (latency)
@@ -2207,6 +2246,7 @@ static void record_all_events(void)
 }
 
 enum {
+	OPT_virt	= 252,
 	OPT_nosplice	= 253,
 	OPT_funcstack	= 254,
 	OPT_date	= 255,
@@ -2278,6 +2318,7 @@ void trace_record (int argc, char **argv)
 			{"date", no_argument, NULL, OPT_date},
 			{"func-stack", no_argument, NULL, OPT_funcstack},
 			{"nosplice", no_argument, NULL, OPT_nosplice},
+			{"virt", no_argument, NULL, OPT_virt},
 			{"help", no_argument, NULL, '?'},
 			{NULL, 0, NULL, 0}
 		};
@@ -2389,6 +2430,8 @@ void trace_record (int argc, char **argv)
 		case 'o':
 			if (host)
 				die("-o incompatible with -N");
+			if (virt)
+				die("-o incompatible with --virt");
 			if (!record && !extract)
 				die("start does not take output\n"
 				    "Did you mean 'record'?");
@@ -2420,6 +2463,8 @@ void trace_record (int argc, char **argv)
 		case 'N':
 			if (!record)
 				die("-N only available with record");
+			if (virt)
+				die("-N incompatible with --virt");
 			if (output)
 				die("-N incompatible with -o");
 			host = optarg;
@@ -2432,6 +2477,8 @@ void trace_record (int argc, char **argv)
 			max_kb = atoi(optarg);
 			break;
 		case 't':
+			if (virt)
+				die("-t incompatible with --virt");
 			use_tcp = 1;
 			break;
 		case 'b':
@@ -2458,6 +2505,17 @@ void trace_record (int argc, char **argv)
 		case OPT_nosplice:
 			recorder_flags |= TRACECMD_RECORD_NOSPLICE;
 			break;
+		case OPT_virt:
+			if (!record)
+				die("--virt only available with record");
+			if (host)
+				die("--virt incompatible with -N");
+			if (output)
+				die("--virt incompatible with -o");
+			if (use_tcp)
+				die("--virt incompatible with -t");
+			virt = true;
+			break;
 		default:
 			usage(argv);
 		}
@@ -2533,6 +2591,8 @@ void trace_record (int argc, char **argv)
 			latency = 1;
 			if (host)
 				die("Network tracing not available with latency tracer plugins");
+			if (virt)
+				die("Virtio-trace not available with latency tracer plugins");
 		}
 		if (fset < 0 && (strcmp(plugin, "function") == 0 ||
 				 strcmp(plugin, "function_graph") == 0))

