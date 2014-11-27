Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849AbaK0Xrk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 18:47:40 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:53941 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbaK0Xrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 18:47:39 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Xunlei Pang <pang.xunlei@linaro.org>, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, Alessandro Zummo <a.zummo@towertech.it>,
        Sven Schnelle <svens@stackframe.org>,
        John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Subject: Re: [RFC PATCH 1/4] rtc/mxc: Convert get_alarm_or_time()/set_alarm_or_time() to use time64_t
Date: Fri, 28 Nov 2014 00:47:14 +0100
Message-ID: <4653852.SPZ1tnKaLF@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <alpine.DEB.2.11.1411272350190.3961@nanos>
References: <1417089760-26848-1-git-send-email-pang.xunlei@linaro.org> <1417089760-26848-2-git-send-email-pang.xunlei@linaro.org> <alpine.DEB.2.11.1411272350190.3961@nanos>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:T6vvpSyC+ZC1B8GkaDcXgOit49Wc+jPBbQsHRdxuxLv
 1tFL1SI34pSGfm1PyWTTUw3WrbDMNGUgAg/UuC598DibAR9/zm
 xnN9nPGjK9g+gXKIPSqDaAP8rG1BnlzC2+mu9bN+3iuVNemHKO
 SPMe78ZdBURVvv4GZs68/BQdGDwCge6iiFKwSoJXCfbaCgGxhn
 lYNbJ8wDTpYYAe6FZAr0FQ/P5ZP6tn6o1sjDBqNFtWtA+hkBRF
 3Ad2xDD9t+PjTGaSlVBgzEPI4O1wtB58LmO/Uh1ZLXKVyozlmk
 U48Wa0DuVNrbwwQqiilzJlMM43CnY7ZM5ynRNmzvOWULVWJ/mm
 d5U9f27rhW4AihK/8C5k=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 November 2014 00:02:47 Thomas Gleixner wrote:
> 
> >  static int rtc_update_alarm(struct device *dev, struct rtc_time *alrm)
> >  {
> >       struct rtc_time alarm_tm, now_tm;
> > -     unsigned long now, time;
> > +     time64_t now, time;
> >       struct platform_device *pdev = to_platform_device(dev);
> >       struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
> >       void __iomem *ioaddr = pdata->ioaddr;
> >  
> >       now = get_alarm_or_time(dev, MXC_RTC_TIME);
> > -     rtc_time_to_tm(now, &now_tm);
> > +     rtc_time64_to_tm(now, &now_tm);
> 
> So here you convert that to struct rtc_time.
> 
> >       alarm_tm.tm_year = now_tm.tm_year;
> >       alarm_tm.tm_mon = now_tm.tm_mon;
> >       alarm_tm.tm_mday = now_tm.tm_mday;
> >       alarm_tm.tm_hour = alrm->tm_hour;
> >       alarm_tm.tm_min = alrm->tm_min;
> >       alarm_tm.tm_sec = alrm->tm_sec;
> > -     rtc_tm_to_time(&alarm_tm, &time);
> > +     time = rtc_tm_to_time64(&alarm_tm);
> 
> Just to convert it back and then do the reverse operation in
> set_alarm_or_time()

Apparently the code originally tried to make the alarm fire within 
the next 24 hours. What you and the author of c92182ee0b5a3
("drivers/rtc/rtc-mxc.c: make alarm work") apparently missed is that
it is taking the year/mon/mday value of today and the hour/min/sec
value from the function argument.

I think the idea was to make it work with user space that sets only
the last three fields (which would work on the typical x86 rtc),
but after that other patch, the function no longer makes any sense,
since it will set the alarm in the past half of the time.

	Arnd
