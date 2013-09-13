Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513Ab3IMCCp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 22:02:45 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:41031 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757450Ab3IMCC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 22:02:28 -0400
X-AuditID: 85900ec0-d0927b9000001514-a9-5232723230b3
Subject: [PATCH V2 5/5] trace-cmd: Add --virt option for record mode
To: Steven Rostedt <rostedt@goodmis.org>
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Date: Fri, 13 Sep 2013 11:06:40 +0900
Message-ID: <20130913020640.28927.12667.stgit@yunodevel>
In-Reply-To: <20130913020627.28927.69090.stgit@yunodevel>
References: <20130913020627.28927.69090.stgit@yunodevel>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add --virt option for record mode for a virtualization environment.
If we use this option on a guest, we can send trace data in low-overhead.
This is because guests can send trace data to a host without copying the data
by using splice(2).

The format is:

   trace-cmd record --virt -e sched*

<Note>
The client using virtio-serial does not wait for the connection message
"tracecmd" from the server. The client sends the connection message
MSG_TCONNECT first.

<Restriction>
This feature can use from kernel-3.6 which supports splice_read for ftrace
and splice_write for virtio-serial.

Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
---
 Documentation/trace-cmd-record.1.txt |   11 ++++-
 trace-cmd.h                          |    3 +
 trace-msg.c                          |   80 ++++++++++++++++++++++++++++++++--
 trace-msg.h                          |    4 ++
 trace-record.c                       |   70 ++++++++++++++++++++++++++++--
 5 files changed, 156 insertions(+), 12 deletions(-)

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
index ce3df2c..d69ea2e 100644
--- a/trace-cmd.h
+++ b/trace-cmd.h
@@ -250,7 +250,8 @@ void tracecmd_stat_cpu(struct trace_seq *s, int cpu);
 long tracecmd_flush_recording(struct tracecmd_recorder *recorder);
 
 /* for clients */
-int tracecmd_msg_send_init_data(int fd);
+int tracecmd_msg_connect_to_server(int fd);
+int tracecmd_msg_send_init_data_nw(int fd);
 int tracecmd_msg_metadata_send(int fd, char *buf, int size);
 int tracecmd_msg_finish_sending_metadata(int fd);
 void tracecmd_msg_send_close_msg();
diff --git a/trace-msg.c b/trace-msg.c
index 0b3b356..4de1cf3 100644
--- a/trace-msg.c
+++ b/trace-msg.c
@@ -30,6 +30,7 @@
 #include <stdio.h>
 #include <unistd.h>
 #include <arpa/inet.h>
+#include <sys/stat.h>
 #include <sys/types.h>
 #include <linux/types.h>
 
@@ -72,6 +73,7 @@ int cpu_count;
 static int psfd;
 unsigned int page_size;
 int *client_ports;
+int *virt_sfds;
 bool send_metadata;
 
 /* for server */
@@ -268,12 +270,20 @@ static int make_rinit(struct tracecmd_msg *msg)
 	return 0;
 }
 
