Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895Ab3LQDBU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 22:01:20 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:59261 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705Ab3LQDAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 22:00:31 -0500
X-AuditID: 85900ec0-d1d29b9000001514-b2-52afbe4ced35
Subject: [PATCH V3 4/6] trace-cmd: Add virt-server mode for a virtualization
 environment
To: Steven Rostedt <rostedt@goodmis.org>
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Aaron Fabbri <aaronx.j.fabbri@intel.com>, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com
Date: Tue, 17 Dec 2013 12:00:27 +0900
Message-ID: <20131217030027.31730.95950.stgit@yunodevel>
In-Reply-To: <20131217030017.31730.66046.stgit@yunodevel>
References: <20131217030017.31730.66046.stgit@yunodevel>
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
of the guests will be reduced. The implementation of clients will be shown
in another patch.

virt-server uses two kinds of virtio-serial I/Fs:
(1) agent-ctl-path(UNIX domain socket)
    => control path of an agent trace-cmd each guest
(2) trace-path-cpuX(named pipe)
    => trace data path each vcpu

Those I/Fs must be defined as below paths:
(1) /tmp/trace-cmd/virt/agent-ctl-path
(2) /tmp/trace-cmd/virt/<guest domain>/trace-path-cpuX

If we run virt-server, agent-ctl-path I/F is automatically created because
virt-server operates as a server mode of UNIX domain socket. However,
trace-path-cpuX is not automatically created because we need to separate
trace data for each guests.

When the client uses virtio-serial, the client must notify the server of the
connection. This is because a virtio-serial I/F on the guest is a just character
device. In other words, the server cannot understand whether the client exists
or not even if the client opens the I/F. So, the server using virtio-serial
waits for the connection message MSG_TCONNECT from the client.
The server and the client operate as follows:

     <server>                 <client>
      wait for MSG_TCONNECT
                              open virtio-serial I/F
                              send MSG_TCONNECT
      receive MSG_TCONNECT <----+
      send MSG_RCONNECT
            +---------------> receive MSG_RCONNECT
                              check "tracecmd-V2"
                              send cpus,pagesize,option(MSG_TINIT)
      receive MSG_TINIT <-------+
      print "cpus=XXX"
      print "pagesize=XXX"
      understand option
      send port_array
               +--MSG_RINIT-> receive MSG_RINIT
                              understand port_array
                              send meta data(MSG_SENDMETA)
      receive MSG_SENDMETA <----+
      record meta data
                         (snip)
                              send a message to finish sending meta data
                                |                           (MSG_FINMETA)
      receive MSG_FINMETA <-----+
      read block
     --- start sending trace data on child processes ---

     --- When client finishes sending trace data ---
                              send MSG_CLOSE
      receive MSG_CLOSE <-------+
      close(socket fd)        close(socket fd)

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
 - virt-server subcommand
 - Create I/F directory(/tmp/trace-cmd/virt/)
 - Use named pipe I/Fs of virtio-serial for trace data paths
 - Use UNIX domain socket for connecting clients on guests
 - Use splice(2) for collecting trace data of guests

<Restrictions>
 - Use libvirt when we boot guests

