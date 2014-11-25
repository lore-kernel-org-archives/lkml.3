Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751809AbaKYBVN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 20:21:13 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:36126 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210AbaKYBVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 20:21:12 -0500
From: Mitchel Humpherys <mitchelh@codeaurora.org>
To: "Elliott\, Robert \(Server Storage\)" <Elliott@hp.com>
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "iommu\@lists.linux-foundation.org" 
	<iommu@lists.linux-foundation.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matt Wagantall <mattw@codeaurora.org>,
        "Don Brace \(PMC\)" <Don.Brace@pmcs.com>,
        "Scales\, Webb" <webb.scales@hp.com>
Subject: Re: [PATCH RESEND v8] iopoll: Introduce memory-mapped IO polling macros
References: <1416860092-11620-1-git-send-email-mitchelh@codeaurora.org>
	<94D0CD8314A33A4D9D801C0FE68B4029593C5E1F@G9W0745.americas.hpqcorp.net>
Date: Mon, 24 Nov 2014 17:21:09 -0800
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B4029593C5E1F@G9W0745.americas.hpqcorp.net>
	(Robert Elliott's message of "Tue, 25 Nov 2014 00:53:19 +0000")
Message-ID: <vnkwy4r0gjne.fsf@mitchelh-linux.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24 2014 at 04:53:19 PM, "Elliott, Robert (Server Storage)" <Elliott@hp.com> wrote:
>> -----Original Message-----
>> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
>> owner@vger.kernel.org] On Behalf Of Mitchel Humpherys
>> Sent: Monday, 24 November, 2014 2:15 PM
> ...
>> From: Matt Wagantall <mattw@codeaurora.org>
>> 
>> It is sometimes necessary to poll a memory-mapped register until its value
>> satisfies some condition. Introduce a family of convenience macros that do
>> this. Tight-looping, sleeping, and timing out can all be accomplished
>> using these macros.
>> 
> ...
>> +#define readx_poll_timeout(op, addr, val, cond, sleep_us, timeout_us)	\
>> +({ \
>> +	ktime_t timeout = ktime_add_us(ktime_get(), timeout_us); \
>> +	might_sleep_if(sleep_us); \
>> +	for (;;) { \
>> +		(val) = op(addr); \
>> +		if (cond) \
>> +			break; \
>> +		if (timeout_us && ktime_compare(ktime_get(), timeout) > 0) {
>> \
>> +			(val) = op(addr); \
>> +			break; \
>> +		} \
>> +		if (sleep_us) \
>> +			usleep_range((sleep_us >> 2) + 1, sleep_us); \
>
> The hpsa SCSI driver used to use usleep_range in a loop like 
> that, but we found that it caused scheduler problems during
> boots because it uses TASK_UNINTERRUPTIBLE:
> [    9.260668] [sched_delayed] sched: RT throttling activated
>
> msleep() worked much better.

Hmm, maybe you were just sleeping for too long?  According to
Documentation/timers/timers-howto.txt, usleep_range is what should be
used for non-atomic sleeps in the range [10us, 20ms].  Plus we need
microsecond granularity anyways, so msleep wouldn't cut it.

If there are any potential users of these macros that would want to
sleep for more than 20ms I guess we could add a special case here to use
msleep when sleep_us exceeds 20,000 or so.


-Mitch

-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
