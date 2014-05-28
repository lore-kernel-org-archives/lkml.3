Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269AbaE1UUn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 16:20:43 -0400
Received: from mga01.intel.com ([192.55.52.88]:3720 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753002AbaE1UUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 16:20:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,930,1392192000"; 
   d="scan'208";a="546358476"
Message-ID: <53864517.3040503@intel.com>
Date: Wed, 28 May 2014 13:20:39 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: Re: [RFC] perf/x86: PMU IRQ handler issues
References: <CABPqkBTsiwicZNuU5BW6FZfB4aC=T=w9vFoxLqBTV3-PS4BnoA@mail.gmail.com>
In-Reply-To: <CABPqkBTsiwicZNuU5BW6FZfB4aC=T=w9vFoxLqBTV3-PS4BnoA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2014 12:48 PM, Stephane Eranian wrote:
> Some days ago, I was alerted that under important network load, something
> is going wrong with perf_event sampling in frequency mode (such as perf top).
> The number of samples was way too low given the cycle count (via perf stat).
> Looking at the syslog, I noticed that the perf irq latency throttler
> had kicked in
> several times. There may have been several reasons for this.
> 
> Maybe the workload had changing phases and the frequency adjustments
> was not working properly and dropping to very small period and then generated
> flood of interrupts.

The problem description here is pretty fuzzy.  Could you give some
actual numbers describing the issues that you're seeing, including the
ftrace that Andi was asking for?  There are also some handy tracepoints
for NMI lengths that I stuck in.

The reason that the throttling code is there is that the CPU can get in
to a state where it is doing *NOTHING* other than processing NMIs (the
biggest of which are the perf-driven ones).  It doesn't start throttling
until 128 samples end up averaging more than the limit.

How large of a system is this, btw?  I had the worst issues on a
160-logical-cpu system.  It was much harder to get it to trouble on
smaller systems.
