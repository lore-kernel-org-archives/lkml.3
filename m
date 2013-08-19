Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751393Ab3HSJoM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 05:44:12 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:36506 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881Ab3HSJmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 05:42:18 -0400
X-AuditID: 85900ec0-d1328b9000001514-42-5211e8791c40
Subject: [RFC PATCH 06/11] [CLEANUP] trace-cmd: Split out the communication
 with client from process_client()
To: Steven Rostedt <rostedt@goodmis.org>
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Date: Mon, 19 Aug 2013 18:46:34 +0900
Message-ID: <20130819094634.26597.60441.stgit@yunodevel>
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

Split out the communication with client from process_client() for avoiding
duplicate codes between listen mode and virt-server mode.

Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
---
 trace-listen.c |  163 ++++++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 116 insertions(+), 47 deletions(-)

diff --git a/trace-listen.c b/trace-listen.c
index c741fa4..f29dd35 100644
--- a/trace-listen.c
+++ b/trace-listen.c
@@ -283,22 +283,12 @@ static int open_udp(const char *node, const char *port, int *pid,
 	return num_port;
 }
 
-static void process_client(const char *node, const char *port, int fd)
+static int communicate_with_client(int fd, int *cpus, int *pagesize)
 {
-	char **temp_files;
 	char buf[BUFSIZ];
 	char *option;
-	int *port_array;
-	int *pid_array;
-	int pagesize;
-	int start_port;
-	int udp_port;
 	int options;
 	int size;
-	int cpus;
-	int cpu;
-	int pid;
-	int ofd;
 	int n, s, t, i;
 
 	/* Let the client know what we are */
@@ -308,31 +298,31 @@ static void process_client(const char *node, const char *port, int fd)
 	n = read_string(fd, buf, BUFSIZ);
 	if (n == BUFSIZ)
 		/** ERROR **/
-		return;
+		return -1;
 
-	cpus = atoi(buf);
+	*cpus = atoi(buf);
 
-	plog("cpus=%d\n", cpus);
-	if (cpus < 0)
-		return;
+	plog("cpus=%d\n", *cpus);
+	if (*cpus < 0)
+		return -1;
 
 	/* next read the page size */
 	n = read_string(fd, buf, BUFSIZ);
 	if (n == BUFSIZ)
 		/** ERROR **/
-		return;
+		return -1;
 
-	pagesize = atoi(buf);
+	*pagesize = atoi(buf);
 
-	plog("pagesize=%d\n", pagesize);
-	if (pagesize <= 0)
-		return;
+	plog("pagesize=%d\n", *pagesize);
+	if (*pagesize <= 0)
+		return -1;
 
 	/* Now the number of options */
 	n = read_string(fd, buf, BUFSIZ);
 	if (n == BUFSIZ)
 		/** ERROR **/
-		return;
+		return -1;
 
 	options = atoi(buf);
 
@@ -341,18 +331,18 @@ static void process_client(const char *node, const char *port, int fd)
 		n = read_string(fd, buf, BUFSIZ);
 		if (n == BUFSIZ)
 			/** ERROR **/
-			return;
+			return -1;
 		size = atoi(buf);
 		/* prevent a client from killing us */
 		if (size > MAX_OPTION_SIZE)
-			return;
+			return -1;
 		option = malloc_or_die(size);
 		do {
 			t = size;
 			s = 0;
 			s = read(fd, option+s, t);
 			if (s <= 0)
-				return;
+				return -1;
 			t -= s;
 			s = size - t;
 		} while (t);
@@ -361,18 +351,53 @@ static void process_client(const char *node, const char *port, int fd)
 		free(option);
 		/* do we understand this option? */
 		if (!s)
-			return;
+			return -1;
 	}
 
 	if (use_tcp)
 		plog("Using TCP for live connection\n");
 
