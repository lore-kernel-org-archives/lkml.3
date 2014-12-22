Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417AbaLVJxP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 04:53:15 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:53570 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754378AbaLVJxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 04:53:11 -0500
Subject: [PATCH trace-cmd V5 6/6] trace-cmd/virt-server: Add --dom option
 which makes a domain directory to virt-server
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com,
        Aaron Fabbri <aaronx.j.fabbri@intel.com>, linux-kernel@vger.kernel.org,
        Divya Vyas <edivya.vyas@gmail.com>
Date: Mon, 22 Dec 2014 12:48:17 -0500
Message-ID: <20141222174817.10068.96790.stgit@localhost.localdomain>
In-Reply-To: <20141222174736.10068.90306.stgit@localhost.localdomain>
References: <20141222174736.10068.90306.stgit@localhost.localdomain>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
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

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

---
Changes in V5: Update document.
Changes in V4: Introduce parse_args_virt()
               Add usage of virt-server in trace-usage.c
---
 Documentation/trace-cmd-virt-server.1.txt |   58 ++++++++---
 trace-listen.c                            |  151 ++++++++++++++++++++++++++---
 trace-usage.c                             |    5 +
 3 files changed, 179 insertions(+), 35 deletions(-)

diff --git a/Documentation/trace-cmd-virt-server.1.txt b/Documentation/trace-cmd-virt-server.1.txt
index b775745..19f2b23 100644
--- a/Documentation/trace-cmd-virt-server.1.txt
+++ b/Documentation/trace-cmd-virt-server.1.txt
@@ -34,40 +34,64 @@ OPTIONS
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
 SETTING
 -------
 Here, an example is written as follows:
 
-1. Run virt-server on a host
-   # trace-cmd virt-server
-
-2. Make guest domain directory
-   # mkdir -p /tmp/trace-cmd/virt/<DOMAIN>
-   # chmod 710 /tmp/trace-cmd/virt/<DOMAIN>
-   # chgrp qemu /tmp/trace-cmd/virt/<DOMAIN>
-
-3. Make FIFO on the host
-   # mkfifo /tmp/trace-cmd/virt/<DOMAIN>/trace-path-cpu{0,1,...,X}.{in,out}
+1. Run virt-server with initializing guest interfaces on a host
+   # trace-cmd virt-server --dom "GUEST" -c 2
 
-4. Set up of virtio-serial pipe of a guest on the host
+2. Set up of virtio-serial pipe of GUEST on the host
    Add the following tags to domain XML files.
-   # virsh edit <guest domain>
+   # virsh edit "GUEST"
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
+   # virsh start "GUEST"
 
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
index 718680f..f6d53d2 100644
--- a/trace-listen.c
+++ b/trace-listen.c
@@ -54,11 +54,21 @@ static int backlog = 5;
 
 static int proto_ver;
 
+struct domain_dir {
+	struct domain_dir *next;
+	char *name;
+	char *group;
+	mode_t perms;
+	int cpu;
+};
+
 enum {
 	NET	= 1,
 	VIRT	= 2,
 };
 
