Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253AbaIRAtI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 20:49:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:36936 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756986AbaIRAtF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 20:49:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,543,1406617200"; 
   d="scan'208";a="601332159"
From: "Ren, Qiaowei" <qiaowei.ren@intel.com>
To: Kevin Easton <kevin@guarana.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "Hansen, Dave" <dave.hansen@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v8 08/10] x86, mpx: add prctl commands PR_MPX_REGISTER,
 PR_MPX_UNREGISTER
Thread-Topic: [PATCH v8 08/10] x86, mpx: add prctl commands PR_MPX_REGISTER,
 PR_MPX_UNREGISTER
Thread-Index: AQHPzZ3/3LbWETWFOEu3f3vsawDskpwC5FKAgAB7e3A=
Date: Thu, 18 Sep 2014 00:40:29 +0000
Message-ID: <9E0BE1322F2F2246BD820DA9FC397ADE017B32C6@shsmsx102.ccr.corp.intel.com>
References: <1410425210-24789-1-git-send-email-qiaowei.ren@intel.com>
 <1410425210-24789-9-git-send-email-qiaowei.ren@intel.com>
 <20140916075007.GA22076@chicago.guarana.org>
In-Reply-To: <20140916075007.GA22076@chicago.guarana.org>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2014-09-16, Kevin Easton wrote:
> On Thu, Sep 11, 2014 at 04:46:48PM +0800, Qiaowei Ren wrote:
>> +
>> +int mpx_register(struct task_struct *tsk) {
>> +	struct mm_struct *mm = tsk->mm;
>> +
>> +	if (!cpu_has_mpx)
>> +		return -EINVAL;
>> +
>> +	/*
>> +	 * runtime in the userspace will be responsible for allocation of
>> +	 * the bounds directory. Then, it will save the base of the bounds
>> +	 * directory into XSAVE/XRSTOR Save Area and enable MPX through
>> +	 * XRSTOR instruction.
>> +	 *
>> +	 * fpu_xsave() is expected to be very expensive. In order to do
>> +	 * performance optimization, here we get the base of the bounds
>> +	 * directory and then save it into mm_struct to be used in future.
>> +	 */
>> +	mm->bd_addr = task_get_bounds_dir(tsk);
>> +	if (!mm->bd_addr)
>> +		return -EINVAL;
>> +
>> +	return 0;
>> +}
>> +
>> +int mpx_unregister(struct task_struct *tsk) {
>> +	struct mm_struct *mm = current->mm;
>> +
>> +	if (!cpu_has_mpx)
>> +		return -EINVAL;
>> +
>> +	mm->bd_addr = NULL;
>> +	return 0;
>> +}
> 
> If that's changed, then mpx_register() and mpx_unregister() don't need
> a task_struct, just an mm_struct.
> 
Yes. An mm_struct is enough.

> Probably these functions should be locking mmap_sem.
> 
> Would it be prudent to use an error code other than EINVAL for the
> "hardware doesn't support it" case?
>
Seems like no specific error code for this case.

>> @@ -2011,6 +2017,12 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned
> long, arg2, unsigned long, arg3,
>>  			me->mm->def_flags &= ~VM_NOHUGEPAGE;
>>  		up_write(&me->mm->mmap_sem);
>>  		break;
>> +	case PR_MPX_REGISTER:
>> +		error = MPX_REGISTER(me);
>> +		break;
>> +	case PR_MPX_UNREGISTER:
>> +		error = MPX_UNREGISTER(me);
>> +		break;
> 
> If you pass me->mm from prctl, that makes it clear that it's
> per-process not per-thread, just like PR_SET_DUMPABLE / PR_GET_DUMPABLE.
> 
> This code should also enforce nulls in arg2 / arg3 / arg4,/ arg5 if
> it's not using them, otherwise you'll be sunk if you ever want to use them later.
> 
> It seems like it only makes sense for all threads using the mm to have
> the same bounds directory set.  If the interface was changed to
> directly pass the address, then could the kernel take care of setting
> it for *all* of the threads in the process? This seems like something
> that would be easier for the kernel to do than userspace.
> 
If the interface was changed to this, it will be possible for insane application to pass error bounds directory address to kernel. We still have to call fpu_xsave() to check this.

Thanks,
Qiaowei

