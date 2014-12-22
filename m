Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301AbaLVJws (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 04:52:48 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:53473 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938AbaLVJwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 04:52:44 -0500
Subject: [PATCH trace-cmd V5 2/6] trace-cmd/listen: Introduce trace-msg
 protocol (protocol v2)
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com,
        Aaron Fabbri <aaronx.j.fabbri@intel.com>, linux-kernel@vger.kernel.org,
        Divya Vyas <edivya.vyas@gmail.com>
Date: Mon, 22 Dec 2014 12:47:50 -0500
Message-ID: <20141222174750.10068.41354.stgit@localhost.localdomain>
In-Reply-To: <20141222174736.10068.90306.stgit@localhost.localdomain>
References: <20141222174736.10068.90306.stgit@localhost.localdomain>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce new trace-msg protocol (protocol V2) for more
flexible messaging. V1 protocol which is currently used
by trace-cmd server and client, is based on a simple
text messages. It is impossible to extend the protocol
without breaking backward compatibility. The V2 protocol
introduced by this patch is a binary message-based protocol
and it is able to extend by just adding message tags.

<How to test>
[1] Backward compatibility checks
 We need to test backward compatibility of this patch for old
 trace-cmds(client/server). So, this patch was tested for [2]
 command checks in following 3 types:

	<client>	<server>
	  new		  old
	  old		  new
	  new		  new

[2] Command checks
- server (common)
	# trace-cmd listen -p 12345

1) record
- client
	# trace-cmd record -e sched -N <server IP>:12345
	^C

2) record + multiple buffers
- client
	# trace-cmd record -B foo -e sched -N <server IP>:12345
	^C

3) extract
- client
	# ./trace-cmd start -e sched
	# sleep 5
	# ./trace-cmd stop
	# ./trace-cmd extract -N <server IP>:12345

4) extract + snapshot
- client
	# ./trace-cmd start -e sched
	# sleep 5
	# ./trace-cmd snapshot -s
	# ./trace-cmd stop
	# ./trace-cmd extract -N <server IP>:12345 -s

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

---
Changes in V5: Client sends "-1V2\0<MAGIC_NUMBER>\00" instead of
               "V2\0<MAGIC_NUMBER>\0" not to make old server create
               zero length file.
               Also add a protocol documentation.
               Cleanup source code.
               Change meaningless loop in tracecmd_msg_collect_metadata().
Changes in V4: Fix some typos, cleanups and rebase for current trace-cmd-v2.4
               Change the argument of tracecmd_msg_recv()
Changes in V3: Change the license of trace-msg.c to LGPL v2.1
Changes in V2: Regacy protocol support in order to keep backward compatibility
---
 Documentation/Protocol.txt |  119 ++++++++
 Makefile                   |    2 
 trace-cmd.h                |   11 +
 trace-listen.c             |   84 ++++-
 trace-msg.c                |  682 ++++++++++++++++++++++++++++++++++++++++++++
 trace-msg.h                |   27 ++
 trace-output.c             |    4 
 trace-record.c             |   91 +++++-
 8 files changed, 980 insertions(+), 40 deletions(-)
 create mode 100644 Documentation/Protocol.txt
 create mode 100644 trace-msg.c
 create mode 100644 trace-msg.h

