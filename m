Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735Ab3KSON0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 09:13:26 -0500
Received: from mail-ee0-f53.google.com ([74.125.83.53]:60956 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487Ab3KSONY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 09:13:24 -0500
Date: Tue, 19 Nov 2013 15:13:19 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Miroslav Lichvar <mlichvar@redhat.com>, linux-kernel@vger.kernel.org,
        Prarit Bhargava <prarit@redhat.com>
Subject: Re: [PATCH RFC] timekeeping: Fix clock stability with nohz
Message-ID: <20131119141319.GA6934@netboy>
References: <1384440640-9482-1-git-send-email-mlichvar@redhat.com>
 <20131116070304.GB4355@netboy>
 <528A8667.7000304@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528A8667.7000304@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 01:28:07PM -0800, John Stultz wrote:
 
> Also, just for clarity's sake, when you're seeing things "broken",
> curious how/what you are measuring?

Here is the background for this issue. The linuxptp stack has a
program called phc2sys whose purpose is to synchronize the Linux
system clock with a PTP hardware clock typically residing on a PCIe
card. This program uses the PTP_SYS_OFFSET ioctl to read the clocks.

One user on the list was complaining that the reported time and
frequency errors were unacceptably large. After vainly trying
different PI weights, we found out that the poor performance is
due to the nohz setting in the kernel.

See below for example logs.
 
> Also is this brokenness something that has been around for awhile for
> you or more recently cropped up?  I'm wondering as nohz idle has been
> around for quite a few years and I've not seen too many complaints. So
> I'm wondering if I'm looking in the right places, or if something has
> regressed recently, or if its just that accuracy expectations have gone up?

I have always avoided nohz like the plague. IIRC, it would not even
compile on ARM for the longest time. In any case, I really don't know
when this issue appeared. At some point, nohz became the Kconfig
default, and I did not notice, and so now I had it enabled by
accident.

Here are two sample runs of phc2sys. The PHC is an Intel i210 PCIe
card. I simply set the PHC time to the Linux system time (using
testptp -s), and then let PHC clock run free. During the test, the
phc2sys program is the only active program, and the system is
otherwise idle.

In this test, the update rate is once per second. When using longer
intervals, the problem becomes worse.

In the listings, "sys offset" is measured in nanosecond using the
PTP_SYS_OFFSET ioctl, "freq" is the PI servo output in ppb, and
"delay" is the time it took to read the two clocks in nanoseconds.

* Periodic Case

  CONFIG_HZ_PERIODIC=y
  CONFIG_NO_HZ=y
  CONFIG_HZ_1000=y

  Here we observe a time error of about 100 nanoseconds peak to peak
  and a frequency error within about .2 PPM.

sudo ./phc2sys -s eth3 -m -q -l7 -O0
phc2sys[5050.678]: PI servo: sync interval 1.000 kp 0.700 ki 0.300000
phc2sys[5051.678]: sys offset    287239 s0 freq      +0 delay   5164
phc2sys[5052.678]: sys offset    303841 s1 freq  +16600 delay   5161
phc2sys[5053.679]: sys offset        11 s2 freq  +16611 delay   5184
phc2sys[5054.679]: sys offset        -6 s2 freq  +16597 delay   5191
phc2sys[5055.679]: sys offset        -6 s2 freq  +16595 delay   5121
phc2sys[5056.679]: sys offset       -32 s2 freq  +16567 delay   5184
phc2sys[5057.679]: sys offset        -6 s2 freq  +16584 delay   5197
phc2sys[5058.679]: sys offset        10 s2 freq  +16598 delay   5186
phc2sys[5059.679]: sys offset        14 s2 freq  +16605 delay   5162
phc2sys[5060.680]: sys offset       -12 s2 freq  +16583 delay   5212
phc2sys[5061.680]: sys offset       -15 s2 freq  +16576 delay   5196
phc2sys[5062.680]: sys offset        -4 s2 freq  +16583 delay   5186
phc2sys[5063.680]: sys offset        21 s2 freq  +16607 delay   5187
phc2sys[5064.680]: sys offset         5 s2 freq  +16597 delay   5196
phc2sys[5065.680]: sys offset        -1 s2 freq  +16593 delay   5192
phc2sys[5066.680]: sys offset        13 s2 freq  +16606 delay   5177
phc2sys[5067.680]: sys offset         5 s2 freq  +16602 delay   5212
phc2sys[5068.681]: sys offset        11 s2 freq  +16610 delay   5191
phc2sys[5069.681]: sys offset       -19 s2 freq  +16583 delay   5203
phc2sys[5070.681]: sys offset        -3 s2 freq  +16593 delay   5185
phc2sys[5071.681]: sys offset         9 s2 freq  +16604 delay   5197
phc2sys[5072.681]: sys offset         4 s2 freq  +16602 delay   5176
phc2sys[5073.681]: sys offset         7 s2 freq  +16606 delay   5196
phc2sys[5074.681]: sys offset        -6 s2 freq  +16595 delay   5186
phc2sys[5075.681]: sys offset       -28 s2 freq  +16572 delay   5192
phc2sys[5076.682]: sys offset        48 s2 freq  +16639 delay   5214

* NO_HZ 

  CONFIG_NO_HZ_COMMON=y
  CONFIG_NO_HZ_IDLE=y
  CONFIG_NO_HZ=y
  CONFIG_RCU_FAST_NO_HZ=y
  CONFIG_HZ_250=y

  Here we observe a time error of about 3 microseconds peak to peak
  and a frequency error within about 3 PPM.

cori@cher1293:~/git/linuxptp$ sudo ./phc2sys -s eth3 -m -q -l7 -O0
phc2sys[105.837]: PI servo: sync interval 1.000 kp 0.700 ki 0.300000
phc2sys[106.837]: sys offset    135052 s0 freq      +0 delay   5189
phc2sys[107.837]: sys offset    151449 s1 freq  +16394 delay   5174
phc2sys[108.837]: sys offset       246 s2 freq  +16640 delay   5179
phc2sys[109.838]: sys offset      -185 s2 freq  +16283 delay   5171
phc2sys[110.838]: sys offset      -552 s2 freq  +15860 delay   5192
phc2sys[111.838]: sys offset      1383 s2 freq  +17630 delay   5179
phc2sys[112.838]: sys offset      -737 s2 freq  +15925 delay   5158
phc2sys[113.838]: sys offset      1147 s2 freq  +17587 delay   5171
phc2sys[114.839]: sys offset     -1593 s2 freq  +15192 delay   5186
phc2sys[115.839]: sys offset     -1006 s2 freq  +15301 delay   5161
phc2sys[116.839]: sys offset      1157 s2 freq  +17162 delay   5191
phc2sys[117.839]: sys offset       410 s2 freq  +16762 delay   5179
phc2sys[118.839]: sys offset         0 s2 freq  +16475 delay   5184
phc2sys[119.839]: sys offset        20 s2 freq  +16495 delay   5159
phc2sys[120.840]: sys offset       473 s2 freq  +16954 delay   5172
phc2sys[121.840]: sys offset      -690 s2 freq  +15933 delay   5186
phc2sys[122.840]: sys offset      -437 s2 freq  +15979 delay   5186
phc2sys[123.840]: sys offset      -229 s2 freq  +16056 delay   5179
phc2sys[124.840]: sys offset       357 s2 freq  +16573 delay   5179
phc2sys[125.840]: sys offset       285 s2 freq  +16608 delay   5121
phc2sys[126.841]: sys offset       512 s2 freq  +16921 delay   5179
phc2sys[127.841]: sys offset      -944 s2 freq  +15618 delay   5179
phc2sys[128.841]: sys offset       338 s2 freq  +16617 delay   5158
phc2sys[129.841]: sys offset      1275 s2 freq  +17655 delay   5171
phc2sys[130.841]: sys offset      -198 s2 freq  +16565 delay   5339
phc2sys[131.841]: sys offset      -702 s2 freq  +16002 delay   5179
phc2sys[132.842]: sys offset      -664 s2 freq  +15829 delay   5101
phc2sys[133.842]: sys offset       -38 s2 freq  +16256 delay   5184
phc2sys[134.842]: sys offset       663 s2 freq  +16945 delay   5164
phc2sys[135.842]: sys offset     -1066 s2 freq  +15415 delay   5187
phc2sys[136.842]: sys offset      1202 s2 freq  +17363 delay   5172
phc2sys[137.842]: sys offset       289 s2 freq  +16811 delay   5161
phc2sys[138.843]: sys offset     -1495 s2 freq  +15114 delay   5154
phc2sys[139.843]: sys offset       877 s2 freq  +17037 delay   5179
phc2sys[140.843]: sys offset      -311 s2 freq  +16112 delay   5186
phc2sys[141.843]: sys offset      1509 s2 freq  +17839 delay   5179

Thanks,
Richard