Changes in V3: Change _nw/_NW to _net/_NET

Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
---
 Documentation/trace-cmd-virt-server.1.txt |   89 ++++++
 trace-cmd.c                               |    3 
 trace-cmd.h                               |    2 
 trace-listen.c                            |  439 ++++++++++++++++++++++++-----
 trace-msg.c                               |  105 ++++++-
 trace-recorder.c                          |   54 +++-
 trace-usage.c                             |   10 +
 7 files changed, 602 insertions(+), 100 deletions(-)
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
index a2958ac..ce3df2c 100644
--- a/trace-cmd.h
+++ b/trace-cmd.h
@@ -242,6 +242,7 @@ struct tracecmd_recorder *tracecmd_create_recorder_maxkb(const char *file, int c
 struct tracecmd_recorder *tracecmd_create_buffer_recorder_fd(int fd, int cpu, unsigned flags, const char *buffer);
 struct tracecmd_recorder *tracecmd_create_buffer_recorder(const char *file, int cpu, unsigned flags, const char *buffer);
 struct tracecmd_recorder *tracecmd_create_buffer_recorder_maxkb(const char *file, int cpu, unsigned flags, const char *buffer, int maxkb);
+struct tracecmd_recorder *tracecmd_create_recorder_virt(const char *file, int cpu, int trace_fd);
 
 int tracecmd_start_recording(struct tracecmd_recorder *recorder, unsigned long sleep);
 void tracecmd_stop_recording(struct tracecmd_recorder *recorder);
@@ -255,6 +256,7 @@ int tracecmd_msg_finish_sending_metadata(int fd);
 void tracecmd_msg_send_close_msg();
 
 /* for server */
+int tracecmd_msg_set_connection(int fd, const char *domain);
 int tracecmd_msg_initial_setting(int fd, int *cpus, int *pagesize);
 int tracecmd_msg_send_port_array(int fd, int total_cpus, int *ports);
 int tracecmd_msg_collect_metadata(int ifd, int ofd);
diff --git a/trace-listen.c b/trace-listen.c
index 280b1af..9819c32 100644
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
@@ -50,15 +54,23 @@ static int backlog = 5;
 
 static int proto_ver;
 
-#define  TEMP_FILE_STR "%s.%s:%s.cpu%d", output_file, host, port, cpu
-static char *get_temp_file(const char *host, const char *port, int cpu)
+#define  TEMP_FILE_STR_NET "%s.%s:%s.cpu%d", output_file, host, port, cpu
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
+		size = snprintf(file, 0, TEMP_FILE_STR_NET);
+		file = malloc_or_die(size + 1);
+		sprintf(file, TEMP_FILE_STR_NET);
+	} else {
+		size = snprintf(file, 0, TEMP_FILE_STR_VIRT);
+		file = malloc_or_die(size + 1);
+		sprintf(file, TEMP_FILE_STR_VIRT);
+	}
 
 	return file;
 }
@@ -81,11 +93,15 @@ static void signal_setup(int sig, sighandler_t handle)
 	sigaction(sig, &action, NULL);
 }
 
-static void delete_temp_file(const char *host, const char *port, int cpu)
+static void delete_temp_file(const char *host, const char *port,
+			     const char *domain, int virtpid, int cpu)
 {
 	char file[MAX_PATH];
 
-	snprintf(file, MAX_PATH, TEMP_FILE_STR);
+	if (host)
+		snprintf(file, MAX_PATH, TEMP_FILE_STR_NET);
+	else
+		snprintf(file, MAX_PATH, TEMP_FILE_STR_VIRT);
 	unlink(file);
 }
 
@@ -113,8 +129,12 @@ static int process_option(char *option)
 	return 0;
 }
 
+static struct tracecmd_recorder *recorder;
+
 static void finish(int sig)
 {
+	if (recorder)
+		tracecmd_stop_recording(recorder);
 	done = true;
 }
 