-	/* Create the client file */
+	return 0;
+}
+
+static int create_client_file(const char *node, const char *port)
+{
+	char buf[BUFSIZ];
+	int ofd;
+
 	snprintf(buf, BUFSIZ, "%s.%s:%s.dat", output_file, node, port);
 
 	ofd = open(buf, O_RDWR | O_CREAT | O_TRUNC, 0644);
 	if (ofd < 0)
 		pdie("Can not create file %s", buf);
+	return ofd;
+}
+
+static void destroy_all_readers(int cpus, int *pid_array, const char *node,
+				const char *port)
+{
+	int cpu;
+
+	for (cpu = 0; cpu < cpus; cpu++) {
+		if (pid_array[cpu] > 0) {
+			kill(pid_array[cpu], SIGKILL);
+			waitpid(pid_array[cpu], NULL, 0);
+			delete_temp_file(node, port, cpu);
+			pid_array[cpu] = 0;
+		}
+	}
+}
+
+static int *create_all_readers(int cpus, const char *node, const char *port,
+			       int pagesize, int fd)
+{
+	char buf[BUFSIZ];
+	int *port_array;
+	int *pid_array;
+	int start_port;
+	int udp_port;
+	int cpu;
+	int pid;
 
 	port_array = malloc_or_die(sizeof(int) * cpus);
 	pid_array = malloc_or_die(sizeof(int) * cpus);
@@ -382,13 +407,17 @@ static void process_client(const char *node, const char *port, int fd)
 
 	/* Now create a UDP port for each CPU */
 	for (cpu = 0; cpu < cpus; cpu++) {
-		udp_port = open_udp(node, port, &pid, cpu, pagesize, start_port);
+		udp_port = open_udp(node, port, &pid, cpu,
+				    pagesize, start_port);
 		if (udp_port < 0)
 			goto out_free;
 		port_array[cpu] = udp_port;
 		pid_array[cpu] = pid;
-		/* due to some bugging finding ports, force search after last port */
-		start_port = udp_port+1;
+		/*
+		 * due to some bugging finding ports,
+		 * force search after last port
+		 */
+		start_port = udp_port + 1;
 	}
 
 	/* send the client a comma deliminated set of port numbers */
@@ -400,9 +429,20 @@ static void process_client(const char *node, const char *port, int fd)
 	/* end with null terminator */
 	write(fd, "\0", 1);
 
-	/* Now we are ready to start reading data from the client */
+	return pid_array;
+
+ out_free:
+	destroy_all_readers(cpus, pid_array, node, port);
+	return NULL;
+}
+
+static void collect_metadata_from_client(int ifd, int ofd)
+{
+	char buf[BUFSIZ];
+	int n, s, t;
+
 	do {
-		n = read(fd, buf, BUFSIZ);
+		n = read(ifd, buf, BUFSIZ);
 		if (n < 0) {
 			if (errno == EINTR)
 				continue;
@@ -411,7 +451,7 @@ static void process_client(const char *node, const char *port, int fd)
 		t = n;
 		s = 0;
 		do {
-			s = write(ofd, buf+s, t);
+			s = write(ofd, buf + s, t);
 			if (s < 0) {
 				if (errno == EINTR)
 					break;
@@ -421,18 +461,23 @@ static void process_client(const char *node, const char *port, int fd)
 			s = n - t;
 		} while (t);
 	} while (n > 0 && !done);
+}
 
-	/* wait a little to let our readers finish reading */
-	sleep(1);
+static void stop_all_readers(int cpus, int *pid_array)
+{
+	int cpu;
 
-	/* stop our readers */
 	for (cpu = 0; cpu < cpus; cpu++) {
 		if (pid_array[cpu] > 0)
 			kill(pid_array[cpu], SIGUSR1);
 	}
+}
 
-	/* wait a little to have the readers clean up */
-	sleep(1);
+static void put_together_file(int cpus, int ofd, const char *node,
+			      const char *port)
+{
+	char **temp_files;
+	int cpu;
 
 	/* Now put together the file */
 	temp_files = malloc_or_die(sizeof(*temp_files) * cpus);
@@ -441,16 +486,40 @@ static void process_client(const char *node, const char *port, int fd)
 		temp_files[cpu] = get_temp_file(node, port, cpu);
 
 	tracecmd_attach_cpu_data_fd(ofd, cpus, temp_files);
+	free(temp_files);
+}
 
- out_free:
-	for (cpu = 0; cpu < cpus; cpu++) {
-		if (pid_array[cpu] > 0) {
-			kill(pid_array[cpu], SIGKILL);
-			waitpid(pid_array[cpu], NULL, 0);
-			delete_temp_file(node, port, cpu);
-			pid_array[cpu] = 0;
-		}
-	}
+static void process_client(const char *node, const char *port, int fd)
+{
+	int *pid_array;
+	int pagesize;
+	int cpus;
+	int ofd;
+
+	if (communicate_with_client(fd, &cpus, &pagesize) < 0)
+		return;
+
+	ofd = create_client_file(node, port);
+
+	pid_array = create_all_readers(cpus, node, port, pagesize, fd);
+	if (!pid_array)
+		return;
+
+	/* Now we are ready to start reading data from the client */
+	collect_metadata_from_client(fd, ofd);
+
+	/* wait a little to let our readers finish reading */
+	sleep(1);
+
+	/* stop our readers */
+	stop_all_readers(cpus, pid_array);
+
+	/* wait a little to have the readers clean up */
+	sleep(1);
+
+	put_together_file(cpus, ofd, node, port);
+
+	destroy_all_readers(cpus, pid_array, node, port);
 }
 
 static int do_fork(int cfd)

