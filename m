Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758325Ab3JPBZB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 21:25:01 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:58613 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918Ab3JPBY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 21:24:59 -0400
X-AuditID: 9c93017d-b7b2eae000005519-85-525deae9e24a
From: Namhyung Kim <namhyung@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, acme@ghostprotocols.net,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf record: mmap output file - v2
References: <1381805731-10398-1-git-send-email-dsahern@gmail.com>
	<20131015060200.GA3866@gmail.com> <8738o3au2g.fsf@sejong.aot.lge.com>
	<525D4230.6070908@gmail.com>
Date: Wed, 16 Oct 2013 10:24:56 +0900
In-Reply-To: <525D4230.6070908@gmail.com> (David Ahern's message of "Tue, 15
	Oct 2013 07:25:04 -0600")
Message-ID: <87li1u9fdj.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Tue, 15 Oct 2013 07:25:04 -0600, David Ahern wrote:
> On 10/15/13 1:09 AM, Namhyung Kim wrote:
>>> The stat() seems superfluous, here in __cmd_record() we've just checked
>>> the output_name and made sure it exists. Can that stat() call ever fail?
>>
>> AFAICS it's needed to check current file size.  But I think it's better
>> to use fstat().
>
> Sure fstat could be used over stat -- if it ends up staying.
>
>
>>>
>>> 3)
>>>
>>> The rec->bytes_at_mmap_start field feels a bit weird. If I read the code
>>> correctly, in every 'perf record' invocation, rec->bytes_written starts at
>>> 0 - i.e. we don't have repeat invocations of cmd_record().
>>
>> rec->bytes_written is updated when it writes to the output file for
>> synthesizing COMM/MMAP events (this mmap output is not used at that time).
>
> Ingo: I went through a number of itereations before using the
> bytes_at_mmap_start. One of those was to use the bytes_written
> counter. All failed. Header + synthesized events are written to the
> file before we start farming the ring buffers.
>
> Perhaps a good code cleanup will help figure out why. I needed the
> functionality ASAP for use with perf-trace -a so I stuck with the new
> variable. Since this change is working out well, I will look at a code
> clean up on the next round.

session->header.data_offset ?

>
> I am traveling to LinuxCon / KVM Forum / Tracing Forum on
> Friday. Perhaps the clean up and followup patch can be done on the
> long plane ride; more likely when I return which means 3.14 material.

See you there :)

>
>> Actually I worried about the mmap offset not being aligned to page
>> size.  But it seems that's not a problem.
>
> This code snippet makes sure the mmap offset is a multiple of 64M
> (rec->mmap_size). offset is the argument to mmap; mmap_offset is the
> where we are within the mmap for the next copy:
>
> +		offset = rec->bytes_at_mmap_start + rec->bytes_written;
> +		if (offset < (ssize_t) rec->mmap_size) {
> +			rec->mmap_offset = offset;
> +			offset = 0;
> +		} else
> +			rec->mmap_offset = 0;
>

Oh, I overlooked this code, it actually aligned offset.

Thanks,
Namhyung