+struct domain_dir *dom_dir_list;
+
 #define  TEMP_FILE_STR_NET "%s.%s:%s.cpu%d", output_file, host, port, cpu
 #define  TEMP_FILE_STR_VIRT "%s.%s:%d.cpu%d", output_file, domain, virtpid, cpu
 static char *get_temp_file(const char *host, const char *port,
@@ -382,7 +392,9 @@ static int open_udp(const char *node, const char *port, int *pid,
 #define TRACE_CMD_DIR		"/tmp/trace-cmd/"
 #define VIRT_DIR		TRACE_CMD_DIR "virt/"
 #define VIRT_TRACE_CTL_SOCK	VIRT_DIR "agent-ctl-path"
-#define TRACE_PATH_DOMAIN_CPU	VIRT_DIR "%s/trace-path-cpu%d.out"
+#define VIRT_DOMAIN_DIR		VIRT_DIR "%s/"
+#define TRACE_PATH_DOMAIN_CPU_O	VIRT_DOMAIN_DIR "trace-path-cpu%d.out"
+#define TRACE_PATH_DOMAIN_CPU_I	VIRT_DOMAIN_DIR "trace-path-cpu%d.in"
 
 static int open_virtio_serial_pipe(int *pid, int cpu, int pagesize,
 				   const char *domain, int virtpid)
@@ -390,7 +402,7 @@ static int open_virtio_serial_pipe(int *pid, int cpu, int pagesize,
 	char buf[PATH_MAX];
 	int fd;
 
-	snprintf(buf, PATH_MAX, TRACE_PATH_DOMAIN_CPU, domain, cpu);
+	snprintf(buf, PATH_MAX, TRACE_PATH_DOMAIN_CPU_O, domain, cpu);
 	fd = open(buf, O_RDONLY | O_NONBLOCK);
 	if (fd < 0) {
 		warning("open %s", buf);
@@ -998,27 +1010,89 @@ static void do_listen_net(char *port)
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
 	}
-	/* QEMU operates as qemu:qemu */
-	chmod(TRACE_CMD_DIR, 0710);
-	group = getgrnam("qemu");
-	if (chown(TRACE_CMD_DIR, -1, group->gr_gid) < 0)
-		pdie("chown %s", TRACE_CMD_DIR);
+	chmod(path, perms);
 
-	if (mkdir(VIRT_DIR, 0710) < 0) {
-		if (errno != EEXIST)
-			pdie("mkdir %s", VIRT_DIR);
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
-	chmod(VIRT_DIR, 0710);
-	if (chown(VIRT_DIR, -1, group->gr_gid) < 0)
-		pdie("chown %s", VIRT_DIR);
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
+	free(dom_dir_list);
+}
+
+static void make_virt_if_dir(void)
+{
+	char gr_name[5] = "qemu";
+
+	/* QEMU operates as qemu:qemu */
+	make_dir_virt(TRACE_CMD_DIR, 0710, gr_name);
+	make_dir_virt(VIRT_DIR, 0710, gr_name);
+
+	if (dom_dir_list)
+		make_domain_dirs();
 }
 
 static void do_listen_virt(void)
@@ -1060,7 +1134,14 @@ static void start_daemon(void)
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
 
@@ -1075,6 +1156,37 @@ static void parse_args_net(int c, char **argv, char **port)
 	}
 }
 
+static void parse_args_virt(int c, char **argv)
+{
+	static struct domain_dir *dom_dir;
+
+	switch (c) {
+	case 'm':
+		if (!dom_dir)
+			die("-m needs --dom <domain>");
+		dom_dir->perms = strtol(optarg, NULL, 8);
+		break;
+	case 'g':
+		if (!dom_dir)
+			die("-g needs --dom <domain>");
+		dom_dir->group = optarg;
+		break;
+	case 'c':
+		if (!dom_dir)
+			die("-c needs --dom <domain>");
+		dom_dir->cpu = atoi(optarg);
+		break;
+	case OPT_dom:
+		dom_dir = malloc_or_die(sizeof(*dom_dir));
+		memset(dom_dir, 0, sizeof(*dom_dir));
+		dom_dir->name = optarg;
+		add_dom_dir(dom_dir);
+		break;
+	default:
+		usage(argv);
+	}
+}
+
 void trace_listen(int argc, char **argv)
 {
 	char *logfile = NULL;
@@ -1097,12 +1209,13 @@ void trace_listen(int argc, char **argv)
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
@@ -1128,12 +1241,14 @@ void trace_listen(int argc, char **argv)
 		default:
 			if (mode == NET)
 				parse_args_net(c, argv, &port);
+			else if (mode == VIRT)
+				parse_args_virt(c, argv);
 			else
 				usage(argv);
 		}
 	}
 
-	if (!port && mode == NET)
+	if (!port && (mode == NET))
 		usage(argv);
 
 	if ((argc - optind) >= 2)
diff --git a/trace-usage.c b/trace-usage.c
index b8c8c71..45865f0 100644
--- a/trace-usage.c
+++ b/trace-usage.c
@@ -187,11 +187,16 @@ static struct usage_help usage_help[] = {
 		"virt-server",
 		"listen on a virtio-serial for trace clients",
 		" %s virt-server [-o file][-d dir][-l logfile]\n"
+		"                [--dom domain [-m permisson] [-g group] [-c cpu]]\n"
 		"          Creates a socket to listen for clients.\n"
 		"          -D create it in daemon mode.\n"
 		"          -o file name to use for clients.\n"
 		"          -d diretory to store client files.\n"
 		"	   -l logfile to write messages to.\n"
+		"          --dom create domain direcroty in /tmp/trace-cmd/virt and folling directory permissions/group names and FIFO files will be changed here\n"
+		"	   -m changes the permission of domain directory.\n"
+		"	   -g changes group of domain directory.\n"
+		"	   -c creates trace data I/F(trace-path-cpu*.{in, out} files) in domain directory.\n"
 	},
 	{
 		"list",


