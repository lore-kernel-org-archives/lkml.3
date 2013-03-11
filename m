Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130Ab3CKON2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 10:13:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5308 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835Ab3CKON1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 10:13:27 -0400
X-Authority-Analysis: v=2.0 cv=BZhaI8R2 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=m4fIWqi2vWkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=U86TJnmrigoA:10 a=i0EeH86SAAAA:8 a=JnhLdDiocsfa-AvqSFEA:9 a=PUjeQqilurYA:10 a=hPjdaMEvmhQA:10 a=6zhRc_TIoaa-kKtv:21 a=EQxev79JOPAdS3oY:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1363011206.12608.10.camel@gandalf.local.home>
Subject: Re: [PATCH 09/13] tracing: use trace_seq_init to initize seq field
 in trace_iterator
From: Steven Rostedt <rostedt@goodmis.org>
To: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Date: Mon, 11 Mar 2013 10:13:26 -0400
In-Reply-To: <513D8441.7050807@huawei.com>
References: <513D8441.7050807@huawei.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-11 at 15:14 +0800, zhangwei(Jovi) wrote:
> the size of seq field in trace_iterator is more than PAGE_SIZE, so
> seq memset is expensive, try to use cheap seq init method: trace_seq_init

I have no problem with this change, except that it may need to be
audited. The seq code is sent out over the trace buffer, and even though
only root can enable tracing, I still don't want to allow uninitialized
memory to ever be seen by userspace.

I believe this code won't allow it, but that memset() was more of a
paranoid way to protect against uninitialized memory leaking to
userspace. I want to review the effect of this change everywhere before
I include it.

-- Steve

> 
> Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
> ---
>  kernel/trace/trace.c     |   10 ++++++----
>  kernel/trace/trace_kdb.c |    5 +++--
>  2 files changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 4cec7b8..c7cc915 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -3551,9 +3551,10 @@ waitagain:
>  		cnt = PAGE_SIZE - 1;
> 
>  	/* reset all but tr, trace, and overruns */
> -	memset(&iter->seq, 0,
> +	trace_seq_init(&iter->seq);
> +	memset(&iter->ent, 0,
>  	       sizeof(struct trace_iterator) -
> -	       offsetof(struct trace_iterator, seq));
> +	       offsetof(struct trace_iterator, ent));
>  	iter->pos = -1;
> 
>  	trace_event_read_lock();
> @@ -5167,9 +5168,10 @@ __ftrace_dump(bool disable_tracing, enum ftrace_dump_mode oops_dump_mode)
>  		cnt++;
> 
>  		/* reset all but tr, trace, and overruns */
> -		memset(&iter.seq, 0,
> +		trace_seq_init(&iter.seq);
> +		memset(&iter.ent, 0,
>  		       sizeof(struct trace_iterator) -
> -		       offsetof(struct trace_iterator, seq));
> +		       offsetof(struct trace_iterator, ent));
>  		iter.iter_flags |= TRACE_FILE_LAT_FMT;
>  		iter.pos = -1;
> 
> diff --git a/kernel/trace/trace_kdb.c b/kernel/trace/trace_kdb.c
> index 6489b2e..84f1584 100644
> --- a/kernel/trace/trace_kdb.c
> +++ b/kernel/trace/trace_kdb.c
> @@ -37,9 +37,10 @@ static void ftrace_dump_buf(int skip_lines, long cpu_file)
>  	kdb_printf("Dumping ftrace buffer:\n");
> 
>  	/* reset all but tr, trace, and overruns */
> -	memset(&iter.seq, 0,
> +	trace_seq_init(&iter.seq);
> +	memset(&iter.ent, 0,
>  		   sizeof(struct trace_iterator) -
> -		   offsetof(struct trace_iterator, seq));
> +		   offsetof(struct trace_iterator, ent));
>  	iter.iter_flags |= TRACE_FILE_LAT_FMT;
>  	iter.pos = -1;
> 


