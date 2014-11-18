Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580AbaKRRnW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 12:43:22 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:60548 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563AbaKRRnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 12:43:20 -0500
Date: Tue, 18 Nov 2014 17:43:11 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/PATCH] ARM: Expose cpuid registers to userspace
Message-ID: <20141118174310.GM28279@e104818-lin.cambridge.arm.com>
References: <1414459152-32425-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414459152-32425-1-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen,

On Tue, Oct 28, 2014 at 01:19:12AM +0000, Stephen Boyd wrote:
> Exporting all the different possible configurations of CPUID
> registers to userspace via hwcaps is going to explode the hwcaps.
> Emulate userspace cpuid register accesses and export a new
> "cpuid" hwcap instead so that userspace can know to try to
> read the cpuid registers itself.

Since there is a parallel thread with the musl guys around CPU feature
detection, I thought I would reply to your patch as well (I missed it
when it first posted as I was on holiday).

First of all, not all the features are relevant to user space, so we
need to make sure the hwcap bits explosion is actually real. If it is
real (I personally doubt it), we should only expose those fields which
are relevant to user space - ID_ISAR*, part of ID_PFR*.

The second issue is that you don't want to expose features which the
kernel does not support (e.g. Neon disabled, crypto would also not be
supported; debug/PMU is another example). So masking or downgrading bit
fields is necessary.

Thirdly, there are reserved bits in the CPUID registers which we don't
want to expose. What if you run an older kernel on a newer hardware
which actually has something to those bits but the kernel doesn't
support them?

Fourthly, there is an auxiliary feature register (ID_AFR0) which is
implementation defined. I'm not sure what user space could do with this.
It needs to be read in combination with MIDR to make any sense but even
though you can't tell before whether the kernel should expose such
information to users.

And lastly, there are big.LITTLE systems, so the kernel needs to provide
a common set of features.

-- 
Catalin
