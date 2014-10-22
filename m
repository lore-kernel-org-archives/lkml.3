Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbaJVBcW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 21:32:22 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:46070 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751120AbaJVBcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 21:32:21 -0400
From: Neil Zhang <zhangwm@marvell.com>
To: Dan Streetman <ddstreet@ieee.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Tue, 21 Oct 2014 18:32:14 -0700
Subject: RE: [PATCH] drivers: base: update cpu offline info when do hotplug
Thread-Topic: [PATCH] drivers: base: update cpu offline info when do hotplug
Thread-Index: Ac/tL2X6syb3st2tRYiUcvvzdBTiTQAaE6aw
Message-ID: <9034CBD80F070943B59700D7F8149ED9024EB81E00@SC-VEXCH4.marvell.com>
References: <1413775748-22478-1-git-send-email-zhangwm@marvell.com>
 <CALZtONB-qX-qL4BnCxadhKc6v60mNtrv8UxinhEwehtiff6S3g@mail.gmail.com>
In-Reply-To: <CALZtONB-qX-qL4BnCxadhKc6v60mNtrv8UxinhEwehtiff6S3g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-10-22_01:2014-10-21,2014-10-21,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1410220014
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9M1WR9n003675

Dan,

> -----Original Message-----
> From: ddstreet@gmail.com [mailto:ddstreet@gmail.com] On Behalf Of Dan
> Streetman
> Sent: 2014å¹´10æœˆ21æ—¥ 21:03
> To: Neil Zhang
> Cc: linux-kernel; Greg Kroah-Hartman
> Subject: Re: [PATCH] drivers: base: update cpu offline info when do hotplug
> 
> On Sun, Oct 19, 2014 at 11:29 PM, Neil Zhang <zhangwm@marvell.com> wrote:
> > The current per-cpu offline info won't be updated if it is hotplugged
> > in/out by a kernel governer.
> > Let's update it via cpu notifier.
> >
> > Signed-off-by: Neil Zhang <zhangwm@marvell.com>
> > ---
> >  drivers/base/cpu.c |   25 +++++++++++++++++++++++++
> >  1 file changed, 25 insertions(+)
> >
> > diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c index
> > 006b1bc..9d61824 100644
> > --- a/drivers/base/cpu.c
> > +++ b/drivers/base/cpu.c
> > @@ -418,10 +418,35 @@ static void __init
> > cpu_dev_register_generic(void)  #endif  }
> >
> > +static int device_hotplug_notifier(struct notifier_block *nfb,
> > +                                     unsigned long action, void
> > +*hcpu) {
> > +       unsigned int cpu = (unsigned long)hcpu;
> > +       struct device *dev = get_cpu_device(cpu);
> > +       int ret;
> > +
> > +       switch (action & ~CPU_TASKS_FROZEN) {
> > +       case CPU_ONLINE:
> > +               dev->offline = false;
> > +               ret = NOTIFY_OK;
> > +               break;
> > +       case CPU_DYING:
> > +               dev->offline = true;
> 
> one thing i just thought of here, since dev->offline is getting set here, can
> you remove it being set in drivers/base/core.c at
> device_online() and device_offline() ?  That's probably redundant now right?

Yes, I ever thought about it.
But I'm not sure whether some other devices (such as memory) will use it later too.
So I still kept it there since seems won't cause any problem.

> 
> 
> > +               ret = NOTIFY_OK;
> > +               break;
> > +       default:
> > +               ret = NOTIFY_DONE;
> > +               break;
> > +       }
> > +
> > +       return ret;
> > +}
> > +
> >  void __init cpu_dev_init(void)
> >  {
> >         if (subsys_system_register(&cpu_subsys, cpu_root_attr_groups))
> >                 panic("Failed to register CPU subsystem");
> >
> >         cpu_dev_register_generic();
> > +       cpu_notifier(device_hotplug_notifier, 0);
> >  }
> > --
> > 1.7.9.5
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe
> > linux-kernel" in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/

Best Regards,
Neil Zhang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
