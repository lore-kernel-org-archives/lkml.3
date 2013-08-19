Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751363Ab3HSJnS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 05:43:18 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:32826 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab3HSJma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 05:42:30 -0400
X-AuditID: 85900ec0-d3b2cb9000001514-46-5211e8831bce
Subject: [RFC PATCH 10/11] trace-cmd: Add virt-server mode for a
 virtualization environment
To: Steven Rostedt <rostedt@goodmis.org>
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Date: Mon, 19 Aug 2013 18:46:44 +0900
Message-ID: <20130819094644.26597.18938.stgit@yunodevel>
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

Add the virt-server mode for a virtualization environment based on the listen
mode for networking. This mode works like client/server mode over TCP/UDP,
but it uses virtio-serial channel instead of IP network. Using networking for
collecting trace data of guests is generally high overhead caused by processing
of the network stack.

We use virtio-serial for collecting trace data of guests. virtio-serial is a
simple communication path between the guest and the host. Moreover,
since virtio-serial and ftrace can use splice(2), memory copying is not
occurred on the guests. Therefore, total overhead for collecting trace data
of the guests will be reduced. The implementation of guests will be shown
in another patch.

virt-server uses two kinds of virtio-serial I/Fs:
(1) agent-ctl-path(UNIX domain socket)
    => control path of an agent trace-cmd each guest
(2) trace-path-cpuX(named pipe)
    => trace data path each vcpu

Those I/Fs must be stored as follows:
(1) /tmp/trace-cmd/virt/agent-ctl-path
(2) /tmp/trace-cmd/virt/<guest domain>/trace-path-cpuX

If we run virt-server, agent-ctl-path I/F is automatically created because
virt-server operates as a server mode of UNIX domain socket. However,
trace-path-cpuX is not automatically created because we need to separate
trace data for each guests.

<How to set up>
1. Run virt-server on a host before booting guests
   # trace-cmd virt-server

2. Make guest domain directory
   # mkdir -p /tmp/trace-cmd/virt/<domain>
   # chmod 710 /tmp/trace-cmd/virt/<domain>
   # chgrp qemu /tmp/trace-cmd/virt/<domain>

3. Make FIFO on the host
   # mkfifo /tmp/trace-cmd/virt/<domain>/trace-path-cpu{0,1,...,X}.{in,out}

4. Set up of virtio-serial pipe of a guest on the host
   Add the following tags to domain XML files.
   # virsh edit <domain>
   <channel type='unix'>
      <source mode='connect' path='/tmp/trace-cmd/virt/agent-ctl-path'/>
      <target type='virtio' name='agent-ctl-path'/>
   </channel>
   <channel type='pipe'>
      <source path='/tmp/trace-cmd/virt/<domain>/trace-path-cpu0'/>
      <target type='virtio' name='trace-path-cpu0'/>
   </channel>
   ... (cpu1, cpu2, ...)

5. Boot the guest
   # virsh start <domain>

6. Check I/F of virtio-serial on the guest
   # ls /dev/virtio-ports
     ...
     agent-ctl-path
     ...
     trace-path-cpu0
     ...

Next, the user will run trace-cmd with record --virt options or other options
for virtualization on the guest.

This patch adds only minimum features of virt-server as follows:
<Features>
 - Add virt-server subcommand
 - Create I/F directory(/tmp/trace-cmd/virt/)
 - Use named pipe I/Fs of virtio-serial for trace data paths
 - Use UNIX domain socket for connecting agents on guests
 - Use splice(2) for collecting trace data of guests

<Restrictions>
 - Use libvirt when we boot guests

Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
---
 Documentation/trace-cmd-virt-server.1.txt |   89 ++++++
 trace-cmd.c                               |    3 
 trace-cmd.h                               |    4 
 trace-listen.c                            |  439 ++++++++++++++++++++++++-----
 trace-msg.c                               |   51 ++-
 trace-recorder.c                          |   54 +++-
 trace-usage.c                             |   10 +
 7 files changed, 540 insertions(+), 110 deletions(-)
 create mode 100644 Documentation/trace-cmd-virt-server.1.txt

