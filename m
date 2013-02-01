Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882Ab3BABdz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 20:33:55 -0500
Received: from mga02.intel.com ([134.134.136.20]:28066 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752639Ab3BABdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 20:33:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,579,1355126400"; 
   d="scan'208";a="279408946"
From: "Li, Fei" <fei.li@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        anish singh <anish198519851985@gmail.com>
CC: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>
Subject: RE: [PATCH V3] suspend: enable freeze timeout configuration through
 sys
Thread-Topic: [PATCH V3] suspend: enable freeze timeout configuration
 through sys
Thread-Index: AQHN/29vZoB86dySZ064bV7yEexaV5hihHEAgACZg4D//45ogIAA04AAgACwmlA=
Date: Fri, 1 Feb 2013 01:33:28 +0000
Message-ID: <BEC9F67575FA1E429CA7CF5AE9BE36343F0F00@SHSMSX102.ccr.corp.intel.com>
References: <1359428300.3211.3.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
 <BEC9F67575FA1E429CA7CF5AE9BE36343F0D19@SHSMSX102.ccr.corp.intel.com>
 <CAK7N6vpdmLv-G3q-m9nbWs1jV-s=k9c4gQ-wKOZsMGZrm4AhVw@mail.gmail.com>
 <1503699.1Mx8Tt0bYE@vostro.rjw.lan>
In-Reply-To: <1503699.1Mx8Tt0bYE@vostro.rjw.lan>
Accept-Language: en-US
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r111Y34O023262

> -----Original Message-----
> From: Rafael J. Wysocki [mailto:rjw@sisk.pl]
> Sent: Friday, February 01, 2013 6:29 AM
> To: anish singh; Li, Fei
> Cc: Yasuaki Ishimatsu; akpm@linux-foundation.org; linux-kernel@vger.kernel.org;
> linux-pm@vger.kernel.org; Liu, Chuansheng
> Subject: Re: [PATCH V3] suspend: enable freeze timeout configuration through
> sys
> 
> On Thursday, January 31, 2013 03:22:25 PM anish singh wrote:
> > On Thu, Jan 31, 2013 at 2:43 PM, Li, Fei <fei.li@intel.com> wrote:
> > >> -----Original Message-----
> > >> From: Yasuaki Ishimatsu [mailto:isimatu.yasuaki@jp.fujitsu.com]
> > >> Sent: Thursday, January 31, 2013 3:30 PM
> > >> To: Li, Fei
> > >> Cc: rjw@sisk.pl; akpm@linux-foundation.org; linux-kernel@vger.kernel.org;
> > >> linux-pm@vger.kernel.org; Liu, Chuansheng
> > >> Subject: Re: [PATCH V3] suspend: enable freeze timeout configuration
> through
> > >> sys
> > >>
> > >> 2013/01/31 13:55, fli24 wrote:
> > >> >
> > >> > At present, the value of timeout for freezing is 20s, which is
> > >> > meaningless in case that one thread is frozen with mutex locked
> > >> > and another thread is trying to lock the mutex, as this time of
> > >> > freezing will fail unavoidably.
> > >> > And if there is no new wakeup event registered, the system will
> > >> > waste at most 20s for such meaningless trying of freezing.
> > >> >
> > >> > With this patch, the value of timeout can be configured to smaller
> > >> > value, so such meaningless trying of freezing will be aborted in
> > >> > earlier time, and later freezing can be also triggered in earlier
> > >> > time. And more power will be saved.
> > >> > In normal case on mobile phone, it costs real little time to freeze
> > >> > processes. On some platform, it only costs about 20ms to freeze
> > >> > user space processes and 10ms to freeze kernel freezable threads.
> > >> >
> > >> > Signed-off-by: Liu Chuansheng <chuansheng.liu@intel.com>
> > >> > Signed-off-by: Li Fei <fei.li@intel.com>
> > >> > ---
> > >> >   Documentation/power/freezing-of-tasks.txt |    5 +++++
> > >> >   include/linux/freezer.h                   |    5 +++++
> > >> >   kernel/power/main.c                       |   27
> > >> +++++++++++++++++++++++++++
> > >> >   kernel/power/process.c                    |    4 ++--
> > >> >   4 files changed, 39 insertions(+), 2 deletions(-)
> > >> >
> > >> > diff --git a/Documentation/power/freezing-of-tasks.txt
> > >> b/Documentation/power/freezing-of-tasks.txt
> > >> > index 6ec291e..85894d8 100644
> > >> > --- a/Documentation/power/freezing-of-tasks.txt
> > >> > +++ b/Documentation/power/freezing-of-tasks.txt
> > >> > @@ -223,3 +223,8 @@ since they ask the freezer to skip freezing this
> task,
> > >> since it is anyway
> > >> >   only after the entire suspend/hibernation sequence is complete.
> > >> >   So, to summarize, use [un]lock_system_sleep() instead of directly using
> > >> >   mutex_[un]lock(&pm_mutex). That would prevent freezing failures.
> > >> > +
> > >> > +V. Miscellaneous
> > >> > +/sys/power/pm_freeze_timeout controls how long it will cost at most to
> > >> freeze
> > >> > +all user space processes or all freezable kernel threads, in unit of
> millisecond.
> > >> > +The default value is 20000, with range of unsigned integer.
> > >> > diff --git a/include/linux/freezer.h b/include/linux/freezer.h
> > >> > index e4238ce..5a24a33 100644
> > >> > --- a/include/linux/freezer.h
> > >> > +++ b/include/linux/freezer.h
> > >> > @@ -13,6 +13,11 @@ extern bool pm_freezing;         /* PM
> freezing in effect
> > >> */
> > >> >   extern bool pm_nosig_freezing;            /* PM nosig freezing in
> effect */
> > >> >
> > >> >   /*
> > >> > + * Timeout for stopping processes
> > >> > + */
> > >> > +extern unsigned int sys_freeze_process_timeout_msecs;
> > >> > +
> > >> > +/*
> > >> >    * Check if a process has been frozen
> > >> >    */
> > >> >   static inline bool frozen(struct task_struct *p)
> > >> > diff --git a/kernel/power/main.c b/kernel/power/main.c
> > >> > index 1c16f91..453ead1 100644
> > >> > --- a/kernel/power/main.c
> > >> > +++ b/kernel/power/main.c
> > >> > @@ -553,6 +553,30 @@ power_attr(pm_trace_dev_match);
> > >> >
> > >> >   #endif /* CONFIG_PM_TRACE */
> > >> >
> > >> > +#ifdef CONFIG_FREEZER
> > >> > +static ssize_t pm_freeze_timeout_show(struct kobject *kobj,
> > >> > +                                 struct kobj_attribute *attr, char
> *buf)
> > >> > +{
> > >> > +   return sprintf(buf, "%u\n", sys_freeze_process_timeout_msecs);
> > >> > +}
> > >> > +
> > >> > +static ssize_t pm_freeze_timeout_store(struct kobject *kobj,
> > >> > +                                  struct kobj_attribute *attr,
> > >> > +                                  const char *buf, size_t n)
> > >> > +{
> > >> > +   unsigned long val;
> > >> > +
> > >> > +   if (kstrtoul(buf, 10, &val))
> > >> > +           return -EINVAL;
> > >> > +
> > >> > +   sys_freeze_process_timeout_msecs = val;
> > >> > +   return n;
> > >> > +}
> > >> > +
> > >> > +power_attr(pm_freeze_timeout);
> > >> > +
> > >> > +#endif     /* CONFIG_FREEZER*/
> > >> > +
> > >> >   static struct attribute * g[] = {
> > >> >     &state_attr.attr,
> > >> >   #ifdef CONFIG_PM_TRACE
> > >> > @@ -576,6 +600,9 @@ static struct attribute * g[] = {
> > >> >     &pm_print_times_attr.attr,
> > >> >   #endif
> > >> >   #endif
> > >> > +#ifdef CONFIG_FREEZER
> > >> > +   &pm_freeze_timeout_attr.attr,
> > >> > +#endif
> > >> >     NULL,
> > >> >   };
> > >> >
> > >> > diff --git a/kernel/power/process.c b/kernel/power/process.c
> > >> > index d5a258b..ba45a26 100644
> > >> > --- a/kernel/power/process.c
> > >> > +++ b/kernel/power/process.c
> > >> > @@ -21,7 +21,7 @@
> > >> >   /*
> > >> >    * Timeout for stopping processes
> > >> >    */
> > >>
> > >> > -#define TIMEOUT    (20 * HZ)
> > >> > +unsigned int __read_mostly sys_freeze_process_timeout_msecs =
> 20000;
> > >>
> > >> 20000 does not mean 20 seconds since we can select HZ other than 1000.
> > >> So (20 * HZ) is better than 20000.
> > >>
> > > [Li, Fei]
> > > Are you sure about this, (20*HZ) better than 20000, or you mean 20 *
> MSEC_PER_SEC?
> > Yasuaki  mean HZ value will not always be 1000.The value of HZ differs for
> each
> >  supported architecture. In fact, on some supported architectures,
> > it even differs between machine types.
> > When writing kernel code, never assume that HZ has any given value.
> > Right now you are assuming that the delay will be always 20 seconds because
> of
> > your assumption of HZ.
> 
> That's correct, the initial value should be 20 * HZ (i.e. as before).
[Li, Fei] 
Yes, you are right, and IMHO it's already as this in the patch, 
as 20 * HZ == msecs_to_jiffies(20000), with the current definition MSEC_PER_SEC
of 1000L. I'll update the default value as 20 * MSEC_PER_SEC in patch V4.

> Besides, the name of the variable doesn't need to be _that_ long.
> What about freeze_timeout_msecs?
[Li, Fei] 
Agree with you, and will update it in patch V4.

Thanks and Regards,
Li Fei

> Rafael
> 
> 
> --
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
