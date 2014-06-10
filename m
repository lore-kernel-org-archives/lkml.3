Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945AbaFJPtS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 11:49:18 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:5680 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750788AbaFJPtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 11:49:17 -0400
Date: Tue, 10 Jun 2014 11:49:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Martin Lau <kafai@fb.com>
Cc: <linux-kernel@vger.kernel.org>, <clm@fb.com>
Subject: Re: [PATCH] ring-buffer: Fix polling on trace_pipe
Message-ID: <20140610114915.5fe24841@gandalf.local.home>
In-Reply-To: <20140610060637.GA14045@devbig242.prn2.facebook.com>
References: <20140610060637.GA14045@devbig242.prn2.facebook.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/aVeD2gm.TC5IfGvlSuPgUMy"
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_/aVeD2gm.TC5IfGvlSuPgUMy
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Mon, 9 Jun 2014 23:06:42 -0700
Martin Lau <kafai@fb.com> wrote:

> ring_buffer_poll_wait() should always put the poll_table to its wait_queue
> even there is immediate data available.  Otherwise, the following epoll and
> read sequence will eventually hang forever:
> 
> 1. Put some data to make the trace_pipe ring_buffer read ready first
> 2. epoll_ctl(efd, EPOLL_CTL_ADD, trace_pipe_fd, ee)
> 3. epoll_wait()
> 4. read(trace_pipe_fd) till EAGAIN
> 5. Add some more data to the trace_pipe ring_buffer
> 6. epoll_wait() -> this epoll_wait() will block forever
> 
> ~ During the epoll_ctl(efd, EPOLL_CTL_ADD,...) call in step 2,
>   ring_buffer_poll_wait() returns immediately without adding poll_table,
>   which has poll_table->_qproc pointing to ep_poll_callback(), to its
>   wait_queue.
> ~ During the epoll_wait() call in step 3 and step 6,
>   ring_buffer_poll_wait() cannot add ep_poll_callback() to its wait_queue
>   because the poll_table->_qproc is NULL and it is how epoll works.
> ~ When there is new data available in step 6, ring_buffer does not know
>   it has to call ep_poll_callback() because it is not in its wait queue.
>   Hence, block forever.
> 
> Other poll implementation seems to call poll_wait() unconditionally as the very
> first thing to do.  For example, tcp_poll() in tcp.c.

I'm trying to see the effect of this bug, but can't seem to reproduce
it. Maybe I did something wrong. Attached is a test program I wrote
trying to follow your instructions. I don't use epoll, so perhaps I
didn't use it correctly.

Can you modify it to show me the problem this is trying to fix. That
is, without this patch it hangs, but with the patch it does not.

Thanks!

-- Steve

> 
> Signed-off-by: Martin Lau <kafai@fb.com>
> ---
>  kernel/trace/ring_buffer.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index fd12cc5..a6e64e8 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -613,10 +613,6 @@ int ring_buffer_poll_wait(struct ring_buffer *buffer, int cpu,
>  	struct ring_buffer_per_cpu *cpu_buffer;
>  	struct rb_irq_work *work;
>  
> -	if ((cpu == RING_BUFFER_ALL_CPUS && !ring_buffer_empty(buffer)) ||
> -	    (cpu != RING_BUFFER_ALL_CPUS && !ring_buffer_empty_cpu(buffer, cpu)))
> -		return POLLIN | POLLRDNORM;
> -
>  	if (cpu == RING_BUFFER_ALL_CPUS)
>  		work = &buffer->irq_work;
>  	else {


--MP_/aVeD2gm.TC5IfGvlSuPgUMy
Content-Type: text/x-c++src
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=ftrace-test-epoll.c

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/epoll.h>
#include <fcntl.h>
#include <unistd.h>

static const char * debugfs_list[] = {
	"/debug/tracing",
	"/sys/kernel/debug/tracing",
	"/d/tracing",
	NULL,
};

static const char *debugfs;
static int markfd;
static int trace_pipe_fd;

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
	write(markfd, str, strlen(str));
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
	ret = epoll_ctl(efd, EPOLL_CTL_ADD, trace_pipe_fd, &ee);
	if (ret < 0) {
		perror("epoll_ctl");
		exit(-1);
	}
	epoll_wait(efd, &ee, 1, 0);
	read_trace_pipe();
	mark_write("more data");
	epoll_wait(efd, &ee, 1, 0);
	read_trace_pipe();

	return 0;
}

--MP_/aVeD2gm.TC5IfGvlSuPgUMy--
