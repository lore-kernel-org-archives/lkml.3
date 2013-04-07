Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933063Ab3DGI46 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 04:56:58 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:47607 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932993Ab3DGI44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 04:56:56 -0400
Message-ID: <516134C6.2010603@linux.vnet.ibm.com>
Date: Sun, 07 Apr 2013 16:56:38 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org,
        len.brown@intel.com, rafael.j.wysocki@intel.com, jkosina@suse.cz,
        clark.williams@gmail.com, tony.luck@intel.com, keescook@chromium.org,
        mgorman@suse.de, riel@redhat.com
Subject: Re: [patch v3 0/8] sched: use runnable avg in load balance
References: <1364873008-3169-1-git-send-email-alex.shi@intel.com> <515A877B.3020908@linux.vnet.ibm.com> <515BEC5F.60001@intel.com> <5160E355.6000701@linux.vnet.ibm.com> <5161208F.1040209@intel.com>
In-Reply-To: <5161208F.1040209@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040708-5816-0000-0000-00000771F143
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2013 03:30 PM, Alex Shi wrote:
>>
>> According to these data, 90us == 90000 is the inflection point on my box
>> for 22 MB 32 clients item, other test items show different float, so
>> 80~90us is the conclusion.
> 
> Thanks a lot for the testing!
>>
>> Now the concern is how to deal with this issue, the results may changed
>> on different deployment, static value is not acceptable, so we need
>> another new knob here?
>>
>> I'm not sure whether you have take a look at the wake-affine throttle
>> patch I sent weeks ago, it's purpose is throttle the wake-affine to not
>> work too frequently.
> 
> Yes. In the patch your directly set the target cpu to this_cpu when no
> wake_affine. Maybe this is the key points, not the wake_affine cost give
> the improvement. Basically I agree with this. but if so, it is a bit
> blind. but, but, The interesting point is the blind target cpu setting
> has the best performance in our current testing. :)

IMHO, the wake-affine stuff is blindly at all, so actually this throttle
knob should be added at the first time along with the stuff, what we
need to do now is just add that missed knob.

I do believe when first time the wake-affine stuff was added, there is
no regression, but since the world changed, the regression start to be
accumulated and become so big, we could not ignore it now.

The throttle idea is just try to provide a way to stop the blind
judgement, easy and efficient :)

> 
>>
>> And since the aim problem is caused by the imbalance which is the
>> side-effect of frequently succeed wake-affine, may be the throttle patch
>> could help to address that issue too, if it is, then we only need to add
>> one new knob.
> 
> As to the aim7 problem, I need apologise to you all!
> The aim7 regression exist with the patch v2 that base on 3.8 kernel, not
> with this v3 version base on 3.9.
> 
> After the lock-stealing RW sem patch introduced in 3.9 kernel, the aim7
> has recovered the cpu task imbalance, So on balanced 3.9 kernel, this v3
> version won't bring extra imbalance on aim7. no clear regression on
> aim7, no extra imbalance on aim7.
> 
> So, I referenced a old testing result without double confirming, tried
> to resolve a disappeared problem. I am sorry and applogize to you all.

That's all right, and it's good to know we could ignore the last patch,
I really like the benefit 1~7 bring, combined with the throttle idea,
pgbench was satisfied a lot ;-)

Regards,
Michael Wang

> 
> And this burst patch doesn't need on 3.9 kernel. Patch 1,2,4,5,6,7 are
> enough and valid.
> 