diff --git a/Documentation/trace-cmd-virt-server.1.txt b/Documentation/trace-cmd-virt-server.1.txt
new file mode 100644
index 0000000..4168a04
--- /dev/null
+++ b/Documentation/trace-cmd-virt-server.1.txt
@@ -0,0 +1,89 @@
+TRACE-CMD-VIRT-SERVER(1)
+========================
+
+NAME
+----
+trace-cmd-virt-server - listen for incoming connection to record tracing of
+                        guests' clients
+
+SYNOPSIS
+--------
+*trace-cmd virt-server ['OPTIONS']
+
+DESCRIPTION
+-----------
+The trace-cmd(1) virt-server sets up UNIX domain socket I/F for communicating
+with guests' clients that run 'trace-cmd-record(1)' with the *--virt* option.
+When a connection is made, and the guest's client sends data, it will create a
+file called 'trace.DOMAIN.dat'. Where DOMAIN is the name of the guest named
+by libvirt.
+
+OPTIONS
+-------
+*-D*::
+    This options causes trace-cmd listen to go into a daemon mode and run in
+    the background.
+
+*-d* 'dir'::
+    This option specifies a directory to write the data files into.
+
+*-o* 'filename'::
+    This option overrides the default 'trace' in the 'trace.DOMAIN.dat' that
+    is created when guest's client connects.
+
+*-l* 'filename'::
+    This option writes the output messages to a log file instead of standard output.
+
+SET UP
+------
+Here, an example is written as follows:
+
+1. Run virt-server on a host
+   # trace-cmd virt-server
+
+2. Make guest domain directory
+   # mkdir -p /tmp/trace-cmd/virt/<DOMAIN>
+   # chmod 710 /tmp/trace-cmd/virt/<DOMAIN>
+   # chgrp qemu /tmp/trace-cmd/virt/<DOMAIN>
+
+3. Make FIFO on the host
+   # mkfifo /tmp/trace-cmd/virt/<DOMAIN>/trace-path-cpu{0,1,...,X}.{in,out}
+
+4. Set up of virtio-serial pipe of a guest on the host
+   Add the following tags to domain XML files.
+   # virsh edit <guest domain>
+   <channel type='unix'>
+      <source mode='connect' path='/tmp/trace-cmd/virt/agent-ctl-path'/>
+      <target type='virtio' name='agent-ctl-path'/>
+   </channel>
+   <channel type='pipe'>
+      <source path='/tmp/trace-cmd/virt/<DOMAIN>/trace-path-cpu0'/>
+      <target type='virtio' name='trace-path-cpu0'/>
+   </channel>
+   ... (cpu1, cpu2, ...)
+
+5. Boot the guest
+   # virsh start <DOMAIN>
+
+6. Run the guest's client(see trace-cmd-record(1) with the *--virt* option)
+   # trace-cmd record -e sched* --virt
+
+SEE ALSO
+--------
+trace-cmd(1), trace-cmd-record(1), trace-cmd-report(1), trace-cmd-start(1),
+trace-cmd-stop(1), trace-cmd-extract(1), trace-cmd-reset(1),
+trace-cmd-split(1), trace-cmd-list(1)
+
+AUTHOR
+------
+Written by Yoshihiro YUNOMAE, <yoshihiro.yunomae.ex@hitachi.com>
+
+RESOURCES
+---------
+git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git
+
+COPYING
+-------
+Copyright \(C) 2013 Hitachi, Ltd. Free use of this software is granted under
+the terms of the GNU Public License (GPL).
+
diff --git a/trace-cmd.c b/trace-cmd.c
index e6f5918..45a5bb4 100644
--- a/trace-cmd.c
+++ b/trace-cmd.c
@@ -219,7 +219,8 @@ int main (int argc, char **argv)
 	} else if (strcmp(argv[1], "mem") == 0) {
 		trace_mem(argc, argv);
 		exit(0);
-	} else if (strcmp(argv[1], "listen") == 0) {
+	} else if (strcmp(argv[1], "listen") == 0 ||
+		   strcmp(argv[1], "virt-server") == 0) {
 		trace_listen(argc, argv);
 		exit(0);
 	} else if (strcmp(argv[1], "split") == 0) {
diff --git a/trace-cmd.h b/trace-cmd.h
index 5ae5313..b4c2267 100644
--- a/trace-cmd.h
+++ b/trace-cmd.h
@@ -242,6 +242,8 @@ struct tracecmd_recorder *tracecmd_create_recorder_maxkb(const char *file, int c
 struct tracecmd_recorder *tracecmd_create_buffer_recorder_fd(int fd, int cpu, unsigned flags, const char *buffer);
 struct tracecmd_recorder *tracecmd_create_buffer_recorder(const char *file, int cpu, unsigned flags, const char *buffer);
 struct tracecmd_recorder *tracecmd_create_buffer_recorder_maxkb(const char *file, int cpu, unsigned flags, const char *buffer, int maxkb);
+struct tracecmd_recorder *tracecmd_create_recorder_virt(const char *file,
+							int cpu, int trace_fd);
 
 int tracecmd_start_recording(struct tracecmd_recorder *recorder, unsigned long sleep);
 void tracecmd_stop_recording(struct tracecmd_recorder *recorder);
@@ -255,7 +257,7 @@ int tracecmd_msg_finish_sending_metadata(int fd);
 void tracecmd_msg_send_close_msg();
 
 /* for server */
-int tracecmd_msg_set_connection(int fd);
+int tracecmd_msg_set_connection(int fd, bool nw);
 int tracecmd_msg_initial_setting(int fd, int *cpus, int *pagesize);
 int tracecmd_msg_send_port_array(int fd, int total_cpus, int *ports);
 int tracecmd_msg_collect_metadata(int ifd, int ofd);
diff --git a/trace-listen.c b/trace-listen.c
index 3cec10c..3105903 100644
--- a/trace-listen.c
+++ b/trace-listen.c
@@ -23,9 +23,13 @@
 #include <stdlib.h>
 #include <string.h>
 #include <getopt.h>
+#include <grp.h>
+#include <sys/stat.h>
 #include <sys/types.h>
 #include <sys/socket.h>
 #include <sys/wait.h>
+#include <sys/epoll.h>
+#include <sys/un.h>
 #include <netdb.h>
 #include <unistd.h>
 #include <fcntl.h>
@@ -46,15 +50,23 @@ static int debug;
 
 static int backlog = 5;
 
-#define  TEMP_FILE_STR "%s.%s:%s.cpu%d", output_file, host, port, cpu
-static char *get_temp_file(const char *host, const char *port, int cpu)
+#define  TEMP_FILE_STR_NW "%s.%s:%s.cpu%d", output_file, host, port, cpu
+#define  TEMP_FILE_STR_VIRT "%s.%s:%d.cpu%d", output_file, domain, virtpid, cpu
+static char *get_temp_file(const char *host, const char *port,
+			   const char *domain, int virtpid, int cpu)
 {
 	char *file = NULL;
 	int size;
 
-	size = snprintf(file, 0, TEMP_FILE_STR);
-	file = malloc_or_die(size + 1);
-	sprintf(file, TEMP_FILE_STR);
+	if (host) {
+		size = snprintf(file, 0, TEMP_FILE_STR_NW);
+		file = malloc_or_die(size + 1);
+		sprintf(file, TEMP_FILE_STR_NW);
+	} else {
+		size = snprintf(file, 0, TEMP_FILE_STR_VIRT);
+		file = malloc_or_die(size + 1);
+		sprintf(file, TEMP_FILE_STR_VIRT);
+	}
 
 	return file;
 }
@@ -77,16 +89,23 @@ static void signal_setup(int sig, sighandler_t handle)
 	sigaction(sig, &action, NULL);
 }
 
-static void delete_temp_file(const char *host, const char *port, int cpu)
+static void delete_temp_file(const char *host, const char *port,
+			     const char *domain, int virtpid, int cpu)
 {
 	char file[MAX_PATH];
 
-	snprintf(file, MAX_PATH, TEMP_FILE_STR);
+	if (host)
+		snprintf(file, MAX_PATH, TEMP_FILE_STR_NW);
+	else
+		snprintf(file, MAX_PATH, TEMP_FILE_STR_VIRT);
 	unlink(file);
 }
 
+static struct tracecmd_recorder *recorder;
 static void finish(int sig)
 {
+	if (recorder)
+		tracecmd_stop_recording(recorder);
 	done = true;
 }
 
@@ -156,7 +175,7 @@ static void process_udp_child(int sfd, const char *host, const char *port,
 
 	signal_setup(SIGUSR1, finish);
 
-	tempfile = get_temp_file(host, port, cpu);
+	tempfile = get_temp_file(host, port, NULL, 0, cpu);
 	fd = open(tempfile, O_WRONLY | O_TRUNC | O_CREAT, 0644);
 	if (fd < 0)
 		pdie("creating %s", tempfile);
@@ -197,6 +216,28 @@ static void process_udp_child(int sfd, const char *host, const char *port,
 	exit(0);
 }
 
+#define SLEEP_DEFAULT	1000
+
+static void process_virt_child(int fd, int cpu, int pagesize,
+			       const char *domain, int virtpid)
+{
+	char *tempfile;
+
+	signal_setup(SIGUSR1, finish);
+	tempfile = get_temp_file(NULL, NULL, domain, virtpid, cpu);
+
+	recorder = tracecmd_create_recorder_virt(tempfile, cpu, fd);
+
+	do {
+		if (tracecmd_start_recording(recorder, SLEEP_DEFAULT) < 0)
+			break;
+	} while (!done);
+
+	tracecmd_free_recorder(recorder);
+	put_temp_file(tempfile);
+	exit(0);
+}
+
 #define START_PORT_SEARCH 1500
 #define MAX_PORT_SEARCH 6000
 
@@ -244,20 +285,37 @@ static int udp_bind_a_port(int start_port, int *sfd)
 	return num_port;
 }
 
-static void fork_udp_reader(int sfd, const char *node, const char *port,
-			    int *pid, int cpu, int pagesize)
+static void fork_reader(int sfd, const char *node, const char *port,
+			int *pid, int cpu, int pagesize, const char *domain,
+			int virtpid)
 {
 	*pid = fork();
 
 	if (*pid < 0)
-		pdie("creating udp reader");
+		pdie("creating reader");
 
-	if (!*pid)
-		process_udp_child(sfd, node, port, cpu, pagesize);
+	if (!*pid) {
+		if (node)
+			process_udp_child(sfd, node, port, cpu, pagesize);
+		else
+			process_virt_child(sfd, cpu, pagesize, domain, virtpid);
+	}
 
 	close(sfd);
 }
 
+static void fork_udp_reader(int sfd, const char *node, const char *port,
+			    int *pid, int cpu, int pagesize)
+{
+	fork_reader(sfd, node, port, pid, cpu, pagesize, NULL, 0);
+}
+
+static void fork_virt_reader(int sfd, int *pid, int cpu, int pagesize,
+			     const char *domain, int virtpid)
+{
+	fork_reader(sfd, NULL, NULL, pid, cpu, pagesize, domain, virtpid);
+}
+
 static int open_udp(const char *node, const char *port, int *pid,
 		    int cpu, int pagesize, int start_port)
 {
@@ -273,10 +331,33 @@ static int open_udp(const char *node, const char *port, int *pid,
 	return num_port;
 }
 
-static int communicate_with_client(int fd, int *cpus, int *pagesize)
+#define TRACE_CMD_DIR		"/tmp/trace-cmd/"
+#define VIRT_DIR		TRACE_CMD_DIR "virt/"
+#define VIRT_TRACE_CTL_SOCK	VIRT_DIR "agent-ctl-path"
+#define TRACE_PATH_DOMAIN_CPU	VIRT_DIR "%s/trace-path-cpu%d.out"
+
+static int open_virtio_serial_pipe(int *pid, int cpu, int pagesize,
+				   const char *domain, int virtpid)
+{
+	char buf[PATH_MAX];
+	int fd;
+
+	snprintf(buf, PATH_MAX, TRACE_PATH_DOMAIN_CPU, domain, cpu);
+	fd = open(buf, O_RDONLY | O_NONBLOCK);
+	if (fd < 0) {
+		warning("open %s", buf);
+		return fd;
+	}
+
+	fork_virt_reader(fd, pid, cpu, pagesize, domain, virtpid);
+
+	return fd;
+}
+
+static int communicate_with_client(int fd, int *cpus, int *pagesize, bool nw)
 {
 	/* Let the client know what we are */
-	if (tracecmd_msg_set_connection(fd) < 0)
+	if (tracecmd_msg_set_connection(fd, nw) < 0)
 		return -1;
 
 	/* read the CPU count, the page size, and options */
@@ -289,12 +370,26 @@ static int communicate_with_client(int fd, int *cpus, int *pagesize)
 	return 0;
 }
 
-static int create_client_file(const char *node, const char *port)
+static int communicate_with_client_nw(int fd, int *cpus, int *pagesize)
+{
+	return communicate_with_client(fd, cpus, pagesize, true);
+}
+
+static int communicate_with_client_virt(int fd, int *cpus, int *pagesize)
+{
+	return communicate_with_client(fd, cpus, pagesize, false);
+}
+
+static int create_client_file(const char *node, const char *port,
+			      const char *domain, int pid)
 {
 	char buf[BUFSIZ];
 	int ofd;
 
-	snprintf(buf, BUFSIZ, "%s.%s:%s.dat", output_file, node, port);
+	if (node)
+		snprintf(buf, BUFSIZ, "%s.%s:%s.dat", output_file, node, port);
+	else
+		snprintf(buf, BUFSIZ, "%s.%s:%d.dat", output_file, domain, pid);
 
 	ofd = open(buf, O_RDWR | O_CREAT | O_TRUNC, 0644);
 	if (ofd < 0)
@@ -303,7 +398,8 @@ static int create_client_file(const char *node, const char *port)
 }
 
 static void destroy_all_readers(int cpus, int *pid_array, const char *node,
-				const char *port)
+				const char *port, const char *domain,
+				int virtpid)
 {
 	int cpu;
 
@@ -311,41 +407,49 @@ static void destroy_all_readers(int cpus, int *pid_array, const char *node,
 		if (pid_array[cpu] > 0) {
 			kill(pid_array[cpu], SIGKILL);
 			waitpid(pid_array[cpu], NULL, 0);
-			delete_temp_file(node, port, cpu);
+			delete_temp_file(node, port, domain, virtpid, cpu);
 			pid_array[cpu] = 0;
 		}
 	}
 }
 
 static int *create_all_readers(int cpus, const char *node, const char *port,
-			       int pagesize, int fd)
+			       const char *domain, int virtpid, int pagesize,
+			       int fd)
 {
-	int *port_array;
+	int *port_array = NULL;
 	int *pid_array;
 	int start_port;
 	int udp_port;
 	int cpu;
 	int pid;
 
-	port_array = malloc_or_die(sizeof(int) * cpus);
+	if (node) {
+		port_array = malloc_or_die(sizeof(int) * cpus);
+		start_port = START_PORT_SEARCH;
+	}
 	pid_array = malloc_or_die(sizeof(int) * cpus);
 	memset(pid_array, 0, sizeof(int) * cpus);
 
-	start_port = START_PORT_SEARCH;
-
-	/* Now create a UDP port for each CPU */
+	/* Now create a reader for each CPU */
 	for (cpu = 0; cpu < cpus; cpu++) {
-		udp_port = open_udp(node, port, &pid, cpu,
-				    pagesize, start_port);
-		if (udp_port < 0)
-			goto out_free;
-		port_array[cpu] = udp_port;
+		if (node) {
+			udp_port = open_udp(node, port, &pid, cpu,
+					    pagesize, start_port);
+			if (udp_port < 0)
+				goto out_free;
+			port_array[cpu] = udp_port;
+			/*
+			 * due to some bugging finding ports,
+			 * force search after last port
+			 */
+			start_port = udp_port + 1;
+		} else {
+			if (open_virtio_serial_pipe(&pid, cpu, pagesize,
+						    domain, virtpid) < 0)
+				goto out_free;
+		}
 		pid_array[cpu] = pid;
-		/*
-		 * due to some bugging finding ports,
-		 * force search after last port
-		 */
-		start_port = udp_port + 1;
 	}
 
 	/* send set of port numbers to the client */
@@ -355,7 +459,7 @@ static int *create_all_readers(int cpus, const char *node, const char *port,
 	return pid_array;
 
  out_free:
-	destroy_all_readers(cpus, pid_array, node, port);
+	destroy_all_readers(cpus, pid_array, node, port, domain, virtpid);
 	return NULL;
 }
 
@@ -370,7 +474,7 @@ static void stop_all_readers(int cpus, int *pid_array)
 }
 
 static void put_together_file(int cpus, int ofd, const char *node,
-			      const char *port)
+			      const char *port, const char *domain, int virtpid)
 {
 	char **temp_files;
 	int cpu;
@@ -379,25 +483,32 @@ static void put_together_file(int cpus, int ofd, const char *node,
 	temp_files = malloc_or_die(sizeof(*temp_files) * cpus);
 
 	for (cpu = 0; cpu < cpus; cpu++)
-		temp_files[cpu] = get_temp_file(node, port, cpu);
+		temp_files[cpu] = get_temp_file(node, port, domain,
+						virtpid, cpu);
 
 	tracecmd_attach_cpu_data_fd(ofd, cpus, temp_files);
 	free(temp_files);
 }
 
-static void process_client(const char *node, const char *port, int fd)
+static void process_client(const char *node, const char *port,
+			   const char *domain, int virtpid, int fd)
 {
 	int *pid_array;
 	int pagesize;
 	int cpus;
 	int ofd;
 
-	if (communicate_with_client(fd, &cpus, &pagesize) < 0)
-		return;
-
-	ofd = create_client_file(node, port);
+	if (node) {
+		if (communicate_with_client_nw(fd, &cpus, &pagesize) < 0)
+			return;
+	} else {
+		if (communicate_with_client_virt(fd, &cpus, &pagesize) < 0)
+			return;
+	}
 
-	pid_array = create_all_readers(cpus, node, port, pagesize, fd);
+	ofd = create_client_file(node, port, domain, virtpid);
+	pid_array = create_all_readers(cpus, node, port, domain, virtpid,
+				       pagesize, fd);
 	if (!pid_array)
 		return;
 
@@ -413,9 +524,22 @@ static void process_client(const char *node, const char *port, int fd)
 	/* wait a little to have the readers clean up */
 	sleep(1);
 
-	put_together_file(cpus, ofd, node, port);
+	put_together_file(cpus, ofd, node, port, domain, virtpid);
+
+	destroy_all_readers(cpus, pid_array, node, port, domain, virtpid);
+}
+
+static void process_client_nw(const char *node, const char *port, int fd)
+{
+	process_client(node, port, NULL, 0, fd);
+}
 
-	destroy_all_readers(cpus, pid_array, node, port);
+static void process_client_virt(const char *domain, int virtpid, int fd)
+{
+	/* keep connection to qemu if clients on guests finish operation */
+	do {
+		process_client(NULL, NULL, domain, virtpid, fd);
+	} while (!done);
 }
 
 static int do_fork(int cfd)
@@ -442,8 +566,9 @@ static int do_fork(int cfd)
 	return 0;
 }
 
