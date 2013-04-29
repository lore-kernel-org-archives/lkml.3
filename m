Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484Ab3D2GAK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 02:00:10 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62898 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750710Ab3D2GAJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 02:00:09 -0400
X-IronPort-AV: E=Sophos;i="4.87,571,1363104000"; 
   d="scan'208";a="7156868"
Subject: Re: [PATCH] cpu: rid cpu_hotplug_disabled check for cpu_down()
From: li guang <lig.fnst@cn.fujitsu.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>
In-Reply-To: <517DFE23.7060805@linux.vnet.ibm.com>
References: <1367203791-9723-1-git-send-email-lig.fnst@cn.fujitsu.com>
	 <517DF770.6020402@linux.vnet.ibm.com>
	 <1367210556.20507.68.camel@liguang.fnst.cn.fujitsu.com>
	 <517DFE23.7060805@linux.vnet.ibm.com>
Date: Mon, 29 Apr 2013 13:20:20 +0800
Message-ID: <1367212820.20507.69.camel@liguang.fnst.cn.fujitsu.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/29 13:20:56,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/29 13:20:58,
	Serialize complete at 2013/04/29 13:20:58
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

在 2013-04-29一的 10:29 +0530，Srivatsa S. Bhat写道：
> On 04/29/2013 10:12 AM, li guang wrote:
> > 在 2013-04-29一的 10:00 +0530，Srivatsa S. Bhat写道：
> >> On 04/29/2013 08:19 AM, liguang wrote:
> >>> in cpu_down(), _cpu_down() will do
> >>> "
> >>>         if (num_online_cpus() == 1)
> >>>                  return -EBUSY;
> >>> "
> >>> when cpu_hotplug_disabled was set, num_online_cpus
> >>> will return 1 for there's only 1 boot cpu.
> >>> so, it's unnecessary to check cpu_hotplug_disabled
> >>> here.
> >>>
> >>
> >> The 2 checks serve very different purposes; they are not the same!
> > 
> > purposes are different, but I think effects are same for this case,
> > the statement 'if ((num_online_cpus() == 1)' seems
> > have same effect with cpu_hotplug_disabled here,
> > because when cpu_hotplug_disabled, only boot cpu is online
> > 
> 
> Why do you keep saying that? They are *two* *different* checks!
> Whether they happen to have the same effect or not completely depends
> on the particular *usecase*. And for example, in the suspend/resume case,
> when the flag 'cpu_hotplug_disabled' is set, *all* CPUs are online!
> Only much later do we actually call disable_nonboot_cpus() to offline
> the non-boot CPUs. Take a look at the following functions, then you'll
> see what scenario I'm referring to:
> cpu_hotplug_disable_before_freeze(), cpu_hotplug_disable_after_thaw()
> 
> Also, recently, there was another usecase for the cpu_hotplug_disabled
> flag, in the reboot code. Here is the link to that discussion:
> http://thread.gmane.org/gmane.linux.kernel/1480380
> 

OK, Thanks!

> 
> >>
> >> The num_online_cpus() check is to ensure that the user doesn't do
> >> something insane like trying to offline the last online CPU in the
> >> system.
> >>
> >> Whereas, the flag 'cpu_hotplug_disabled' is used to prevent user-
> >> triggered CPU hotplug (such as those initiated through sysfs).
> >> This is useful in cases where the system itself wants to initiate CPU
> >> hotplug and it doesn't want annoying races with CPU hotplug going
> >> on in parallel due to other reasons. One such case is suspend/resume.
> >> That's why, if you have noticed, the suspend/resume code invokes the
> >> _cpu_down() version, in order to bypass the flag and get its job done.
> >>
> >> So, no, I think the check needs to stay.
> >>
> >> Regards,
> >> Srivatsa S. Bhat
> >>
> >>> Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
> >>> ---
> >>>  kernel/cpu.c |    6 ------
> >>>  1 files changed, 0 insertions(+), 6 deletions(-)
> >>>
> >>> diff --git a/kernel/cpu.c b/kernel/cpu.c
> >>> index b5e4ab2..cd166d3 100644
> >>> --- a/kernel/cpu.c
> >>> +++ b/kernel/cpu.c
> >>> @@ -330,14 +330,8 @@ int __ref cpu_down(unsigned int cpu)
> >>>
> >>>  	cpu_maps_update_begin();
> >>>
> >>> -	if (cpu_hotplug_disabled) {
> >>> -		err = -EBUSY;
> >>> -		goto out;
> >>> -	}
> >>> -
> >>>  	err = _cpu_down(cpu, 0);
> >>>
> >>> -out:
> >>>  	cpu_maps_update_done();
> >>>  	return err;
> >>>  }
> >>>
> >>
> > 
> > 
> 


