Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824Ab3LQDAi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 22:00:38 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:37468 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551Ab3LQDAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 22:00:35 -0500
X-AuditID: 85900ec0-d1d29b9000001514-b5-52afbe5132d9
Subject: [PATCH V3 6/6] trace-cmd: Add --dom option which makes a domain
 directory to virt-server
To: Steven Rostedt <rostedt@goodmis.org>
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Aaron Fabbri <aaronx.j.fabbri@intel.com>, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com
Date: Tue, 17 Dec 2013 12:00:32 +0900
Message-ID: <20131217030032.31730.10447.stgit@yunodevel>
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

Add --dom option which makes a domain directory to virt-server. When a user
already knows domain name of a guest before running virt-server, trace-cmd
should automatically set up I/Fs of the guest. By adding --dom option,
trace-cmd creates a domain directory with 0710 and qemu group.

This patch adds additional options for --dom as follows:

-m <permission>
   This option changes the permission of domain directory. If you don't use
   this option, the default permission is 0710.

-g <group>
   This option changes group of domain directory. If you don't use this option,
   the default group is qemu.

-c <cpu>
   This option creates trace data I/Fs(trace-path-cpu*.{in,out}) for each CPU
   of 'domain'. If you don't use this option, those files are not created.

Here, an example you use this option is written as follows:

- trace-cmd creates a guest1 directory with trace data I/Fs of 2 CPUs.
   # trace-cmd virt-server --dom guest1 -c 2

- trace-cmd creates guest2 and guest3 directories
   # trace-cmd virt-server --dom guest2 -c 3 --dom guest3 -c 1

Changes in V3: Add this patch

Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
---
 Documentation/trace-cmd-virt-server.1.txt |   57 ++++++++---
 trace-listen.c                            |  151 ++++++++++++++++++++++++++---
 2 files changed, 177 insertions(+), 31 deletions(-)

diff --git a/Documentation/trace-cmd-virt-server.1.txt b/Documentation/trace-cmd-virt-server.1.txt
index 4168a04..51de144 100644
--- a/Documentation/trace-cmd-virt-server.1.txt
+++ b/Documentation/trace-cmd-virt-server.1.txt
@@ -34,40 +34,67 @@ OPTIONS
 *-l* 'filename'::
     This option writes the output messages to a log file instead of standard output.
 
+*--dom* 'domain'::
+    This option makes a directory for the 'domain'. You can use additional options
+    *-m*, *-g*, *-c* after this option for the 'domain'. If you don't use these
+    additional options, the directory is made as 0710 and qemu group and
+    trace data I/Fs(trace-path-cpu*.{in,out}) are not created. 
+
+*-m* 'permission'::
+    This option changes the permission of 'domain' directory. If you don't use
+    this option, the default permission is 0710.
+
+*-g* 'group'::
+    This option changes group of 'domain' directory. If you don't use this option,
+    the default group is qemu.
+
+*-c* 'cpu'::
+    This option creates trace data I/Fs(trace-path-cpu*.{in,out}) for each CPU
+    of 'domain'. If you don't use this option, those files are not created.
+
 SET UP
 ------
 Here, an example is written as follows:
 
 1. Run virt-server on a host
-   # trace-cmd virt-server
+   # trace-cmd virt-server --dom guest1 -c 2
 
-2. Make guest domain directory
-   # mkdir -p /tmp/trace-cmd/virt/<DOMAIN>
-   # chmod 710 /tmp/trace-cmd/virt/<DOMAIN>
-   # chgrp qemu /tmp/trace-cmd/virt/<DOMAIN>
-
-3. Make FIFO on the host
-   # mkfifo /tmp/trace-cmd/virt/<DOMAIN>/trace-path-cpu{0,1,...,X}.{in,out}
+   <NOTE> Set up two guests(guest1, guest2):
+   # trace-cmd virt-server --dom guest1 -c 2 --dom guest2 -c 1
 
-4. Set up of virtio-serial pipe of a guest on the host
+2. Set up of virtio-serial pipe of guest1 on the host
    Add the following tags to domain XML files.
-   # virsh edit <guest domain>
+   # virsh edit guest1
    <channel type='unix'>
       <source mode='connect' path='/tmp/trace-cmd/virt/agent-ctl-path'/>
       <target type='virtio' name='agent-ctl-path'/>
    </channel>
    <channel type='pipe'>
-      <source path='/tmp/trace-cmd/virt/<DOMAIN>/trace-path-cpu0'/>
+      <source path='/tmp/trace-cmd/virt/guest1/trace-path-cpu0'/>
       <target type='virtio' name='trace-path-cpu0'/>
    </channel>
-   ... (cpu1, cpu2, ...)
+   <channel type='pipe'>
+      <source path='/tmp/trace-cmd/virt/guest1/trace-path-cpu1'/>
+      <target type='virtio' name='trace-path-cpu1'/>
+   </channel>
 
