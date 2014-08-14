Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795AbaHNOKa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 10:10:30 -0400
Received: from mga14.intel.com ([192.55.52.115]:15970 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754120AbaHNOK3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 10:10:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,863,1400050800"; 
   d="scan'208";a="576679578"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Liu, Changcheng" <changcheng.liu@intel.com>,
        "Wang, Xiaoming" <xiaoming.wang@intel.com>,
        "Chakravarty, Souvik K" <souvik.k.chakravarty@intel.com>
Subject: RE: [PATCH] cpuidle: Fix the CPU stuck at C0 for 2-3s after PM_QOS
 back to DEFAULT
Thread-Topic: [PATCH] cpuidle: Fix the CPU stuck at C0 for 2-3s after PM_QOS
 back to DEFAULT
Thread-Index: AQHPt8F75AdjnnUX70e/nlyx/xxV5JvQIeMg
Date: Thu, 14 Aug 2014 14:10:27 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A01E5B73B@SHSMSX101.ccr.corp.intel.com>
References: <1407982309-4863-1-git-send-email-chuansheng.liu@intel.com>
 <CAKnoXLw3DrBAxCUWEkXtvCTf+E1w0xTHJSiSUY6Qd6xHXeGaoQ@mail.gmail.com>
 <20140814105336.GH16043@twins.programming.kicks-ass.net>
 <27240C0AC20F114CBF8149A2696CBE4A01E5B61C@SHSMSX101.ccr.corp.intel.com>
 <20140814131304.GK16043@twins.programming.kicks-ass.net>
In-Reply-To: <20140814131304.GK16043@twins.programming.kicks-ass.net>
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



> -----Original Message-----
> From: Peter Zijlstra [mailto:peterz@infradead.org]
> Sent: Thursday, August 14, 2014 9:13 PM
> To: Liu, Chuansheng
> Cc: Daniel Lezcano; Rafael J. Wysocki; linux-pm@vger.kernel.org; LKML; Liu,
> Changcheng; Wang, Xiaoming; Chakravarty, Souvik K
> Subject: Re: [PATCH] cpuidle: Fix the CPU stuck at C0 for 2-3s after PM_QOS
> back to DEFAULT
> 
> On Thu, Aug 14, 2014 at 11:24:06AM +0000, Liu, Chuansheng wrote:
> > If inspecting the polling flag, we can not fix the race between poll_idle and
> smp_callback,
> > since in poll_idle(), before set polling flag, if the smp_callback come in, then
> no resched bit set,
> > after that, poll_idle() will do the polling action, without reselection
> immediately, it will bring power
> > regression here.
> 
> -ENOPARSE. Is there a question there?

Lezcano suggest to inspect the polling flag, then code is like below:
smp_callback() {
if (polling_flag)
  set_resched_bit;
}

And the poll_idle code is like below:
static int poll_idle(struct cpuidle_device *dev,
                struct cpuidle_driver *drv, int index)
{
        local_irq_enable();
        if (!current_set_polling_and_test()) {
                while (!need_resched())
                        cpu_relax();
        }   
        current_clr_polling();

        return index;
}

The race is:
Idle task:
poll_idle
  local_irq_enable()
<== IPI interrupt coming, check the polling flag is not set yet, do nothing;
Come back to poll_idle, it will stay in the poll loop for a while, instead break
it immediately to let governor reselect the right C-state.






