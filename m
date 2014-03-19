Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758934AbaCSCOH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 22:14:07 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:39094 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758161AbaCSCOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 22:14:04 -0400
MIME-Version: 1.0
In-Reply-To: <20140318091656.GQ25546@laptop.programming.kicks-ass.net>
References: <CAJvTdK=+aNN66mYpCGgbHGCHhYQAKx-vB0kJSWjVpsNb_hOAtQ@mail.gmail.com>
	<baff264285f6e585df757d58b17788feabc68918.1387403066.git.len.brown@intel.com>
	<tip-40e2d7f9b5dae048789c64672bf3027fbb663ffa@git.kernel.org>
	<1395102010.2474.21.camel@buesod1.americas.hpqcorp.net>
	<20140318091656.GQ25546@laptop.programming.kicks-ass.net>
Date: Tue, 18 Mar 2014 19:14:04 -0700
X-Google-Sender-Auth: nQ4cOLHp8eOSPIv9n-Crlv1EZL0
Message-ID: <CAGQ1y=4q5ayY4fFV=_u4+mn196WEoxw=p0JMyHGFrWt94Xbgxg@mail.gmail.com>
Subject: Re: [tip:x86/urgent] x86 idle: Repair large-server 50-watt idle-power regression
From: Jason Low <jason.low2@hp.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Davidlohr Bueso <davidlohr@hp.com>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, hpa@linux.intel.com,
        len.brown@intel.com, linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2014 at 2:16 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, Mar 17, 2014 at 05:20:10PM -0700, Davidlohr Bueso wrote:
>> On Thu, 2013-12-19 at 11:51 -0800, tip-bot for Len Brown wrote:
>> > Commit-ID:  40e2d7f9b5dae048789c64672bf3027fbb663ffa
>> > Gitweb:     http://git.kernel.org/tip/40e2d7f9b5dae048789c64672bf3027fbb663ffa
>> > Author:     Len Brown <len.brown@intel.com>
>> > AuthorDate: Wed, 18 Dec 2013 16:44:57 -0500
>> > Committer:  H. Peter Anvin <hpa@linux.intel.com>
>> > CommitDate: Thu, 19 Dec 2013 11:47:39 -0800
>> >
>> > x86 idle: Repair large-server 50-watt idle-power regression
>>
>> FYI this commit can cause some non trivial performance regressions for
>> larger core count systems. While not surprising because of the nature of
>> the change, having intel_idle do more cacheline invalidations, I still
>> wanted to let you guys know. For instance, on a 160 core Westmere
>> system, aim7 throughput can go down in a number of tests, anywhere from
>> -10% to -25%.
>>
>> I guess it comes down to one of those performance vs energy things. And
>> sure, max_cstate can be set to overcome this, but it's still something
>> that was previously taken for granted.
>
> -10% to -25% seems a lot for a single cacheline flush. Also I would
> expect the expected idle time to be very short while running aim7. So
> could it be the cacheflush is actually taking longer than the expected
> idle time?

Can we consider conditionally skipping the cacheline flush if the
approximate average CPU idle time is very short, for instance,
something along the lines of skipping if CPU average idle time <
(sched migration cost or "cacheline_flush_penalty")?