diff --git a/Documentation/Protocol.txt b/Documentation/Protocol.txt
new file mode 100644
index 0000000..49f7766
--- /dev/null
+++ b/Documentation/Protocol.txt
@@ -0,0 +1,119 @@
+Trace-cmd Protocols
+===================
+
+Index
+=====
+1. What is the trace-cmd protocol?
+2. Trace-cmd Protocol V1 (Obsolete)
+3. Trace-cmd Protocol V2
+
+
+1. What is the trace-cmd protocol?
+==================================
+ Trace-cmd can run as a remote-trace agent(server) and a client, which
+communicate over network and passing the trace data. Trace-cmd protocol
+is used for the communication between the server and the client.
+ There are 2 versions of the trace-cmd protocol. V1 protocol was simple
+text-based but hard to extend. On the other hand, V2 protocol is message
+based and extensible.
+
+
+2. Trace-cmd Protocol V1 (Obsolete)
+========================
+
+The old trace-cmd which supports V1 protocol works as follows;
+
+     <server(local)>          <client(remote)>
+      listen to socket fd
+                              connect to socket fd
+      accept the client
+      send "tracecmd"
+               +------------> receive "tracecmd"
+                              check "tracecmd"
+                              send cpus
+      receive cpus <------------+
+      print "cpus=XXX"
+                              send pagesize
+                                |
+      receive pagesize <--------+
+      print "pagesize=XXX"
+                              send options
+                                |
+      receive options <---------+
+      understand options
+      send port_array
+               +------------> receive port_array
+                              understand port_array
+                              send meta data
+      receive meta data <-------+
+      record meta data
+                        (snip)
+      read block
+     --- start sending trace data on child processes ---
+
+     --- When client finishes sending trace data ---
+                              close(socket fd)
+      read size = 0
+      close(socket fd)
+
+All messages are unstructured character strings and the messaging
+order and contents are fixed. It is impossible to extend the
+protocol without breaking the compatibility.
+
+
+3. Trace-cmd Protocol V2
+========================
+
+From the protocol V2, the structured binary message "trace-msg" is
+introduced as the communication protocol.
+
+     <server>                 <client>
+      listen to socket fd
+                              connect to socket fd
+      accept the client
+      send "tracecmd"
+               +------------> receive "tracecmd"
+                              check "tracecmd"
+                              send "-1V2\0<MAGIC_NUMBER>\0" as the v2 protocol
+      receive "-1V2" <----------+
+      check "-1V2"
+      check <MAGIC_NUMBER>
+      send "V2"
+            +---------------> receive "V2"
+                              check "V2"
+                              send MSG_TINIT with cpus, pagesize and options
+      receive MSG_TINIT <-------+
+      perse the parameters
+      send MSG_RINIT with port_array
+           +----------------> receive MSG_RINIT
+                              get port_array
+                              send meta data(MSG_SENDMETA)
+      receive MSG_SENDMETA <----+
+      record meta data
+                         (snip)
+                              send a message to finish sending meta data
+                                |                           (MSG_FINMETA)
+      receive MSG_FINMETA <-----+
+      read block
+     --- start sending trace data on child processes ---
+
+     --- When client finishes sending trace data ---
+                              send MSG_CLOSE
+      receive MSG_CLOSE <-------+
+      close(socket fd)        close(socket fd)
+
+In this version, after the client checks "tracecmd", it sends
+"-1V2\0<MAGIC_NUMBER>\0". This is for the backward compatibility.
+When the newer client tries to connect to the old server and sends
+this string to the server, the old server parses it to get the
+number of CPUs. Since "-1V2" actually becomes -1 and this is a
+wrong value, the server refuses the client. Then, the client gets
+a connection error because the server is old, so it can try to
+connect with V1 protocol again.
+
+On the other hand, if new server gets a connection from an old
+client, it can easily check whether the client uses V1 protocol
+or not by checking the first message from the client. If client
+sends a positive number, it should be a V1 protocol client.
+
+
diff --git a/Makefile b/Makefile
index cbe0eb9..9977528 100644
--- a/Makefile
+++ b/Makefile
@@ -318,7 +318,7 @@ KERNEL_SHARK_OBJS = $(TRACE_VIEW_OBJS) $(TRACE_GRAPH_OBJS) $(TRACE_GUI_OBJS) \
 PEVENT_LIB_OBJS = event-parse.o trace-seq.o parse-filter.o parse-utils.o
 TCMD_LIB_OBJS = $(PEVENT_LIB_OBJS) trace-util.o trace-input.o trace-ftrace.o \
 			trace-output.o trace-recorder.o trace-restore.o trace-usage.o \
-			trace-blk-hack.o kbuffer-parse.o event-plugin.o
+			trace-blk-hack.o kbuffer-parse.o event-plugin.o trace-msg.o
 
 PLUGIN_OBJS =
 PLUGIN_OBJS += plugin_jbd2.o
diff --git a/trace-cmd.h b/trace-cmd.h
index 92b4ff2..f65f29e 100644
--- a/trace-cmd.h
+++ b/trace-cmd.h
@@ -248,6 +248,17 @@ void tracecmd_stop_recording(struct tracecmd_recorder *recorder);
 void tracecmd_stat_cpu(struct trace_seq *s, int cpu);
 long tracecmd_flush_recording(struct tracecmd_recorder *recorder);
 
+/* for clients */
+int tracecmd_msg_send_init_data(int fd);
+int tracecmd_msg_metadata_send(int fd, char *buf, int size);
+int tracecmd_msg_finish_sending_metadata(int fd);
+void tracecmd_msg_send_close_msg(void);
+
+/* for server */
+int tracecmd_msg_initial_setting(int fd, int *cpus, int *pagesize);
+int tracecmd_msg_send_port_array(int fd, int total_cpus, int *ports);
+int tracecmd_msg_collect_metadata(int ifd, int ofd);
+
 /* --- Plugin handling --- */
 extern struct plugin_option trace_ftrace_options[];
 
diff --git a/trace-listen.c b/trace-listen.c
index 18672b0..17ab184 100644
--- a/trace-listen.c
+++ b/trace-listen.c
@@ -33,6 +33,7 @@
 #include <errno.h>
 
 #include "trace-local.h"
+#include "trace-msg.h"
 
 #define MAX_OPTION_SIZE 4096
 
@@ -45,10 +46,10 @@ static FILE *logfp;
 
 static int debug;
 
-static int use_tcp;
-
 static int backlog = 5;
 
+static int proto_ver;
+
 #define  TEMP_FILE_STR "%s.%s:%s.cpu%d", output_file, host, port, cpu
 static char *get_temp_file(const char *host, const char *port, int cpu)
 {
@@ -112,7 +113,6 @@ static int process_option(char *option)
 	return 0;
 }
 