-static int do_connection(int cfd, struct sockaddr_storage *peer_addr,
-			  socklen_t peer_addr_len)
+static int do_connection(int cfd, struct sockaddr *peer_addr,
+			 socklen_t *peer_addr_len, const char *domain,
+			 int virtpid)
 {
 	char host[NI_MAXHOST], service[NI_MAXSERV];
 	int s;
@@ -453,21 +578,22 @@ static int do_connection(int cfd, struct sockaddr_storage *peer_addr,
 	if (ret)
 		return ret;
 
-	s = getnameinfo((struct sockaddr *)peer_addr, peer_addr_len,
-			host, NI_MAXHOST,
-			service, NI_MAXSERV, NI_NUMERICSERV);
-
-	if (s == 0)
-		plog("Connected with %s:%s\n",
-		       host, service);
-	else {
-		plog("Error with getnameinfo: %s\n",
-		       gai_strerror(s));
-		close(cfd);
-		return -1;
-	}
-
-	process_client(host, service, cfd);
+	if (peer_addr) {
+		s = getnameinfo(peer_addr, *peer_addr_len, host, NI_MAXHOST,
+				service, NI_MAXSERV, NI_NUMERICSERV);
+	
+		if (s == 0)
+			plog("Connected with %s:%s\n",
+			       host, service);
+		else {
+			plog("Error with getnameinfo: %s\n",
+			       gai_strerror(s));
+			close(cfd);
+			return -1;
+		}
+		process_client_nw(host, service, cfd);
+	} else
+		process_client_virt(domain, virtpid, cfd);
 
 	close(cfd);
 
@@ -477,6 +603,77 @@ static int do_connection(int cfd, struct sockaddr_storage *peer_addr,
 	return 0;
 }
 
+static int do_connection_nw(int cfd, struct sockaddr *addr, socklen_t *addrlen)
+{
+	return do_connection(cfd, addr, addrlen, NULL, 0);
+}
+
+#define LIBVIRT_DOMAIN_PATH     "/var/run/libvirt/qemu/"
+
+/* We can convert pid to domain name of a guest when we use libvirt. */
+static char *get_guest_domain_from_pid(int pid)
+{
+	struct dirent *dirent;
+	char file_name[NAME_MAX];
+	char *file_name_ret, *domain;
+	char buf[BUFSIZ];
+	DIR *dir;
+	size_t doml;
+	int fd;
+
+	dir = opendir(LIBVIRT_DOMAIN_PATH);
+	if (!dir) {
+		if (errno == ENOENT)
+			warning("Only support for using libvirt");
+		return NULL;
+	}
+
+	for (dirent = readdir(dir); dirent != NULL; dirent = readdir(dir)) {
+		snprintf(file_name, NAME_MAX, LIBVIRT_DOMAIN_PATH"%s",
+			 dirent->d_name);
+		file_name_ret = strstr(file_name, ".pid");
+		if (file_name_ret) {
+			fd = open(file_name, O_RDONLY);
+			if (fd < 0)
+				return NULL;
+			if (read(fd, buf, BUFSIZ) < 0)
+				return NULL;
+
+			if (pid == atoi(buf)) {
+				/* not include /var/run/libvirt/qemu */
+				doml = (size_t)(file_name_ret - file_name)
+					- strlen(LIBVIRT_DOMAIN_PATH);
+				domain = strndup(file_name +
+						 strlen(LIBVIRT_DOMAIN_PATH),
+						 doml);
+				plog("start %s\n", domain);
+				return domain;
+			}
+		}
+	}
+
+	return NULL;
+}
+
+static int do_connection_virt(int cfd)
+{
+	struct ucred cr;
+	socklen_t cl;
+	int ret;
+	char *domain;
+
+	cl = sizeof(cr);
+	ret = getsockopt(cfd, SOL_SOCKET, SO_PEERCRED, &cr, &cl);
+	if (ret < 0)
+		return ret;
+
+	domain = get_guest_domain_from_pid(cr.pid);
+	if (!domain)
+		return -1;
+
+	return do_connection(cfd, NULL, NULL, domain, cr.pid);
+}
+
 static int *client_pids;
 static int saved_pids;
 static int size_pids;
@@ -521,12 +718,11 @@ static void remove_process(int pid)
 
 static void kill_clients(void)
 {
-	int status;
 	int i;
 
 	for (i = 0; i < saved_pids; i++) {
 		kill(client_pids[i], SIGINT);
-		waitpid(client_pids[i], &status, 0);
+		waitpid(client_pids[i], NULL, 0);
 	}
 
 	saved_pids = 0;
@@ -545,31 +741,51 @@ static void clean_up(int sig)
 	} while (ret > 0);
 }
 
-static void do_accept_loop(int sfd)
+static void do_accept_loop(int sfd, bool nw, struct sockaddr *addr,
+			   socklen_t *addrlen)
 {
-	struct sockaddr_storage peer_addr;
-	socklen_t peer_addr_len;
 	int cfd, pid;
 
-	peer_addr_len = sizeof(peer_addr);
-
 	do {
-		cfd = accept(sfd, (struct sockaddr *)&peer_addr,
-			     &peer_addr_len);
+		cfd = accept(sfd, addr, addrlen);
 		printf("connected!\n");
 		if (cfd < 0 && errno == EINTR)
 			continue;
 		if (cfd < 0)
 			pdie("connecting");
 
-		pid = do_connection(cfd, &peer_addr, peer_addr_len);
+		if (nw)
+			pid = do_connection_nw(cfd, addr, addrlen);
+		else
+			pid = do_connection_virt(cfd);
 		if (pid > 0)
 			add_process(pid);
 
 	} while (!done);
 }
 
-static void do_listen(char *port)
+static void do_accept_loop_nw(int sfd)
+{
+	struct sockaddr_storage peer_addr;
+	socklen_t peer_addr_len;
+
+	peer_addr_len = sizeof(peer_addr);
+
+	do_accept_loop(sfd, true, (struct sockaddr *)&peer_addr,
+		       &peer_addr_len);
+}
+
+static void do_accept_loop_virt(int sfd)
+{
+	struct sockaddr_un un_addr;
+	socklen_t un_addrlen;
+
+	un_addrlen = sizeof(un_addr);
+
+	do_accept_loop(sfd, false, (struct sockaddr *)&un_addr, &un_addrlen);
+}
+
+static void do_listen_nw(char *port)
 {
 	struct addrinfo hints;
 	struct addrinfo *result, *rp;
@@ -607,8 +823,64 @@ static void do_listen(char *port)
 	if (listen(sfd, backlog) < 0)
 		pdie("listen");
 
-	do_accept_loop(sfd);
+	do_accept_loop_nw(sfd);
+
+	kill_clients();
+}
+
+static void make_virt_if_dir(void)
+{
+	struct group *group;
+
+	if (mkdir(TRACE_CMD_DIR, 0710) < 0) {
+		if (errno != EEXIST)
+			pdie("mkdir %s", TRACE_CMD_DIR);
+	}
+	/* QEMU operates as qemu:qemu */
+	chmod(TRACE_CMD_DIR, 0710);
+	group = getgrnam("qemu");
+	if (chown(TRACE_CMD_DIR, -1, group->gr_gid) < 0)
+		pdie("chown %s", TRACE_CMD_DIR);
+
+	if (mkdir(VIRT_DIR, 0710) < 0) {
+		if (errno != EEXIST)
+			pdie("mkdir %s", VIRT_DIR);
+	}
+	chmod(VIRT_DIR, 0710);
+	if (chown(VIRT_DIR, -1, group->gr_gid) < 0)
+		pdie("chown %s", VIRT_DIR);
+}
+
+static void do_listen_virt(void)
+{
+	struct sockaddr_un un_server;
+	struct group *group;
+	socklen_t slen;
+	int sfd;
+
+	make_virt_if_dir();
+
+	slen = sizeof(un_server);
+	sfd = socket(AF_UNIX, SOCK_STREAM, 0);
+	if (sfd < 0)
+		pdie("socket");
+
+	un_server.sun_family = AF_UNIX;
+	snprintf(un_server.sun_path, PATH_MAX, VIRT_TRACE_CTL_SOCK);
+
+	if (bind(sfd, (struct sockaddr *)&un_server, slen) < 0)
+		pdie("bind");
+	chmod(VIRT_TRACE_CTL_SOCK, 0660);
+	group = getgrnam("qemu");
+	if (chown(VIRT_TRACE_CTL_SOCK, -1, group->gr_gid) < 0)
+		pdie("fchown %s", VIRT_TRACE_CTL_SOCK);
+
+	if (listen(sfd, backlog) < 0)
+		pdie("listen");
+
+	do_accept_loop_virt(sfd);
 
+	unlink(VIRT_TRACE_CTL_SOCK);
 	kill_clients();
 }
 
@@ -628,11 +900,17 @@ void trace_listen(int argc, char **argv)
 	char *port = NULL;
 	int daemon = 0;
 	int c;
+	int nw = 0;
+	int virt = 0;
 
 	if (argc < 2)
 		usage(argv);
 
-	if (strcmp(argv[1], "listen") != 0)
+	if ((nw = (strcmp(argv[1], "listen") == 0)))
+		; /* do nothing */
+	else if ((virt = (strcmp(argv[1], "virt-server") == 0)))
+		; /* do nothing */
+	else
 		usage(argv);
 
 	for (;;) {
@@ -653,6 +931,8 @@ void trace_listen(int argc, char **argv)
 			usage(argv);
 			break;
 		case 'p':
+			if (virt)
+				die("-p only available with listen");
 			port = optarg;
 			break;
 		case 'd':
@@ -675,7 +955,7 @@ void trace_listen(int argc, char **argv)
 		}
 	}
 
