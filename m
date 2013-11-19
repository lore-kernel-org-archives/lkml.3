Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040Ab3KSCdQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 21:33:16 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:64558 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990Ab3KSCdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 21:33:14 -0500
Message-ID: <528ACDE7.3050107@gmail.com>
Date: Mon, 18 Nov 2013 19:33:11 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, jolsa@redhat.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 4/5] perf record: mmap output file - v5
References: <1384267617-3446-1-git-send-email-dsahern@gmail.com>	<1384267617-3446-5-git-send-email-dsahern@gmail.com>	<20131112145707.GV5056@laptop.programming.kicks-ass.net>	<20131112150751.GA19321@ghostprotocols.net>	<20131112151944.GX5056@laptop.programming.kicks-ass.net>	<52824AE3.4050207@gmail.com> <20131112211121.GC25913@gmail.com>	<20131113113439.GI21461@twins.programming.kicks-ass.net>	<52864ED1.1080607@gmail.com>	<20131118090117.GE3866@twins.programming.kicks-ass.net>	<20131118094036.GA26251@gmail.com> <877gc5utkf.fsf@sejong.aot.lge.com>	<528AB229.6030603@gmail.com> <87wqk5t9yd.fsf@sejong.aot.lge.com>	<528ACA41.4030202@gmail.com> <87ob5ht962.fsf@sejong.aot.lge.com>
In-Reply-To: <87ob5ht962.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/13, 7:30 PM, Namhyung Kim wrote:
> On Mon, 18 Nov 2013 19:17:37 -0700, David Ahern wrote:
>> On 11/18/13, 7:13 PM, Namhyung Kim wrote:
>>> I think it should be
>>>
>>>     perf record -e cycles -F 4000 -e faults -c 1 --call-graph dwarf,8192 -a -- sleep 1
>>>
>>> (at least to generate the feedback spiral more efficiently..)
>>
>> you don't need the cycles. faults by itself works. Each event contains
>> 2 pages of data in the sample. With mmap-based output a single
>> sample (1 page fault in any process) generates 2-3 page faults by perf
>> which cause 2-3 >8k samples to be generated, which generates faults,
>> ....
>
> But after perf touches all pages in ring-buffer and stack, it won't
> generate page-faults for itself anymore, right?
>
> Hmm.. thinking it again, perf has all ring-buffer pages in memory when
> mmap() called, right?  If so why not doing something like MAP_POPULATE
> so that it doesn't need to generate minor-faults?

This is mmap'ed output, not the ring buffers or its stack. As the output 
file grows, new pages are needed and those are allocated on access via 
page faults. The ftruncate only extends the file size, it does not 
allocate pages at that time.

David
