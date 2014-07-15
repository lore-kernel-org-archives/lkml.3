Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933723AbaGOTq2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 15:46:28 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:19114 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933493AbaGOTqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 15:46:20 -0400
Date: Tue, 15 Jul 2014 15:46:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Martin Lau <kafai@fb.com>
Cc: <linux-kernel@vger.kernel.org>, <clm@fb.com>
Subject: Re: [PATCH] ring-buffer: Fix polling on trace_pipe
Message-ID: <20140715154612.06afb98a@gandalf.local.home>
In-Reply-To: <20140710222030.GC12717@devbig242.prn2.facebook.com>
References: <20140610060637.GA14045@devbig242.prn2.facebook.com>
	<20140610114915.5fe24841@gandalf.local.home>
	<20140611055814.GA30265@devbig242.prn2.facebook.com>
	<20140626183445.GA2663@devbig242.prn2.facebook.com>
	<20140626205327.5b526302@gandalf.local.home>
	<20140627065243.GA2826@devbig242.prn2.facebook.com>
	<20140710222030.GC12717@devbig242.prn2.facebook.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/TrnjszWM_Hkpxl_DOb28R5E"
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_/TrnjszWM_Hkpxl_DOb28R5E
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thu, 10 Jul 2014 15:20:30 -0700
Martin Lau <kafai@fb.com> wrote:

> Hi Steve,
> 
> Do you have a chance to give it another try?
> 

OK, I finally got around to testing it. Yep I see your point. Do you
think it should go to 3.16 and stable? I can add it to my next git pull
request.

Also, I modified your test such that it wouldn't hang on failure, but
detects that it hung and returns a exit value to add this to my
testing. That is, it exits with zero on success and non zero on failure.

-- Steve

--MP_/TrnjszWM_Hkpxl_DOb28R5E
Content-Type: text/x-c++src
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=ftrace-test-epoll-kafai-2.c

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/stat.h>
#include <sys/epoll.h>
#include <fcntl.h>
#include <unistd.h>
#include <assert.h>
#include <signal.h>
#include <errno.h>

static const char * debugfs_list[] = {
	"/debug/tracing",
	"/sys/kernel/debug/tracing",
	"/d/tracing",
	NULL,
};

static const char *debugfs;
static int markfd;
static int trace_pipe_fd;

static void alog(const char *name, int ret)
{
	printf("%d: %s: %d\n", getpid(), name, ret);
}

static const char *find_debugfs(void)
{
	struct stat st;
	int i;
	int r;

	for (i = 0; debugfs_list[i]; i++) {
		r = stat(debugfs_list[i], &st);
		if (r < 0)
			continue;
		if (S_ISDIR(st.st_mode))
			return debugfs_list[i];
	}
	return NULL;
}

static char * make_path(const char *file)
{
	char *path;
	int size;

	size = strlen(debugfs) + strlen(file) + 2;
	path = malloc(size);
	if (!path) {
		perror("malloc");
		exit(-1);
	}
	sprintf(path, "%s/%s", debugfs, file);
	return path;
}

static void mark_write(const char *str)
{
	int ret;
	ret = write(markfd, str, strlen(str));
	alog("write(markfd)", ret);
}

static void read_trace_pipe(void)
{
	char buf[1024];
	int r;

	while ((r = read(trace_pipe_fd, buf, 1024)) > 0)
		printf("%.*s", r, buf);
}

int main (int argc, char **argv)
{
	struct epoll_event ee;
	char *marker;
	char *pipe;
	int efd;
	int ret;
	pid_t dwrt_pid;

	debugfs = find_debugfs();
	if (!debugfs) {
		fprintf(stderr, "Could not find debugfs\n");
		exit(-1);
	}

	marker = make_path("trace_marker");
	pipe = make_path("trace_pipe");

	markfd = open(marker, O_WRONLY);
	if (markfd < 0) {
		perror("marker");
		exit(-1);
	}
	trace_pipe_fd = open(pipe, O_RDONLY|O_NONBLOCK);
	if (trace_pipe_fd < 0) {
		perror("trace_pipe");
		exit(-1);
	}

	efd = epoll_create(1);
	if (efd < 0) {
		perror("epoll_create");
		exit(-1);
	}

	mark_write("some data");
	memset(&ee, 0, sizeof(ee));
	ee.events = EPOLLIN;
	ret = epoll_ctl(efd, EPOLL_CTL_ADD, trace_pipe_fd, &ee);
	if (ret < 0) {
		perror("epoll_ctl");
		exit(-1);
	}
	alog("waiting data......", 0);
	ret = epoll_wait(efd, &ee, 1, -1);
	alog("epoll_wait()", ret);
	read_trace_pipe();
	dwrt_pid = fork();
	assert(dwrt_pid != -1);
	if (dwrt_pid > 0) {
		int status;
		sleep(10);
		mark_write("more data");
		sleep(10);
		ret = waitpid(dwrt_pid, &status, WNOHANG);
		if (ret != dwrt_pid) {
			alog("Poll never finished!", 0);
			kill(dwrt_pid, 9);
			exit(-1);
		}
		if (WEXITSTATUS(status) != 0) {
			alog("Something failed on polling!",
				 WEXITSTATUS(status));
			exit(-1);
		}
	} else {
		alog("waiting form more data......", 0);
		ret = epoll_wait(efd, &ee, 1, -1);
		alog("epoll_wait()", ret);
		read_trace_pipe();
		if (ret < 0)
			exit(errno);
	}
	exit (0);
}

--MP_/TrnjszWM_Hkpxl_DOb28R5E--
