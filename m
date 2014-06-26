Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751410AbaFZSe6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 14:34:58 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:61126 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750797AbaFZSe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 14:34:56 -0400
Date: Thu, 26 Jun 2014 11:34:46 -0700
From: Martin Lau <kafai@fb.com>
To: Steven Rostedt <rostedt@goodmis.org>
CC: <linux-kernel@vger.kernel.org>, <clm@fb.com>
Subject: Re: [PATCH] ring-buffer: Fix polling on trace_pipe
Message-ID: <20140626183445.GA2663@devbig242.prn2.facebook.com>
References: <20140610060637.GA14045@devbig242.prn2.facebook.com>
 <20140610114915.5fe24841@gandalf.local.home>
 <20140611055814.GA30265@devbig242.prn2.facebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140611055814.GA30265@devbig242.prn2.facebook.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-26_07:2014-06-26,2014-06-26,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=1.43943745811725e-11 kscore.compositescore=0
 circleOfTrustscore=22.6900859407804 compositescore=0.997695897463551
 urlsuspect_oldscore=0.997695897463551 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.997695897463551 spamscore=0
 recipient_to_sender_domain_totalscore=6 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1406260196
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

Can the modified test program reproduce the problem in your test setup?

Thanks,
--Martin

On Tue, Jun 10, 2014 at 10:58:14PM -0700, Martin Lau wrote:
> Hi Steve,
> 
> Attached is the modified test program.  Here is the sample output:
> 
> localhost ~ # ./ftrace-test-epoll-kafai
>            <...>-1857  [000] ...1   720.174295: tracing_mark_write: some data
> 1857: waitting for more data......
> 1858: written more data
> <block here>
> 
> Thanks,
> --Martin
> 
> On Tue, Jun 10, 2014 at 11:49:15AM -0400, Steven Rostedt wrote:
> > On Mon, 9 Jun 2014 23:06:42 -0700
> > Martin Lau <kafai@fb.com> wrote:
> > 
> > > ring_buffer_poll_wait() should always put the poll_table to its wait_queue
> > > even there is immediate data available.  Otherwise, the following epoll and
> > > read sequence will eventually hang forever:
> > > 
> > > 1. Put some data to make the trace_pipe ring_buffer read ready first
> > > 2. epoll_ctl(efd, EPOLL_CTL_ADD, trace_pipe_fd, ee)
> > > 3. epoll_wait()
> > > 4. read(trace_pipe_fd) till EAGAIN
> > > 5. Add some more data to the trace_pipe ring_buffer
> > > 6. epoll_wait() -> this epoll_wait() will block forever
> > > 
> > > ~ During the epoll_ctl(efd, EPOLL_CTL_ADD,...) call in step 2,
> > >   ring_buffer_poll_wait() returns immediately without adding poll_table,
> > >   which has poll_table->_qproc pointing to ep_poll_callback(), to its
> > >   wait_queue.
> > > ~ During the epoll_wait() call in step 3 and step 6,
> > >   ring_buffer_poll_wait() cannot add ep_poll_callback() to its wait_queue
> > >   because the poll_table->_qproc is NULL and it is how epoll works.
> > > ~ When there is new data available in step 6, ring_buffer does not know
> > >   it has to call ep_poll_callback() because it is not in its wait queue.
> > >   Hence, block forever.
> > > 
> > > Other poll implementation seems to call poll_wait() unconditionally as the very
> > > first thing to do.  For example, tcp_poll() in tcp.c.
> > 
> > I'm trying to see the effect of this bug, but can't seem to reproduce
> > it. Maybe I did something wrong. Attached is a test program I wrote
> > trying to follow your instructions. I don't use epoll, so perhaps I
> > didn't use it correctly.
> > 
> > Can you modify it to show me the problem this is trying to fix. That
> > is, without this patch it hangs, but with the patch it does not.
> > 
> > Thanks!
> > 
> > -- Steve
> > 
> > > 
> > > Signed-off-by: Martin Lau <kafai@fb.com>
> > > ---
> > >  kernel/trace/ring_buffer.c | 4 ----
> > >  1 file changed, 4 deletions(-)
> > > 
> > > diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> > > index fd12cc5..a6e64e8 100644
> > > --- a/kernel/trace/ring_buffer.c
> > > +++ b/kernel/trace/ring_buffer.c
> > > @@ -613,10 +613,6 @@ int ring_buffer_poll_wait(struct ring_buffer *buffer, int cpu,
> > >  	struct ring_buffer_per_cpu *cpu_buffer;
> > >  	struct rb_irq_work *work;
> > >  
> > > -	if ((cpu == RING_BUFFER_ALL_CPUS && !ring_buffer_empty(buffer)) ||
> > > -	    (cpu != RING_BUFFER_ALL_CPUS && !ring_buffer_empty_cpu(buffer, cpu)))
> > > -		return POLLIN | POLLRDNORM;
> > > -
> > >  	if (cpu == RING_BUFFER_ALL_CPUS)
> > >  		work = &buffer->irq_work;
> > >  	else {
> > 
> 

> #include <stdio.h>
> #include <stdlib.h>
> #include <string.h>
> #include <sys/types.h>
> #include <sys/stat.h>
> #include <sys/epoll.h>
> #include <fcntl.h>
> #include <unistd.h>
> #include <assert.h>
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
> 	write(markfd, str, strlen(str));
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
> 	ret = epoll_ctl(efd, EPOLL_CTL_ADD, trace_pipe_fd, &ee);
> 	if (ret < 0) {
> 		perror("epoll_ctl");
> 		exit(-1);
> 	}
> 	epoll_wait(efd, &ee, 1, -1);
> 	read_trace_pipe();
> 	dwrt_pid = fork();
> 	assert(dwrt_pid != -1);
> 	if (dwrt_pid == 0) {
> 		sleep(10);
> 		mark_write("more data");
> 		printf("%d: written more data\n", getpid());
> 	} else {
> 		printf("%d: waitting for more data......\n", getpid());
> 		epoll_wait(efd, &ee, 1, -1);
> 		printf("%d: got more data\n", getpid());
> 		read_trace_pipe();
> 	}
> 	return 0;
> }

