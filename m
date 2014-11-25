Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751321AbaKYAyF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 19:54:05 -0500
Received: from g4t3427.houston.hp.com ([15.201.208.55]:54751 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbaKYAyD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 19:54:03 -0500
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
To: Mitchel Humpherys <mitchelh@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Matt Wagantall <mattw@codeaurora.org>,
        "Don Brace (PMC)" <Don.Brace@pmcs.com>,
        "Scales, Webb" <webb.scales@hp.com>
Subject: RE: [PATCH RESEND v8] iopoll: Introduce memory-mapped IO polling
 macros
Thread-Topic: [PATCH RESEND v8] iopoll: Introduce memory-mapped IO polling
 macros
Thread-Index: AQHQCCNtAqVL7P1v/0SqGz4Bzc5Be5xwgPlA
Date: Tue, 25 Nov 2014 00:53:19 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B4029593C5E1F@G9W0745.americas.hpqcorp.net>
References: <1416860092-11620-1-git-send-email-mitchelh@codeaurora.org>
In-Reply-To: <1416860092-11620-1-git-send-email-mitchelh@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.48.37]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Mitchel Humpherys
> Sent: Monday, 24 November, 2014 2:15 PM
...
> From: Matt Wagantall <mattw@codeaurora.org>
> 
> It is sometimes necessary to poll a memory-mapped register until its value
> satisfies some condition. Introduce a family of convenience macros that do
> this. Tight-looping, sleeping, and timing out can all be accomplished
> using these macros.
> 
...
> +#define readx_poll_timeout(op, addr, val, cond, sleep_us, timeout_us)	\
> +({ \
> +	ktime_t timeout = ktime_add_us(ktime_get(), timeout_us); \
> +	might_sleep_if(sleep_us); \
> +	for (;;) { \
> +		(val) = op(addr); \
> +		if (cond) \
> +			break; \
> +		if (timeout_us && ktime_compare(ktime_get(), timeout) > 0) {
> \
> +			(val) = op(addr); \
> +			break; \
> +		} \
> +		if (sleep_us) \
> +			usleep_range((sleep_us >> 2) + 1, sleep_us); \

The hpsa SCSI driver used to use usleep_range in a loop like 
that, but we found that it caused scheduler problems during
boots because it uses TASK_UNINTERRUPTIBLE:
[    9.260668] [sched_delayed] sched: RT throttling activated

msleep() worked much better.

---
Rob Elliott    HP Server Storage



