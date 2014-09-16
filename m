Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754252AbaIPDUi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 23:20:38 -0400
Received: from mga02.intel.com ([134.134.136.20]:47090 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753875AbaIPDUh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 23:20:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,533,1406617200"; 
   d="scan'208";a="477763759"
From: "Ren, Qiaowei" <qiaowei.ren@intel.com>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "Hansen, Dave" <dave.hansen@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v8 08/10] x86, mpx: add prctl commands PR_MPX_REGISTER,
 PR_MPX_UNREGISTER
Thread-Topic: [PATCH v8 08/10] x86, mpx: add prctl commands PR_MPX_REGISTER,
 PR_MPX_UNREGISTER
Thread-Index: AQHPzZ3/3LbWETWFOEu3f3vsawDskpwAzsGAgAJF92A=
Date: Tue, 16 Sep 2014 03:20:27 +0000
Message-ID: <9E0BE1322F2F2246BD820DA9FC397ADE017AE183@shsmsx102.ccr.corp.intel.com>
References: <1410425210-24789-1-git-send-email-qiaowei.ren@intel.com>
	<1410425210-24789-9-git-send-email-qiaowei.ren@intel.com>
 <20140915010025.5940c946@alan.etchedpixels.co.uk>
In-Reply-To: <20140915010025.5940c946@alan.etchedpixels.co.uk>
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



On 2014-09-15, One Thousand Gnomes wrote:
>> The base of the bounds directory is set into mm_struct during
>> PR_MPX_REGISTER command execution. This member can be used to check
>> whether one application is mpx enabled.
> 
> Not really because by the time you ask the question another thread
> might have decided to unregister it.
> 
> 
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
> 
> What stops two threads calling this in parallel ?
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
> 
> or indeed calling this in parallel
> 
> What are the semantics across execve() ?
> 
This will not impact on the semantics of execve(). One runtime library for MPX will be provided (or merged into Glibc), and when the application starts, this runtime will be called to initialize MPX runtime environment, including calling prctl() to notify the kernel to start managing the bounds directories. You can see the discussion about exec(): https://lkml.org/lkml/2014/1/26/199 

It would be extremely unusual for an application to have some MPX and some non-MPX threads, since they would share the same address space and the non-MPX threads would mess up the bounds. That is to say, it looks like be unusual for one of these threads to call prctl() to enable or disable MPX. I guess we need to add some rules into documentation.

Thanks,
Qiaowei

