Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758261AbaGOUUu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 16:20:50 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:37010 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758132AbaGOUUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 16:20:48 -0400
Date: Tue, 15 Jul 2014 13:20:23 -0700
From: Martin Lau <kafai@fb.com>
To: Steven Rostedt <rostedt@goodmis.org>
CC: <linux-kernel@vger.kernel.org>, <clm@fb.com>
Subject: Re: [PATCH] ring-buffer: Fix polling on trace_pipe
Message-ID: <20140715202021.GA12499@devbig242.prn2.facebook.com>
References: <20140610060637.GA14045@devbig242.prn2.facebook.com>
 <20140610114915.5fe24841@gandalf.local.home>
 <20140611055814.GA30265@devbig242.prn2.facebook.com>
 <20140626183445.GA2663@devbig242.prn2.facebook.com>
 <20140626205327.5b526302@gandalf.local.home>
 <20140627065243.GA2826@devbig242.prn2.facebook.com>
 <20140710222030.GC12717@devbig242.prn2.facebook.com>
 <20140715154612.06afb98a@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140715154612.06afb98a@gandalf.local.home>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-07-15_06:2014-07-15,2014-07-15,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=2.94542168433054e-13 kscore.compositescore=0
 circleOfTrustscore=22.4078557653337 compositescore=0.997695897463551
 urlsuspect_oldscore=0.997695897463551 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=62764
 rbsscore=0.997695897463551 spamscore=0
 recipient_to_sender_domain_totalscore=6 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1407150220
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, I think it should go to both stable and 3.16.

Thanks,
--Martin

On Tue, Jul 15, 2014 at 03:46:12PM -0400, Steven Rostedt wrote:
> On Thu, 10 Jul 2014 15:20:30 -0700
> Martin Lau <kafai@fb.com> wrote:
> 
> > Hi Steve,
> > 
> > Do you have a chance to give it another try?
> > 
> 
> OK, I finally got around to testing it. Yep I see your point. Do you
> think it should go to 3.16 and stable? I can add it to my next git pull
> request.
> 
> Also, I modified your test such that it wouldn't hang on failure, but
> detects that it hung and returns a exit value to add this to my
> testing. That is, it exits with zero on success and non zero on failure.
> 
> -- Steve

> #include <stdio.h>
> #include <stdlib.h>
> #include <string.h>
> #include <sys/types.h>
> #include <sys/wait.h>
> #include <sys/stat.h>
> #include <sys/epoll.h>
> #include <fcntl.h>
> #include <unistd.h>
> #include <assert.h>
> #include <signal.h>
> #include <errno.h>
> 
> static const char * debugfs_list[] = {
> 	"/debug/tracing",
> 	"/sys/kernel/debug/tracing",
> 	"/d/tracing",
> 	NULL,
> };
> 
> static const char *debugfs;
> static int markfd;
> static int trace_pipe_fd;
> 
> static void alog(const char *name, int ret)
> {
> 	printf("%d: %s: %d\n", getpid(), name, ret);
> }
> 
> static const char *find_debugfs(void)
> {
> 	struct stat st;
> 	int i;
> 	int r;
> 
> 	for (i = 0; debugfs_list[i]; i++) {
> 		r = stat(debugfs_list[i], &st);
> 		if (r < 0)
> 			continue;
> 		if (S_ISDIR(st.st_mode))
> 			return debugfs_list[i];
> 	}
> 	return NULL;
> }
> 
> static char * make_path(const char *file)
> {
> 	char *path;
> 	int size;
> 
> 	size = strlen(debugfs) + strlen(file) + 2;
> 	path = malloc(size);
> 	if (!path) {
> 		perror("malloc");
> 		exit(-1);
> 	}
> 	sprintf(path, "%s/%s", debugfs, file);
> 	return path;
> }
> 
> static void mark_write(const char *str)
> {
> 	int ret;
> 	ret = write(markfd, str, strlen(str));
> 	alog("write(markfd)", ret);
> }
> 
> static void read_trace_pipe(void)
> {
> 	char buf[1024];
> 	int r;
> 
> 	while ((r = read(trace_pipe_fd, buf, 1024)) > 0)
> 		printf("%.*s", r, buf);
> }
> 
> int main (int argc, char **argv)
> {
> 	struct epoll_event ee;
> 	char *marker;
> 	char *pipe;
> 	int efd;
> 	int ret;
> 	pid_t dwrt_pid;
> 
> 	debugfs = find_debugfs();
> 	if (!debugfs) {
> 		fprintf(stderr, "Could not find debugfs\n");
> 		exit(-1);
> 	}
> 
> 	marker = make_path("trace_marker");
> 	pipe = make_path("trace_pipe");
> 
> 	markfd = open(marker, O_WRONLY);
> 	if (markfd < 0) {
> 		perror("marker");
> 		exit(-1);
> 	}
> 	trace_pipe_fd = open(pipe, O_RDONLY|O_NONBLOCK);
> 	if (trace_pipe_fd < 0) {
> 		perror("trace_pipe");
> 		exit(-1);
> 	}
> 
> 	efd = epoll_create(1);
> 	if (efd < 0) {
> 		perror("epoll_create");
> 		exit(-1);
> 	}
> 
> 	mark_write("some data");
> 	memset(&ee, 0, sizeof(ee));
> 	ee.events = EPOLLIN;
> 	ret = epoll_ctl(efd, EPOLL_CTL_ADD, trace_pipe_fd, &ee);
> 	if (ret < 0) {
> 		perror("epoll_ctl");
> 		exit(-1);
> 	}
> 	alog("waiting data......", 0);
> 	ret = epoll_wait(efd, &ee, 1, -1);
> 	alog("epoll_wait()", ret);
> 	read_trace_pipe();
> 	dwrt_pid = fork();
> 	assert(dwrt_pid != -1);
> 	if (dwrt_pid > 0) {
> 		int status;
> 		sleep(10);
> 		mark_write("more data");
> 		sleep(10);
> 		ret = waitpid(dwrt_pid, &status, WNOHANG);
> 		if (ret != dwrt_pid) {
> 			alog("Poll never finished!", 0);
> 			kill(dwrt_pid, 9);
> 			exit(-1);
> 		}
> 		if (WEXITSTATUS(status) != 0) {
> 			alog("Something failed on polling!",
> 				 WEXITSTATUS(status));
> 			exit(-1);
> 		}
> 	} else {
> 		alog("waiting form more data......", 0);
> 		ret = epoll_wait(efd, &ee, 1, -1);
> 		alog("epoll_wait()", ret);
> 		read_trace_pipe();
> 		if (ret < 0)
> 			exit(errno);
> 	}
> 	exit (0);
> }

