Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861Ab3KNPC6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 10:02:58 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:37535 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185Ab3KNPCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 10:02:51 -0500
Message-ID: <5284E618.6060701@gmail.com>
Date: Thu, 14 Nov 2013 08:02:48 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>,
        Joseph Schuchart <joseph.schuchart@tu-dresden.de>,
        Fr??d??ric Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        thomas.ilsche@tu-dresden.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Perf: Correct Assumptions about Sample Timestamps in
 Passes
References: <528484CB.7@tu-dresden.de> <20131114083930.GC16543@gmail.com> <528490DE.4080204@tu-dresden.de> <20131114100552.GA5064@gmail.com> <5284DD7E.30604@gmail.com> <20131114144444.GK16796@laptop.programming.kicks-ass.net>
In-Reply-To: <20131114144444.GK16796@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/13, 7:44 AM, Peter Zijlstra wrote:
> On Thu, Nov 14, 2013 at 07:26:06AM -0700, David Ahern wrote:
>> On 11/14/13, 3:05 AM, Ingo Molnar wrote:
>>
>>> What am I missing?
>>
>> I have spent quite a bit of time on this problem on this well. I think the
>> flush time needs to be based on the start time of each round, not the
>> minimum time observed across mmaps. I have tried the minimum time stamp
>> route and it still fails often enough to be annoying.
>>
>> See builtin-kvm.c, perf_kvm__mmap_read(). The problem is that it takes time
>> to move from mmap to mmap and sample can come in behind you - an mmap that
>> has already be scanned with a timestamp less than what is determined to be
>> the lowest minimum for the samples actually read. 'perf kvm stat live' in a
>> nested environment is a stress test for the problem.
>
> In which case you need the sliding sort window to be n*buf_size, where n
> is the number of buffers flushed into the one file. Or move to one file
> per buffer and merge sort the lot, buffers should be monotonic.

The one file per buffer does not work for live commands -- like perf-top 
and kvm-stat-live. perf-trace is not using the ordered samples code, but 
I think it needs to - especially for system wide.

David

