Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932663Ab3CDVlf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 16:41:35 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:41495 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932254Ab3CDVle convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 16:41:34 -0500
Date: Mon, 4 Mar 2013 16:41:10 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Martin Peres <martin.peres@free.fr>
Cc: airlied@linux.ie, bskeggs@redhat.com, marcin.slusarz@gmail.com,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: nouveau shuts the machine down with v3.9-rc1 (temperature (72 C)
 hit the 'shutdown' threshold).
Message-ID: <20130304214110.GA17402@phenom.dumpdata.com>
References: <20130304184022.GA8222@phenom.dumpdata.com>
 <5134F44C.7040700@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <5134F44C.7040700@free.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 04, 2013 at 08:21:48PM +0100, Martin Peres wrote:
> Hi Konrad,
> 
> On 04/03/2013 19:40, Konrad Rzeszutek Wilk wrote:> After git merge
> ab7826595e9ec51a51f622c5fc91e2f59440481a
> > (Merge tag 'mfd-3.9-1' of
> git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-2.6)
> > the nouveau driver ends up shutting of the machine when booting.
> >
> >
> > I hadn't done a git bisection yet and was wondering if there are some
> > juice commits I ought to look at?
> 
> Sure, no need to bisect, it is a new (apparently-broken-for-you) feature.
> 
> The code is in /drivers/gpu/drm/nouveau/core/subdev/therm/
> 
> 
> >
> > Here is the serial console:
> 
> 
> > [    6.940628] nouveau  [  PTHERM][0000:00:0d.0] Thermal
> management: disabled
> > [    6.957474] nouveau  [  PTHERM][0000:00:0d.0] programmed
> thresholds [ 90(2), 95(3), 145(2), 135(5) ]
> > [    6.966594] nouveau     6.975100] nouveau  [
> PTHERM][0000:00:0d.0] Thermal management: automatic
> > [    6.982059] nouveau  [  PTHERM][0000:00:0d.0] temperature (88
> C) hit the 'downclock' threshold
> > [    6.990680] nouveau  [  PTHERM][0000:00:0d.0] temperature (88
> C) hit the 'critical' threshold
> > [    6.999194] nouveau  [  PTHERM][0000:00:0d.0] temperature (90
> C) hit the 'shutdown' threshold
> 
> See, this is strange. If I believe the "programmed thresholds" line,
> the fanboost threshold is at 90°C, downclock is at 95°C, critical
> temperature is at 145°C and shutdown is at 135°C.
> So, from the BIOS side, things seem to be in fairly good shape
> (critical should be lower than shutdown, but that's OK).
> 
> My theory is that your temperature sensor is very variable that
> would set off the shutdown alarm. So, either the sensor needs more
> settling time or the output is genuinely very variable.

You should see it when I boot it under Xen:

[    8.427789] nouveau  [  PTHERM][0000:00:0d.0] programmed thresholds [ 90(2), 95(3), 145(2), 135(5) ]^M^M
[    8.427855] nouveau  [  PTHERM][0000:00:0d.0] temperature (222 C) hit the 'fanboost' threshold^M^M
[    8.427919] nouveau  [  PTHERM][0000:00:0d.0] Thermal management: automatic^M^M
[    8.427973] nouveau  [  PTHERM][0000:00:0d.0] temperature (222 C) hit the 'downclock' threshold^M^M
[    8.428036] nouveau  [  PTHERM][0000:00:0d.0] temperature (222 C) hit the 'critical' threshold^M^M
[    8.428099] nouveau  [  PTHERM][0000:00:0d.0] temperature (222 C) hit the 'shutdown' threshold^M^M

> 
> In the first case, we could fix that by increasing the settling time
> (at the expense of a longer boot period). We could also for a 10s
> wait at boot time before reading temperature.
> If this is the latter case, we only have the solution to average the
> temperature on several samples. I would need statistics on the
> variability in order to calculate a proper low-pass filter that
> wouldn't be too slow or too RAM/wakeup-intensive.
> 
> I really hope the problem is the settling time!
> 
> 
> Here is what you can do to test the theory:
> 
> Change the mdelay at line 41 of
> /drivers/gpu/drm/nouveau/core/subdev/therm/nv40.c (http://cgit.freedesktop.org/nouveau/linux-2.6/tree/drivers/gpu/drm/nouveau/core/subdev/therm/nv40.c#n41)
> from 10 to 1000.
> Please also add an mdelay of 1000 between lines 44 and 45.

Let me do that tomorrow and report my findings.
> 
> If it works with this patch, then try decreasing the delay to 20ms.
> 
> In any way, I'll send some thermal patches tonight to be more
> resistant to long settling times.

Pls CC me in case you would like me also to test them with the
mdelay patch.

> 
> Thanks for reporting!

Of course.
> 
> Martin (mupuf)
> 
> 
