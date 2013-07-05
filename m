Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454Ab3GENqH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 09:46:07 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:3151 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757410Ab3GENqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 09:46:05 -0400
X-IronPort-AV: E=Sophos;i="4.87,1001,1363132800"; 
   d="scan'208";a="33626665"
Message-ID: <51D6CE19.1050503@citrix.com>
Date: Fri, 5 Jul 2013 14:46:01 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120428 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>, <konrad.wilk@oracle.com>,
        <john.stultz@linaro.org>, <xen-devel@lists.xen.org>,
        Artem Savkov <artem.savkov@gmail.com>
Subject: Re: [tip:timers/core] hrtimers: Support resuming with two or more
 CPUs online (but stopped)
References: <1372329348-20841-2-git-send-email-david.vrabel@citrix.com> <tip-7c4c3a0f18ba57ea2a2985034532303d2929902a@git.kernel.org> <20130705093003.GA4033@cpv436-motbuntu> <51D69ACF.9020001@citrix.com> <alpine.DEB.2.02.1307051225060.11637@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1307051225060.11637@ionos.tec.linutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/13 11:25, Thomas Gleixner wrote:
> On Fri, 5 Jul 2013, David Vrabel wrote:
> 
> You failed to CC Artem :(
> 
>> On 05/07/13 10:30, Artem Savkov wrote:
>>> This commit brings up a warning about a potential deadlock in
>>> smp_call_function_many() discussed previously:
>>> https://lkml.org/lkml/2013/4/18/546
>>
>> Can we just avoid the wait in clock_was_set()?  Something like this?
>>
>> 8<------------------------------------------------------
>> hrtimers: do not wait for other CPUs in clock_was_set()
>>
>> Calling on_each_cpu() and waiting in a softirq causes a WARNing about
>> a potential deadlock.
>>
>> Because hrtimers are per-CPU, it is sufficient to ensure that all
>> other CPUs' timers are reprogrammed as soon as possible and before the
>> next softirq on that CPU.  There is no need to wait for this to be
>> complete on all CPUs.

Unfortunately this doesn't look sufficient.  on_each_cpu(..., 0) may
still wait for other calls to complete before queuing the calls due to
the use of a single set of per-CPU csd data.

David
