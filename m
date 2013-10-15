Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759136Ab3JONZ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 09:25:59 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:64091 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758780Ab3JONZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 09:25:58 -0400
Message-ID: <525D4230.6070908@gmail.com>
Date: Tue, 15 Oct 2013 07:25:04 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@kernel.org>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf record: mmap output file - v2
References: <1381805731-10398-1-git-send-email-dsahern@gmail.com>	<20131015060200.GA3866@gmail.com> <8738o3au2g.fsf@sejong.aot.lge.com>
In-Reply-To: <8738o3au2g.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/13 1:09 AM, Namhyung Kim wrote:
>> The stat() seems superfluous, here in __cmd_record() we've just checked
>> the output_name and made sure it exists. Can that stat() call ever fail?
>
> AFAICS it's needed to check current file size.  But I think it's better
> to use fstat().

Sure fstat could be used over stat -- if it ends up staying.


>>
>> 3)
>>
>> The rec->bytes_at_mmap_start field feels a bit weird. If I read the code
>> correctly, in every 'perf record' invocation, rec->bytes_written starts at
>> 0 - i.e. we don't have repeat invocations of cmd_record().
>
> rec->bytes_written is updated when it writes to the output file for
> synthesizing COMM/MMAP events (this mmap output is not used at that time).

Ingo: I went through a number of itereations before using the 
bytes_at_mmap_start. One of those was to use the bytes_written counter. 
All failed. Header + synthesized events are written to the file before 
we start farming the ring buffers.

Perhaps a good code cleanup will help figure out why. I needed the 
functionality ASAP for use with perf-trace -a so I stuck with the new 
variable. Since this change is working out well, I will look at a code 
clean up on the next round.

I am traveling to LinuxCon / KVM Forum / Tracing Forum on Friday. 
Perhaps the clean up and followup patch can be done on the long plane 
ride; more likely when I return which means 3.14 material.

> Actually I worried about the mmap offset not being aligned to page
> size.  But it seems that's not a problem.

This code snippet makes sure the mmap offset is a multiple of 64M 
(rec->mmap_size). offset is the argument to mmap; mmap_offset is the 
where we are within the mmap for the next copy:

+		offset = rec->bytes_at_mmap_start + rec->bytes_written;
+		if (offset < (ssize_t) rec->mmap_size) {
+			rec->mmap_offset = offset;
+			offset = 0;
+		} else
+			rec->mmap_offset = 0;


David
