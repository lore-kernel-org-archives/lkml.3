Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398AbaLVJxI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 04:53:08 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:53547 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754339AbaLVJxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 04:53:05 -0500
Subject: [PATCH trace-cmd V5 5/6] trace-cmd/record: Add --virt option for
 record mode
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com,
        Aaron Fabbri <aaronx.j.fabbri@intel.com>, linux-kernel@vger.kernel.org,
        Divya Vyas <edivya.vyas@gmail.com>
Date: Mon, 22 Dec 2014 12:48:11 -0500
Message-ID: <20141222174810.10068.82877.stgit@localhost.localdomain>
In-Reply-To: <20141222174736.10068.90306.stgit@localhost.localdomain>
References: <20141222174736.10068.90306.stgit@localhost.localdomain>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
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

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

---
Changes in V4: Rebase for current trace-cmd-v2.4
               Add usage of --virt for record in trace-usage.c
               Divide tracecmd_msg_connect_to_server() into two functions
                (tracecmd_msg_connect_to_server() and
                                     tracecmd_msg_send_init_data_virt(fd))
Changes in V3: Change _nw/_NW to _net/_NET
---
 Documentation/trace-cmd-record.1.txt |   11 ++++-
 trace-cmd.h                          |    4 +-
 trace-msg.c                          |   79 +++++++++++++++++++++++++++++++---
 trace-msg.h                          |    4 ++
 trace-record.c                       |   71 ++++++++++++++++++++++++++++---
 trace-usage.c                        |    3 +
 6 files changed, 158 insertions(+), 14 deletions(-)

diff --git a/Documentation/trace-cmd-record.1.txt b/Documentation/trace-cmd-record.1.txt
index 9e63eb4..c0de074 100644
--- a/Documentation/trace-cmd-record.1.txt
+++ b/Documentation/trace-cmd-record.1.txt
@@ -258,6 +258,15 @@ OPTIONS
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
 
@@ -320,7 +329,7 @@ SEE ALSO
 --------
 trace-cmd(1), trace-cmd-report(1), trace-cmd-start(1), trace-cmd-stop(1),
 trace-cmd-extract(1), trace-cmd-reset(1), trace-cmd-split(1),
-trace-cmd-list(1), trace-cmd-listen(1)
+trace-cmd-list(1), trace-cmd-listen(1), trace-cmd-virt-server(1)
 
 AUTHOR
 ------
diff --git a/trace-cmd.h b/trace-cmd.h
index c4e5beb..1c1b0c3 100644
--- a/trace-cmd.h
+++ b/trace-cmd.h
@@ -250,7 +250,9 @@ void tracecmd_stat_cpu(struct trace_seq *s, int cpu);
 long tracecmd_flush_recording(struct tracecmd_recorder *recorder);
 
 /* for clients */
-int tracecmd_msg_send_init_data(int fd);
+int tracecmd_msg_connect_to_server(int fd);
+int tracecmd_msg_send_init_data_net(int fd);
+int tracecmd_msg_send_init_data_virt(int fd);
 int tracecmd_msg_metadata_send(int fd, char *buf, int size);
 int tracecmd_msg_finish_sending_metadata(int fd);
 void tracecmd_msg_send_close_msg(void);
diff --git a/trace-msg.c b/trace-msg.c
index c9dcac5..e3b2653 100644
--- a/trace-msg.c
+++ b/trace-msg.c
@@ -30,6 +30,7 @@
 #include <stdio.h>
 #include <unistd.h>
 #include <arpa/inet.h>
+#include <sys/stat.h>
 #include <sys/types.h>
 #include <linux/types.h>
 
@@ -70,6 +71,7 @@ int cpu_count;
 static int psfd;
 unsigned int page_size;
 int *client_ports;
+int *virt_sfds;
 bool send_metadata;
 
 /* for server */
@@ -270,12 +272,20 @@ static int make_rinit(struct tracecmd_msg *msg)
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
 		return sizeof(msg->data.rconnect.str.size)
 		       + sizeof(CONNECT_MSG);
@@ -304,6 +314,7 @@ static u32 tracecmd_msg_get_body_length(u32 cmd)
 		       + sizeof(msg->data.rinit.port_array);
 	case MSG_SENDMETA:
 		return TRACECMD_MSG_MAX_LEN - TRACECMD_MSG_HDR_LEN;
+	case MSG_TCONNECT:
 	case MSG_CLOSE:
 	case MSG_FINMETA:
 		break;
@@ -312,15 +323,18 @@ static u32 tracecmd_msg_get_body_length(u32 cmd)
 	return 0;
 }
 
