Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751212AbaK0XXy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 18:23:54 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:49328 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbaK0XXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 18:23:52 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Xunlei Pang <pang.xunlei@linaro.org>, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, Alessandro Zummo <a.zummo@towertech.it>,
        Sven Schnelle <svens@stackframe.org>,
        John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Subject: Re: [RFC PATCH 2/4] rtc: Convert rtc_class_ops.set_mmss() to use time64_t
Date: Fri, 28 Nov 2014 00:23:48 +0100
Message-ID: <3958728.Cz3JcLN4Uc@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <alpine.DEB.2.11.1411280003020.3961@nanos>
References: <1417089760-26848-1-git-send-email-pang.xunlei@linaro.org> <1417089760-26848-3-git-send-email-pang.xunlei@linaro.org> <alpine.DEB.2.11.1411280003020.3961@nanos>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:fMhZNmGXVVfhTSPRlm7scsVz49oXfyVYJyrL3poCtmL
 s4D+/0Lg65IJXQF79stjTIJUv84w13pOw7lUo6NAn1MBhzuk4G
 D2+MVXYkTfC+P+P8/n5lptdxGArvLlMn9kZy+TT3xZUPqzxukY
 2vrnfFDIrLATnxWazyalqxIIECjbtBuvBeMMtaDfGIzfRZaR81
 w0buOM0M4E4b7cVl3jDWQPMI5AehyOMupmsAiJ7kAu64s+adlC
 jDblfLqTb26a9Zv3Vwd08MKIgjo6CCW/fownHcX+cCSmMqCLiI
 Nwyu7usDy39gnPghQA3wEXXbMaETTIIjkTgKnB7JGMn2Zsi3BO
 bNTi2UnAbM0QA48VNVgg=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 November 2014 00:05:34 Thomas Gleixner wrote:
> On Thu, 27 Nov 2014, Xunlei Pang wrote:
> > -static int coh901331_set_mmss(struct device *dev, unsigned long secs)
> > +static int coh901331_set_mmss(struct device *dev, time64_t secs)
> >  {
> >       struct coh901331_port *rtap = dev_get_drvdata(dev);
> >  
> >       clk_enable(rtap->clk);
> > +     /*
> > +      * y2106 issue:
> > +      *   On 32bit systems the time64_t secs value gets cast to
> > +      *   a 32bit long, and thus we can only write a maximum value
> > +      *   of y2016
> 
> That really makes a lot of sense. Before that patch the driver was
> safe up to 2038. Now it is facing the y2016 problem.

Actually the comment is still wrong with the number fixed, I hadn't
noticed when I looked at the patch earlier:

The cast happens on both 32-bit and 64-bit, as we cast into a u32
value through the writel(). The behavior of this driver doesn't
even change with this patch, it was good until y2106 and stays
that way because 'unsigned long', 'time64_t' and 'u32' can all represent
at least times between 1970 and 2106, the change is just to document
the time at which it will break, while changing the API.

Some other drivers in this patch actually get changed to work beyond
2106, to the full time span that their hardware register layout allows.

	Arnd
