Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752320AbaANHbY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 02:31:24 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:62020 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008AbaANHbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 02:31:20 -0500
MIME-Version: 1.0
In-Reply-To: <20140113192406.GL27046@suse.de>
References: <1389103248-17617-1-git-send-email-mgorman@suse.de>
	<20140107141715.GA32491@kroah.com>
	<20140107185440.GA7844@kroah.com>
	<20140107203012.GA27046@suse.de>
	<20140108104340.GC27046@suse.de>
	<20140108134858.GF27046@suse.de>
	<20140113192406.GL27046@suse.de>
Date: Tue, 14 Jan 2014 02:31:18 -0500
X-Google-Sender-Auth: u-DdqrCMQrCDCEMQV3GlmzCiqCo
Message-ID: <CAJvTdKniGkxxzvPvEDSU9BgtubR-5Fn3YsepjSNAwn5XkL3nVA@mail.gmail.com>
Subject: Re: Idle power fix regresses ebizzy performance (was 3.12-stable
 backport of NUMA balancing patches)
From: Len Brown <lenb@kernel.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Len Brown <len.brown@intel.com>, athorlton@sgi.com,
        Rik van Riel <riel@redhat.com>, chegu_vinod@hp.com,
        Greg KH <gregkh@linuxfoundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This is a false alarm.

Thanks for the follow-up, Mel.

Agreed, it makes no sense for ebizzy measure 'throughput', when a
library debug bottleneck
prevents it from scaling past 3% CPU utilization.

Still, the broken configuration did find a difference due to the
addition of CLFLUSH on this box.
It makes me wonder if we will find issues on workloads that may depend
on the latency
of idle entry/exit, or perhaps sensitivity to the state of the cache
line containing thread_info->flags.

If somebody runs into such a workload, please try changing this 1 line
of intel_idle.c to limit
the CLFLUSH to C-states deeper than C1E, and let me know what you see.

- if (this_cpu_has(X86_FEATURE_CLFLUSH_MONITOR))
+ if ((eax > 1) && this_cpu_has(X86_FEATURE_CLFLUSH_MONITOR))
          clflush((void *)&current_thread_info()->flags);

thanks,
Len Brown, Intel Open Source Technology Center
