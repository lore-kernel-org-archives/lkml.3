Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932214AbaE1Tsw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 15:48:52 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:55115 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146AbaE1Tsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 15:48:51 -0400
MIME-Version: 1.0
Date: Wed, 28 May 2014 21:48:51 +0200
Message-ID: <CABPqkBTsiwicZNuU5BW6FZfB4aC=T=w9vFoxLqBTV3-PS4BnoA@mail.gmail.com>
Subject: [RFC] perf/x86: PMU IRQ handler issues
From: Stephane Eranian <eranian@google.com>
To: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Some days ago, I was alerted that under important network load, something
is going wrong with perf_event sampling in frequency mode (such as perf top).
The number of samples was way too low given the cycle count (via perf stat).
Looking at the syslog, I noticed that the perf irq latency throttler
had kicked in
several times. There may have been several reasons for this.

Maybe the workload had changing phases and the frequency adjustments
was not working properly and dropping to very small period and then generated
flood of interrupts.

Another explanation is that because we ACK the NMI early, we leave the
door open to other interrupts, incl. NIC, and we are interrupting the execution
of the PMU IRQ handler, yet that detour is measured in the PMU handler
latency, causing more throttling than needed. Is that a plausible scenario too?
And if so, I think we need to narrow the window for timing errors, by
acking late
on all processors and not just HSW.

I still suspect there is something wrong with the frequency mode.

Any better explanation for the problem?
