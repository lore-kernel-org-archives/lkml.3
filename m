Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757467AbaCFASc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 19:18:32 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:51715 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756472AbaCFASb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 19:18:31 -0500
Message-ID: <5317BE94.20703@oracle.com>
Date: Wed, 05 Mar 2014 17:17:24 -0700
From: Khalid Aziz <khalid.aziz@oracle.com>
Organization: Oracle Corp
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: David Lang <david@lang.hm>
CC: Oleg Nesterov <oleg@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        peterz@infradead.org, akpm@linux-foundation.org,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH] Pre-emption control for userspace
References: <1393870033-31076-1-git-send-email-khalid.aziz@oracle.com> <531641A8.40306@zytor.com> <53164824.3000704@oracle.com> <20140304222356.41c55bbc@alan.etchedpixels.co.uk> <5316574F.6040105@oracle.com> <alpine.DEB.2.02.1403050129570.18573@ionos.tec.linutronix.de> <8738ix5uyk.fsf@tassilo.jf.intel.com> <20140305145420.GA30173@redhat.com> <20140305155601.GF22728@two.firstfloor.org> <20140305163644.GA2824@redhat.com> <53175D54.1020804@oracle.com> <alpine.DEB.2.02.1403051506550.6682@nftneq.ynat.uz> <5317B7D5.2030403@oracle.com> <alpine.DEB.2.02.1403051555360.6682@nftneq.ynat.uz>
In-Reply-To: <alpine.DEB.2.02.1403051555360.6682@nftneq.ynat.uz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2014 04:59 PM, David Lang wrote:
> what's the cost to setup mmap of this file in /proc. this is sounding
> like a lot of work.

That is a one time cost paid when a thread initializes itself.

>
>>> is this gain from not giving up the CPU at all? or is it from avoiding
>>> all the delays due to the contending thread trying in turn? the
>>> yield_to() approach avoids all those other threads trying in turn so it
>>> should get fairly close to the same benefits.
>>>
>>
>> The gain is from avoiding contention by giving locking thread a chance
>> to complete its critical section which is expected to be very short
>> (certainly shorter than timeslice). Pre-emption immunity gives it one
>> and only one additional timeslice.
>
> but the yield_to() does almost the same thing, there is a small bump,
> but you don't have to wait for thread B to spin, thread C..ZZZ etc to
> spin before thread A can finish it's work. As soon as the second thread
> hits the critical section, thread A is going to be able to do more work
> (and hopefully finish)
>
>> Hope this helps clear things up.
>
> It doesn't sound like you and I are understanding how the yield_to()
> approach would work. I hope my comments have helped get us on the same
> page.
>

I apologize if I am being dense. My understanding of yield_to() is what 
Oleg had said in his reply earlier, so I will quote the example he gave:

	my_lock()
	{
		if (!TRY_LOCK()) {
			yield_to(owner);
			LOCK();
		}

		owner = gettid();
	}

If thread A had already lost the processor by the time thread B executes 
above code, wouldn't we have paid the price of two context switches for 
thread A?

Thanks,
Khalid
