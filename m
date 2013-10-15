Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932786Ab3JONqE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 09:46:04 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:36709 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932270Ab3JONqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 09:46:00 -0400
Message-ID: <525D4713.3060706@gmail.com>
Date: Tue, 15 Oct 2013 07:45:55 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf record: mmap output file - v2
References: <1381805731-10398-1-git-send-email-dsahern@gmail.com> <87txgj9eir.fsf@sejong.aot.lge.com> <20131015074451.GA28186@gmail.com>
In-Reply-To: <20131015074451.GA28186@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/13 1:44 AM, Ingo Molnar wrote:
>
> * Namhyung Kim <namhyung@kernel.org> wrote:
>
>> [SNIP]
>>> +/* mmap file big chunks at a time */
>>> +#define MMAP_OUTPUT_SIZE   (64*1024*1024)
>>
>> Why did you choose 64MB for the size?  Did you also test other sizes?
>
> Btw., should this value go up if the ring buffer (mmap_pages) is larger
> than 64MB?
>

I made mmap_size a variable:
+	size_t			mmap_size;      /* size of mmap segments */

with the above initial value. I was planning to make it in an option and 
just forgot to complete it.

Why 64M? mmap / munmap are also system calls and I was looking to trade 
off huge file size jumps versus the frequency of adjusting the maps. 64M 
Was just a nice round number between 1 and 100. 8, 16 are too small. 128 
seems to big for a default. That left only 32 and 64. 64M seems the 
better trade off of the two.

Making it a user knob would help with smaller deployments. Could also 
have mmap_size = 0 mean turn it off (use write over mmap).

Perhaps something that adjust automatically would be useful too. e.g., 
For the case that motivates the change I have 16 cpus each with a 4M 
buffer (1024 mmap pages). Should we generically set the size:

mmap_size = ncpus_online * mmap_pages * page_size?

Do that only for system wide profiling?

David
