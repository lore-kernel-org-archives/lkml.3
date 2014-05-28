Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968AbaE1My1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 08:54:27 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:43191 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477AbaE1MyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 08:54:25 -0400
MIME-Version: 1.0
In-Reply-To: <20140528081053.GP11096@twins.programming.kicks-ass.net>
References: <1401257890-30535-1-git-send-email-zheng.z.yan@intel.com>
	<1401257890-30535-7-git-send-email-zheng.z.yan@intel.com>
	<20140528081053.GP11096@twins.programming.kicks-ass.net>
Date: Wed, 28 May 2014 14:54:25 +0200
Message-ID: <CABPqkBTwU8mqHimfUnn0WEonL_reCcBED+tQx3XgwJh7gnFEsw@mail.gmail.com>
Subject: Re: [RFC PATCH 6/7] perf, x86: large PEBS interrupt threshold
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 10:10 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, May 28, 2014 at 02:18:09PM +0800, Yan, Zheng wrote:
>> PEBS always had the capability to log samples to its buffers without
>> an interrupt. Traditionally perf has not used this but always set the
>> PEBS threshold to one.
>>
>> For the common cases we still need to use the PMI because the PEBS
>> hardware has various limitations. The biggest one is that it can not
>> supply a callgraph. It also requires setting a fixed period, as the
>> hardware does not support adaptive period. Another issue is that it
>> cannot supply a time stamp and some other options.
>
> So the reason I've never done this is because Intel has never fully
> explained the demuxing of pebs events.
>
> In particular, the 0x90 offset (IA32_PERF_GLOBAL_STATUS). Intel once
> confirmed to me that that is a direct copy of the similarly named MSR at
> the time of the PEBS assist.
>
> This is a problem, since if multiple counters overflow multiple bits
> will be set and its (afaict) ambiguous which event is for which counter.
>
I am not sure how having only one entry in the PEBS buffer solves this.
I think PEBS will create only one entry if multiple counters overflow
simultaneously. That OVFL_STATUS bitmask will have multiple bits
set. I understand the problem in perf_events because you need to
assign a sample to an event and not all events may record the same
info in the sampling buffer.

> At one point it was said they'd fix this 0x90 offset to indicate which
> counter triggered the event, but I've never heard back if this happened.
>
> So until you can give an official Intel answer on how all this demuxing
> is supposed to work and be correct this patch set isn't moving anywhere.
>
>> To supply a TID it
>> requires flushing on context switch. It can however supply the IP
>
> On SNB+, previous to SNB it would need to have precise==1. I've seen no
> such logic in. Instead you seem to artificially limit it to SNB+, for no
> apparent reason to me.
