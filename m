Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136Ab3FXJbu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 05:31:50 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:48850 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751115Ab3FXJbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 05:31:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Xiaoguang Chen <chenxg.marvell@gmail.com>
Cc: Xiaoguang Chen <chenxg@marvell.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ning Jiang <njiang1@marvell.com>, Zhoujie Wu <zjwu@marvell.com>,
        Yilu Mao <ylmao@marvell.com>
Subject: Re: [PATCH v9] Cpufreq: Fix governor start/stop race condition
Date: Mon, 24 Jun 2013 11:41:15 +0200
Message-ID: <80721807.qapsadYhBd@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAFgnuDdzjyUQnXZGMCnwP2mXr7eQ9n-ZxOxxG4KWdgPMKOjEfw@mail.gmail.com>
References: <1371625207-26702-1-git-send-email-chenxg@marvell.com> <51C16B97.3040304@marvell.com> <CAFgnuDdzjyUQnXZGMCnwP2mXr7eQ9n-ZxOxxG4KWdgPMKOjEfw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 24, 2013 02:04:50 PM Xiaoguang Chen wrote:
> Hi, Rafael
> When can this patch be merged?

Well, it's in my bleeding-edge branch.  If it doesn't break builds, it will
go to linux-next for 3.11.

Thanks,
Rafael


> 2013/6/19 Xiaoguang Chen <chenxg@marvell.com>:
> > On 06/19/2013 03:55 PM, Viresh Kumar wrote:
> >>
> >> On 19 June 2013 12:30, Xiaoguang Chen <chenxg@marvell.com> wrote:
> >>>
> >>> Cpufreq governor's stop and start operation should be kept in sequence.
> >>> If not, there will be unexpected behavior, for example:
> >>>
> >>> There are 4 CPUs and policy->cpu=CPU0, CPU1/2/3 are linked to CPU0.
> >>> The normal sequence is as below:
> >>>
> >>> 1) Current governor is userspace, One application tries to set
> >>> governor to ondemand. It will call __cpufreq_set_policy in which it
> >>> will stop userspace governor and then start ondemand governor.
> >>>
> >>> 2) Current governor is userspace, Now CPU0 hotplugs in CPU3 (put CPU3
> >>> online),
> >>> It will call cpufreq_add_policy_cpu in which it first stops userspace
> >>> governor, and then starts userspace governor.
> >>>
> >>> Now if the sequence of above two cases interleaves, It becomes like
> >>> below:
> >>>
> >>> 1) Application stops userspace governor
> >>> 2)                                      Hotplug stops userspace governor
> >>> 3) Application starts ondemand governor
> >>> 4)                                      Hotplug starts a governor
> >>>
> >>> In step 4, Hotplug is supposed to start userspace governor, But now
> >>> the governor has been changed by application to ondemand, So hotplug
> >>> starts ondemand governor again !!!!
> >>>
> >>> The solution is: Do not allow stop policy's governor multi-times.
> >>> Governor should only be stopped once for one policy, After it is stopped,
> >>> No other governor stop operation should be executed. also add one mutex
> >>> to
> >>> protect __cpufreq_governor so governor operation can be kept in sequence.
> >>>
> >>> Signed-off-by: Xiaoguang Chen <chenxg@marvell.com>
> >>> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> >>> ---
> >>>   drivers/cpufreq/cpufreq.c | 24 ++++++++++++++++++++++++
> >>>   include/linux/cpufreq.h   |  1 +
> >>>   2 files changed, 25 insertions(+)
> >>
> >> All good now. Sorry for the noise :)
> >
> > Thank you for the professional instructions. It makes the code more
> > beautiful. :)
> >
> > --
> > Thanks
> > Xiaoguang
> >
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
