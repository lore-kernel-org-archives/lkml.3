Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab3DIFB1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 01:01:27 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:43035 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab3DIFBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 01:01:25 -0400
Message-ID: <5163A097.4050101@linux.vnet.ibm.com>
Date: Tue, 09 Apr 2013 13:01:11 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
CC: Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Alex Shi <alex.shi@intel.com>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Subject: Re: [RFC PATCH] sched: wake-affine throttle
References: <514FDF76.2060806@linux.vnet.ibm.com> <1365415249.2609.145.camel@laptop>
In-Reply-To: <1365415249.2609.145.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040904-8878-0000-0000-000006A091F9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2013 06:00 PM, Peter Zijlstra wrote:
> On Mon, 2013-03-25 at 13:24 +0800, Michael Wang wrote:
>>         if (affine_sd) {
>> -               if (cpu != prev_cpu && wake_affine(affine_sd, p,
>> sync))
>> +               if (cpu != prev_cpu && wake_affine(affine_sd, p,
>> sync)) {
>> +                       /*
>> +                        * wake_affine() stuff try to pull wakee to
>> the cpu
>> +                        * around waker, this will benefit us if the
>> data
>> +                        * cached on waker cpu is hot for wakee, or
>> the extreme
>> +                        * ping-pong case.
>> +                        *
>> +                        * However, do such blindly work too
>> frequently will
>> +                        * cause regression to some workload, thus,
>> each time
>> +                        * when wake_affine() succeed, throttle it for
>> a while.
>> +                        */
>> +                       wake_affine_throttle(p);
>>                         prev_cpu = cpu;
>> +               }
> 
> How about only throttling when wake_affine() starts returning false? At
> that point its lost its benefit.

Honestly, I used to think this won't work, but the testing results show
it even better than throttle on succeed...your suggestion is correct, it
will be applied to the next version.

But please allow me to express my concern here:

In summary, I don't think 'return false' is the only point wake-affine
lost it's benefit.

When wake-affine return true, the only thing guaranteed is the balance,
but what about the factors like:

1. wakee has no hot data cached on curr_cpu
2. hot data cached on curr_cpu for wakee is less than those on prev_cpu
3. wakee has no relationship with waker at all
...

Those factors was unconsidered when wake_affine() return true, but they
could be a reason for regression too, isn't it?

Anyway, according to the test results, the benefit of wake-affine
reserved by 'throttle on failed' is impressive, those factors failed to
defend them self...

> 
> Also, why not place this inside wake_affine() like you did the throttled
> test.

That's right, will correct it :)

Regards,
Michael Wang

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

