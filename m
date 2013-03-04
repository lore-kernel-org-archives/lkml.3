Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932239Ab3CDTWm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 14:22:42 -0500
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:42032 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758573Ab3CDTWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 14:22:41 -0500
Message-ID: <5134F44C.7040700@free.fr>
Date: Mon, 04 Mar 2013 20:21:48 +0100
From: Martin Peres <martin.peres@free.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: airlied@linux.ie, bskeggs@redhat.com, marcin.slusarz@gmail.com,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: nouveau shuts the machine down with v3.9-rc1 (temperature (72
 C) hit the 'shutdown' threshold).
References: <20130304184022.GA8222@phenom.dumpdata.com>
In-Reply-To: <20130304184022.GA8222@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Konrad,

On 04/03/2013 19:40, Konrad Rzeszutek Wilk wrote:> After git merge 
ab7826595e9ec51a51f622c5fc91e2f59440481a
 > (Merge tag 'mfd-3.9-1' of 
git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-2.6)
 > the nouveau driver ends up shutting of the machine when booting.
 >
 >
 > I hadn't done a git bisection yet and was wondering if there are some
 > juice commits I ought to look at?

Sure, no need to bisect, it is a new (apparently-broken-for-you) feature.

The code is in /drivers/gpu/drm/nouveau/core/subdev/therm/


 >
 > Here is the serial console:


 > [    6.940628] nouveau  [  PTHERM][0000:00:0d.0] Thermal management: 
disabled
 > [    6.957474] nouveau  [  PTHERM][0000:00:0d.0] programmed 
thresholds [ 90(2), 95(3), 145(2), 135(5) ]
 > [    6.966594] nouveau     6.975100] nouveau  [ 
PTHERM][0000:00:0d.0] Thermal management: automatic
 > [    6.982059] nouveau  [  PTHERM][0000:00:0d.0] temperature (88 C) 
hit the 'downclock' threshold
 > [    6.990680] nouveau  [  PTHERM][0000:00:0d.0] temperature (88 C) 
hit the 'critical' threshold
 > [    6.999194] nouveau  [  PTHERM][0000:00:0d.0] temperature (90 C) 
hit the 'shutdown' threshold

See, this is strange. If I believe the "programmed thresholds" line, the 
fanboost threshold is at 90°C, downclock is at 95°C, critical 
temperature is at 145°C and shutdown is at 135°C.
So, from the BIOS side, things seem to be in fairly good shape (critical 
should be lower than shutdown, but that's OK).

My theory is that your temperature sensor is very variable that would 
set off the shutdown alarm. So, either the sensor needs more settling 
time or the output is genuinely very variable.

In the first case, we could fix that by increasing the settling time (at 
the expense of a longer boot period). We could also for a 10s wait at 
boot time before reading temperature.
If this is the latter case, we only have the solution to average the 
temperature on several samples. I would need statistics on the 
variability in order to calculate a proper low-pass filter that wouldn't 
be too slow or too RAM/wakeup-intensive.

I really hope the problem is the settling time!


Here is what you can do to test the theory:

Change the mdelay at line 41 of 
/drivers/gpu/drm/nouveau/core/subdev/therm/nv40.c 
(http://cgit.freedesktop.org/nouveau/linux-2.6/tree/drivers/gpu/drm/nouveau/core/subdev/therm/nv40.c#n41) 
from 10 to 1000.
Please also add an mdelay of 1000 between lines 44 and 45.

If it works with this patch, then try decreasing the delay to 20ms.

In any way, I'll send some thermal patches tonight to be more resistant 
to long settling times.

Thanks for reporting!

Martin (mupuf)


