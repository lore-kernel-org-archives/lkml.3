Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896Ab3D2Eo6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 00:44:58 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:34697 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750708Ab3D2Eo5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 00:44:57 -0400
X-IronPort-AV: E=Sophos;i="4.87,571,1363104000"; 
   d="scan'208";a="7156729"
Subject: Re: [PATCH] cpu: rid cpu_hotplug_disabled check for cpu_down()
From: li guang <lig.fnst@cn.fujitsu.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>
In-Reply-To: <517DF770.6020402@linux.vnet.ibm.com>
References: <1367203791-9723-1-git-send-email-lig.fnst@cn.fujitsu.com>
	 <517DF770.6020402@linux.vnet.ibm.com>
Date: Mon, 29 Apr 2013 12:42:36 +0800
Message-ID: <1367210556.20507.68.camel@liguang.fnst.cn.fujitsu.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/29 12:43:13,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/29 12:43:14,
	Serialize complete at 2013/04/29 12:43:14
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

在 2013-04-29一的 10:00 +0530，Srivatsa S. Bhat写道：
> On 04/29/2013 08:19 AM, liguang wrote:
> > in cpu_down(), _cpu_down() will do
> > "
> >         if (num_online_cpus() == 1)
> >                  return -EBUSY;
> > "
> > when cpu_hotplug_disabled was set, num_online_cpus
> > will return 1 for there's only 1 boot cpu.
> > so, it's unnecessary to check cpu_hotplug_disabled
> > here.
> >
> 
> The 2 checks serve very different purposes; they are not the same!

purposes are different, but I think effects are same for this case,
the statement 'if ((num_online_cpus() == 1)' seems
have same effect with cpu_hotplug_disabled here,
because when cpu_hotplug_disabled, only boot cpu is online

> 
> The num_online_cpus() check is to ensure that the user doesn't do
> something insane like trying to offline the last online CPU in the
> system.
> 
> Whereas, the flag 'cpu_hotplug_disabled' is used to prevent user-
> triggered CPU hotplug (such as those initiated through sysfs).
> This is useful in cases where the system itself wants to initiate CPU
> hotplug and it doesn't want annoying races with CPU hotplug going
> on in parallel due to other reasons. One such case is suspend/resume.
> That's why, if you have noticed, the suspend/resume code invokes the
> _cpu_down() version, in order to bypass the flag and get its job done.
> 
> So, no, I think the check needs to stay.
> 
> Regards,
> Srivatsa S. Bhat
> 
> > Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
> > ---
> >  kernel/cpu.c |    6 ------
> >  1 files changed, 0 insertions(+), 6 deletions(-)
> > 
> > diff --git a/kernel/cpu.c b/kernel/cpu.c
> > index b5e4ab2..cd166d3 100644
> > --- a/kernel/cpu.c
> > +++ b/kernel/cpu.c
> > @@ -330,14 +330,8 @@ int __ref cpu_down(unsigned int cpu)
> > 
> >  	cpu_maps_update_begin();
> > 
> > -	if (cpu_hotplug_disabled) {
> > -		err = -EBUSY;
> > -		goto out;
> > -	}
> > -
> >  	err = _cpu_down(cpu, 0);
> > 
> > -out:
> >  	cpu_maps_update_done();
> >  	return err;
> >  }
> > 
> 


