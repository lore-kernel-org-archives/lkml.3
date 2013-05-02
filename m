Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152Ab3EBFsy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 01:48:54 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:34826 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab3EBFsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 01:48:53 -0400
Message-ID: <5181FE1B.6010508@linux.vnet.ibm.com>
Date: Thu, 02 May 2013 13:48:11 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Mike Galbraith <efault@gmx.de>, Alex Shi <alex.shi@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH] sched: wake-affine throttle
References: <5164DCE7.8080906@linux.vnet.ibm.com> <1366626208.2721.12.camel@laptop>
In-Reply-To: <1366626208.2721.12.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050205-5490-0000-0000-00000361A60F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2013 06:23 PM, Peter Zijlstra wrote:
> 
> OK,.. Ingo said that pipe-test was the original motivation for
> wake_affine() and since that's currently broken to pieces due to
> select_idle_sibling() is there still a benefit to having it at all?
> 
> Can anybody find any significant regression when simply killing
> wake_affine()?

I got the proof that we could not simply killing the stuff (finally...).

It's the hackbench with a high pipe number, still on 12 cpu box, the
result of "./hackbench 48 process 10000" is:

	Running with 48*40 (== 1920) tasks.
	Time: 33.372

After killed the wake-affine, the result is:

	Running with 48*40 (== 1920) tasks.
	Time: 38.205

About 14.48% performance dropped without wake-affine, I guess it was
caused by the missing spread behaviour.

I've done the test for several times, also compared with the throttle
approach, default 1ms interval still works very well, the regression on
hackbench start to exceed 2% when interval become 100ms on my box, but
please note the pgbench already gain a lot benefit at that time.

I think now we could say that wake-affine is useful, and we could not
simply kill it.

So I still suggest we adopt the throttle approach, then we could make
adjustment according to the demand.

And please let me know if there are any concerns ;-)

Regards,
Michael Wang

> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

