Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758010Ab3J2C6N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 22:58:13 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:61179 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757424Ab3J2C6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 22:58:11 -0400
Message-ID: <526F2440.9030607@gmail.com>
Date: Mon, 28 Oct 2013 20:58:08 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, Gleb Natapov <gleb@redhat.com>
CC: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>, yoshihiro.yunomae.ez@hitachi.com
Subject: Re: RFC: paravirtualizing perf_clock
References: <526DBD7F.1010807@gmail.com> <20131028131556.GN19466@laptop.lan>
In-Reply-To: <20131028131556.GN19466@laptop.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/13 7:15 AM, Peter Zijlstra wrote:
>> Any suggestions on how to do this and without impacting performance. I
>> noticed the MSR path seems to take about twice as long as the current
>> implementation (which I believe results in rdtsc in the VM for x86 with
>> stable TSC).
>
> So assuming all the TSCs are in fact stable; you could implement this by
> syncing up the guest TSC to the host TSC on guest boot. I don't think
> anything _should_ rely on the absolute TSC value.
>
> Of course you then also need to make sure the host and guest tsc
> multipliers (cyc2ns) are identical, you can play games with
> cyc2ns_offset if you're brave.
>

This and the method Gleb mentioned both are going to be complex and 
fragile -- based assumptions on how the perf_clock timestamps are 
generated. For example, 489223e assumes you have the tracepoint enabled 
at VM start with some means of capturing the data (e.g., a perf-session 
active). In both cases the end result requires piecing together and 
re-generating the VM's timestamp on the events. For perf this means 
either modifying the tool to take parameters and an algorithm on how to 
modify the timestamp or a homegrown tool to regenerate the file with 
updated timestamps.

To back out a bit, my end goal is to be able to create and merge 
perf-events from any context on a KVM-based host -- guest userspace, 
guest kernel space, host userspace and host kernel space (userspace 
events with a perf-clock timestamp is another topic ;-)). Having the 
events generated with the proper timestamp is the simpler approach than 
trying to collect various tidbits of data, massage timestamps (and 
hoping the clock source hasn't changed) and then merge events.

And then for the cherry on top a design that works across architectures 
(e.g., x86 now, but arm later).

David