-	if (!port)
+	if (!port && nw)
 		usage(argv);
 
 	if ((argc - optind) >= 2)
@@ -703,7 +983,10 @@ void trace_listen(int argc, char **argv)
 	signal_setup(SIGINT, finish);
 	signal_setup(SIGTERM, finish);
 
-	do_listen(port);
+	if (nw)
+		do_listen_nw(port);
+	else
+		do_listen_virt();
 
 	return;
 }
diff --git a/trace-msg.c b/trace-msg.c
index 36117cd..251e99c 100644
--- a/trace-msg.c
+++ b/trace-msg.c
@@ -249,11 +249,13 @@ static int make_rinit(struct tracecmd_msg *msg)
 
 	msg->data.rinit.cpus = htonl(cpu_count);
 
-	for (i = 0; i < cpu_count; i++) {
-		/* + rrqports->cpus or rrqports->port_array[i] */
-		offset += sizeof(be32);
-		port = htonl(port_array[i]);
-		bufcpy(msg, offset, &port, sizeof(be32) * cpu_count);
+	if (port_array) {
+		for (i = 0; i < cpu_count; i++) {
+			/* + rrqports->cpus or rrqports->port_array[i] */
+			offset += sizeof(be32);
+			port = htonl(port_array[i]);
+			bufcpy(msg, offset, &port, sizeof(be32) * cpu_count);
+		}
 	}
 
 	return 0;
@@ -565,22 +567,41 @@ static void error_operation_for_server(struct tracecmd_msg *msg)
 		warning("Message: cmd=%d size=%d\n", cmd, ntohl(msg->size));
 }
 