@@ -184,7 +204,7 @@ static void process_udp_child(int sfd, const char *host, const char *port,
 
 	signal_setup(SIGUSR1, finish);
 
-	tempfile = get_temp_file(host, port, cpu);
+	tempfile = get_temp_file(host, port, NULL, 0, cpu);
 	fd = open(tempfile, O_WRONLY | O_TRUNC | O_CREAT, 0644);
 	if (fd < 0)
 		pdie("creating %s", tempfile);
@@ -225,6 +245,28 @@ static void process_udp_child(int sfd, const char *host, const char *port,
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
 
@@ -272,20 +314,37 @@ static int udp_bind_a_port(int start_port, int *sfd)
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
@@ -305,7 +364,30 @@ static int open_udp(const char *node, const char *port, int *pid,
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
+static int communicate_with_client_net(int fd, int *cpus, int *pagesize)
 {
 	char buf[BUFSIZ];
 	char *option;
@@ -404,12 +486,30 @@ static int communicate_with_client(int fd, int *cpus, int *pagesize)
 	return 0;
 }
 
-static int create_client_file(const char *node, const char *port)
+static int communicate_with_client_virt(int fd, const char *domain,  int *cpus, int *pagesize)
+{
+	proto_ver = V2_PROTOCOL;
+
+	if (tracecmd_msg_set_connection(fd, domain) < 0)
+		return -1;
+
+	/* read the CPU count, the page size, and options */
+	if (tracecmd_msg_initial_setting(fd, cpus, pagesize) < 0)
+		return -1;
+
+	return 0;
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
@@ -418,7 +518,8 @@ static int create_client_file(const char *node, const char *port)
 }
 
 static void destroy_all_readers(int cpus, int *pid_array, const char *node,
-				const char *port)
+				const char *port, const char *domain,
+				int virtpid)
 {
 	int cpu;
 
@@ -426,42 +527,49 @@ static void destroy_all_readers(int cpus, int *pid_array, const char *node,
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
+			       const char *domain, int virtpid, int pagesize, int fd)
 {
 	char buf[BUFSIZ];
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
+			 * Due to some bugging finding ports,
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
-		 * Due to some bugging finding ports,
-		 * force search after last port
-		 */
-		start_port = udp_port + 1;
 	}
 
 	if (proto_ver == V2_PROTOCOL) {
@@ -482,7 +590,7 @@ static int *create_all_readers(int cpus, const char *node, const char *port,
 	return pid_array;
 
  out_free:
-	destroy_all_readers(cpus, pid_array, node, port);
+	destroy_all_readers(cpus, pid_array, node, port, domain, virtpid);
 	return NULL;
 }
 
@@ -524,7 +632,7 @@ static void stop_all_readers(int cpus, int *pid_array)
 }
 
 static void put_together_file(int cpus, int ofd, const char *node,
-			      const char *port)
+			      const char *port, const char *domain, int virtpid)
 {
 	char **temp_files;
 	int cpu;
@@ -533,25 +641,31 @@ static void put_together_file(int cpus, int ofd, const char *node,
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
+		if (communicate_with_client_net(fd, &cpus, &pagesize) < 0)
+			return;
+	} else {
+		if (communicate_with_client_virt(fd, domain, &cpus, &pagesize) < 0)
+			return;
+	}
 
-	pid_array = create_all_readers(cpus, node, port, pagesize, fd);
+	ofd = create_client_file(node, port, domain, virtpid);
+	pid_array = create_all_readers(cpus, node, port, domain, virtpid, pagesize, fd);
 	if (!pid_array)
 		return;
 
@@ -570,9 +684,22 @@ static void process_client(const char *node, const char *port, int fd)
 	/* wait a little to have the readers clean up */
 	sleep(1);
 
-	put_together_file(cpus, ofd, node, port);
+	put_together_file(cpus, ofd, node, port, domain, virtpid);
 
-	destroy_all_readers(cpus, pid_array, node, port);
+	destroy_all_readers(cpus, pid_array, node, port, domain, virtpid);
+}
+
+static void process_client_net(const char *node, const char *port, int fd)
+{
+	process_client(node, port, NULL, 0, fd);
+}
+
+static void process_client_virt(const char *domain, int virtpid, int fd)
+{
+	/* keep connection to qemu if clients on guests finish operation */
+	do {
+		process_client(NULL, NULL, domain, virtpid, fd);
+	} while (!done);
 }
 
 static int do_fork(int cfd)
@@ -599,8 +726,8 @@ static int do_fork(int cfd)
 	return 0;
 }
 
-static int do_connection(int cfd, struct sockaddr_storage *peer_addr,
-			  socklen_t peer_addr_len)
+static int do_connection(int cfd, struct sockaddr *peer_addr,
+			 socklen_t *peer_addr_len, const char *domain, int virtpid)
 {
 	char host[NI_MAXHOST], service[NI_MAXSERV];
 	int s;
@@ -610,21 +737,22 @@ static int do_connection(int cfd, struct sockaddr_storage *peer_addr,
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
+		process_client_net(host, service, cfd);
+	} else
+		process_client_virt(domain, virtpid, cfd);
 
 	close(cfd);
 
@@ -634,6 +762,77 @@ static int do_connection(int cfd, struct sockaddr_storage *peer_addr,
 	return 0;
 }
 
+static int do_connection_net(int cfd, struct sockaddr *addr, socklen_t *addrlen)
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
+				plog("start %s:%d\n", domain, pid);
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
@@ -678,12 +877,11 @@ static void remove_process(int pid)
 
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
@@ -702,31 +900,51 @@ static void clean_up(int sig)
 	} while (ret > 0);
 }
 
-static void do_accept_loop(int sfd)
+static void do_accept_loop(int sfd, bool net, struct sockaddr *addr,
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
+		if (net)
+			pid = do_connection_net(cfd, addr, addrlen);
+		else
+			pid = do_connection_virt(cfd);
 		if (pid > 0)
 			add_process(pid);
 
 	} while (!done);
 }
 
