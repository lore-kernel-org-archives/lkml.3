Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692Ab3ERHOq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 May 2013 03:14:46 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:1341 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753559Ab3ERHOm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 May 2013 03:14:42 -0400
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
Message-ID: <51972A51.40106@broadcom.com>
Date: Sat, 18 May 2013 09:14:25 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US;
 rv:1.9.2.24) Gecko/20111103 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ACPI Devel Maling List" <linux-acpi@vger.kernel.org>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: REGRESSION: 3.10-rc1: Dell Latitude e6410 hangs within 3
 seconds
References: <5192363E.7040204@broadcom.com>
 <1396357.SFbZsj3Bmy@vostro.rjw.lan> <5192A0DE.90209@broadcom.com>
 <519697CC.1070308@broadcom.com>
 <20130518014724.GA4006@linux.vnet.ibm.com>
In-Reply-To: <20130518014724.GA4006@linux.vnet.ibm.com>
X-WSS-ID: 7D89F6F531W21567671-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/13 03:47, Paul E. McKenney wrote:
> On Fri, May 17, 2013 at 10:49:16PM +0200, Arend van Spriel wrote:
>> On 05/14/2013 10:38 PM, Arend van Spriel wrote:
>>> On 05/14/2013 10:34 PM, Rafael J. Wysocki wrote:
>>>> On Tuesday, May 14, 2013 03:03:58 PM Arend van Spriel wrote:
>>>>> Laptop hangs pretty soon after booting. Workaround for me was to turn
>>>>> off ACPI on kernel command line, ie. acpi=off
>>>>>
>>>>> Attached is my kernel configuration.
>>>>
>>>> Well, I have no idea what may be the source of this.
>>>
>>> Me neither.
>>>
>>>> Any chance to bisect?
>>>
>>> can try. Rebuilding kernels can be a drag :-p
>>>
>>> Regards,
>>> Arend
>>
>> Hi Rafael,
>>
>> The bisect result found commit c0f4dfd4f as culprit. I also verified
>> that the merge into Linus' tree introduced the issue upstream, ie.
>> 6c24499 works and 1f889ec does not. I tried to revert the commit,
>> but that was a bit risky (conflict to resolve) and did not give me a
>> stable kernel. The only thing that works is selecting acpi=off. I
>> tried also nohz=off but that resulted in /init failure.
>>
>> Regards,
>> Arend
>>
>> ---8<----------------------------------------------------------------
>>
>> commit 1f889ec62c3f0d8913f3c32f9aff2a1e15099346
>>    Merge: 6c24499 8fcfae3
>>
>>    commit 8fcfae31719c0a6c03f2cf63f815b46d378d8be4
>>      Merge: d02a9a8 6d87669
>>
>>      commit 6d87669357936bffa1e8fea7a4e7743e76905736
>>        Merge: 3f944ad 81e5949 910ee45
>>
>>        commit c0f4dfd4f90f1667d234d21f15153ea09a2eaa66
>>        Author: Paul E. McKenney<paul.mckenney@linaro.org>
>>        Date:   Fri Dec 28 11:30:36 2012 -0800
>>
>>            rcu: Make RCU_FAST_NO_HZ take advantage of numbered callbacks
>>
>>            Because RCU callbacks are now associated with the number
>>            of the grace period that they must wait for, CPUs can now
>>            take advance callbacks corresponding to grace periods that
>>            ended while a given CPU was in dyntick-idle mode. This
>>            eliminates the need to try forcing the RCU state machine
>>            while entering idle, thus reducing the CPU intensiveness
>>            of RCU_FAST_NO_HZ, which should increase its energy
>>            efficiency.
>>
>>        Signed-off-by: Paul E. McKenney<paul.mckenney@linaro.org>
>>        Signed-off-by: Paul E. McKenney<paulmck@linux.vnet.ibm.com>
>
> Hello, Arend,
>
> Thank you for tracking this down!  Could you please try out the following
> patch?

Thanks, Paul

That did the trick. Made me bumping into another regression in the 
driver I am maintaining so more fun to do :-)

Looking at the commit message I guess it is already in some tree. 
Otherwise I would have said: "You may add

Tested-by: Arend van Spriel <arend@broadcom.com>"

> ------------------------------------------------------------------------
>
> rcu: Fix comparison sense in rcu_needs_cpu()
>
> Commit c0f4dfd4f (rcu: Make RCU_FAST_NO_HZ take advantage of numbered
> callbacks) introduced a bug that can result in excessively long grace
> periods.  This bug reverse the senes of the "if" statement checking

Oh, there is a typo in the commit message: sense iso senes.

> for lazy callbacks, so that RCU takes a lazy approach when there are
> in fact non-lazy callbacks.  This can result in excessive boot, suspend,
> and resume times.
>
> This commit therefore fixes the sense of this "if" statement.
>
> Reported-by: Borislav Petkov<bp@alien8.de>
> Reported-by: Bjørn Mork<bjorn@mork.no>
> Reported-by: Joerg Roedel<joro@8bytes.org>
> Signed-off-by: Paul E. McKenney<paulmck@linux.vnet.ibm.com>
> Tested-by: Bjørn Mork<bjorn@mork.no>
> Tested-by: Joerg Roedel<joro@8bytes.org>

Gr. AvS

