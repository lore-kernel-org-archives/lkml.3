Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213AbaKQW6h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 17:58:37 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:49803 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022AbaKQW6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 17:58:36 -0500
Message-ID: <546A7D9A.5090009@kernel.dk>
Date: Mon, 17 Nov 2014 15:58:34 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@kernel.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: frequent lockups in 3.18rc4
References: <20141114213124.GB3344@redhat.com> <CA+55aFx16ks_azU0eAcx+qZ5-o8Xo0zzP6aNjrskai8rqp+eMg@mail.gmail.com> <alpine.DEB.2.11.1411142326510.3909@nanos> <CA+55aFxExBiRpPemPECKP9wMnR4F4J=ne8UoHKcXjntGB_OEgA@mail.gmail.com> <CA+55aFyBnd_Hbe46UpeRktS+ePkAdL5k7vEChUMEx3-e8O1Usg@mail.gmail.com> <alpine.DEB.2.11.1411172303070.3909@nanos> <alpine.DEB.2.11.1411172335100.3909@nanos>
In-Reply-To: <alpine.DEB.2.11.1411172335100.3909@nanos>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2014 03:43 PM, Thomas Gleixner wrote:
> On Mon, 17 Nov 2014, Thomas Gleixner wrote:
>> On Mon, 17 Nov 2014, Linus Torvalds wrote:
>>>  	llist_for_each_entry_safe(csd, csd_next, entry, llist) {
>>> -		csd->func(csd->info);
>>> +		smp_call_func_t func = csd->func;
>>> +		void *info = csd->info;
>>>  		csd_unlock(csd);
>>> +
>>> +		func(info);
>>
>> No, that won't work for synchronous calls:
>>
>>     CPU 0      	    		CPU 1
>>
>>     csd_lock(csd);
>>     queue_csd();
>>     ipi();
>> 				func = csd->func;
>> 				info = csd->info;
>> 				csd_unlock(csd);
>>     csd_lock_wait();    
>> 				func(info);
>>    
>> The csd_lock_wait() side will succeed and therefor assume that the
>> call has been completed while the function has not been called at
>> all. Interesting explosions to follow.
>>
>> The proper solution is to revert that commit and properly analyze the
>> problem which Jens was trying to solve and work from there.
> 
> So a combo of both (Jens and yours) might do the trick. Patch below.
> 
> I think what Jens was trying to solve is:
> 
>      CPU 0      	    		CPU 1
>  
>      csd_lock(csd);
>      queue_csd();
>      ipi();
>  				csd->func(csd->info);
>      wait_for_completion(csd);
> 				   complete(csd);
>      reuse_csd(csd);		
> 				csd_unlock(csd);

Maybe... The above looks ok to me from a functional point of view, but
now I can't convince myself that the blk-mq use case is correct.

I'll try and backout the original patch and reproduce the issue, that
should jog my memory and give me full understanding of what the issue I
faced back then was.

-- 
Jens Axboe