-static void do_listen(char *port)
+static void do_accept_loop_net(int sfd)
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
+static void do_listen_net(char *port)
 {
 	struct addrinfo hints;
 	struct addrinfo *result, *rp;
@@ -764,11 +982,67 @@ static void do_listen(char *port)
 	if (listen(sfd, backlog) < 0)
 		pdie("listen");
 
-	do_accept_loop(sfd);
+	do_accept_loop_net(sfd);
 
 	kill_clients();
 }
 
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
+
+	unlink(VIRT_TRACE_CTL_SOCK);
+	kill_clients();
+}
+
 static void start_daemon(void)
 {
 	if (daemon(1, 0) < 0)
@@ -785,11 +1059,17 @@ void trace_listen(int argc, char **argv)
 	char *port = NULL;
 	int daemon = 0;
 	int c;
+	int net = 0;
+	int virt = 0;
 
 	if (argc < 2)
 		usage(argv);
 
-	if (strcmp(argv[1], "listen") != 0)
+	if ((net = (strcmp(argv[1], "listen") == 0)))
+		; /* do nothing */
+	else if ((virt = (strcmp(argv[1], "virt-server") == 0)))
+		; /* do nothing */
+	else
 		usage(argv);
 
 	for (;;) {
@@ -810,6 +1090,8 @@ void trace_listen(int argc, char **argv)
 			usage(argv);
 			break;
 		case 'p':
+			if (virt)
+				die("-p only available with listen");
 			port = optarg;
 			break;
 		case 'd':
@@ -832,7 +1114,7 @@ void trace_listen(int argc, char **argv)
 		}
 	}
 
-	if (!port)
+	if (!port && net)
 		usage(argv);
 
 	if ((argc - optind) >= 2)
@@ -860,7 +1142,10 @@ void trace_listen(int argc, char **argv)
 	signal_setup(SIGINT, finish);
 	signal_setup(SIGTERM, finish);
 
-	do_listen(port);
+	if (net)
+		do_listen_net(port);
+	else
+		do_listen_virt();
 
 	return;
 }
diff --git a/trace-msg.c b/trace-msg.c
index 2e4c0b0..bb7a130 100644
--- a/trace-msg.c
+++ b/trace-msg.c
@@ -59,6 +59,11 @@ typedef __be32 be32;
 
 #define CPU_MAX				256
 
+/* use CONNECTION_MSG as a protocol version of trace-msg */
+#define MSG_VERSION		"V2"
+#define CONNECTION_MSG		"tracecmd-" MSG_VERSION
+#define CONNECTION_MSGSIZE	sizeof(CONNECTION_MSG)
+
 /* for both client and server */
 bool use_tcp;
 int cpu_count;
@@ -78,6 +83,10 @@ struct tracecmd_msg_str {
 	char *buf;
 } __attribute__((packed));
 