-int tracecmd_msg_set_connection(int fd)
+int tracecmd_msg_set_connection(int fd, bool nw)
 {
 	struct tracecmd_msg *msg;
-	char buf[TRACECMD_MSG_MAX_LEN];
+	char buf[TRACECMD_MSG_MAX_LEN] = {};
 	u32 cmd;
 	int ret;
 
 	/* wait for connection msg by a client first */
-	ret = tracecmd_msg_recv_wait(fd, buf, &msg);
-	if (ret < 0) {
-		if (ret == -ETIMEDOUT)
-			/* network connection will be started soon */
-			warning("No connection message");
-		else
-			warning("Disconnect");
-		return ret;
+	if (nw) {
+		ret = tracecmd_msg_recv_wait(fd, buf, &msg);
+		if (ret < 0) {
+			if (ret == -ETIMEDOUT)
+				/* network connection will be started soon */
+				warning("No connection message");
+			else
+				warning("Disconnect");
+			return ret;
+		}
+	} else {
+		/*
+		 * If a client uses virtio-serial, a connection message will
+		 * not be sent immediately after accept(). connect() is called
+		 * in QEMU, so the client can send the connection message
+		 * after guest boots. Therefore, the virt-server patiently
+		 * waits for the connection request of a client.
+		 */ 
+		ret = tracecmd_msg_recv(fd, buf);
+		if (ret < 0) {
+			if (!buf[0]) {
+				/* No data means QEMU has already died. */
+				close(fd);
+				die("Connection refuesd");
+			}
+			return -ENOMSG;
+		}
 	}
 
 	msg = (struct tracecmd_msg *)buf;
diff --git a/trace-recorder.c b/trace-recorder.c
index 520d486..8169dc3 100644
--- a/trace-recorder.c
+++ b/trace-recorder.c
@@ -149,19 +149,23 @@ tracecmd_create_buffer_recorder_fd2(int fd, int fd2, int cpu, unsigned flags,
 	recorder->fd1 = fd;
 	recorder->fd2 = fd2;
 
-	path = malloc_or_die(strlen(buffer) + 40);
-	if (!path)
-		goto out_free;
-
-	if (flags & TRACECMD_RECORD_SNAPSHOT)
-		sprintf(path, "%s/per_cpu/cpu%d/snapshot_raw", buffer, cpu);
-	else
-		sprintf(path, "%s/per_cpu/cpu%d/trace_pipe_raw", buffer, cpu);
-	recorder->trace_fd = open(path, O_RDONLY);
-	if (recorder->trace_fd < 0)
-		goto out_free;
-
-	free(path);
+	if (buffer) {
+		path = malloc_or_die(strlen(buffer) + 40);
+		if (!path)
+			goto out_free;
+	
+		if (flags & TRACECMD_RECORD_SNAPSHOT)
+			sprintf(path, "%s/per_cpu/cpu%d/snapshot_raw",
+				buffer, cpu);
+		else
+			sprintf(path, "%s/per_cpu/cpu%d/trace_pipe_raw",
+				buffer, cpu);
+		recorder->trace_fd = open(path, O_RDONLY);
+		if (recorder->trace_fd < 0)
+			goto out_free;
+	
+		free(path);
+	}
 
 	if ((recorder->flags & TRACECMD_RECORD_NOSPLICE) == 0) {
 		ret = pipe(recorder->brass);
@@ -184,8 +188,9 @@ tracecmd_create_buffer_recorder_fd(int fd, int cpu, unsigned flags, const char *
 	return tracecmd_create_buffer_recorder_fd2(fd, -1, cpu, flags, buffer, 0);
 }
 
-struct tracecmd_recorder *
-tracecmd_create_buffer_recorder(const char *file, int cpu, unsigned flags, const char *buffer)
+static struct tracecmd_recorder *
+__tracecmd_create_buffer_recorder(const char *file, int cpu, unsigned flags,
+				  const char *buffer)
 {
 	struct tracecmd_recorder *recorder;
 	int fd;
@@ -248,6 +253,25 @@ tracecmd_create_buffer_recorder_maxkb(const char *file, int cpu, unsigned flags,
 	goto out;
 }
 
+struct tracecmd_recorder *
+tracecmd_create_buffer_recorder(const char *file, int cpu, unsigned flags,
+				const char *buffer)
+{
+	return __tracecmd_create_buffer_recorder(file, cpu, flags, buffer);
+}
+
+struct tracecmd_recorder *
+tracecmd_create_recorder_virt(const char *file, int cpu, int trace_fd)
+{
+	struct tracecmd_recorder *recorder;
+
+	recorder = __tracecmd_create_buffer_recorder(file, cpu, 0, NULL);
+	if (recorder)
+		recorder->trace_fd = trace_fd;
+
+	return recorder;
+}
+
 struct tracecmd_recorder *tracecmd_create_recorder_fd(int fd, int cpu, unsigned flags)
 {
 	char *tracing;
diff --git a/trace-usage.c b/trace-usage.c
index b8f26e6..e6a239f 100644
--- a/trace-usage.c
+++ b/trace-usage.c
@@ -153,6 +153,16 @@ static struct usage_help usage_help[] = {
 		"	   -l logfile to write messages to.\n"
 	},
 	{
+		"virt-server",
+		"listen on a virtio-serial for trace clients",
+		" %s virt-server [-o file][-d dir][-l logfile]\n"
+		"          Creates a socket to listen for clients.\n"
+		"          -D create it in daemon mode.\n"
+		"          -o file name to use for clients.\n"
+		"          -d diretory to store client files.\n"
+		"	   -l logfile to write messages to.\n"
+	},
+	{
 		"list",
 		"list the available events, plugins or options",
 		" %s list [-e][-t][-o][-f [regex]]\n"

