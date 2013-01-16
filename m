Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253Ab3APFmw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 00:42:52 -0500
Received: from mga02.intel.com ([134.134.136.20]:13366 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877Ab3APFmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 00:42:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,476,1355126400"; 
   d="scan'208";a="247476720"
Message-ID: <50F63E16.1060903@intel.com>
Date: Wed, 16 Jan 2013 13:43:50 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
CC: Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "bp@alien8.de" <bp@alien8.de>, "pjt@google.com" <pjt@google.com>,
        "namhyung@kernel.org" <namhyung@kernel.org>,
        "efault@gmx.de" <efault@gmx.de>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 05/22] sched: remove domain iterations in fork/exec/wake
References: <1357375071-11793-1-git-send-email-alex.shi@intel.com> <1357375071-11793-6-git-send-email-alex.shi@intel.com> <20130109182102.GC2046@e103034-lin> <50EF9B69.3000201@linux.vnet.ibm.com>
In-Reply-To: <50EF9B69.3000201@linux.vnet.ibm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-		/* while loop will break here if sd == NULL */
>>
>> I agree that this should be a major optimization. I just can't figure
>> out why the existing recursive search for an idle cpu switches to the
>> new cpu near the end and then starts a search for an idle cpu in the new
>> cpu's domain. Is this to handle some exotic sched domain configurations?
>> If so, they probably wouldn't work with your optimizations.
> 
> Let me explain my understanding of why the recursive search is the way
> it is.
> 
>  _________________________  sd0
> |                         |
> |  ___sd1__   ___sd2__    |
> | |        | |        |   |
> | | sgx    | |  sga   |   |
> | | sgy    | |  sgb   |   |
> | |________| |________|   |
> |_________________________|
> 
> What the current recursive search is doing is (assuming we start with
> sd0-the top level sched domain whose flags are rightly set). we find
> that sd1 is the idlest group,and a cpux1 in sgx is the idlest cpu.
> 
> We could have ideally stopped the search here.But the problem with this
> is that there is a possibility that sgx is more loaded than sgy; meaning
> the cpus in sgx are heavily imbalanced;say there are two cpus cpux1 and
> cpux2 in sgx,where cpux2 is heavily loaded and cpux1 has recently gotten
> idle and load balancing has not come to its rescue yet.According to the
> search above, cpux1 is idle,but is *not the right candidate for
> scheduling forked task,it is the right candidate for relieving the load
> from cpux2* due to cache locality etc.

The problem still exists on the current code. It still goes to cpux1.
and then goes up to sgx to seek idlest group ... idlest cpu, and back to
cpux1 again. nothing help.


