Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756362AbaGQJVM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 05:21:12 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:10448 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755844AbaGQJVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 05:21:08 -0400
X-IronPort-AV: E=Sophos;i="5.00,907,1396972800"; 
   d="scan'208";a="33401497"
Message-ID: <53C795BE.1070105@cn.fujitsu.com>
Date: Thu, 17 Jul 2014 17:22:06 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Gleb Natapov <gleb@kernel.org>
CC: Jan Kiszka <jan.kiszka@web.de>, <mtosatti@redhat.com>,
        <nadav.amit@gmail.com>, <kvm@vger.kernel.org>, <laijs@cn.fujitsu.com>,
        <isimatu.yasuaki@jp.fujitsu.com>, <guz.fnst@cn.fujitsu.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 5/5] kvm, mem-hotplug: Do not pin apic access page
 in memory.
References: <1404824492-30095-1-git-send-email-tangchen@cn.fujitsu.com> <1404824492-30095-6-git-send-email-tangchen@cn.fujitsu.com> <20140712080442.GH4399@minantech.com> <53C38D55.2040307@cn.fujitsu.com> <20140714145822.GK4399@minantech.com> <53C51608.4080109@web.de> <20140715120921.GT18167@minantech.com> <53C51E66.7030208@cn.fujitsu.com> <20140715124048.GU18167@minantech.com> <53C52469.3060607@cn.fujitsu.com> <20140715144030.GN4399@minantech.com>
In-Reply-To: <20140715144030.GN4399@minantech.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.99]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gleb,

Sorry for the delay. Please see below.

On 07/15/2014 10:40 PM, Gleb Natapov wrote:
......
>>>>
>>> We can request APIC_ACCESS_ADDR reload during L2->L1 vmexit emulation, so
>>> if APIC_ACCESS_ADDR changes while L2 is running it will be reloaded for L1 too.
>>>
>>
>> apic pages for L2 and L1 are not the same page, right ?
>>
> If L2 guest enable apic access page then they are different, otherwise
> they are the same.
>
>> I think, just like we are doing in patch 5/5, we cannot wait for the next
>> L2->L1 vmexit.
>> We should enforce a L2->L1 vmexit in mmu_notifier, just like
>> make_all_cpus_request() does.
>>
>> Am I right ?
>>
> I do not see why forcing APIC_ACCESS_ADDR reload during L2->L1 exit is not enough.

Yes, you are right. APIC_ACCESS_ADDR reload should be done during L2->L1 
vmexit.

I mean, before the page is moved to other place, we have to enforce a 
L2->L1 vmexit,
but not wait for the next L2->L1 vmexit. Since when the page is being 
moved, if the
L2 vm is still running, it could access apic page directly. And the vm 
may corrupt.

In the mmu_notifier called before the page is moved, we have to enforce 
a L2->L1
vmexit, and ask vcpus to reload APIC_ACCESS_ADDR for L2 vm. The process 
will wait
till the page migration is completed, and update the APIC_ACCESS_ADDR, 
and re-enter
guest mode.

Thanks.
