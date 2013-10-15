Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674Ab3JOHKI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 03:10:08 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:55982 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753Ab3JOHKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 03:10:06 -0400
X-AuditID: 9c930197-b7b88ae0000032c4-dd-525cea4bf2f6
From: Namhyung Kim <namhyung@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: David Ahern <dsahern@gmail.com>, acme@ghostprotocols.net,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf record: mmap output file - v2
References: <1381805731-10398-1-git-send-email-dsahern@gmail.com>
	<20131015060200.GA3866@gmail.com>
Date: Tue, 15 Oct 2013 16:09:59 +0900
In-Reply-To: <20131015060200.GA3866@gmail.com> (Ingo Molnar's message of "Tue,
	15 Oct 2013 08:02:00 +0200")
Message-ID: <8738o3au2g.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Tue, 15 Oct 2013 08:02:00 +0200, Ingo Molnar wrote:
> * David Ahern <dsahern@gmail.com> wrote:
>
>> +	/* for MMAP based file writes */
>> +	void			*mmap_addr;
>> +	u64			bytes_at_mmap_start; /* bytes in file when mmap use starts */
>> +	u64			mmap_offset;    /* current location within mmap */
>> +	size_t			mmap_size;      /* size of mmap segments */
>> +	bool			use_mmap;
>
>> +	if (!rec->opts.pipe_output && stat(output_name, &st) == 0) {
>> +		rec->use_mmap = true;
>> +		rec->bytes_at_mmap_start = st.st_size - rec->bytes_written;
>> +	}
>
> 1)
>
> I think __cmd_record() has become way too large, nearly 300 lines of code. 
> It would be nice to split it into 2-3 helpers that operate on 'struct 
> perf_record' or so.

Agreed.

>
> 2)
>
> The stat() seems superfluous, here in __cmd_record() we've just checked 
> the output_name and made sure it exists. Can that stat() call ever fail?

AFAICS it's needed to check current file size.  But I think it's better
to use fstat().

>
> 3)
>
> The rec->bytes_at_mmap_start field feels a bit weird. If I read the code 
> correctly, in every 'perf record' invocation, rec->bytes_written starts at 
> 0 - i.e. we don't have repeat invocations of cmd_record().

rec->bytes_written is updated when it writes to the output file for
synthesizing COMM/MMAP events (this mmap output is not used at that time).

>
> That means that this:
>
> 		rec->bytes_at_mmap_start = st.st_size - rec->bytes_written;
>
> is really:
>
> 		rec->bytes_at_mmap_start = st.st_size;
>
> furthermore, since we don't allow appends anymore, st.st_size ought to be 
> zero as well.
>
> Which means that ->bytes_at_mmap_start is always zero - and could be 
> eliminated altogether.

No, st_size is bigger than rec->bytes_written due to the
perf_file_header which is written without updating rec->bytes_written.

Actually I worried about the mmap offset not being aligned to page
size.  But it seems that's not a problem.

Thanks,
Namhyung