+static int make_error_msg(u32 len, struct tracecmd_msg *msg)
+{
+	bufcpy(msg, TRACECMD_MSG_HDR_LEN, errmsg, len);
+	return 0;
+}
+
 static u32 tracecmd_msg_get_body_length(u32 cmd)
 {
 	struct tracecmd_msg *msg;
 	u32 len = 0;
 
 	switch (cmd) {
+	case MSG_ERROR:
+		return ntohl(errmsg->size);
 	case MSG_RCONNECT:
 		return sizeof(msg->data.rconnect.str.size) + CONNECTION_MSGSIZE;
 	case MSG_TINIT:
@@ -302,6 +312,7 @@ static u32 tracecmd_msg_get_body_length(u32 cmd)
 		       + sizeof(msg->data.rinit.port_array);
 	case MSG_SENDMETA:
 		return TRACECMD_MSG_MAX_LEN - TRACECMD_MSG_HDR_LEN;
+	case MSG_TCONNECT:
 	case MSG_CLOSE:
 	case MSG_FINMETA:
 		break;
@@ -313,12 +324,15 @@ static u32 tracecmd_msg_get_body_length(u32 cmd)
 static int tracecmd_msg_make_body(u32 cmd, u32 len, struct tracecmd_msg *msg)
 {
 	switch (cmd) {
+	case MSG_ERROR:
+		return make_error_msg(len, msg);
 	case MSG_RCONNECT:
 		return make_rconnect(CONNECTION_MSG, CONNECTION_MSGSIZE, msg);
 	case MSG_TINIT:
 		return make_tinit(len, msg);
 	case MSG_RINIT:
 		return make_rinit(msg);
+	case MSG_TCONNECT:
 	case MSG_CLOSE:
 	case MSG_SENDMETA: /* meta data is not stored here. */
 	case MSG_FINMETA:
@@ -374,6 +388,12 @@ static int tracecmd_msg_send(int fd, u32 cmd)
 	return 0;
 }
 
+static void tracecmd_msg_send_error(int fd, struct tracecmd_msg *msg)
+{
+	errmsg = msg;
+ 	tracecmd_msg_send(fd, MSG_ERROR);
+}
+
 static int tracecmd_msg_read_extra(int fd, char *buf, u32 size, int *n)
 {
 	int r = 0;
@@ -502,20 +522,36 @@ static int tracecmd_msg_send_and_wait_for_msg(int fd, u32 cmd, struct tracecmd_m
 	return 0;
 }
 
-int tracecmd_msg_send_init_data(int fd)
+static int tracecmd_msg_send_init_data(int fd, bool nw)
 {
-	struct tracecmd_msg *msg;
+	struct tracecmd_msg *msg = NULL;
 	int i, cpus;
 	int ret;
+	char buf[PATH_MAX];
 
 	ret = tracecmd_msg_send_and_wait_for_msg(fd, MSG_TINIT, &msg);
 	if (ret < 0)
 		return ret;
 
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
@@ -523,6 +559,40 @@ int tracecmd_msg_send_init_data(int fd)
 	return 0;
 }
 
+int tracecmd_msg_send_init_data_nw(int fd)
+{
+	return tracecmd_msg_send_init_data(fd, true);
+}
+
+static int tracecmd_msg_send_init_data_virt(int fd)
+{
+	return tracecmd_msg_send_init_data(fd, false);
+}
+
+int tracecmd_msg_connect_to_server(int fd)
+{
+	struct tracecmd_msg *msg = NULL;
+	int ret;
+
+	/* connect to a server */
+	ret = tracecmd_msg_send_and_wait_for_msg(fd, MSG_TCONNECT, &msg);
+	if (ret < 0) {
+		if (ret == -EPROTONOSUPPORT)
+			goto error;
+		return ret;
+	}
+
+	ret = tracecmd_msg_send_init_data_virt(fd);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+
+error:
+	tracecmd_msg_send_error(fd, msg);
+	return ret;
+}
+
 static bool process_option(struct tracecmd_msg_opt *opt)
 {
 	/* currently the only option we have is to us TCP */
diff --git a/trace-msg.h b/trace-msg.h
index b23e72b..502c1bf 100644
--- a/trace-msg.h
+++ b/trace-msg.h
@@ -2,6 +2,9 @@
 #define _TRACE_MSG_H_
 
 #include <stdbool.h>
+#define VIRTIO_PORTS	"/dev/virtio-ports/"
+#define AGENT_CTL_PATH	VIRTIO_PORTS "agent-ctl-path"
+#define TRACE_PATH_CPU	VIRTIO_PORTS "trace-path-cpu%d"
 
 #define UDP_MAX_PACKET	(65536 - 20)
 #define V2_MAGIC	"677768\0"
@@ -17,6 +20,7 @@ extern int cpu_count;
 extern unsigned int page_size;
 extern int *client_ports;
 extern bool send_metadata;
+extern int *virt_sfds;
 
 /* for server */
 extern bool done;
diff --git a/trace-record.c b/trace-record.c
index ebfe6c0..1b1d293 100644
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
@@ -1578,6 +1581,9 @@ static int create_recorder(struct buffer_instance *instance, int cpu, int extrac
 	if (client_ports) {
 		connect_port(cpu);
 		recorder = tracecmd_create_recorder_fd(client_ports[cpu], cpu, recorder_flags);
+	} else if (virt_sfds) {
+		recorder = tracecmd_create_recorder_fd(virt_sfds[cpu], cpu,
+						       recorder_flags);
 	} else {
 		file = get_temp_file(instance, cpu);
 		recorder = create_recorder_instance(instance, file, cpu);
@@ -1613,7 +1619,7 @@ static void check_first_msg_from_server(int fd)
 		die("server not tracecmd server");
 }
 
-static void communicate_with_listener_v1(int fd)
+static void communicate_with_listener_v1_nw(int fd)
 {
 	char buf[BUFSIZ];
 	ssize_t n;
@@ -1676,9 +1682,9 @@ static void communicate_with_listener_v1(int fd)
 	}
 }
 
-static void communicate_with_listener_v2(int fd)
+static void communicate_with_listener_v2_nw(int fd)
 {
-	if (tracecmd_msg_send_init_data(fd) < 0)
+	if (tracecmd_msg_send_init_data_nw(fd) < 0)
 		die("Cannot communicate with server");
 }
 
@@ -1716,6 +1722,12 @@ static void check_protocol_version(int fd)
 	}
 }
 
+static void communicate_with_listener_virt(int fd)
+{
+	if (tracecmd_msg_connect_to_server(fd) < 0)
+		die("Cannot communicate with server");
+}
+
 static void setup_network(void)
 {
 	struct tracecmd_output *handle;
@@ -1772,11 +1784,11 @@ again:
 			close(sfd);
 			goto again;
 		}
-		communicate_with_listener_v2(sfd);
+		communicate_with_listener_v2_nw(sfd);
 	}
 
 	if (proto_ver == V1_PROTOCOL)
-		communicate_with_listener_v1(sfd);
+		communicate_with_listener_v1_nw(sfd);
 
 	/* Now create the handle through this socket */
 	handle = tracecmd_create_init_fd_glob(sfd, listed_events);
@@ -1787,6 +1799,21 @@ again:
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
 	if (proto_ver == V2_PROTOCOL)
@@ -1795,6 +1822,13 @@ static void finish_network(void)
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
@@ -1802,6 +1836,8 @@ static void start_threads(void)
 
 	if (host)
 		setup_network();
+	else if (virt)
+		setup_virtio();
 
 	/* make a thread for every CPU we have */
 	pids = malloc_or_die(sizeof(*pids) * cpu_count * (buffers + 1));
@@ -1846,6 +1882,9 @@ static void record_data(char *date2ts, struct trace_seq *s)
 	if (host) {
 		finish_network();
 		return;
+	} else if (virt) {
+		finish_virt();
+		return;
 	}
 
 	if (latency)
@@ -2337,6 +2376,7 @@ static void record_all_events(void)
 }
 
 enum {
+	OPT_virt	= 252,
 	OPT_nosplice	= 253,
 	OPT_funcstack	= 254,
 	OPT_date	= 255,
@@ -2408,6 +2448,7 @@ void trace_record (int argc, char **argv)
 			{"date", no_argument, NULL, OPT_date},
 			{"func-stack", no_argument, NULL, OPT_funcstack},
 			{"nosplice", no_argument, NULL, OPT_nosplice},
+			{"virt", no_argument, NULL, OPT_virt},
 			{"help", no_argument, NULL, '?'},
 			{NULL, 0, NULL, 0}
 		};
@@ -2519,6 +2560,8 @@ void trace_record (int argc, char **argv)
 		case 'o':
 			if (host)
 				die("-o incompatible with -N");
+			if (virt)
+				die("-o incompatible with --virt");
 			if (!record && !extract)
 				die("start does not take output\n"
 				    "Did you mean 'record'?");
@@ -2550,6 +2593,8 @@ void trace_record (int argc, char **argv)
 		case 'N':
 			if (!record)
 				die("-N only available with record");
+			if (virt)
+				die("-N incompatible with --virt");
 			if (output)
 				die("-N incompatible with -o");
 			host = optarg;
@@ -2562,6 +2607,8 @@ void trace_record (int argc, char **argv)
 			max_kb = atoi(optarg);
 			break;
 		case 't':
+			if (virt)
+				die("-t incompatible with --virt");
 			use_tcp = 1;
 			break;
 		case 'b':
@@ -2588,6 +2635,17 @@ void trace_record (int argc, char **argv)
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
@@ -2663,6 +2721,8 @@ void trace_record (int argc, char **argv)
 			latency = 1;
 			if (host)
 				die("Network tracing not available with latency tracer plugins");
+			if (virt)
+				die("Virtio-trace not available with latency tracer plugins");
 		}
 		if (fset < 0 && (strcmp(plugin, "function") == 0 ||
 				 strcmp(plugin, "function_graph") == 0))

