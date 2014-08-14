Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861AbaHNLSA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 07:18:00 -0400
Received: from mga14.intel.com ([192.55.52.115]:1347 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754508AbaHNLR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 07:17:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,862,1400050800"; 
   d="scan'208";a="576615976"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Liu, Changcheng" <changcheng.liu@intel.com>,
        "Wang, Xiaoming" <xiaoming.wang@intel.com>,
        "Chakravarty, Souvik K" <souvik.k.chakravarty@intel.com>
Subject: RE: [PATCH] cpuidle: Fix the CPU stuck at C0 for 2-3s after PM_QOS
 back to DEFAULT
Thread-Topic: [PATCH] cpuidle: Fix the CPU stuck at C0 for 2-3s after PM_QOS
 back to DEFAULT
Thread-Index: AQHPt7D9LFYUDjq6M0WfHt459I0U05vP8sfg
Date: Thu, 14 Aug 2014 11:17:52 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A01E5B5FB@SHSMSX101.ccr.corp.intel.com>
References: <1407982309-4863-1-git-send-email-chuansheng.liu@intel.com>
 <CAKnoXLw3DrBAxCUWEkXtvCTf+E1w0xTHJSiSUY6Qd6xHXeGaoQ@mail.gmail.com>
 <20140814110040.GI16043@twins.programming.kicks-ass.net>
 <53EC9A29.8090408@linaro.org>
In-Reply-To: <53EC9A29.8090408@linaro.org>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s7EBI7ce027530



> -----Original Message-----
> From: Daniel Lezcano [mailto:daniel.lezcano@linaro.org]
> Sent: Thursday, August 14, 2014 7:15 PM
> To: Peter Zijlstra
> Cc: Liu, Chuansheng; Rafael J. Wysocki; linux-pm@vger.kernel.org; LKML; Liu,
> Changcheng; Wang, Xiaoming; Chakravarty, Souvik K
> Subject: Re: [PATCH] cpuidle: Fix the CPU stuck at C0 for 2-3s after PM_QOS
> back to DEFAULT
> 
> On 08/14/2014 01:00 PM, Peter Zijlstra wrote:
> > On Thu, Aug 14, 2014 at 12:29:32PM +0200, Daniel Lezcano wrote:
> >> Hi Chuansheng,
> >>
> >> On 14 August 2014 04:11, Chuansheng Liu <chuansheng.liu@intel.com>
> wrote:
> >>
> >>> We found sometimes even after we let PM_QOS back to DEFAULT,
> >>> the CPU still stuck at C0 for 2-3s, don't do the new suitable C-state
> >>> selection immediately after received the IPI interrupt.
> >>>
> >>> The code model is simply like below:
> >>> {
> >>>          pm_qos_update_request(&pm_qos, C1 - 1);
> >>>                  < == Here keep all cores at C0
> >>>          ...;
> >>>          pm_qos_update_request(&pm_qos,
> PM_QOS_DEFAULT_VALUE);
> >>>                  < == Here some cores still stuck at C0 for 2-3s
> >>> }
> >>>
> >>> The reason is when pm_qos come back to DEFAULT, there is IPI interrupt to
> >>> wake up the core, but when core is in poll idle state, the IPI interrupt
> >>> can not break the polling loop.
> >
> > So seeing how you're from @intel.com I'm assuming you're using x86 here.
> >
> > I'm not seeing how this can be possible, MWAIT is interrupted by IPIs
> > just fine, which means we'll fall out of the cpuidle_enter(), which
> > means we'll cpuidle_reflect(), and then leave cpuidle_idle_call().
> >
> > It will indeed not leave the cpu_idle_loop() function and go right back
> > into cpuidle_idle_call(), but that will then call cpuidle_select() which
> > should pick a new C state.
> >
> > So the interrupt _should_ work. If it doesn't you need to explain why.
> 
> I think the issue is related to the poll_idle state, in
> drivers/cpuidle/driver.c. This state is x86 specific and inserted in the
> cpuidle table as the state 0 (POLL). There is no mwait for this state.
> It is a bit confusing because this state is not listed in the acpi /
> intel idle driver but inserted implicitly at the beginning of the idle
> table by the cpuidle framework when the driver is registered.

Yes, I am talking about the poll_idle() function which didn't use the mwait,
If we want the reselection happening immediately, we need to break the poll while loop
with setting schedule bit, insteadly we didn't care if real re-schedule happening or not.




ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