+struct tracecmd_msg_rconnect {
+	struct tracecmd_msg_str str;
+};
+
 struct tracecmd_msg_opt {
 	be32 size;
 	be32 opt_cmd;
@@ -104,6 +113,7 @@ struct tracecmd_msg_error {
 	be32 size;
 	be32 cmd;
 	union {
+		struct tracecmd_msg_rconnect rconnect;
 		struct tracecmd_msg_tinit tinit;
 		struct tracecmd_msg_rinit rinit;
 		struct tracecmd_msg_meta meta;
@@ -111,7 +121,10 @@ struct tracecmd_msg_error {
 } __attribute__((packed));
 
 enum tracecmd_msg_cmd {
+	MSG_ERROR	= 0,
 	MSG_CLOSE	= 1,
+	MSG_TCONNECT	= 2,
+	MSG_RCONNECT	= 3,
 	MSG_TINIT	= 4,
 	MSG_RINIT	= 5,
 	MSG_SENDMETA	= 6,
@@ -122,6 +135,7 @@ struct tracecmd_msg {
 	be32 size;
 	be32 cmd;
 	union {
+		struct tracecmd_msg_rconnect rconnect;
 		struct tracecmd_msg_tinit tinit;
 		struct tracecmd_msg_rinit rinit;
 		struct tracecmd_msg_meta meta;
@@ -155,6 +169,16 @@ static void bufcpy(void *dest, u32 offset, const void *buf, u32 buflen)
 	memcpy(dest+offset, buf, buflen);
 }
 
+static int make_rconnect(const char *buf, int buflen, struct tracecmd_msg *msg)
+{
+	u32 offset = offsetof(struct tracecmd_msg, data.rconnect.str.buf);
+
+	msg->data.rconnect.str.size = htonl(buflen);
+	bufcpy(msg, offset, buf, buflen);
+
+	return 0;
+}
+
 enum msg_opt_command {
 	MSGOPT_USETCP = 1,
 };
@@ -232,11 +256,13 @@ static int make_rinit(struct tracecmd_msg *msg)
 
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
@@ -248,6 +274,8 @@ static u32 tracecmd_msg_get_body_length(u32 cmd)
 	u32 len = 0;
 
 	switch (cmd) {
+	case MSG_RCONNECT:
+		return sizeof(msg->data.rconnect.str.size) + CONNECTION_MSGSIZE;
 	case MSG_TINIT:
 		len = sizeof(msg->data.tinit.cpus)
 		      + sizeof(msg->data.tinit.page_size)
@@ -285,6 +313,8 @@ static u32 tracecmd_msg_get_body_length(u32 cmd)
 static int tracecmd_msg_make_body(u32 cmd, u32 len, struct tracecmd_msg *msg)
 {
 	switch (cmd) {
+	case MSG_RCONNECT:
+		return make_rconnect(CONNECTION_MSG, CONNECTION_MSGSIZE, msg);
 	case MSG_TINIT:
 		return make_tinit(len, msg);
 	case MSG_RINIT:
@@ -425,6 +455,8 @@ static void *tracecmd_msg_buf_access(struct tracecmd_msg *msg, int offset)
 static int tracecmd_msg_wait_for_msg(int fd, struct tracecmd_msg **msg)
 {
 	char msg_tmp[TRACECMD_MSG_MAX_LEN];
+	char *buf;
+	int offset = TRACECMD_MSG_HDR_LEN;
 	u32 cmd;
 	int ret;
 
@@ -437,8 +469,20 @@ static int tracecmd_msg_wait_for_msg(int fd, struct tracecmd_msg **msg)
 
 	*msg = (struct tracecmd_msg *)msg_tmp;
 	cmd = ntohl((*msg)->cmd);
-	if (cmd == MSG_CLOSE)
+	switch (cmd) {
+	case MSG_RCONNECT:
+		offset += sizeof((*msg)->data.rconnect.str.size);
+		buf = tracecmd_msg_buf_access(*msg, offset);
+		/* Make sure the server is the tracecmd server */
+		if (memcmp(buf, CONNECTION_MSG,
+		    ntohl((*msg)->data.rconnect.str.size) - 1) != 0) {
+			warning("server not tracecmd server");
+			return -EPROTONOSUPPORT;
+		}
+		break;
+	case MSG_CLOSE:
 		return -ECONNABORTED;
+	}
 
 	return 0;
 }
@@ -495,7 +539,54 @@ static void error_operation_for_server(struct tracecmd_msg *msg)
 
 	cmd = ntohl(msg->cmd);
 
-	warning("Message: cmd=%d size=%d\n", cmd, ntohl(msg->size));
+	if (cmd == MSG_ERROR)
+		plog("Receive error message: cmd=%d size=%d\n",
+		     ntohl(msg->data.err.cmd), ntohl(msg->data.err.size));
+	else
+		warning("Message: cmd=%d size=%d\n", cmd, ntohl(msg->size));
+}
+
+int tracecmd_msg_set_connection(int fd, const char *domain)
+{
+	struct tracecmd_msg *msg;
+	char buf[TRACECMD_MSG_MAX_LEN] = {};
+	u32 cmd;
+	int ret;
+
+	/*
+	 * Wait for connection msg by a client first.
+	 * If a client uses virtio-serial, a connection message will
+	 * not be sent immediately after accept(). connect() is called
+	 * in QEMU, so the client can send the connection message
+	 * after guest boots. Therefore, the virt-server patiently
+	 * waits for the connection request of a client.
+	 */ 
+	ret = tracecmd_msg_recv(fd, buf);
+	if (ret < 0) {
+		if (!buf[0]) {
+			/* No data means QEMU has already died. */
+			close(fd);
+			die("Connection refuesd: %s", domain);
+		}
+		return -ENOMSG;
+	}
+
+	msg = (struct tracecmd_msg *)buf;
+	cmd = ntohl(msg->cmd);
+	if (cmd == MSG_CLOSE)
+		return -ECONNABORTED;
+	else if (cmd != MSG_TCONNECT)
+		return -EINVAL;
+
+	ret = tracecmd_msg_send(fd, MSG_RCONNECT);
+	if (ret < 0)
+		goto error;
+
+	return 0;
+
+error:
+	error_operation_for_server(msg);
+	return ret;
 }
 
 #define MAX_OPTION_SIZE 4096
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