-static int done;
 static void finish(int sig)
 {
 	done = 1;
@@ -144,7 +144,7 @@ static void __plog(const char *prefix, const char *fmt, va_list ap,
 	fprintf(fp, "%.*s", r, buf);
 }
 
-static void plog(const char *fmt, ...)
+void plog(const char *fmt, ...)
 {
 	va_list ap;
 
@@ -153,7 +153,7 @@ static void plog(const char *fmt, ...)
 	va_end(ap);
 }
 
-static void pdie(const char *fmt, ...)
+void pdie(const char *fmt, ...)
 {
 	va_list ap;
 	char *str = "";
@@ -305,25 +305,15 @@ static int open_udp(const char *node, const char *port, int *pid,
 	return num_port;
 }
 
-static int communicate_with_client(int fd, int *cpus, int *pagesize)
+/* Setup client who is using the v1 protocol */
+static int client_initial_setting(int fd, char *buf, int *cpus, int *pagesize)
 {
-	char buf[BUFSIZ];
 	char *option;
 	int options;
 	int size;
 	int n, s, t, i;
 
-	/* Let the client know what we are */
-	write(fd, "tracecmd", 8);
-
-	/* read back the CPU count */
-	n = read_string(fd, buf, BUFSIZ);
-	if (n == BUFSIZ)
-		/** ERROR **/
-		return -1;
-
 	*cpus = atoi(buf);
-
 	plog("cpus=%d\n", *cpus);
 	if (*cpus < 0)
 		return -1;
@@ -376,6 +366,41 @@ static int communicate_with_client(int fd, int *cpus, int *pagesize)
 			return -1;
 	}
 
+	return 0;
+}
+
+static int communicate_with_client(int fd, int *cpus, int *pagesize)
+{
+	char buf[BUFSIZ];
+	int n;
+
+	/* Let the client know what we are */
+	write(fd, "tracecmd", 8);
+
+	/* read back the CPU count */
+	n = read_string(fd, buf, BUFSIZ);
+	if (n == BUFSIZ)
+		/** ERROR **/
+		return -1;
+
+	/* Is the client using the new protocol? */
+	if (memcmp(buf, "-1V2", 4) == 0) {
+		read(fd, buf, sizeof(V2_MAGIC));
+		if (memcmp(buf, V2_MAGIC, strlen(V2_MAGIC)) != 0) {
+			plog("Invalid magic number %s", buf);
+			return -1;
+		}
+		proto_ver = V2_PROTOCOL;
+
+		/* Let the client know we use v2 protocol */
+		write(fd, "V2", 2);
+
+		/* read the CPU count, the page size, and options */
+		if (tracecmd_msg_initial_setting(fd, cpus, pagesize) < 0)
+			return -1;
+	} else if (client_initial_setting(fd, buf, cpus, pagesize) < 0)
+		return -1;
+
 	if (use_tcp)
 		plog("Using TCP for live connection\n");
 
@@ -442,14 +467,20 @@ static int *create_all_readers(int cpus, const char *node, const char *port,
 		start_port = udp_port + 1;
 	}
 
-	/* send the client a comma deliminated set of port numbers */
-	for (cpu = 0; cpu < cpus; cpu++) {
-		snprintf(buf, BUFSIZ, "%s%d",
-			 cpu ? "," : "", port_array[cpu]);
-		write(fd, buf, strlen(buf));
+	if (proto_ver == V2_PROTOCOL) {
+		/* send set of port numbers to the client */
+		if (tracecmd_msg_send_port_array(fd, cpus, port_array) < 0)
+			goto out_free;
+	} else {
+		/* send the client a comma deliminated set of port numbers */
+		for (cpu = 0; cpu < cpus; cpu++) {
+			snprintf(buf, BUFSIZ, "%s%d",
+				 cpu ? "," : "", port_array[cpu]);
+			write(fd, buf, strlen(buf));
+		}
+		/* end with null terminator */
+		write(fd, "\0", 1);
 	}
-	/* end with null terminator */
-	write(fd, "\0", 1);
 
 	return pid_array;
 
@@ -528,7 +559,10 @@ static void process_client(const char *node, const char *port, int fd)
 		return;
 
 	/* Now we are ready to start reading data from the client */
-	collect_metadata_from_client(fd, ofd);
+	if (proto_ver == V2_PROTOCOL)
+		tracecmd_msg_collect_metadata(fd, ofd);
+	else
+		collect_metadata_from_client(fd, ofd);
 
 	/* wait a little to let our readers finish reading */
 	sleep(1);
diff --git a/trace-msg.c b/trace-msg.c
new file mode 100644
index 0000000..a97222c
--- /dev/null
+++ b/trace-msg.c
@@ -0,0 +1,682 @@
+/*
+ * trace-msg.c : define message protocol for communication between clients and
+ *               a server
+ *
+ * Copyright (C) 2013 Hitachi, Ltd.
+ * Created by Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU Lesser General Public
+ * License as published by the Free Software Foundation;
+ * version 2.1 of the License (not later!)
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU Lesser General Public
+ * License along with this program; if not,  see <http://www.gnu.org/licenses>
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ */
+
+#include <errno.h>
+#include <poll.h>
+#include <fcntl.h>
+#include <limits.h>
+#include <stddef.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <arpa/inet.h>
+#include <sys/types.h>
+#include <linux/types.h>
+
+#include "trace-cmd-local.h"
+#include "trace-msg.h"
+
+typedef __u32 u32;
+typedef __be32 be32;
+
+#define TRACECMD_MSG_MAX_LEN		BUFSIZ
+
+					/* size + cmd */
+#define TRACECMD_MSG_HDR_LEN		((sizeof(be32)) + (sizeof(be32)))
+
+					/* + size of the metadata */
+#define TRACECMD_MSG_META_MIN_LEN	\
+				((TRACECMD_MSG_HDR_LEN) + (sizeof(be32)))
+
+					/* - header size for error msg */
+#define TRACECMD_MSG_META_MAX_LEN	\
+((TRACECMD_MSG_MAX_LEN) - (TRACECMD_MSG_META_MIN_LEN) - TRACECMD_MSG_HDR_LEN)
+
+					/* size + opt_cmd + size of str */
+#define TRACECMD_OPT_MIN_LEN		\
+			((sizeof(be32)) + (sizeof(be32)) + (sizeof(be32)))
+
+
+#define CPU_MAX				256
+
+/* for both client and server */
+bool use_tcp;
+int cpu_count;
+
+/* for client */
+static int psfd;
+unsigned int page_size;
+int *client_ports;
+bool send_metadata;
+
+/* for server */
+static int *port_array;
+bool done;
+
+struct tracecmd_msg_str {
+	be32 size;
+	char *buf;
+} __attribute__((packed));
+
+struct tracecmd_msg_opt {
+	be32 size;
+	be32 opt_cmd;
+	struct tracecmd_msg_str str;
+};
+
+struct tracecmd_msg_tinit {
+	be32 cpus;
+	be32 page_size;
+	be32 opt_num;
+	struct tracecmd_msg_opt *opt;
+} __attribute__((packed));
+
+struct tracecmd_msg_rinit {
+	be32 cpus;
+	be32 port_array[CPU_MAX];
+} __attribute__((packed));
+
+struct tracecmd_msg_meta {
+	struct tracecmd_msg_str str;
+};
+
+struct tracecmd_msg_error {
+	be32 size;
+	be32 cmd;
+	union {
+		struct tracecmd_msg_tinit tinit;
+		struct tracecmd_msg_rinit rinit;
+		struct tracecmd_msg_meta meta;
+	} data;
+} __attribute__((packed));
+
+enum tracecmd_msg_cmd {
+	MSG_CLOSE	= 1,
+	MSG_TINIT	= 4,
+	MSG_RINIT	= 5,
+	MSG_SENDMETA	= 6,
+	MSG_FINMETA	= 7,
+};
+
+struct tracecmd_msg {
+	be32 size;
+	be32 cmd;
+	union {
+		struct tracecmd_msg_tinit tinit;
+		struct tracecmd_msg_rinit rinit;
+		struct tracecmd_msg_meta meta;
+		struct tracecmd_msg_error err;
+	} data;
+} __attribute__((packed));
+
+struct tracecmd_msg *errmsg;
+
+static ssize_t msg_do_write_check(int fd, struct tracecmd_msg *msg)
+{
+	return __do_write_check(fd, msg, ntohl(msg->size));
+}
+
+static void tracecmd_msg_init(u32 cmd, u32 len, struct tracecmd_msg *msg)
+{
+	memset(msg, 0, len);
+	msg->size = htonl(len);
+	msg->cmd = htonl(cmd);
+}
+
+static int tracecmd_msg_alloc(u32 cmd, u32 len, struct tracecmd_msg **msg)
+{
+	len += TRACECMD_MSG_HDR_LEN;
+	*msg = malloc(len);
+	if (!*msg)
+		return -ENOMEM;
+
+	tracecmd_msg_init(cmd, len, *msg);
+	return 0;
+}
+
+static void bufcpy(void *dest, u32 offset, const void *buf, u32 buflen)
+{
+	memcpy(dest+offset, buf, buflen);
+}
+
+enum msg_opt_command {
+	MSGOPT_USETCP = 1,
+};
+
+static int add_option_to_tinit(u32 cmd, const char *buf,
+			       struct tracecmd_msg *msg, int offset)
+{
+	struct tracecmd_msg_opt *opt;
+	u32 len = TRACECMD_OPT_MIN_LEN;
+	u32 buflen = 0;
+
+	if (buf) {
+		buflen = strlen(buf);
+		len += buflen;
+	}
+
+	opt = malloc(len);
+	if (!opt)
+		return -ENOMEM;
+
+	opt->size = htonl(len);
+	opt->opt_cmd = htonl(cmd);
+	opt->str.size = htonl(buflen);
+
+	if (buf)
+		bufcpy(opt, TRACECMD_OPT_MIN_LEN, buf, buflen);
+
+	/* add option to msg */
+	bufcpy(msg, offset, opt, ntohl(opt->size));
+
+	free(opt);
+	return len;
+}
+
+static int add_options_to_tinit(struct tracecmd_msg *msg)
+{
+	int offset = offsetof(struct tracecmd_msg, data.tinit.opt);
+	int ret;
+
+	if (use_tcp) {
+		ret = add_option_to_tinit(MSGOPT_USETCP, NULL, msg, offset);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int make_tinit(struct tracecmd_msg *msg)
+{
+	int opt_num = 0;
+	int ret = 0;
+
+	if (use_tcp)
+		opt_num++;
+
+	if (opt_num) {
+		ret = add_options_to_tinit(msg);
+		if (ret < 0)
+			return ret;
+	}
+
+	msg->data.tinit.cpus = htonl(cpu_count);
+	msg->data.tinit.page_size = htonl(page_size);
+	msg->data.tinit.opt_num = htonl(opt_num);
+
+	return 0;
+}
+
+static int make_rinit(struct tracecmd_msg *msg)
+{
+	int i;
+	u32 offset = TRACECMD_MSG_HDR_LEN;
+	be32 port;
+
+	msg->data.rinit.cpus = htonl(cpu_count);
+
+	for (i = 0; i < cpu_count; i++) {
+		/* + rrqports->cpus or rrqports->port_array[i] */
+		offset += sizeof(be32);
+		port = htonl(port_array[i]);
+		bufcpy(msg, offset, &port, sizeof(be32) * cpu_count);
+	}
+
+	return 0;
+}
+
+static u32 tracecmd_msg_get_body_length(u32 cmd)
+{
+	struct tracecmd_msg *msg;
+	u32 len = 0;
+
+	switch (cmd) {
+	case MSG_TINIT:
+		len = sizeof(msg->data.tinit.cpus)
+		      + sizeof(msg->data.tinit.page_size)
+		      + sizeof(msg->data.tinit.opt_num);
+
+		/*
+		 * If we are using IPV4 and our page size is greater than
+		 * or equal to 64K, we need to punt and use TCP. :-(
+		 */
+
+		/* TODO, test for ipv4 */
+		if (page_size >= UDP_MAX_PACKET) {
+			warning("page size too big for UDP using TCP in live read");
+			use_tcp = true;
+		}
+
+		if (use_tcp)
+			len += TRACECMD_OPT_MIN_LEN;
+
+		return len;
+	case MSG_RINIT:
+		return sizeof(msg->data.rinit.cpus)
+		       + sizeof(msg->data.rinit.port_array);
+	case MSG_SENDMETA:
+		return TRACECMD_MSG_MAX_LEN - TRACECMD_MSG_HDR_LEN;
+	case MSG_CLOSE:
+	case MSG_FINMETA:
+		break;
+	}
+
+	return 0;
+}
+
+static int tracecmd_msg_make_body(u32 cmd, struct tracecmd_msg *msg)
+{
+	switch (cmd) {
+	case MSG_TINIT:
+		return make_tinit(msg);
+	case MSG_RINIT:
+		return make_rinit(msg);
+	case MSG_CLOSE:
+	case MSG_SENDMETA: /* meta data is not stored here. */
+	case MSG_FINMETA:
+		break;
+	}
+
+	return 0;
+}
+
+static int tracecmd_msg_create(u32 cmd, struct tracecmd_msg **msg)
+{
+	u32 len = 0;
+	int ret = 0;
+
+	len = tracecmd_msg_get_body_length(cmd);
+	if (len > (TRACECMD_MSG_MAX_LEN - TRACECMD_MSG_HDR_LEN)) {
+		plog("Exceed maximum message size cmd=%d\n", cmd);
+		return -EINVAL;
+	}
+
+	ret = tracecmd_msg_alloc(cmd, len, msg);
+	if (ret < 0)
+		return ret;
+
+	ret = tracecmd_msg_make_body(cmd, *msg);
+	if (ret < 0)
+		free(*msg);
+
+	return ret;
+}
+
+static int tracecmd_msg_send(int fd, u32 cmd)
+{
+	struct tracecmd_msg *msg = NULL;
+	int ret = 0;
+
+	if (cmd > MSG_FINMETA) {
+		plog("Unsupported command: %d\n", cmd);
+		return -EINVAL;
+	}
+
+	ret = tracecmd_msg_create(cmd, &msg);
+	if (ret < 0)
+		return ret;
+
+	ret = msg_do_write_check(fd, msg);
+	if (ret < 0)
+		ret = -ECOMM;
+
+	free(msg);
+	return ret;
+}
+
+static int tracecmd_msg_read_extra(int fd, void *buf, u32 size, int *n)
+{
+	int r = 0;
+
+	do {
+		r = read(fd, buf + *n, size);
+		if (r < 0) {
+			if (errno == EINTR)
+				continue;
+			return -errno;
+		} else if (!r)
+			return -ENOTCONN;
+		size -= r;
+		*n += r;
+	} while (size);
+
+	return 0;
+}
+
+/*
+ * Read header information of msg first, then read all data
+ */
+static int tracecmd_msg_recv(int fd, struct tracecmd_msg *msg)
+{
+	u32 size = 0;
+	int n = 0;
+	int ret;
+
+	ret = tracecmd_msg_read_extra(fd, msg, TRACECMD_MSG_HDR_LEN, &n);
+	if (ret < 0)
+		return ret;
+
+	size = ntohl(msg->size);
+	if (size > TRACECMD_MSG_MAX_LEN)
+		/* too big */
+		goto error;
+	else if (size < TRACECMD_MSG_HDR_LEN)
+		/* too small */
+		goto error;
+	else if (size > TRACECMD_MSG_HDR_LEN) {
+		size -= TRACECMD_MSG_HDR_LEN;
+		return tracecmd_msg_read_extra(fd, msg, size, &n);
+	}
+
+	return 0;
+error:
+	plog("Receive an invalid message(size=%d)\n", size);
+	return -ENOMSG;
+}
+
+static void *tracecmd_msg_buf_access(struct tracecmd_msg *msg, int offset)
+{
+	return (void *)msg + offset;
+}
+
+static int tracecmd_msg_wait_for_msg(int fd, struct tracecmd_msg *msg)
+{
+	u32 cmd;
+	int ret;
+
+	ret = tracecmd_msg_recv(fd, msg);
+	if (ret < 0)
+		return ret;
+
+	cmd = ntohl(msg->cmd);
+	if (cmd == MSG_CLOSE)
+		return -ECONNABORTED;
+
+	return 0;
+}
+
+static int tracecmd_msg_send_and_wait_for_msg(int fd, u32 cmd, struct tracecmd_msg *msg)
+{
+	int ret;
+
+	ret = tracecmd_msg_send(fd, cmd);
+	if (ret < 0)
+		return ret;
+
+	ret = tracecmd_msg_wait_for_msg(fd, msg);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+int tracecmd_msg_send_init_data(int fd)
+{
+	char buf[TRACECMD_MSG_MAX_LEN];
+	struct tracecmd_msg *msg;
+	int i, cpus;
+	int ret;
+
+	msg = (struct tracecmd_msg *)buf;
+	ret = tracecmd_msg_send_and_wait_for_msg(fd, MSG_TINIT, msg);
+	if (ret < 0)
+		return ret;
+
+	cpus = ntohl(msg->data.rinit.cpus);
+	client_ports = malloc_or_die(sizeof(int) * cpus);
+	for (i = 0; i < cpus; i++)
+		client_ports[i] = ntohl(msg->data.rinit.port_array[i]);
+
+	/* Next, send meta data */
+	send_metadata = true;
+
+	return 0;
+}
+
+static bool process_option(struct tracecmd_msg_opt *opt)
+{
+	/* currently the only option we have is to us TCP */
+	if (ntohl(opt->opt_cmd) == MSGOPT_USETCP) {
+		use_tcp = true;
+		return true;
+	}
+	return false;
+}
+
+static void error_operation_for_server(struct tracecmd_msg *msg)
+{
+	u32 cmd;
+
+	cmd = ntohl(msg->cmd);
+
+	warning("Message: cmd=%d size=%d\n", cmd, ntohl(msg->size));
+}
+
+#define MAX_OPTION_SIZE 4096
+
+int tracecmd_msg_initial_setting(int fd, int *cpus, int *pagesize)
+{
+	struct tracecmd_msg *msg;
+	struct tracecmd_msg_opt *opt;
+	char buf[TRACECMD_MSG_MAX_LEN];
+	int offset = offsetof(struct tracecmd_msg, data.tinit.opt);
+	int options, i, s;
+	int ret;
+	u32 size = 0;
+	u32 cmd;
+
+	msg = (struct tracecmd_msg *)buf;
+	ret = tracecmd_msg_recv(fd, msg);
+	if (ret < 0)
+		return ret;
+
+	cmd = ntohl(msg->cmd);
+	if (cmd != MSG_TINIT) {
+		ret = -EINVAL;
+		goto error;
+	}
+
+	*cpus = ntohl(msg->data.tinit.cpus);
+	plog("cpus=%d\n", *cpus);
+	if (*cpus < 0) {
+		ret = -EINVAL;
+		goto error;
+	}
+
+	*pagesize = ntohl(msg->data.tinit.page_size);
+	plog("pagesize=%d\n", *pagesize);
+	if (*pagesize <= 0) {
+		ret = -EINVAL;
+		goto error;
+	}
+
+	options = ntohl(msg->data.tinit.opt_num);
+	for (i = 0; i < options; i++) {
+		offset += size;
+		opt = tracecmd_msg_buf_access(msg, offset);
+		size = ntohl(opt->size);
+		/* prevent a client from killing us */
+		if (size > MAX_OPTION_SIZE) {
+			plog("Exceed MAX_OPTION_SIZE\n");
+			ret = -EINVAL;
+			goto error;
+		}
+		s = process_option(opt);
+		/* do we understand this option? */
+		if (!s) {
+			plog("Cannot understand(%d:%d:%d)\n",
+			     i, ntohl(opt->size), ntohl(opt->opt_cmd));
+			ret = -EINVAL;
+			goto error;
+		}
+	}
+
+	return 0;
+
+error:
+	error_operation_for_server(msg);
+	return ret;
+}
+
+int tracecmd_msg_send_port_array(int fd, int total_cpus, int *ports)
+{
+	int ret;
+
+	cpu_count = total_cpus;
+	port_array = ports;
+
+	ret = tracecmd_msg_send(fd, MSG_RINIT);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+void tracecmd_msg_send_close_msg(void)
+{
+	tracecmd_msg_send(psfd, MSG_CLOSE);
+}
+
+static void make_meta(const char *buf, int buflen, struct tracecmd_msg *msg)
+{
+	int offset = offsetof(struct tracecmd_msg, data.meta.str.buf);
+
+	msg->data.meta.str.size = htonl(buflen);
+	bufcpy(msg, offset, buf, buflen);
+}
+
+int tracecmd_msg_metadata_send(int fd, char *buf, int size)
+{
+	struct tracecmd_msg *msg;
+	int n, len;
+	int ret;
+	int count = 0;
+
+	ret = tracecmd_msg_create(MSG_SENDMETA, &msg);
+	if (ret < 0)
+		return ret;
+
+	n = size;
+	do {
+		if (n > TRACECMD_MSG_META_MAX_LEN) {
+			make_meta(buf+count, TRACECMD_MSG_META_MAX_LEN, msg);
+			n -= TRACECMD_MSG_META_MAX_LEN;
+			count += TRACECMD_MSG_META_MAX_LEN;
+		} else {
+			make_meta(buf+count, n, msg);
+			/*
+			 * TRACECMD_MSG_META_MAX_LEN is stored in msg->size,
+			 * so update the size to the correct value.
+			 */
+			len = TRACECMD_MSG_META_MIN_LEN + n;
+			msg->size = htonl(len);
+			n = 0;
+		}
+
+		ret = msg_do_write_check(fd, msg);
+		if (ret < 0)
+			break;
+	} while (n);
+
+	free(msg);
+	return ret;
+}
+
+int tracecmd_msg_finish_sending_metadata(int fd)
+{
+	int ret;
+
+	ret = tracecmd_msg_send(fd, MSG_FINMETA);
+	if (ret < 0)
+		return ret;
+
+	/* psfd will be used for closing */
+	psfd = fd;
+	return 0;
+}
+
+int tracecmd_msg_collect_metadata(int ifd, int ofd)
+{
+	struct tracecmd_msg *msg;
+	char buf[TRACECMD_MSG_MAX_LEN];
+	u32 s, t, n, cmd;
+	int offset = TRACECMD_MSG_META_MIN_LEN;
+	int ret;
+
+	msg = (struct tracecmd_msg *)buf;
+
+	do {
+		ret = tracecmd_msg_recv(ifd, msg);
+		if (ret < 0) {
+			warning("reading client");
+			return ret;
+		}
+
+		cmd = ntohl(msg->cmd);
+		if (cmd == MSG_FINMETA) {
+			/* Finish receiving meta data */
+			break;
+		} else if (cmd != MSG_SENDMETA)
+			goto error;
+
+		n = ntohl(msg->data.meta.str.size);
+		t = n;
+		s = 0;
+		do {
+			s = write(ofd, buf+s+offset, t);
+			if (s < 0) {
+				if (errno == EINTR)
+					continue;
+				warning("writing to file");
+				return -errno;
+			}
+			t -= s;
+			s = n - t;
+		} while (t);
+	} while (!done);
+
+	/* check the finish message of the client */
+	if (!done) {
+		ret = tracecmd_msg_recv(ifd, msg);
+		if (ret < 0) {
+			warning("reading client");
+			return ret;
+		}
+
+		msg = (struct tracecmd_msg *)buf;
+		cmd = ntohl(msg->cmd);
+		if (cmd != MSG_CLOSE) {
+			warning("Not accept the message %d", ntohl(msg->cmd));
+			ret = -EINVAL;
+			goto error;
+		}
+		/* Finish this connection */
+	}
+
+	return 0;
+
+error:
+	error_operation_for_server(msg);
+	return ret;
+}
diff --git a/trace-msg.h b/trace-msg.h
new file mode 100644
index 0000000..b23e72b
--- /dev/null
+++ b/trace-msg.h
@@ -0,0 +1,27 @@
+#ifndef _TRACE_MSG_H_
+#define _TRACE_MSG_H_
+
+#include <stdbool.h>
+
+#define UDP_MAX_PACKET	(65536 - 20)
+#define V2_MAGIC	"677768\0"
+
+#define V1_PROTOCOL	1
+#define V2_PROTOCOL	2
+
+/* for both client and server */
+extern bool use_tcp;
+extern int cpu_count;
+
+/* for client */
+extern unsigned int page_size;
+extern int *client_ports;
+extern bool send_metadata;
+
+/* for server */
+extern bool done;
+
+void plog(const char *fmt, ...);
+void pdie(const char *fmt, ...);
+
+#endif /* _TRACE_MSG_H_ */
diff --git a/trace-output.c b/trace-output.c
index b033baa..4661870 100644
--- a/trace-output.c
+++ b/trace-output.c
@@ -37,6 +37,7 @@
 
 #include "trace-cmd-local.h"
 #include "list.h"
+#include "trace-msg.h"
 #include "version.h"
 
 /* We can't depend on the host size for size_t, all must be 64 bit */
@@ -82,6 +83,9 @@ struct list_event_system {
 static stsize_t
 do_write_check(struct tracecmd_output *handle, void *data, tsize_t size)
 {
+	if (send_metadata)
+		return tracecmd_msg_metadata_send(handle->fd, data, size);
+
 	return __do_write_check(handle->fd, data, size);
 }
 
diff --git a/trace-record.c b/trace-record.c
index a3a07e1..19711df 100644
--- a/trace-record.c
+++ b/trace-record.c
@@ -45,6 +45,7 @@
 #include <errno.h>
 
 #include "trace-local.h"
+#include "trace-msg.h"
 
 #define _STR(x) #x
 #define STR(x) _STR(x)
@@ -59,25 +60,17 @@
 #define STAMP		"stamp"
 #define FUNC_STACK_TRACE "func_stack_trace"
 
-#define UDP_MAX_PACKET (65536 - 20)
-
 static int rt_prio;
 
-static int use_tcp;
-
-static unsigned int page_size;
-
 static const char *output_file = "trace.dat";
 
 static int latency;
 static int sleep_time = 1000;
-static int cpu_count;
 static int recorder_threads;
 static int *pids;
 static int buffers;
 
 static char *host;
-static int *client_ports;
 static int sfd;
 static struct tracecmd_output *network_handle;
 
@@ -99,6 +92,7 @@ static unsigned recorder_flags;
 /* Try a few times to get an accurate date */
 static int date2ts_tries = 5;
 
+static int proto_ver = V2_PROTOCOL;
 static struct func_list *graph_funcs;
 
 static int func_stack;
@@ -1821,20 +1815,26 @@ static int create_recorder(struct buffer_instance *instance, int cpu, int extrac
 	exit(0);
 }
 
-static void communicate_with_listener(int fd)
+static void check_first_msg_from_server(int fd)
 {
 	char buf[BUFSIZ];
-	ssize_t n;
-	int cpu, i;
 
-	n = read(fd, buf, 8);
+	read(fd, buf, 8);
 
 	/* Make sure the server is the tracecmd server */
 	if (memcmp(buf, "tracecmd", 8) != 0)
 		die("server not tracecmd server");
+}
 
-	/* write the number of CPUs we have (in ASCII) */
+static void communicate_with_listener_v1(int fd)
+{
+	char buf[BUFSIZ];
+	ssize_t n;
+	int cpu, i;
+
+	check_first_msg_from_server(fd);
 
+	/* write the number of CPUs we have (in ASCII) */
 	sprintf(buf, "%d", cpu_count);
 
 	/* include \0 */
@@ -1889,6 +1889,52 @@ static void communicate_with_listener(int fd)
 	}
 }
 
+static void communicate_with_listener_v2(int fd)
+{
+	if (tracecmd_msg_send_init_data(fd) < 0)
+		die("Cannot communicate with server");
+}
+
+static void check_protocol_version(int fd)
+{
+	char buf[BUFSIZ];
+	int ret;
+
+	check_first_msg_from_server(fd);
+
+	/*
+	 * Write dummy CPU number(-1) in order to make old server not create
+	 * zero length file, the protocol version(V2), the magic number,
+	 * and the dummy option(0) (in ASCII). The client understands whether
+	 * the client uses the v2 protocol or not by checking a reply message
+	 * from the server. If the message is "V2", the server uses v2
+	 * protocol. On the other hands, if the message is just number strings,
+	 * the server returned port numbers. So, in that time, the client
+	 * understands the server uses the v1 protocol. However, the old server
+	 * tells the client port numbers after reading cpu_count, page_size,
+	 * and option. So, we add the dummy number (the magic number and 0
+	 * option) to the first client message.
+	 */
+	ret = write(fd, "-1V2\0"V2_MAGIC"\0", strlen(V2_MAGIC)+6);
+	if (ret < 0)
+		die("Cannot send initial message");
+
+	/* read a reply message */
+	ret = read(fd, buf, BUFSIZ);
+	if (ret < 0) {
+		if (errno == ECONNRESET) {
+			/* the server uses the v1 protocol, so we'll use it */
+			proto_ver = V1_PROTOCOL;
+			plog("Use the v1 protocol\n");
+		} else
+			die("Cannot read initial message");
+	} else {
+		if (memcmp(buf, "V2", 2) != 0)
+			die("Cannot handle the protocol %s", buf);
+		/* OK, let's use v2 protocol */
+	}
+}
+
 static void setup_network(void)
 {
 	struct addrinfo hints;
@@ -1916,6 +1962,7 @@ static void setup_network(void)
 	hints.ai_family = AF_UNSPEC;
 	hints.ai_socktype = SOCK_STREAM;
 
+again:
 	s = getaddrinfo(server, port, &hints, &result);
 	if (s != 0)
 		die("getaddrinfo: %s", gai_strerror(s));
@@ -1936,16 +1983,32 @@ static void setup_network(void)
 
 	freeaddrinfo(result);
 
-	communicate_with_listener(sfd);
+	if (proto_ver == V2_PROTOCOL) {
+		check_protocol_version(sfd);
+		if (proto_ver == V1_PROTOCOL) {
+			/* reconnect to the server for using the v1 protocol */
+			close(sfd);
+			goto again;
+		}
+		communicate_with_listener_v2(sfd);
+	}
+
+	if (proto_ver == V1_PROTOCOL)
+		communicate_with_listener_v1(sfd);
 
 	/* Now create the handle through this socket */
 	network_handle = tracecmd_create_init_fd_glob(sfd, listed_events);
 
+	if (proto_ver == V2_PROTOCOL)
+		tracecmd_msg_finish_sending_metadata(sfd);
+
 	/* OK, we are all set, let'r rip! */
 }
 
 static void finish_network(void)
 {
+	if (proto_ver == V2_PROTOCOL)
+		tracecmd_msg_send_close_msg();
 	close(sfd);
 	free(host);
 }


