Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829AbaAHEG6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 23:06:58 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:55188 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550AbaAHEGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 23:06:51 -0500
X-AuditID: 9c93017d-b7b66ae000006a2a-28-52ccced84686
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] tools lib traceevent: Add state member to struct trace_seq
References: <1389063612-18173-1-git-send-email-namhyung@kernel.org>
	<1389063612-18173-3-git-send-email-namhyung@kernel.org>
	<20140107130558.GB2919@krava.brq.redhat.com>
Date: Wed, 08 Jan 2014 13:06:48 +0900
In-Reply-To: <20140107130558.GB2919@krava.brq.redhat.com> (Jiri Olsa's message
	of "Tue, 7 Jan 2014 14:05:58 +0100")
Message-ID: <87lhyrce1z.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Tue, 7 Jan 2014 14:05:58 +0100, Jiri Olsa wrote:
> On Tue, Jan 07, 2014 at 12:00:09PM +0900, Namhyung Kim wrote:
>
> SNIP
>
>>  void trace_seq_init(struct trace_seq *s);
>> diff --git a/tools/lib/traceevent/trace-seq.c b/tools/lib/traceevent/trace-seq.c
>> index d7f2e68bc5b9..1747aa50ecb0 100644
>> --- a/tools/lib/traceevent/trace-seq.c
>> +++ b/tools/lib/traceevent/trace-seq.c
>> @@ -32,8 +32,9 @@
>>  #define TRACE_SEQ_POISON	((void *)0xdeadbeef)
>>  #define TRACE_SEQ_CHECK(s)						\
>>  do {									\
>> -	if ((s)->buffer == TRACE_SEQ_POISON)			\
>> -		die("Usage of trace_seq after it was destroyed");	\
>> +	if (WARN_ONCE((s)->buffer == TRACE_SEQ_POISON,			\
>> +		      "Usage of trace_seq after it was destroyed"))	\
>> +		(s)->state = TRACE_SEQ__BUFFER_POISONED;		\
>>  } while (0)
>>  
>>  /**
>> @@ -46,6 +47,7 @@ void trace_seq_init(struct trace_seq *s)
>>  	s->readpos = 0;
>>  	s->buffer_size = TRACE_SEQ_BUF_SIZE;
>>  	s->buffer = malloc_or_die(s->buffer_size);
>> +	s->state = TRACE_SEQ__GOOD;
>>  }
>>  
>>  /**
>> @@ -81,7 +83,7 @@ static void expand_buffer(struct trace_seq *s)
>>  	s->buffer_size += TRACE_SEQ_BUF_SIZE;
>>  	s->buffer = realloc(s->buffer, s->buffer_size);
>>  	if (!s->buffer)
>> -		die("Can't allocate trace_seq buffer memory");
>> +		s->state = TRACE_SEQ__MEM_ALLOC_FAILED;
>
> and also here?
>
> 	if (WARN_ONCE(!s->buffer))
> 		s->state = TRACE_SEQ__MEM_ALLOC_FAILED;

Ah, will fix.

>
> otherwise the whole series seems ok,

Thanks for your review!
Namhyung
