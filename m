Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787AbaF0Gw4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 02:52:56 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:60168 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751598AbaF0Gwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 02:52:55 -0400
Date: Thu, 26 Jun 2014 23:52:45 -0700
From: Martin Lau <kafai@fb.com>
To: Steven Rostedt <rostedt@goodmis.org>
CC: <linux-kernel@vger.kernel.org>, <clm@fb.com>
Subject: Re: [PATCH] ring-buffer: Fix polling on trace_pipe
Message-ID: <20140627065243.GA2826@devbig242.prn2.facebook.com>
References: <20140610060637.GA14045@devbig242.prn2.facebook.com>
 <20140610114915.5fe24841@gandalf.local.home>
 <20140611055814.GA30265@devbig242.prn2.facebook.com>
 <20140626183445.GA2663@devbig242.prn2.facebook.com>
 <20140626205327.5b526302@gandalf.local.home>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="45Z9DzgjV8m4Oswq"
Content-Disposition: inline
In-Reply-To: <20140626205327.5b526302@gandalf.local.home>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-27_03:2014-06-26,2014-06-27,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=22.6900859407804
 compositescore=0.997695897463551 urlsuspect_oldscore=0.997695897463551
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.997695897463551 spamscore=0
 recipient_to_sender_domain_totalscore=6 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1406270086
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

Hi Steve,

I retried the test program (with the kernel patch).  It does block from
time to time.  I spotted the ee.events is not set to EPOLLIN before
calling epll_ctl(eft, EPOLL_CTL_ADD,...).  I fixed it and ran
the test in a bash-loop.

I have the kafai-2 version attached (with some more logging in case
if it still blocks).

Can you retry?

Thanks,
Martin

On Thu, Jun 26, 2014 at 08:53:27PM -0400, Steven Rostedt wrote:
> On Thu, 26 Jun 2014 11:34:46 -0700
> Martin Lau <kafai@fb.com> wrote:
> 
> > Hi Steve,
> > 
> > Can the modified test program reproduce the problem in your test setup?
> 
> Ah sorry, got distracted by other work.
> 
> OK, I just tried it out, and here's my results:
> 
> I ran you code with my current kernel and this is what I got:
> 
> # ./ftrace-test-epoll-kafai 
>            <...>-3183  [002] ...1    81.777891: tracing_mark_write:
> some data 3183: waitting for more data......
> 3184: written more data
> 
> And it just hung there.
> 
> 
> Then I applied your patch, compiled and booted it, and ran the test
> again, and I got this:
> 
> # ./ftrace-test-epoll-kafai
> 
> It just hung there. No forward progress.
> 
> I don't think that was the result you intended.
> 
> -- Steve
> 
> 

--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: attachment; filename="ftrace-test-epoll-kafai-2.c"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/epoll.h>
#include <fcntl.h>
#include <unistd.h>
#include <assert.h>

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
	if (dwrt_pid == 0) {
		sleep(10);
		mark_write("more data");
	} else {
		alog("waiting form more data......", 0);
		ret = epoll_wait(efd, &ee, 1, -1);
		alog("epoll_wait()", ret);
		read_trace_pipe();
		wait(NULL);
	}
	return 0;
}

--45Z9DzgjV8m4Oswq--
