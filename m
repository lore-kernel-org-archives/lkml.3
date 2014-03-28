Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751208AbaC1Gp3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 02:45:29 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:55328 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751024AbaC1Gp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 02:45:28 -0400
From: Neil Zhang <zhangwm@marvell.com>
To: John Stultz <john.stultz@linaro.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 27 Mar 2014 23:45:23 -0700
Subject: RE: [PATCH] printk: add sleep time into timestamp
Thread-Topic: [PATCH] printk: add sleep time into timestamp
Thread-Index: Ac9KNFc3bsWE1K8gQ2yVaN+9aqDXyQAD8u8A
Message-ID: <175CCF5F49938B4D99B2E3EF7F558EBE550559A27C@SC-VEXCH4.marvell.com>
References: <1395908241-6392-1-git-send-email-zhangwm@marvell.com>
 <CANcMJZCG7CT_rOShK7jGo3xVZ0MiRD-jUJE=FCTW68tv88g-Bw@mail.gmail.com>
In-Reply-To: <CANcMJZCG7CT_rOShK7jGo3xVZ0MiRD-jUJE=FCTW68tv88g-Bw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-03-28_03:2014-03-27,2014-03-28,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1403270194
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2S6k9cN010266

John,
 
> -----Original Message-----
> From: johnstul.lkml@gmail.com [mailto:johnstul.lkml@gmail.com] On Behalf
> Of John Stultz
> Sent: 2014Äê3ÔÂ28ÈÕ 11:18
> To: Neil Zhang
> Cc: Andrew Morton; Linux Kernel Mailing List
> Subject: Re: [PATCH] printk: add sleep time into timestamp
> 
> On Thu, Mar 27, 2014 at 1:17 AM, Neil Zhang <zhangwm@marvell.com>
> wrote:
> > Add sleep time into timestamp to reflect the actual time since
> > sched_clock will be stopped during suspend.
> 
> So why is this change necessary?
> 
> Further, since the sleep time may be updated a bit late in the resume cycle (in
> many cases we cannot access the RTC until irqs are enabled back on), you may
> see messages that show pre-suspend times when really they occur after we
> resume (but before the sleep time is incremented).
> 
Thanks for the comments.
Yes, the sleep time will be update in RTC and the print in the resume procedure still w/o the sleep time.
But I think the messages are not too much at this stage. 

> More comments below....
> 
> > This patch depends on the following patch.
> > timekeeping: check params before use them
> >
> > Signed-off-by: Neil Zhang <zhangwm@marvell.com>
> > ---
> >  kernel/printk/printk.c |   15 +++++++++++++--
> >  1 file changed, 13 insertions(+), 2 deletions(-)
> >
> > diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c index
> > 4dae9cb..2dc6145 100644
> > --- a/kernel/printk/printk.c
> > +++ b/kernel/printk/printk.c
> > @@ -250,6 +250,17 @@ static char __log_buf[__LOG_BUF_LEN]
> > __aligned(LOG_ALIGN);  static char *log_buf = __log_buf;  static u32
> > log_buf_len = __LOG_BUF_LEN;
> >
> > +static u64 print_clock(void)
> > +{
> > +       struct timespec ts;
> > +       u64 ts_nsec = local_clock();
> > +
> > +       get_xtime_and_monotonic_and_sleep_offset(NULL, NULL, &ts);
> 
> So this will cause deadlocks anytime we print from the timekeeping core, since
> we may hold a write on the timekeeper lock, and this patch makes every printk
> try to take a read-lock on the timekeeper lock.
> 
Sorry, I don't quite understand why it will cause deadlock.
Yes, it will take a read-lock, but it should not be expensive.

> I'd suggest you use monotonic_to_bootbased() here instead of hacking up this
> hrtimer specific interface, but even so, right now that call doesn't take the
> timekeeper lock, but probably should, so its not a good long term plan.

It maybe doable, or whether we can add another function to only return sleep time.
Then no read-lock is needed.

> 
> I'm still not convinced this change needs to be done, but a  better solution
> here would be to add infrastructure that when the sleep time is updated we
> update an offset that the is adding to the local_clock() however, you probably
> want to be careful since you don't want sleep time in normal
> local_clock/sched_clock calls since it would mess up scheduling.
> 
Sometimes we need to compare the kernel log with user space log, 
so it would be convenient to add the sleep time into kernel timestamp.

> thanks
> -john

Best Regards,
Neil Zhang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
