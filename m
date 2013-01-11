Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638Ab3AKULo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 15:11:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55310 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753385Ab3AKULn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 15:11:43 -0500
Message-ID: <50F071F1.6090600@redhat.com>
Date: Fri, 11 Jan 2013 15:11:29 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
CC: Rafael Aquini <aquini@redhat.com>, linux-kernel@vger.kernel.org,
        walken@google.com, eric.dumazet@gmail.com, lwoodman@redhat.com,
        jeremy@goop.org, Jan Beulich <JBeulich@novell.com>, knoel@redhat.com,
        chegu_vinod@hp.com, mingo@redhat.com
Subject: Re: [PATCH 0/5] x86,smp: make ticket spinlock proportional backoff
 w/ auto tuning
References: <20130108172632.1126898a@annuminas.surriel.com> <50ED679B.9020306@linux.vnet.ibm.com> <20130110022722.GA1636@x61.redhat.com> <20130110173603.GA31549@linux.vnet.ibm.com>
In-Reply-To: <20130110173603.GA31549@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2013 12:36 PM, Raghavendra K T wrote:
> * Rafael Aquini <aquini@redhat.com> [2013-01-10 00:27:23]:
>
>> On Wed, Jan 09, 2013 at 06:20:35PM +0530, Raghavendra K T wrote:
>>> I ran kernbench on 32 core (mx3850) machine with 3.8-rc2 base.
>>> x base_3.8rc2
>>> + rik_backoff
>>>      N           Min           Max        Median           Avg        Stddev
>>> x   8       222.977        231.16       227.735       227.388     3.1512986
>>> +   8        218.75       232.347      229.1035     228.25425     4.2730225
>>> No difference proven at 95.0% confidence
>>
>> I got similar results on smaller systems (1 socket, dual-cores and quad-cores)
>> when running Rik's latest series, no big difference for good nor for worse,
>> but I also think Rik's work is meant to address bigger systems with more cores
>> contending for any given spinlock.
>
> I was able to do the test on same 32 core machine with
> 4 guests (8GB RAM, 32 vcpu).
> Here are the results
>
> base = 3.8-rc2
> patched =  base + Rik V3 backoff series [patch 1-4]

I believe I understand why this is happening.

Modern Intel and AMD CPUs have a feature called Pause Loop Exiting (PLE)
and Pause Filter (PF), respectively.  This feature is used to trap to
the host when the guest is spinning on a spinlock.

This allows the host to run something else, and having the spinner
temporarily yield the CPU.  Effectively, this causes the KVM code
to already do some limited amount of spinlock backoff code, in the
host.

Adding more backoff code in the guest can lead to wild delays in
acquiring locks, and generally bad performance.

I suspect that when running in a virtual machine, we should limit
the delay factor to something much smaller, since the host will take
care of most of the backoff for us.

Maybe a maximum delay value of ~10 would do the trick for KVM
guests.

We should be able to get this right by placing the value for the
maximum delay in a __read_mostly section and setting it to something
small from an init function when we detect we are running in a
virtual machine.

Let me cook up, and test, a patch that does that...

-- 
All rights reversed
