Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201AbaHNSQo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 14:16:44 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:49377 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498AbaHNSQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 14:16:42 -0400
Message-ID: <53ECFD08.5060605@codeaurora.org>
Date: Thu, 14 Aug 2014 11:16:40 -0700
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Prarit Bhargava <prarit@redhat.com>
CC: Viresh Kumar <viresh.kumar@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lenny Szubowicz <lszubowi@redhat.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] cpufreq, store_scaling_governor requires policy->rwsem
 to be held for duration of changing governors [v2]
References: <1406634362-811-1-git-send-email-prarit@redhat.com> <2066166.pXm4lKLOID@vostro.rjw.lan> <53DA8389.80804@redhat.com> <1917362.abr2Y4p7vh@vostro.rjw.lan> <53DA8A41.2030601@redhat.com> <53DAA60B.6040802@codeaurora.org> <53DAA749.5080506@redhat.com> <53DAA95B.2040505@codeaurora.org> <53DAB038.3050007@redhat.com> <53DABFA6.6090503@codeaurora.org> <53DACA26.1000908@redhat.com> <53DAE592.2030909@codeaurora.org> <53DB6B81.6050400@redhat.com> <53DBCBE8.6010809@codeaurora.org> <53DBE764.8050109@redhat.com> <53DBEC27.7050803@codeaurora.org> <CAKohpombG3Gj4mbm02vPNnAxzaRvQP7rb=iQ14dCFH4_+71H3w@mail.gmail.com> <53E0B657.4070007@redhat.com> <CAKohponxBdYEgY2oYuzmdaqfSRS8Uq8bZOzcb1QDmKO-z5ZBFQ@mail.gmail.com> <53E1556B.5070304@codeaurora.org> <53E15DBB.7080800@redhat.com> <53E15FE7.4040808@codeaurora.org> <53EBC332.30507@redhat.com>
In-Reply-To: <53EBC332.30507@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2014 12:57 PM, Prarit Bhargava wrote:
>
>
> On 08/05/2014 06:51 PM, Saravana Kannan wrote:
>
>>
>> I definitely have a fix for this and the original race you reported. It's
>> basically reverting that commit you reverted + a fix for the deadlock. That's
>> the only way to fix the scaling_governor issue.
>>
>> You fix the deadlock by moving the governor attribute group removing to the
>> framework code and doing it before STOP+EXIT to governor without holding the
>> policy lock. And the reverse for INIT+STOP.
>>
>
> I'm still not convinced of the deadlock so I did a bit of additional research
> and am pretty close to saying that this is a false positive from the lockdep
> code in the kernfs area.
>
> A few things that have caused me concern about the lockdep splat we're seeing:
>
> 1.  The splat occurs when we hit __kernfs_remove+0x25b/0x360 which resolves to
>
>          if (kernfs_lockdep(kn)) {
>                  rwsem_acquire(&kn->dep_map, 0, 0, _RET_IP_);  <<< RIGHT HERE
>                  if (atomic_read(&kn->active) != KN_DEACTIVATED_BIAS)
>                          lock_contended(&kn->dep_map, _RET_IP_);
>          }
>
> ie) the *ONLY* way we hit a "deadlock" in this code is if we have LOCKDEP
> configured in the kernfs.
>
> It should be noted, that having kernfs_lockdep() always return 0 [1], results in
> NO additional lockdep warnings.
>
> Additionally the splat contains
>
> [  107.428421]        CPU0                    CPU1
> [  107.433482]        ----                    ----
> [  107.438544]   lock(&policy->rwsem);
> [  107.442459]                                lock(s_active#98);
> [  107.448916]                                lock(&policy->rwsem);
> [  107.455650]   lock(s_active#98);
>
> which also points to the situation above (s_active is the default naming used in
> the kernfs lockdep code).
>
> In short -- there is no deadlock here.  It only happens in the lockdep code
> itself, not because lockdep has identified a real problem.
>
> 2.  I then started asking myself why this was occurring.  The reason appears to
> be that the attribute for scaling_governor is deleting other sysfs attributes
> and that got me to wondering if there were other areas where this occurred and I
> remembered it does!  In the USB code writing and reading to the  bConfiguration
> of a device may lead to the removal of "down stream" attributes.  The reading
> and writing of bConfiguration occurs in
> drivers/usb/core/sysfs.c:79
>
>
> /* configuration value is always present, and r/w */
> usb_actconfig_show(bConfigurationValue, "%u\n");
>
> static ssize_t bConfigurationValue_store(struct device *dev,
>                                           struct device_attribute *attr,
>                                           const char *buf, size_t count)
> {
>          struct usb_device       *udev = to_usb_device(dev);
>          int                     config, value;
>
>          if (sscanf(buf, "%d", &config) != 1 || config < -1 || config > 255)
>                  return -EINVAL;
>          usb_lock_device(udev);
>          value = usb_set_configuration(udev, config);
>          usb_unlock_device(udev);
>          return (value < 0) ? value : count;
> }
>
> ... and the next lines are IMO important here:
>
> static DEVICE_ATTR_IGNORE_LOCKDEP(bConfigurationValue, S_IRUGO | S_IWUSR,
>                  bConfigurationValue_show, bConfigurationValue_store);
>
> FWIW, it isn't *exactly* the same ... but commit
> 356c05d58af05d582e634b54b40050c73609617b explains a similarity between what is
> happening with our lockdep splat and the lockdep issues seen in USB.

This seems VERY different from our situation. I don't see an equivalent 
of a policy lock that's grabbed from both threads, but in opposite order.

If I'm not mistaken, the sysfs entry here uses some wait/complete pair 
to wait for something. But that's an equivalent of a semaphore with max 
count of 1. Lockdep just seems to be making it obvious by adding 
semaphore calls.

So, a semaphore equivalent deadlock with another semaphore. I believe 
this is a read deadlock.

-Saravana


-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
