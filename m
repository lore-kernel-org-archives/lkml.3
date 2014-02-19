Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256AbaBSDfH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 22:35:07 -0500
Received: from mga09.intel.com ([134.134.136.24]:34453 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006AbaBSDfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 22:35:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,503,1389772800"; 
   d="scan'208";a="485580930"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Brown, Len" <len.brown@intel.com>, "pavel@ucw.cz" <pavel@ucw.cz>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Li, Zhuangzhi" <zhuangzhi.li@intel.com>
Subject: RE: [PATCH v3 5/5] PM / sleep: Asynchronous threads for suspend_late
Thread-Topic: [PATCH v3 5/5] PM / sleep: Asynchronous threads for
 suspend_late
Thread-Index: AQHPLLwr6+zopFEWTk2CKzLVbwhazJq77BuA
Date: Wed, 19 Feb 2014 03:34:58 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A01C2580D@SHSMSX101.ccr.corp.intel.com>
References: <1392617954-5292-6-git-send-email-chuansheng.liu@intel.com>
 <10253072.9TaPuJL1lG@vostro.rjw.lan>
 <27240C0AC20F114CBF8149A2696CBE4A01C241FF@SHSMSX101.ccr.corp.intel.com>
 <4518865.xplOjLcUGM@vostro.rjw.lan>
In-Reply-To: <4518865.xplOjLcUGM@vostro.rjw.lan>
Accept-Language: zh-CN, en-US
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s1J3ZEC5002183

Hello Rafael,

> -----Original Message-----
> From: Rafael J. Wysocki [mailto:rjw@rjwysocki.net]
> Sent: Tuesday, February 18, 2014 11:29 PM
> To: Liu, Chuansheng
> Cc: gregkh@linuxfoundation.org; Brown, Len; pavel@ucw.cz;
> linux-pm@vger.kernel.org; linux-kernel@vger.kernel.org; Li, Zhuangzhi
> Subject: Re: [PATCH v3 5/5] PM / sleep: Asynchronous threads for suspend_late
> 
> On Tuesday, February 18, 2014 12:33:11 AM Liu, Chuansheng wrote:
> > Hello Rafael,
> >
> > > -----Original Message-----
> > > From: Rafael J. Wysocki [mailto:rjw@rjwysocki.net]
> > > Sent: Tuesday, February 18, 2014 1:28 AM
> > > To: Liu, Chuansheng
> > > Cc: gregkh@linuxfoundation.org; Brown, Len; pavel@ucw.cz;
> > > linux-pm@vger.kernel.org; linux-kernel@vger.kernel.org; Li, Zhuangzhi
> > > Subject: Re: [PATCH v3 5/5] PM / sleep: Asynchronous threads for
> suspend_late
> > >
> > > On Monday, February 17, 2014 02:19:14 PM Chuansheng Liu wrote:
> > > > In analogy with commits 5af84b82701a and 97df8c12995, using
> > > > asynchronous threads can improve the overall suspend_late
> > > > time significantly.
> > > >
> > > > This patch is for suspend_late phase.
> > > >
> > > > Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
> > > > ---
> > > >  drivers/base/power/main.c | 66
> > > ++++++++++++++++++++++++++++++++++++++---------
> > > >  1 file changed, 54 insertions(+), 12 deletions(-)
> > > >
> > > > diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
> > > > index 72b4c9c..c031050 100644
> > > > --- a/drivers/base/power/main.c
> > > > +++ b/drivers/base/power/main.c
> > > > @@ -1127,16 +1127,26 @@ static int
> dpm_suspend_noirq(pm_message_t
> > > state)
> > > >   *
> > > >   * Runtime PM is disabled for @dev while this function is being
> executed.
> > > >   */
> > > > -static int device_suspend_late(struct device *dev, pm_message_t state)
> > > > +static int __device_suspend_late(struct device *dev, pm_message_t
> state,
> > > bool async)
> > > >  {
> > > >  	pm_callback_t callback = NULL;
> > > >  	char *info = NULL;
> > > > -	int error;
> > > > +	int error = 0;
> > > > +
> > > > +	dpm_wait_for_children(dev, async);
> > > >
> > >
> > > Like in patch [4/5], all of the "goto Complete" statements can go before
> > > the waiting.
> > >
> > You are right, will do that in patch V4, thanks your reviewing.
> 
> I've queued up your last series:
> 
> http://marc.info/?l=linux-pm&m=139269109711745&w=4
> 
> for 3.15, but I've rebased it on some patches already in my queue, so please
> double check the result in linux-pm.git/bleeding-edge.
> 
Thanks. I have pulled the latest linux-pm.git/bleeding-edge branch, and checked
them which are OK.


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
