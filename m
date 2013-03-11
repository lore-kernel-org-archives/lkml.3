Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759Ab3CKCOA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 22:14:00 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57596 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525Ab3CKCN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 22:13:59 -0400
Date: Mon, 11 Mar 2013 11:13:52 +0900 (JST)
Message-Id: <20130311.111352.105946462.d.hatayama@jp.fujitsu.com>
To: ebiederm@xmission.com
Cc: len.brown@intel.com, fenghua.yu@intel.com, x86@kernel.org,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        rob.herring@calxeda.com, grant.likely@secretlab.ca, hpa@zytor.com,
        tglx@linutronix.de, mingo@elte.hu, vgoyal@redhat.com
Subject: Re: [PATCH v1 2/2] x86, apic: Disable BSP if boot cpu is AP
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
In-Reply-To: <20130311.100721.32982204.d.hatayama@jp.fujitsu.com>
References: <20121026.122406.13396329.d.hatayama@jp.fujitsu.com>
	<87r4oloopm.fsf@xmission.com>
	<20130311.100721.32982204.d.hatayama@jp.fujitsu.com>
X-Mailer: Mew version 6.3 on Emacs 24.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: Re: [PATCH v1 2/2] x86, apic: Disable BSP if boot cpu is AP
Date: Mon, 11 Mar 2013 10:07:21 +0900

> From: "Eric W. Biederman" <ebiederm@xmission.com>
> Subject: Re: [PATCH v1 2/2] x86, apic: Disable BSP if boot cpu is AP
> Date: Thu, 25 Oct 2012 21:13:25 -0700
> 
>> HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com> writes:
>> 
>>> From: "H. Peter Anvin" <hpa@zytor.com>
>>> Subject: Re: [PATCH v1 2/2] x86, apic: Disable BSP if boot cpu is AP
>>> Date: Mon, 22 Oct 2012 17:35:47 -0700
>>>
>>>> On 10/22/2012 02:29 PM, Eric W. Biederman wrote:
> <cut>
>>> Considering these, I'll make a patch to clear BSP flag at appropreate
>>> position in kernel boot-up code. OTOH, according to the discussion, it
>>> was reported that clearing BSP flag affected some BIOSes. To deal with
>>> this, I'll prepare a kernel option to decide whether to clear BSP flag
>>> or not.
>>>
>>> Does anyone have any comments now? Or please comment after I submit a
>>> new patch.
>> 
>> I think you are on right track with preparing some patches, and this
>> certainly looks like worth experimenting with.
>> 
>> At least for i386 the code need to verify you have a cpu new enough to
>> have an APIC_BASE_MSR, but I don't think that is going to be hard.
> 
> Eric, you have probably forgotten this work but I want to restart the
> work to allow multiple CPUs on the 2nd kernel. But on my
> investigation, I have a question about inconsistent states kdump
> framework assumes in the crash path on the 1st kernel.
> 
> Now I'm re-investigating how to unset BSP flag on the 1st kernel in a
> safe manner. But then I must discuss possibility of BSP flag being set
> again after the unsetting of BSP. This includes firmware that assumes
> BSP flag is kept set throughtout system execution, but I noticed,
> fundamentally, it can happen even only with kernel code in the
> inconsistent state from the point where any bug happpens to before
> entering 2nd kernel.
> 
> For example, some bug that causes buffer overrun can rewrite kdump
> code so some part of it be wrmsr but any other part is safe enough to
> boot 2nd kernel successfully... Although this is very low, but it must
> actually happen. Of course, we face the same situation if we put
> unsetting code in machine_shutdown() path, which is similarly not
> guaranteed to work well in inconsistent state.
> 
> Different from kernel state and similar to any other device states, it
> seems to me that it's impossible to unset BSP flag in a safe manner
> together with inconsistent state kdump framework considers. Then, it
> seems to me that disabling BSP on 2nd kernel is a final resort.

I noticed this was not enough. In the inconsistent state, even AP can
have BSP flag set due to some bug. Then, in conclusion, we cannot use
multiple cpus on the 2nd kernel on top of kdump framework policy if
any change cannot be made there.

It seems to me that at least there needs to be the following design
policy for multiple CPUs on the 2nd kenrel:

- There's no firmware, kernel components and modules that depend on
  BSP flag being kept set on the original BSP flag and never set BSP
  flag of any of the existing CPUs again at runtime.

- Exclude a kind of bugs on which kdump framework works well, that set
  BSP flag on any of the existing CPUs including AP.

If one of the assumption doesn't hold, we have to accept a risk of
system leading to unspecified behaviour.

Thanks.
HATAYAMA, Daisuke