-5. Boot the guest
-   # virsh start <DOMAIN>
+3. Boot the guest
+   # virsh start guest1
 
-6. Run the guest's client(see trace-cmd-record(1) with the *--virt* option)
+4. Run the guest1's client(see trace-cmd-record(1) with the *--virt* option)
    # trace-cmd record -e sched* --virt
 
+If you want to boot another guest sends trace-data via virtio-serial,
+you will manually make the guest domain directory and trace data I/Fs.
+
+- Make guest domain directory on the host
+   # mkdir -p /tmp/trace-cmd/virt/<DOMAIN>
+   # chmod 710 /tmp/trace-cmd/virt/<DOMAIN>
+   # chgrp qemu /tmp/trace-cmd/virt/<DOMAIN>
+
+- Make FIFO on the host
+   # mkfifo /tmp/trace-cmd/virt/<DOMAIN>/trace-path-cpu{0,1,...,X}.{in,out}
+
 SEE ALSO
 --------
 trace-cmd(1), trace-cmd-record(1), trace-cmd-report(1), trace-cmd-start(1),
diff --git a/trace-listen.c b/trace-listen.c
index 9819c32..07823b7 100644
--- a/trace-listen.c
+++ b/trace-listen.c
@@ -54,6 +54,16 @@ static int backlog = 5;
 
 static int proto_ver;
 
