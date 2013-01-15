Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099Ab3AOAWZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 19:22:25 -0500
Received: from mail-vc0-f182.google.com ([209.85.220.182]:35763 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756000Ab3AOAWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 19:22:24 -0500
MIME-Version: 1.0
In-Reply-To: <CAFTL4hzYkPCmkfqBafkTA5E_snkLoC_y3p9xwumj=L1xWAWK0g@mail.gmail.com>
References: <1357941108-14138-1-git-send-email-ccross@android.com>
	<CAFTL4hzYkPCmkfqBafkTA5E_snkLoC_y3p9xwumj=L1xWAWK0g@mail.gmail.com>
Date: Mon, 14 Jan 2013 16:22:23 -0800
X-Google-Sender-Auth: vqLcU99O-P8z6s5wwEFZCSjoa_A
Message-ID: <CAMbhsRQv=ogNmkK=Np6JGM-iuG=aocqb_4aMBC6CW5mpkGvpmw@mail.gmail.com>
Subject: Re: [PATCH v2] hardlockup: detect hard lockups without NMIs using
 secondary cpus
From: Colin Cross <ccross@android.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Don Zickus <dzickus@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        liu chuansheng <chuansheng.liu@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 4:13 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 2013/1/11 Colin Cross <ccross@android.com>:
>> Emulate NMIs on systems where they are not available by using timer
>> interrupts on other cpus.  Each cpu will use its softlockup hrtimer
>> to check that the next cpu is processing hrtimer interrupts by
>> verifying that a counter is increasing.
>>
>> This patch is useful on systems where the hardlockup detector is not
>> available due to a lack of NMIs, for example most ARM SoCs.
>> Without this patch any cpu stuck with interrupts disabled can
>> cause a hardware watchdog reset with no debugging information,
>> but with this patch the kernel can detect the lockup and panic,
>> which can result in useful debugging info.
>>
>> Signed-off-by: Colin Cross <ccross@android.com>
>
> I believe this is pretty much what the RCU stall detector does
> already: checks for other CPUs being responsive. The only difference
> is on how it checks that. For RCU it's about checking for CPUs
> reporting quiescent states when requested to do so. In your case it's
> about ensuring the hrtimer interrupt is well handled.
>
> One thing you can do is to enqueue an RCU callback (cal_rcu()) every
> minute so you can force other CPUs to report quiescent states
> periodically and thus check for lockups.

That's a good point, I'll take a look at using that.  A minute is too
long, some SoCs have maximum HW watchdog periods of under 30 seconds,
but a call_rcu every 10-20 seconds might be sufficient.

> Now you'll face the same problem in the end: if you don't have NMIs,
> you won't have a very useful report.

Yes, but its still better than a silent reset.
