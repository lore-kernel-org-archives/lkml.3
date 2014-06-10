Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108AbaFJP73 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 11:59:29 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:60617 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751711AbaFJP72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 11:59:28 -0400
Message-ID: <53972B5C.5020605@hurleysoftware.com>
Date: Tue, 10 Jun 2014 11:59:24 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>, Jan Kara <jack@suse.cz>
CC: pmladek@suse.cz, Andrew Morton <akpm@linux-foundation.org>,
        Jet Chen <jet.chen@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: console: lockup on boot
References: <5388838B.8070802@oracle.com> <53888E76.5040101@hurleysoftware.com> <20140530140757.GC2419@quack.suse.cz> <53921116.5050804@oracle.com>
In-Reply-To: <53921116.5050804@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2014 03:05 PM, Sasha Levin wrote:
> On 05/30/2014 10:07 AM, Jan Kara wrote:
>> On Fri 30-05-14 09:58:14, Peter Hurley wrote:
>>>> On 05/30/2014 09:11 AM, Sasha Levin wrote:
>>>>>> Hi all,
>>>>>>
>>>>>> I sometime see lockups when booting my KVM guest with the latest -next kernel,
>>>>>> it basically hangs right when it should start 'init', and after a while I get
>>>>>> the following spew:
>>>>>>
>>>>>> [   30.790833] BUG: spinlock lockup suspected on CPU#1, swapper/1/0
>>>>
>>>> Maybe related to this report: https://lkml.org/lkml/2014/5/30/26
>>>> from Jet Chen which was bisected to
>>>>
>>>> commit bafe980f5afc7ccc693fd8c81c8aa5a02fbb5ae0
>>>> Author:     Jan Kara <jack@suse.cz>
>>>> AuthorDate: Thu May 22 10:43:35 2014 +1000
>>>> Commit:     Stephen Rothwell <sfr@canb.auug.org.au>
>>>> CommitDate: Thu May 22 10:43:35 2014 +1000
>>>>
>>>>      printk: enable interrupts before calling console_trylock_for_printk()
>>>>          We need interrupts disabled when calling console_trylock_for_printk() only
>>>>      so that cpu id we pass to can_use_console() remains valid (for other
>>>>      things console_sem provides all the exclusion we need and deadlocks on
>>>>      console_sem due to interrupts are impossible because we use
>>>>      down_trylock()).  However if we are rescheduled, we are guaranteed to run
>>>>      on an online cpu so we can easily just get the cpu id in
>>>>      can_use_console().
>>>>          We can lose a bit of performance when we enable interrupts in
>>>>      vprintk_emit() and then disable them again in console_unlock() but OTOH it
>>>>      can somewhat reduce interrupt latency caused by console_unlock()
>>>>      especially since later in the patch series we will want to spin on
>>>>      console_sem in console_trylock_for_printk().
>>>>          Signed-off-by: Jan Kara <jack@suse.cz>
>>>>      Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>>>>
>>>> ?
>>    Yeah, very likely. I think I see the problem, I'll send the fix shortly.
>
> Hi Jan,
>
> It seems that the issue I'm seeing is different from the "[prink]  BUG: spinlock
> lockup suspected on CPU#0, swapper/1".
>
> Is there anything else I could try here? The issue is very common during testing.

Sasha,

Is this bisectable? Maybe that's the best way forward here.

Regards,
Peter Hurley

