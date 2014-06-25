Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566AbaFYHEX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 03:04:23 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:42827 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483AbaFYHEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 03:04:21 -0400
Message-ID: <53AA746E.1030500@gmail.com>
Date: Wed, 25 Jun 2014 10:04:14 +0300
From: Avi Kivity <avi.kivity@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>, Andi Kleen <andi@firstfloor.org>
CC: peterz@infradead.org, gleb@kernel.org, pbonzini@redhat.com,
        eranian@google.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 4/4] kvm: Implement PEBS virtualization
References: <1401412327-14810-1-git-send-email-andi@firstfloor.org> <1401412327-14810-5-git-send-email-andi@firstfloor.org> <53A6E0B9.10408@gmail.com> <20140622190225.GN5714@two.firstfloor.org> <20140624164514.GA25220@amt.cnet>
In-Reply-To: <20140624164514.GA25220@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 06/24/2014 07:45 PM, Marcelo Tosatti wrote:
> On Sun, Jun 22, 2014 at 09:02:25PM +0200, Andi Kleen wrote:
>>> First, it's not sufficient to pin the debug store area, you also
>>> have to pin the guest page tables that are used to map the debug
>>> store.  But even if you do that, as soon as the guest fork()s, it
>>> will create a new pgd which the host will be free to swap out.  The
>>> processor can then attempt a PEBS store to an unmapped address which
>>> will fail, even though the guest is configured correctly.
>> That's a good point. You're right of course.
>>
>> The only way I can think around it would be to intercept CR3 writes
>> while PEBS is active and always pin all the table pages leading
>> to the PEBS buffer. That's slow, but should be only needed
>> while PEBS is running.
>>
>> -Andi
> Suppose that can be done separately from the pinned spte patchset.
> And it requires accounting into mlock limits as well, as noted.
>
> One set of pagetables per pinned virtual address leading down to the
> last translations is sufficient per-vcpu.

Or 4, and use the CR3 exit filter to prevent vmexits among the last 4 
LRU CR3 values.
