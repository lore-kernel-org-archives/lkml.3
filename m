Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225AbaAPAup (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 19:50:45 -0500
Received: from mga09.intel.com ([134.134.136.24]:54598 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750856AbaAPAum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 19:50:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,665,1384329600"; 
   d="scan'208";a="459527341"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Brown, Len" <len.brown@intel.com>, "pavel@ucw.cz" <pavel@ucw.cz>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Li, Zhuangzhi" <zhuangzhi.li@intel.com>
Subject: RE: [PATCH] PM: Enable asynchronous noirq resume threads to save
 the resuming time
Thread-Topic: [PATCH] PM: Enable asynchronous noirq resume threads to save
 the resuming time
Thread-Index: AQHPEfPFFbhGj4fSWU2n5uJZfYRlQZqGhHvQ
Date: Thu, 16 Jan 2014 00:50:16 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A01C04905@SHSMSX101.ccr.corp.intel.com>
References: <1389683888.3650.78.camel@cliu38-desktop-build>
 <1746120.u7vbF1Vtmp@vostro.rjw.lan>
 <27240C0AC20F114CBF8149A2696CBE4A01C02047@SHSMSX101.ccr.corp.intel.com>
 <5903751.zQEEgRvxSH@vostro.rjw.lan>
In-Reply-To: <5903751.zQEEgRvxSH@vostro.rjw.lan>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s0G0opa3014045



> -----Original Message-----
> From: Rafael J. Wysocki [mailto:rjw@rjwysocki.net]
> Sent: Wednesday, January 15, 2014 9:28 PM
> To: Liu, Chuansheng
> Cc: gregkh@linuxfoundation.org; Brown, Len; pavel@ucw.cz;
> linux-pm@vger.kernel.org; linux-kernel@vger.kernel.org; Li, Zhuangzhi
> Subject: Re: [PATCH] PM: Enable asynchronous noirq resume threads to save
> the resuming time
> 
> On Wednesday, January 15, 2014 12:35:16 AM Liu, Chuansheng wrote:
> > Hello Rafael,
> >
> > > -----Original Message-----
> > > From: Rafael J. Wysocki [mailto:rjw@rjwysocki.net]
> > > Sent: Wednesday, January 15, 2014 6:55 AM
> > > To: Liu, Chuansheng
> > > Cc: gregkh@linuxfoundation.org; Brown, Len; pavel@ucw.cz;
> > > linux-pm@vger.kernel.org; linux-kernel@vger.kernel.org; Li, Zhuangzhi
> > > Subject: Re: [PATCH] PM: Enable asynchronous noirq resume threads to
> save
> > > the resuming time
> > >
> > > On Tuesday, January 14, 2014 03:18:08 PM Chuansheng Liu wrote:
> > > >
> > > > Currently, the dpm_resume_noirq() is done synchronously, and for PCI
> devices
> > > > pci_pm_resume_noirq():
> > > >
> > > > pci_pm_resume_noirq()
> > > >  pci_pm_default_resume_early()
> > > >   pci_power_up()
> > > >    pci_raw_set_power_state()
> > > > Which set the device from D3hot to D0 mostly, for every device, there will
> > > > be one 10ms(pci_pm_d3_delay) to wait.
> > > >
> > > > Hence normally dpm_resume_noirq() will cost > 100ms, which is bigger
> for
> > > mobile
> > > > platform.
> > >
> > > pci_pm_d3_delay usually is not 10 ms.  What is 10 ms is dev->d3_delay,
> but
> > > that also is not on every platform now.
> > Yes, it is d3_delay exactly, thanks your correction.
> >
> > >
> > > That said the approach here makes sense, but I have two questions:
> > >
> > > 1. On what systems has it been tested?
> > I have been tested on Baytrail platform, and at the beginning the d3_delay is
> set to 0,
> > but we really meet the HANG issue if we operate the device immediately
> sometimes,
> > so currently most PCI devices in Baytrail has the 10ms delay.
> > And it caused the whole resume time bigger than Clovertrail platform;
> 
> Does setting d3_delay to something smaller that 10 ms work on BayTrail?
> 
> You can try to set 5 ms and then 2.5 ms if that works and so on.  That still
> would be an improvement from the 10 ms.
Yes, for most devices in Baytrail platform, we already set the default value to 3ms, it works well now,
but for rare device, we set the d3_delay to 10ms.
So with this patch, the noirq execution time is 10ms;

> 
> > > 2. What about suspend_late/resume_early?  If the _noirq things are to be
> > > executed asynchronously, those should be too.
> > I noticed it just taken little time often, and I cannot find out some reasons for
> changing them
> > in theory, so if you like it, I will update them into patch V2 also:)
> 
> Yes, please do that.
Will do it, thanks.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
