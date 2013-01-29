Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857Ab3A2O1q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 09:27:46 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16163 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331Ab3A2O1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 09:27:44 -0500
X-Authority-Analysis: v=2.0 cv=QcjkT7nv c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=N0wm57CNQ5UA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=y2CyqpC7EpYA:10 a=dIpcJ15s2rXEDLvaY88A:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1359469661.17639.32.camel@gandalf.local.home>
Subject: Re: [PATCH] Tracepoint Event: Add 4 tracepoint events for vfs
 subsystem.
From: Steven Rostedt <rostedt@goodmis.org>
To: chenggang <chenggang.qin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, David Ahern <dsahern@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Yanmin Zhang <yanmin.zhang@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chenggang Qin <chenggang.qcg@alibaba-inc.com>
Date: Tue, 29 Jan 2013 09:27:41 -0500
In-Reply-To: <1359444308-3780-1-git-send-email-chenggang.qin@gmail.com>
References: <1359444308-3780-1-git-send-email-chenggang.qin@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-01-29 at 15:25 +0800, chenggang wrote:

> ---
>  include/trace/events/vfs.h |  110 ++++++++++++++++++++++++++++++++++++++++++++
>  mm/filemap.c               |   18 ++++++++
>  2 files changed, 128 insertions(+)
>  create mode 100644 include/trace/events/vfs.h
> 
> diff --git a/include/trace/events/vfs.h b/include/trace/events/vfs.h
> new file mode 100644
> index 0000000..33498e1
> --- /dev/null
> +++ b/include/trace/events/vfs.h
> @@ -0,0 +1,110 @@
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM vfs
> +#define TRACE_INCLUDE_FILE vfs
> +
> +#if !defined(_TRACE_EVENTS_VFS_H) || defined(TRACE_HEADER_MULTI_READ)
> +#define _TRACE_EVENTS_VFS_H
> +
> +#include <linux/tracepoint.h>
> +
> +#include <asm/ptrace.h>
> +
> +TRACE_EVENT(generic_file_aio_read,
> +
> +	TP_PROTO(long long pos, unsigned long bytes, unsigned char *fname),
> +
> +	TP_ARGS(pos, bytes, fname),
> +
> +	TP_STRUCT__entry(
> +		__field(	long long,	pos		)
> +		__field(	unsigned long,	bytes		)
> +		__array(	unsigned char,	fname,	100	)

100 bytes is a big waste of space in the ring buffer. Please use dynamic
string, unless fname is always a 100 bytes in length:

	__string(	fname,		fname		)


> +	),
> +
> +	TP_fast_assign(
> +		__entry->pos	= pos;
> +		__entry->bytes	= bytes;
> +		strncpy(__entry->fname, fname, 100);

Then here add:

	__assign_str(fname, fname);

> +	),
> +
> +	TP_printk("aio read(Filename: %s Pos: %lld Bytes: %lu)",
> +		  __entry->fname, __entry->pos, __entry->bytes)
> +);
> +
> +TRACE_EVENT_FLAGS(generic_file_aio_read, TRACE_EVENT_FL_CAP_ANY)
> +
> +TRACE_EVENT(generic_file_aio_write,
> +
> +	TP_PROTO(long long pos, unsigned long bytes, unsigned char *fname),
> +
> +	TP_ARGS(pos, bytes, fname),
> +
> +	TP_STRUCT__entry(
> +		__field(	long long,	pos		)
> +		__field(	unsigned long,	bytes		)
> +		__array(	unsigned char,	fname,	100	)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->pos	= pos;
> +		__entry->bytes	= bytes;
> +		strncpy(__entry->fname, fname, 100);
> +	),
> +
> +	TP_printk("aio write(Filename: %s Pos: %lld Bytes: %lu)",
> +		  __entry->fname, __entry->pos, __entry->bytes)
> +);
> +
> +TRACE_EVENT_FLAGS(generic_file_aio_write, TRACE_EVENT_FL_CAP_ANY)
> +
> +TRACE_EVENT(direct_io_read,
> +	TP_PROTO(long long pos, unsigned long bytes, unsigned char *fname),
> +
> +	TP_ARGS(pos, bytes, fname),
> +
> +	TP_STRUCT__entry(
> +		__field(	long long,	pos		)
> +		__field(	unsigned long,  bytes		)
> +		__array(	unsigned char,	fname,  100	)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->pos	= pos;
> +		__entry->bytes  = bytes;
> +		strncpy(__entry->fname, fname, 100);
> +	),
> +
> +	TP_printk("direct io read(Filename: %s Pos: %lld Bytes: %lu)",
> +		  __entry->fname, __entry->pos, __entry->bytes)
> +);
> +
> +TRACE_EVENT_FLAGS(direct_io_read, TRACE_EVENT_FL_CAP_ANY)
> +
> +TRACE_EVENT(direct_io_write,
> +	TP_PROTO(long long pos, unsigned long bytes, unsigned char *fname),
> +
> +	TP_ARGS(pos, bytes, fname),
> +
> +	TP_STRUCT__entry(
> +		__field(	long long,	pos		)
> +		__field(	unsigned long,  bytes		)
> +		__array(	unsigned char,	fname,	100	)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->pos	= pos;
> +		__entry->bytes	= bytes;
> +		strncpy(__entry->fname, fname, 100);
> +	),
> +
> +	TP_printk("direct io write(Filename: %s Pos: %lld Bytes: %lu)",
> +		  __entry->fname, __entry->pos, __entry->bytes)

All of these are identical, except that you repeat the tracepoint name
in the TP_printk format, which in unnecessary, as the tracepoint name is
always printed in the trace. Please create a single
DECLACE_EVENT_CLASS() and create 4 DEFINE_EVENTS(). Every TRACE_EVENT
costs about 5k in code. A DECLARE_EVENT_CLASS() costs about 4.5k, and
each DEFINE_EVENT costs about 250 bytes.

-- Steve

> +);
> +
> +TRACE_EVENT_FLAGS(direct_io_write, TRACE_EVENT_FL_CAP_ANY)
> +
> +#endif /* _TRACE_EVENTS_SYSCALLS_H */
> +
> +/* This part must be outside protection */
> +#include <trace/define_trace.h>
> +
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 83efee7..0310e7b 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -42,6 +42,9 @@
>  
>  #include <asm/mman.h>
>  
> +#define CREATE_TRACE_POINTS
> +#include <trace/events/vfs.h>
> +
>  /*