-static int tracecmd_msg_make_body(u32 cmd, struct tracecmd_msg *msg)
+static int tracecmd_msg_make_body(u32 cmd, u32 len, struct tracecmd_msg *msg)
 {
 	switch (cmd) {
+	case MSG_ERROR:
+		return make_error_msg(len, msg);
 	case MSG_RCONNECT:
 		return make_rconnect(CONNECT_MSG, sizeof(CONNECT_MSG), msg);
 	case MSG_TINIT:
 		return make_tinit(msg);
 	case MSG_RINIT:
 		return make_rinit(msg);
+	case MSG_TCONNECT:
 	case MSG_CLOSE:
 	case MSG_SENDMETA: /* meta data is not stored here. */
 	case MSG_FINMETA:
@@ -345,7 +359,7 @@ static int tracecmd_msg_create(u32 cmd, struct tracecmd_msg **msg)
 	if (ret < 0)
 		return ret;
 
-	ret = tracecmd_msg_make_body(cmd, *msg);
+	ret = tracecmd_msg_make_body(cmd, len, *msg);
 	if (ret < 0)
 		free(*msg);
 
@@ -374,6 +388,12 @@ static int tracecmd_msg_send(int fd, u32 cmd)
 	return ret;
 }
 
+static void tracecmd_msg_send_error(int fd, struct tracecmd_msg *msg)
+{
+	errmsg = msg;
+	tracecmd_msg_send(fd, MSG_ERROR);
+}
+
 static int tracecmd_msg_read_extra(int fd, void *buf, u32 size, int *n)
 {
 	int r = 0;
@@ -498,9 +518,10 @@ static int tracecmd_msg_send_and_wait_for_msg(int fd, u32 cmd, struct tracecmd_m
 	return 0;
 }
 
-int tracecmd_msg_send_init_data(int fd)
+static int tracecmd_msg_send_init_data(int fd, bool net)
 {
 	char buf[TRACECMD_MSG_MAX_LEN];
+	char path[PATH_MAX];
 	struct tracecmd_msg *msg;
 	int i, cpus;
 	int ret;
@@ -511,9 +532,24 @@ int tracecmd_msg_send_init_data(int fd)
 		return ret;
 
 	cpus = ntohl(msg->data.rinit.cpus);
-	client_ports = malloc_or_die(sizeof(int) * cpus);
-	for (i = 0; i < cpus; i++)
-		client_ports[i] = ntohl(msg->data.rinit.port_array[i]);
+	if (net) {
+		client_ports = malloc_or_die(sizeof(int) * cpus);
+		for (i = 0; i < cpus; i++)
+			client_ports[i] =
+					ntohl(msg->data.rinit.port_array[i]);
+	} else {
+		virt_sfds = malloc_or_die(sizeof(int) * cpus);
+
+		/* Open data paths of virtio-serial */
+		for (i = 0; i < cpus; i++) {
+			snprintf(path, PATH_MAX, TRACE_PATH_CPU, i);
+			virt_sfds[i] = open(path, O_WRONLY);
+			if (virt_sfds[i] < 0) {
+				warning("Cannot open %s", TRACE_PATH_CPU, i);
+				return -errno;
+			}
+		}
+	}
 
 	/* Next, send meta data */
 	send_metadata = true;
@@ -521,6 +557,37 @@ int tracecmd_msg_send_init_data(int fd)
 	return 0;
 }
 
+int tracecmd_msg_send_init_data_net(int fd)
+{
+	return tracecmd_msg_send_init_data(fd, true);
+}
+
+int tracecmd_msg_send_init_data_virt(int fd)
+{
+	return tracecmd_msg_send_init_data(fd, false);
+}
+
+int tracecmd_msg_connect_to_server(int fd)
+{
+	char buf[TRACECMD_MSG_MAX_LEN];
+	struct tracecmd_msg *msg;
+	int ret;
+
+	msg = (struct tracecmd_msg *)buf;
+	/* connect to a server */
+	ret = tracecmd_msg_send_and_wait_for_msg(fd, MSG_TCONNECT, msg);
+	if (ret < 0) {
+		if (ret == -EPROTONOSUPPORT)
+			goto error;
+	}
+
+	return ret;
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
index 19711df..5ef7508 100644
--- a/trace-record.c
+++ b/trace-record.c
@@ -77,6 +77,9 @@ static struct tracecmd_output *network_handle;
 /* Max size to let a per cpu file get */
 static int max_kb;
 
+struct tracecmd_output *virt_handle;
+static bool virt;
+
 static int do_ptrace;
 
 static int filter_task;
@@ -1791,6 +1794,9 @@ static int create_recorder(struct buffer_instance *instance, int cpu, int extrac
 	if (client_ports) {
 		connect_port(cpu);
 		recorder = tracecmd_create_recorder_fd(client_ports[cpu], cpu, recorder_flags);
+	} else if (virt_sfds) {
+		recorder = tracecmd_create_recorder_fd(virt_sfds[cpu], cpu,
+						       recorder_flags);
 	} else {
 		file = get_temp_file(instance, cpu);
 		recorder = create_recorder_instance(instance, file, cpu);
@@ -1826,7 +1832,7 @@ static void check_first_msg_from_server(int fd)
 		die("server not tracecmd server");
 }
 
-static void communicate_with_listener_v1(int fd)
+static void communicate_with_listener_v1_net(int fd)
 {
 	char buf[BUFSIZ];
 	ssize_t n;
@@ -1889,9 +1895,9 @@ static void communicate_with_listener_v1(int fd)
 	}
 }
 
-static void communicate_with_listener_v2(int fd)
+static void communicate_with_listener_v2_net(int fd)
 {
-	if (tracecmd_msg_send_init_data(fd) < 0)
+	if (tracecmd_msg_send_init_data_net(fd) < 0)
 		die("Cannot communicate with server");
 }
 
@@ -1935,6 +1941,15 @@ static void check_protocol_version(int fd)
 	}
 }
 
+static void communicate_with_listener_virt(int fd)
+{
+	if (tracecmd_msg_connect_to_server(fd) < 0)
+		die("Cannot communicate with server");
+
+	if (tracecmd_msg_send_init_data_virt(fd) < 0)
+		die("Cannot send init data");
+}
+
 static void setup_network(void)
 {
 	struct addrinfo hints;
@@ -1990,11 +2005,11 @@ again:
 			close(sfd);
 			goto again;
 		}
-		communicate_with_listener_v2(sfd);
+		communicate_with_listener_v2_net(sfd);
 	}
 
 	if (proto_ver == V1_PROTOCOL)
