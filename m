Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181Ab3FFNvw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 09:51:52 -0400
Received: from exprod6og103.obsmtp.com ([64.18.1.185]:38572 "EHLO
	exprod6og103.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991Ab3FFNvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 09:51:50 -0400
Message-ID: <51B09399.1060301@verisign.com>
Date: Thu, 06 Jun 2013 09:50:17 -0400
From: David C Niemi <dniemi@verisign.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Borislav Petkov <bp@suse.de>
CC: Stratos Karafotis <stratosk@semaphore.gr>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] cpufreq: ondemand: Change the calculation of target
 frequency
References: <51AF60D5.3080605@semaphore.gr> <20130605161703.GA29958@pd.tnic> <51AF6E39.2080307@verisign.com> <20130606095526.GB21181@pd.tnic>
In-Reply-To: <20130606095526.GB21181@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Jun 2013 13:50:17.0560 (UTC) FILETIME=[C7316580:01CE62BC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/13 05:55, Borislav Petkov wrote:
> Please do not top-post.
>
> On Wed, Jun 05, 2013 at 12:58:33PM -0400, David C Niemi wrote:
>> When you are doing a locally-originated truly CPU-bound task, "race to
>> idle" does make some sense. But I can think of a couple of caveats.
>>
>> 1) If you care about power consumption, you want to avoid
>> super-power-hungry turbo states, as you get less done per watt-hour
>> than in some of the middle states.
>>
>> 2) CPU usage that is related to I/O (network, disk, video) doesn't
>> necessarily let you go to idle sooner if at all. In this case if you
>> want to minimize power consumption you may want to use middle states a
>> lot. But if you care more about responsiveness or latency than power
>> consumption, you might want to go to a high state anyway; that is why
>> we have tunables -- so we can configure based on the actual priorities
>> for the machine.
> No, users don't always know about tunables - this should Just Work(tm).
It should "Just Work" for the common mass-market case.  Tunables are not for the average end-user -- they are for either the userland part of the operating system to manage, or for people like me who have specific requirements to meet on thoroughly managed machines.  Without tunables you will be lumping servers, desktops, laptops, and embedded devices together and they simply do not have the same high-level priorities.
>
> The correct "fix" for this whole deal is coupling cpufreq with
> the scheduler, as it has been said so many times before. You need
> "something" which can tell you whether raising the freq. is worth it or
> not (i.e. the process is waiting on IO or is executing instructions).
I'll grant you this in the case of regular userland processes that have medium to large chunks of work to do.  For handling huge amounts of I/O, you have different needs -- think about cases where you need to peg many of your cores at once just handling I/O.  That has to work well too.  That's not saying the scheduler can't help, but the governor needs to know about all CPU consumed, including doing I/O and in all parts of the kernel.

Another part of this picture is the p-state governor.  That is even more scheduler-relevant than the c-state governor.
...
DCN
