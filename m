Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140Ab3A3GXI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 01:23:08 -0500
Received: from mga09.intel.com ([134.134.136.24]:30838 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752266Ab3A3GXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 01:23:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,565,1355126400"; 
   d="scan'208";a="254680720"
From: "Li, Fei" <fei.li@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>
Subject: RE: [PATCH] suspend: enable freeze timeout configuration through
 sysctl
Thread-Topic: [PATCH] suspend: enable freeze timeout configuration through
 sysctl
Thread-Index: AQHN/czCz+mnQmosFEmQnVRjo0Y3nZhfqakAgAG0iaA=
Date: Wed, 30 Jan 2013 06:22:55 +0000
Message-ID: <BEC9F67575FA1E429CA7CF5AE9BE36343F06B6@SHSMSX102.ccr.corp.intel.com>
References: <1359428300.3211.3.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
 <2146878.OLeVueUb0g@vostro.rjw.lan>
In-Reply-To: <2146878.OLeVueUb0g@vostro.rjw.lan>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r0U6NBdV012626

Hello Rafael,
   Thanks for your feedback, and my understanding is interleaved in your email as below.

Best Regards,
Li Fei

> -----Original Message-----
> From: Rafael J. Wysocki [mailto:rjw@sisk.pl]
> Sent: Tuesday, January 29, 2013 7:42 PM
> To: Li, Fei
> Cc: akpm@linux-foundation.org; linux-kernel@vger.kernel.org;
> linux-pm@vger.kernel.org; Liu, Chuansheng
> Subject: Re: [PATCH] suspend: enable freeze timeout configuration through sysctl
> 
> On Tuesday, January 29, 2013 10:58:20 AM fli24 wrote:
> >
> > At present, the timeout value for freezing tasks is fixed as 20s,
> > which is too long for handheld device usage, especially for mobile
> > phone.
> >
> > In order to improve user experience, we enable freeze timeout
> > configuration through sysctl, so that we can tune the value easily
> > for concrete usage, such as smaller value for handheld device such
> > as mobile phone.
> 
> Well, I'd argue that you shouldn't see freeze problems on such systems.
> If you're seeing them, it's better to fix them than to try to hide them
> from users (they are problems after all).
[Li, Fei] 
Thanks for your opinion.
Indeed, I see such freeze problems on mobile phone system using fuse file system.
The scenario is as below:
Thread A with i_mutex held is frozen during waiting for feedback from fuse daemon;
Thread B is trying to lock i_mutex and can't be frozen.
In the case above, 20s waiting is needless, as freezing will fail unavoidably.

I agree with you that we'd better fix them from the root, which may need solution of long term.
I also saw some related discussion on Linux community as below, without final conclusion:
http://lists.linux-foundation.org/pipermail/linux-pm/2008-October/018774.html

So I think if we can enable freezing timeout configuration, it will improve such issue.

> Do you have a specific example in which that new knob will be useful?
[Li, Fei] 
As the scenario stated above, if we can configure the value of timeout to 10s or other small value,
this time of freezing will be aborted in earlier time, and after i_mutex is released during thread A restarting,
the next time of suspend/freeze may succeed in relatively earlier time.

> Why do you want to do that through sysctl and not sysfs?
[Li, Fei] 
Thanks for your suggestion, sysfs is more suitable, and I'll use sysfs in patch V2.

> Rafael
> 
> 
> > Signed-off-by: Liu Chuansheng <chuansheng.liu@intel.com>
> > Signed-off-by: Li Fei <fei.li@intel.com>
> > ---
> >  include/linux/freezer.h |    5 +++++
> >  kernel/power/process.c  |    4 ++--
> >  kernel/sysctl.c         |   12 ++++++++++++
> >  3 files changed, 19 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/linux/freezer.h b/include/linux/freezer.h
> > index e4238ce..f37b3be 100644
> > --- a/include/linux/freezer.h
> > +++ b/include/linux/freezer.h
> > @@ -13,6 +13,11 @@ extern bool pm_freezing;		/* PM freezing in effect
> */
> >  extern bool pm_nosig_freezing;		/* PM nosig freezing in effect */
> >
> >  /*
> > + * Timeout for stopping processes
> > + */
> > +extern unsigned int sysctl_freeze_process_timeout_secs;
> > +
> > +/*
> >   * Check if a process has been frozen
> >   */
> >  static inline bool frozen(struct task_struct *p)
> > diff --git a/kernel/power/process.c b/kernel/power/process.c
> > index d5a258b..f7eb7c9 100644
> > --- a/kernel/power/process.c
> > +++ b/kernel/power/process.c
> > @@ -21,7 +21,7 @@
> >  /*
> >   * Timeout for stopping processes
> >   */
> > -#define TIMEOUT	(20 * HZ)
> > +unsigned int __read_mostly sysctl_freeze_process_timeout_secs = 20;
> >
> >  static int try_to_freeze_tasks(bool user_only)
> >  {
> > @@ -36,7 +36,7 @@ static int try_to_freeze_tasks(bool user_only)
> >
> >  	do_gettimeofday(&start);
> >
> > -	end_time = jiffies + TIMEOUT;
> > +	end_time = jiffies + sysctl_freeze_process_timeout_secs * HZ;
> >
> >  	if (!user_only)
> >  		freeze_workqueues_begin();
> > diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> > index c88878d..f88bcb9 100644
> > --- a/kernel/sysctl.c
> > +++ b/kernel/sysctl.c
> > @@ -90,6 +90,9 @@
> >  #include <linux/nmi.h>
> >  #endif
> >
> > +#ifdef CONFIG_FREEZER
> > +#include <linux/freezer.h>
> > +#endif
> >
> >  #if defined(CONFIG_SYSCTL)
> >
> > @@ -1047,6 +1050,15 @@ static struct ctl_table kern_table[] = {
> >  		.proc_handler	= proc_dointvec,
> >  	},
> >  #endif
> > +#ifdef CONFIG_FREEZER
> > +	{
> > +		.procname	= "freeze_process_timeout_secs",
> > +		.data		= &sysctl_freeze_process_timeout_secs,
> > +		.maxlen		= sizeof(unsigned int),
> > +		.mode		= 0644,
> > +		.proc_handler	= proc_dointvec,
> > +	},
> > +#endif
> >  	{ }
> >  };
> >
> >
> --
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
