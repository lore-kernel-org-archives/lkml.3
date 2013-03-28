Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985Ab3C1Acq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 20:32:46 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:45110 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753257Ab3C1Aco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 20:32:44 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Alex Shi <alex.shi@intel.com>, Len Brown <len.brown@intel.com>,
        Changlong Xie <changlongx.xie@intel.com>, linux-acpi@vger.kernel.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>, lkp@linux.intel.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [LKP] Commit ac3ebafa81a makes NHM EX/EP machines hung out since 3.9-rc1
Date: Thu, 28 Mar 2013 01:40:11 +0100
Message-ID: <15175142.3Xo9lEvds6@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAE9FiQUnXev4Q+B1Cww-bhZM8O7bhbvOT=Y5c4SOjFksq1oXEw@mail.gmail.com>
References: <20130313022759.GA120840@bee> <5152781B.6060603@intel.com> <CAE9FiQUnXev4Q+B1Cww-bhZM8O7bhbvOT=Y5c4SOjFksq1oXEw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, March 27, 2013 09:36:44 AM Yinghai Lu wrote:
> On Tue, Mar 26, 2013 at 9:39 PM, Alex Shi <alex.shi@intel.com> wrote:
> > On 03/13/2013 10:27 AM, Changlong Xie wrote:
> >> Hi Len,
> >>
> >>       FYI, since 3.9-rc1 our three NHM EP/EX LKP(linux kernel performance) test servers
> >>       except SNB/IVB/WSM hung up unexpectly.
> >>
> >>       We did git bisect for about 8 times on all servers, it said that the first bad commit is ac3ebafa.
> >>
> >>       commit ac3ebafa81af76d65e4fb45c6388f08e90ddcc6d
> >>       Author: Daniel Lezcano <daniel.lezcano@linaro.org>
> >>       Date:   Mon Feb 4 22:44:43 2013 +0000
> >
> > fixing patch for review:
> >
> >
> > -----------------------
> > From 78a74aea386b0969909c2e4ae388024ce71fdb18 Mon Sep 17 00:00:00 2001
> > From: Alex Shi <alex.shi@intel.com>
> > Date: Tue, 26 Mar 2013 22:57:47 +0800
> > Subject: [PATCH] cpuidle/acpi: recover percpu acpi processor cstate
> >
> > Commit: ac3ebafa81af76d6 "ACPI / idle: remove usage of the statedata"
> > change the percpu processor cstate to a unify unique cstate in acpi
> > idle. That cause all our NHM box boot hang or panic.
> >
> > 2178751 Task dump for CPU 1:^M
> >         2178752 swapper/1       R  running task     6736     0      1
> > 0x00000000^M
> >         2178753  ffff8801e8029dc8 ffffffff8101cf96 ffff8801e8029e28
> > ffffffff813d294b^M
> >         2178754  0000000000000f99 0000000000000003 00000000003cf654
> > 0000000025c17d03^M
> >         2178755  ffff8801e8029e38 ffff8801e74fc000 00000002590dc5c4
> > ffffffff8163cdb0^M
> >         2178756 Call Trace:^M
> >         2178757  [<ffffffff8101cf96>] ? acpi_processor_ffh_cstate_enter+0x2d/0x2f^M
> >         2178758  [<ffffffff813d294b>] acpi_idle_enter_bm+0x1b1/0x236^M
> >         2178759  [<ffffffff8163cdb0>] ? disable_cpuidle+0x10/0x10^M
> >         2178760  [<ffffffff8163cdc2>] cpuidle_enter+0x12/0x14^M
> >         2178761  [<ffffffff8163d286>] cpuidle_wrap_enter+0x2f/0x6d^M
> >         2178762  [<ffffffff8163d2d4>] cpuidle_enter_tk+0x10/0x12^M
> >         2178763  [<ffffffff8163cdd6>] cpuidle_enter_state+0x12/0x3a^M
> >         2178764  [<ffffffff8163d4a7>] cpuidle_idle_call+0xe8/0x161^M
> >         2178765  [<ffffffff81008d99>] cpu_idle+0x5e/0xa4^M
> >         2178766  [<ffffffff8174c6c1>] start_secondary+0x1a9/0x1ad^M
> >         2178767 Task dump for CPU 2:^M
> >
> > In fact, the acpi idle bases on percpu cstate difference assumption, the
> > infrastructure use many percpu structures to implement self.
> > Just unique acpi_processor_cx is far far not enough.
> >
> > This patch just is a quick fix by introducing back the percpu cstates.
> > And keep driver_data away.
> >
> > If someone really want to unify the acpi cstates, please make sure whole
> > software infrastructure changed and get the grant from hardware,
> > include many kinds of BIOS setting.
> >
> > Signed-off-by: Alex Shi <alex.shi@intel.com>
> > ---
> >  drivers/acpi/processor_idle.c | 13 +++++++------
> >  1 file changed, 7 insertions(+), 6 deletions(-)
> >
> > diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
> > index fc95308..ee255c6 100644
> > --- a/drivers/acpi/processor_idle.c
> > +++ b/drivers/acpi/processor_idle.c
> > @@ -66,7 +66,8 @@ module_param(latency_factor, uint, 0644);
> >
> >  static DEFINE_PER_CPU(struct cpuidle_device *, acpi_cpuidle_device);
> >
> > -static struct acpi_processor_cx *acpi_cstate[CPUIDLE_STATE_MAX];
> > +static DEFINE_PER_CPU(struct acpi_processor_cx * [CPUIDLE_STATE_MAX],
> > +                                                               acpi_cstate);
> >
> >  static int disabled_by_idle_boot_param(void)
> >  {
> > @@ -722,7 +723,7 @@ static int acpi_idle_enter_c1(struct cpuidle_device *dev,
> >                 struct cpuidle_driver *drv, int index)
> >  {
> >         struct acpi_processor *pr;
> > -       struct acpi_processor_cx *cx = acpi_cstate[index];
> > +       struct acpi_processor_cx *cx = per_cpu(acpi_cstate[index], dev->cpu);
> >
> >         pr = __this_cpu_read(processors);
> >
> > @@ -745,7 +746,7 @@ static int acpi_idle_enter_c1(struct cpuidle_device *dev,
> >   */
> >  static int acpi_idle_play_dead(struct cpuidle_device *dev, int index)
> >  {
> > -       struct acpi_processor_cx *cx = acpi_cstate[index];
> > +       struct acpi_processor_cx *cx = per_cpu(acpi_cstate[index], dev->cpu);
> >
> >         ACPI_FLUSH_CPU_CACHE();
> >
> > @@ -775,7 +776,7 @@ static int acpi_idle_enter_simple(struct cpuidle_device *dev,
> >                 struct cpuidle_driver *drv, int index)
> >  {
> >         struct acpi_processor *pr;
> > -       struct acpi_processor_cx *cx = acpi_cstate[index];
> > +       struct acpi_processor_cx *cx = per_cpu(acpi_cstate[index], dev->cpu);
> >
> >         pr = __this_cpu_read(processors);
> >
> > @@ -833,7 +834,7 @@ static int acpi_idle_enter_bm(struct cpuidle_device *dev,
> >                 struct cpuidle_driver *drv, int index)
> >  {
> >         struct acpi_processor *pr;
> > -       struct acpi_processor_cx *cx = acpi_cstate[index];
> > +       struct acpi_processor_cx *cx = per_cpu(acpi_cstate[index], dev->cpu);
> >
> >         pr = __this_cpu_read(processors);
> >
> > @@ -960,7 +961,7 @@ static int acpi_processor_setup_cpuidle_cx(struct acpi_processor *pr,
> >                     !(acpi_gbl_FADT.flags & ACPI_FADT_C2_MP_SUPPORTED))
> >                         continue;
> >  #endif
> > -               acpi_cstate[count] = cx;
> > +               per_cpu(acpi_cstate[count], dev->cpu) = cx;
> >
> >                 count++;
> >                 if (count == CPUIDLE_STATE_MAX)
> > --
> 
> It fixes the problem on my 8 sockets Nehalem-EX that will hang around
> ip_auto_config()
> 
> Tested-by: Yinghai Lu <yinghai@kernel.org>
> 
> Rafael,
> Can you please push this one to Linus tree ?
> As the offending patch was via your tree to upstream.

I will if there's no better way to address this issue before -rc6.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
