Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293Ab3AOANM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 19:13:12 -0500
Received: from mail-vc0-f169.google.com ([209.85.220.169]:43383 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab3AOANL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 19:13:11 -0500
MIME-Version: 1.0
In-Reply-To: <1357941108-14138-1-git-send-email-ccross@android.com>
References: <1357941108-14138-1-git-send-email-ccross@android.com>
Date: Tue, 15 Jan 2013 01:13:10 +0100
Message-ID: <CAFTL4hzYkPCmkfqBafkTA5E_snkLoC_y3p9xwumj=L1xWAWK0g@mail.gmail.com>
Subject: Re: [PATCH v2] hardlockup: detect hard lockups without NMIs using
 secondary cpus
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Colin Cross <ccross@android.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Don Zickus <dzickus@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        liu chuansheng <chuansheng.liu@intel.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/1/11 Colin Cross <ccross@android.com>:
> Emulate NMIs on systems where they are not available by using timer
> interrupts on other cpus.  Each cpu will use its softlockup hrtimer
> to check that the next cpu is processing hrtimer interrupts by
> verifying that a counter is increasing.
>
> This patch is useful on systems where the hardlockup detector is not
> available due to a lack of NMIs, for example most ARM SoCs.
> Without this patch any cpu stuck with interrupts disabled can
> cause a hardware watchdog reset with no debugging information,
> but with this patch the kernel can detect the lockup and panic,
> which can result in useful debugging info.
>
> Signed-off-by: Colin Cross <ccross@android.com>

I believe this is pretty much what the RCU stall detector does
already: checks for other CPUs being responsive. The only difference
is on how it checks that. For RCU it's about checking for CPUs
reporting quiescent states when requested to do so. In your case it's
about ensuring the hrtimer interrupt is well handled.

One thing you can do is to enqueue an RCU callback (cal_rcu()) every
minute so you can force other CPUs to report quiescent states
periodically and thus check for lockups.

Now you'll face the same problem in the end: if you don't have NMIs,
you won't have a very useful report.
