Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207Ab3KUAwe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 19:52:34 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:57469 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754423Ab3KUAw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 19:52:26 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH V2 13/16] cpuidle: free all state kobjects from cpuidle_free_state_kobj()
Date: Thu, 21 Nov 2013 02:05:06 +0100
Message-ID: <7256587.cI3URDaS0R@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CAKohpokQh_Awj2tzhFbqzv8u4zQ2WV0QZP0Sq1tqVQBYemW+gA@mail.gmail.com>
References: <cover.1380815504.git.viresh.kumar@linaro.org> <CAKohpo=+W9vTcfRcH=6t0Bbct2+GJYge60ZoQZwYuZ=An6UCtQ@mail.gmail.com> <CAKohpokQh_Awj2tzhFbqzv8u4zQ2WV0QZP0Sq1tqVQBYemW+gA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 20, 2013 01:33:53 PM Viresh Kumar wrote:
> Fixing Rafael's email id..
> 
> On 20 November 2013 13:33, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> > On 3 October 2013 21:26, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> >> Loop for states is currently present on callers side and so is replicated at
> >> several places. It would be better to move that inside cpuidle_free_state_kobj()
> >> instead.
> >>
> >> This patch does it.
> >>
> >> Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> >> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> >> ---
> >>  drivers/cpuidle/sysfs.c | 23 ++++++++++++-----------
> >>  1 file changed, 12 insertions(+), 11 deletions(-)
> >
> > Hi Rafael,
> >
> > You missed applying this one?

I might.  Care to resend?

> >> diff --git a/drivers/cpuidle/sysfs.c b/drivers/cpuidle/sysfs.c
> >> index e918b6d..ade31a9 100644
> >> --- a/drivers/cpuidle/sysfs.c
> >> +++ b/drivers/cpuidle/sysfs.c
> >> @@ -378,12 +378,17 @@ static struct kobj_type ktype_state_cpuidle = {
> >>         .release = cpuidle_state_sysfs_release,
> >>  };
> >>
> >> -static inline void cpuidle_free_state_kobj(struct cpuidle_device *device, int i)
> >> +static inline void cpuidle_free_state_kobj(struct cpuidle_device *device,
> >> +               int count)
> >>  {
> >> -       kobject_put(&device->kobjs[i]->kobj);
> >> -       wait_for_completion(&device->kobjs[i]->kobj_unregister);
> >> -       kfree(device->kobjs[i]);
> >> -       device->kobjs[i] = NULL;
> >> +       int i;
> >> +
> >> +       for (i = 0; i < count; i++) {
> >> +               kobject_put(&device->kobjs[i]->kobj);
> >> +               wait_for_completion(&device->kobjs[i]->kobj_unregister);
> >> +               kfree(device->kobjs[i]);
> >> +               device->kobjs[i] = NULL;
> >> +       }
> >>  }
> >>
> >>  /**
> >> @@ -419,8 +424,7 @@ static int cpuidle_add_state_sysfs(struct cpuidle_device *device)
> >>         return 0;
> >>
> >>  error_state:
> >> -       for (i = i - 1; i >= 0; i--)
> >> -               cpuidle_free_state_kobj(device, i);
> >> +       cpuidle_free_state_kobj(device, i);
> >>         return ret;
> >>  }
> >>
> >> @@ -430,10 +434,7 @@ error_state:
> >>   */
> >>  static void cpuidle_remove_state_sysfs(struct cpuidle_device *device)
> >>  {
> >> -       int i;
> >> -
> >> -       for (i = 0; i < device->state_count; i++)
> >> -               cpuidle_free_state_kobj(device, i);
> >> +       cpuidle_free_state_kobj(device, device->state_count);
> >>  }
> >>
> >>  #ifdef CONFIG_CPU_IDLE_MULTIPLE_DRIVERS
> >> --
> >> 1.7.12.rc2.18.g61b472e
> >>
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
