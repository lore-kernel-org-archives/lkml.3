Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711Ab3EMQI0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 12:08:26 -0400
Received: from mga03.intel.com ([143.182.124.21]:48781 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992Ab3EMQIY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 12:08:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,662,1363158000"; 
   d="scan'208";a="240836464"
From: "R, Durgadoss" <durgadoss.r@intel.com>
To: "Greg KH (gregkh@linuxfoundation.org)" <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Linux PM list (linux-pm@vger.kernel.org)" <linux-pm@vger.kernel.org>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>
Subject: RE: Kobject_uevent in cpufreq.c
Thread-Topic: Kobject_uevent in cpufreq.c
Thread-Index: Ac5PzAsHEbqKdSyMS+KKwxMdrUgOtP//rfKA//9h6sA=
Date: Mon, 13 May 2013 16:08:19 +0000
Message-ID: <4D68720C2E767A4AA6A8796D42C8EB59C8D936@BGSMSX101.gar.corp.intel.com>
References: <4D68720C2E767A4AA6A8796D42C8EB59C8D667@BGSMSX101.gar.corp.intel.com>
 <20130513115801.GA11433@kroah.com>
In-Reply-To: <20130513115801.GA11433@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: linux-pm-owner@vger.kernel.org [mailto:linux-pm-
> owner@vger.kernel.org] On Behalf Of Greg KH
> (gregkh@linuxfoundation.org)
> Sent: Monday, May 13, 2013 5:28 PM
> To: R, Durgadoss
> Cc: linux-kernel@vger.kernel.org; Linux PM list (linux-pm@vger.kernel.org);
> Wysocki, Rafael J
> Subject: Re: Kobject_uevent in cpufreq.c
> 
> On Mon, May 13, 2013 at 11:31:57AM +0000, R, Durgadoss wrote:
> > Hi,
> >
> > I am observing an UEvent issue in cpufreq.c.
> > The cpufreq_add_dev() function is called whenever a core is 'onlined'.
> > we expect the kobject_uevent() method in cpufreq_add_dev() to
> > send an UEvent with KOBJ_ADD as the action parameter.
> >
> > But this call fails because of the 'filter function' inside kobject_uevent_env
> > inside lib/kobject_uevent.c. The ->filter points to 'dev_uevent_filter' in
> > drivers/base/core.c, where the check for 'device_ktype' fails.
> >
> > Error message:
> > kobject: 'cpufreq' (e5bbf290): kobject_uevent_env:
> > filter function caused the event to drop!
> >
> > As far as I can see, we need a kset, and associated filter function
> > inside cpufreq.c to get this working. Is this the right way to go ?
> > Any other easy/correct ways to get it working ? Please advise.
> 
> What exactly are you trying to do, and want the kernel to do?  You
> already get on/offline events for CPUs, why do you want them for cpufreq
> devices as well?

I want to update the permission of a cpufreq sysfs interface (scaling_*)
of a cpu (say cpu1) when the cpu resumes from suspend (s3).
I am trying to do this by listening to the uevent (sent by cpufreq.c,
when a cpu resumes) through udev.

For example,
chmod user:user /sys/devices/system/cpu1/cpufreq/scaling_max_freq

But I am not able to receive this event in udev, because kobject_uevent()
call fails due to the above-mentioned reason (i.e filter function)
I am trying to see how to make the kobject_uevent() call succeed,
so that I can change the permission as mentioned above.

The on/offline events come only when I manually do a
echo 0 > /sys/devices/system/cpu/cpu1/online
They don't come when the cpu resumes from suspend(s3)

[I checked this in code. Looks like during resume, the call flow
does not hit cpu.c, where this KOBJ_ONLINE is being sent]

Thanks,
Durga

> 
> thanks,
> 
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