+struct domain_dir {
+	struct domain_dir *next;
+	char *name;
+	char *group;
+	mode_t perms;
+	int cpu;
+};
+
+struct domain_dir *dom_dir_list;
+
 #define  TEMP_FILE_STR_NET "%s.%s:%s.cpu%d", output_file, host, port, cpu
 #define  TEMP_FILE_STR_VIRT "%s.%s:%d.cpu%d", output_file, domain, virtpid, cpu
 static char *get_temp_file(const char *host, const char *port,
@@ -367,7 +377,9 @@ static int open_udp(const char *node, const char *port, int *pid,
 #define TRACE_CMD_DIR		"/tmp/trace-cmd/"
 #define VIRT_DIR		TRACE_CMD_DIR "virt/"
 #define VIRT_TRACE_CTL_SOCK	VIRT_DIR "agent-ctl-path"
-#define TRACE_PATH_DOMAIN_CPU	VIRT_DIR "%s/trace-path-cpu%d.out"
+#define VIRT_DOMAIN_DIR		VIRT_DIR "%s/"
+#define TRACE_PATH_DOMAIN_CPU_O	VIRT_DOMAIN_DIR "trace-path-cpu%d.out"
+#define TRACE_PATH_DOMAIN_CPU_I	VIRT_DOMAIN_DIR "trace-path-cpu%d.in"
 
 static int open_virtio_serial_pipe(int *pid, int cpu, int pagesize,
 				   const char *domain, int virtpid)
@@ -375,7 +387,7 @@ static int open_virtio_serial_pipe(int *pid, int cpu, int pagesize,
 	char buf[PATH_MAX];
 	int fd;
 
-	snprintf(buf, PATH_MAX, TRACE_PATH_DOMAIN_CPU, domain, cpu);
+	snprintf(buf, PATH_MAX, TRACE_PATH_DOMAIN_CPU_O, domain, cpu);
 	fd = open(buf, O_RDONLY | O_NONBLOCK);
 	if (fd < 0) {
 		warning("open %s", buf);
@@ -987,27 +999,102 @@ static void do_listen_net(char *port)
 	kill_clients();
 }
 
-static void make_virt_if_dir(void)
+#define for_each_domain(i) for (i = dom_dir_list; i; i = (i)->next)
+
+static void make_dir_virt(const char *path, mode_t perms, const char *gr_name)
 {
 	struct group *group;
 
-	if (mkdir(TRACE_CMD_DIR, 0710) < 0) {
+	if (mkdir(path, perms) < 0) {
 		if (errno != EEXIST)
-			pdie("mkdir %s", TRACE_CMD_DIR);
+			pdie("mkdir %s", path);
+	}
+	chmod(path, perms);
+
+	group = getgrnam(gr_name);
+	if (!group)
+		pdie("getgrnam %s", gr_name);
+	if (chown(path, -1, group->gr_gid) < 0)
+		pdie("chown %s", path);
+}
+
+static void make_traceif_in_dom_dir(const char *name, int cpu)
+{
+	char fifo_in[PATH_MAX];
+	char fifo_out[PATH_MAX];
+	int i;
+
+	for (i = 0; i < cpu; i++) {
+		snprintf(fifo_in, PATH_MAX, TRACE_PATH_DOMAIN_CPU_I, name, i);
+		snprintf(fifo_out, PATH_MAX, TRACE_PATH_DOMAIN_CPU_O, name, i);
+		if (mkfifo(fifo_in, 0644) < 0) {
+			if (errno != EEXIST)
+				pdie("mkfifo %s", fifo_in);
+		}
+		if (mkfifo(fifo_out, 0644) < 0) {
+			if (errno != EEXIST)
+				pdie("mkfifo %s", fifo_out);
+		}
 	}
+	plog("CPUS: %d\n", cpu);
+}
+
+static void make_domain_dirs(void)
+{
+	struct domain_dir *dom_dir;
+	char gr_name[5] = "qemu";
+	char buf[PATH_MAX];
+	mode_t perms;
+
+	for_each_domain(dom_dir) {
+		snprintf(buf, PATH_MAX, VIRT_DOMAIN_DIR, dom_dir->name);
+
+		if (dom_dir->perms)
+			perms = dom_dir->perms;
+		else
+			perms = 0710;
+
+		if (dom_dir->group)
+			make_dir_virt(buf, perms, dom_dir->group);
+		else
+			make_dir_virt(buf, perms, gr_name);
+
+		plog("---\n"
+		     "Process Directory: %s\n"
+		     "Directory permission: %o\n"
+		     "Group: %s\n", buf, perms, dom_dir->group ? dom_dir->group : gr_name);
+
+		if (dom_dir->cpu)
+			make_traceif_in_dom_dir(dom_dir->name, dom_dir->cpu);
+	}
+
+	plog("---\n");
+}
+
+static void free_domain_dirs(void)
+{
+	struct domain_dir *dom_dir, *prev_dom_dir = NULL;
+
+	for_each_domain(dom_dir) {
+		if (prev_dom_dir)
+			free(prev_dom_dir);
+		prev_dom_dir = dom_dir;
+	}
+	free(prev_dom_dir);
+}
+
+static void make_virt_if_dir(void)
+{
+	char gr_name[5] = "qemu";
+
 	/* QEMU operates as qemu:qemu */
-	chmod(TRACE_CMD_DIR, 0710);
-	group = getgrnam("qemu");
-	if (chown(TRACE_CMD_DIR, -1, group->gr_gid) < 0)
-		pdie("chown %s", TRACE_CMD_DIR);
+	make_dir_virt(TRACE_CMD_DIR, 0710, gr_name);
+	make_dir_virt(VIRT_DIR, 0710, gr_name);
 
-	if (mkdir(VIRT_DIR, 0710) < 0) {
-		if (errno != EEXIST)
-			pdie("mkdir %s", VIRT_DIR);
+	if (dom_dir_list) {
+		make_domain_dirs();
+		free_domain_dirs();
 	}
-	chmod(VIRT_DIR, 0710);
-	if (chown(VIRT_DIR, -1, group->gr_gid) < 0)
-		pdie("chown %s", VIRT_DIR);
 }
 
 static void do_listen_virt(void)
@@ -1049,12 +1136,20 @@ static void start_daemon(void)
 		die("starting daemon");
 }
 
+static void add_dom_dir(struct domain_dir *dom_dir)
+{
+	dom_dir->next = dom_dir_list;
+	dom_dir_list = dom_dir;
+}
+
 enum {
+	OPT_dom		= 254,
 	OPT_debug	= 255,
 };
 
 void trace_listen(int argc, char **argv)
 {
+	struct domain_dir *dom_dir = NULL;
 	char *logfile = NULL;
 	char *port = NULL;
 	int daemon = 0;
@@ -1076,12 +1171,13 @@ void trace_listen(int argc, char **argv)
 		int option_index = 0;
 		static struct option long_options[] = {
 			{"port", required_argument, NULL, 'p'},
+			{"dom", required_argument, NULL, OPT_dom},
 			{"help", no_argument, NULL, '?'},
 			{"debug", no_argument, NULL, OPT_debug},
 			{NULL, 0, NULL, 0}
 		};
 
-		c = getopt_long (argc-1, argv+1, "+hp:o:d:l:D",
+		c = getopt_long (argc-1, argv+1, "+hp:o:d:l:Dm:g:c:",
 			long_options, &option_index);
 		if (c == -1)
 			break;
@@ -1106,6 +1202,29 @@ void trace_listen(int argc, char **argv)
 		case 'D':
 			daemon = 1;
 			break;
+		case 'm':
+			if (!dom_dir)
+				die("-m needs --dom <domain>");
+			dom_dir->perms = strtol(optarg, NULL, 8);
+			break;
+		case 'g':
+			if (!dom_dir)
+				die("-g needs --dom <domain>");
+			dom_dir->group = optarg;
+			break;
+		case 'c':
+			if (!dom_dir)
+				die("-c needs --dom <domain>");
+			dom_dir->cpu = atoi(optarg);
+			break;
+		case OPT_dom:
+			if (net)
+				die("--dom only available with virt-server");
+			dom_dir = malloc_or_die(sizeof(*dom_dir));
+			memset(dom_dir, 0, sizeof(*dom_dir));
+			dom_dir->name = optarg;
+			add_dom_dir(dom_dir);
+			break;
 		case OPT_debug:
 			debug = 1;
 			break;