-		communicate_with_listener_v1(sfd);
+		communicate_with_listener_v1_net(sfd);
 
 	/* Now create the handle through this socket */
 	network_handle = tracecmd_create_init_fd_glob(sfd, listed_events);
@@ -2005,6 +2020,21 @@ again:
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
@@ -2013,6 +2043,13 @@ static void finish_network(void)
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
@@ -2020,6 +2057,8 @@ static void start_threads(void)
 
 	if (host)
 		setup_network();
+	else if (virt)
+		setup_virtio();
 
 	/* make a thread for every CPU we have */
 	pids = malloc_or_die(sizeof(*pids) * cpu_count * (buffers + 1));
@@ -2089,6 +2128,9 @@ static void record_data(char *date2ts)
 	if (host) {
 		finish_network();
 		return;
+	} else if (virt) {
+		finish_virt();
+		return;
 	}
 
 	if (latency)
@@ -2742,6 +2784,7 @@ static void record_all_events(void)
 }
 
 enum {
+	OPT_virt	= 252,
 	OPT_nosplice	= 253,
 	OPT_funcstack	= 254,
 	OPT_date	= 255,
@@ -2895,6 +2938,7 @@ void trace_record (int argc, char **argv)
 			{"date", no_argument, NULL, OPT_date},
 			{"func-stack", no_argument, NULL, OPT_funcstack},
 			{"nosplice", no_argument, NULL, OPT_nosplice},
+			{"virt", no_argument, NULL, OPT_virt},
 			{"help", no_argument, NULL, '?'},
 			{NULL, 0, NULL, 0}
 		};
@@ -3025,6 +3069,8 @@ void trace_record (int argc, char **argv)
 		case 'o':
 			if (host)
 				die("-o incompatible with -N");
+			if (virt)
+				die("-o incompatible with --virt");
 			if (!record && !extract)
 				die("start does not take output\n"
 				    "Did you mean 'record'?");
@@ -3056,6 +3102,8 @@ void trace_record (int argc, char **argv)
 		case 'N':
 			if (!record && !extract)
 				die("-N only available with record or extract");
+			if (virt)
+				die("-N incompatible with --virt");
 			if (output)
 				die("-N incompatible with -o");
 			host = optarg;
@@ -3071,6 +3119,8 @@ void trace_record (int argc, char **argv)
 			instance->cpumask = optarg;
 			break;
 		case 't':
+			if (virt)
+				die("-t incompatible with --virt");
 			use_tcp = 1;
 			break;
 		case 'b':
@@ -3095,6 +3145,17 @@ void trace_record (int argc, char **argv)
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
diff --git a/trace-usage.c b/trace-usage.c
index 0411cb4..b8c8c71 100644
--- a/trace-usage.c
+++ b/trace-usage.c
@@ -19,7 +19,7 @@ static struct usage_help usage_help[] = {
 		" %s record [-v][-e event [-f filter]][-p plugin][-F][-d][-D][-o file] \\\n"
 		"           [-s usecs][-O option ][-l func][-g func][-n func] \\\n"
 		"           [-P pid][-N host:port][-t][-r prio][-b size][-B buf][command ...]\n"
-		"           [-m max]\n"
+		"           [-m max][--virt]\n"
 		"          -e run command with event enabled\n"
 		"          -f filter for previous -e event\n"
 		"          -R trigger for previous -e event\n"
@@ -48,6 +48,7 @@ static struct usage_help usage_help[] = {
 		"          -i do not fail if an event is not found\n"
 		"          --func-stack perform a stack trace for function tracer\n"
 		"             (use with caution)\n"
+		"	   --virt to connect to virt-server\n"
 	},
 	{
 		"start",


