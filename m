Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541Ab3KNO0W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 09:26:22 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:43430 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361Ab3KNO0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 09:26:16 -0500
Message-ID: <5284DD7E.30604@gmail.com>
Date: Thu, 14 Nov 2013 07:26:06 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>,
        Joseph Schuchart <joseph.schuchart@tu-dresden.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Fr??d??ric Weisbecker <fweisbec@gmail.com>
CC: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        thomas.ilsche@tu-dresden.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Perf: Correct Assumptions about Sample Timestamps in
 Passes
References: <528484CB.7@tu-dresden.de> <20131114083930.GC16543@gmail.com> <528490DE.4080204@tu-dresden.de> <20131114100552.GA5064@gmail.com>
In-Reply-To: <20131114100552.GA5064@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/13, 3:05 AM, Ingo Molnar wrote:

> What am I missing?

I have spent quite a bit of time on this problem on this well. I think 
the flush time needs to be based on the start time of each round, not 
the minimum time observed across mmaps. I have tried the minimum time 
stamp route and it still fails often enough to be annoying.

See builtin-kvm.c, perf_kvm__mmap_read(). The problem is that it takes 
time to move from mmap to mmap and sample can come in behind you - an 
mmap that has already be scanned with a timestamp less than what is 
determined to be the lowest minimum for the samples actually read. 'perf 
kvm stat live' in a nested environment is a stress test for the problem.

I believe reading perf_clock at the start of each round and using that 
as the flush time will fix the problem (to the degree that perf_clock is 
monotonic across all cpus and sockets).

But, right now we have no means of reading the perf_clock timestamp in 
userspace.

David
