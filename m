Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064AbaKYROd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 12:14:33 -0500
Received: from mail-vc0-f181.google.com ([209.85.220.181]:37289 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbaKYRO3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 12:14:29 -0500
MIME-Version: 1.0
In-Reply-To: <3222595.cbGxNcWa4c@diego>
References: <1416344908-5975-1-git-send-email-amstan@chromium.org>
	<3222595.cbGxNcWa4c@diego>
Date: Tue, 25 Nov 2014 09:14:28 -0800
X-Google-Sender-Auth: R20yZDuO65hSe_IF1m17SjVayJU
Message-ID: <CAD=FV=X=03Onok8FpFH1J96o7N7X2ycSOoRxoyyhU_XEq7CU8Q@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] Add support for the rockchip mmc clock phases
 using the framework
From: Doug Anderson <dianders@chromium.org>
To: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>
Cc: Alexandru M Stan <amstan@chromium.org>,
        Mike Turquette <mturquette@linaro.org>,
        addy ke <addy.ke@rock-chips.com>, Sonny Rao <sonnyrao@chromium.org>,
        Kever Yang <kever.yang@rock-chips.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        Mark yao <mark.yao@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heiko,

On Tue, Nov 25, 2014 at 1:35 AM, Heiko Stübner <heiko@sntech.de> wrote:
> Am Dienstag, 18. November 2014, 13:08:26 schrieb Alexandru M Stan:
>> For now all I have is the getter and setter for the phase, nothing that uses
>> it (that is ready). You can test the getter like this:
>> localhost ~ # cat /sys/kernel/debug/clk/clk_summary|grep sample -C 1
>>     sclk_sdio1                            0            0    24000000
>>  0 0 sdio1_sample                       0            0    12000000
>> 0 0 sdio1_drv                          0            0    12000000
>> 0 90 --
>>           sclk_sdmmc                      1            1   297000000
>>  0 0 sdmmc_sample                 0            0   148500000          0 134
>> sdmmc_drv                    0            0   148500000          0 90 --
>>           sclk_sdio0                      1            1   100000000
>>  0 0 sdio0_sample                 0            0    50000000          0 0
>> sdio0_drv                    0            0    50000000          0 90
>> sclk_emmc                       1            1   100000000          0 0
>> emmc_sample                  0            0    50000000          0 0
>> emmc_drv                     0            0    50000000          0 180
>>
>> Next thing that will come is some dts changes that will make use of these
>> new clocks, and eventually mmc code will be changed to tune with these
>> clocks.
>
> As already said in v1, this looks nice to me, but I'll give Mike another day
> or two to voice possible concerns.

Please hold off on applying.  I spent some time with Alex over the
last few days and we found a few issues.  There were a few tiny bugs,
but also we found that some cards were not tuning properly.

Specifically it appears that on our board most UHS cards will reports
two valid ranges of valid phases, like:
  0 - 135: good
  225 - 270: good

That means that 180 was bad and 315 were bad.  It's a little unclear
why there are two bad ranges (I know very little of the signaling of
MMC), but my uneducated guess was that one of the bad ranges was
because of timing and the other because of signal integrity
(reflections, etc?)

In any case, on some cards we were actually finding only one range,
like maybe we'd find that 0 - 270 were good and only 315 was bad.
Then we'd pick right in the middle of the range, like 135.  The
problem was that on these cards 135 was a little iffy.  It somehow
managed to pass the tuning most of the time but then it would fail in
real usage.  Even repeating tuning 1000 times wasn't enough to get it
to fail reliably.  Could it be that the "fine delay" actually varies
with a very long period, so maybe it acts like "40ps" for a while then
"80ps" for a while?  That means that when we thought tuned with 135
degrees maybe we actually tuned with 120 degrees or 150 degrees.  When
it changed we started getting failures?


Our current proposal is to add "22.5" degree increments to the driver,
which seemed to fix the problem on the cards we tested.  It
successfully noticed some extra failing phases.  Going by 22.5 is the
smallest increment we can go without exposing the iffy-ness of the
fine delay to the driver.  Remember that the fine delay is between
40-80ps per count and we assume 60ps.  So our delay can be 1.33x as
long or .67 times as long.  Going by 22.5, we get

0 = exactly 0 degrees (coarse delay)
22.5 = 15 degrees - 30 degrees (coarse delay + fine delay)
45.0 = 30 degrees - 60 degrees (coarse delay + fine delay)
67.5 = 45 degrees - 90 degrees (coarse delay + fine delay)
90.0 = exactly 90 degrees (coarse delay)

That means we can be guaranteed that the real delay when the user
requests 90.0 degrees is >= the relay delay when they request 67.5.
We also get a guarantee that we _definitely_ tested a phase that is 0,
a phase that is < 45 degrees and one that was >= 45 degrees.


If the above proposal is not OK or we find cards that still fail with
that, we might have to go back to the drawing board and somehow expose
the fact that our fine delay is not very precise.  Other proposals
that were talked about:

1. On higher speed cards, we could completely use the fine delay.  The
fine delay can easily make all 360 degrees, but it doesn't make them
reliably so you can't assume that 0 and 360 are the same  dw_mmc would
need to be aware of that.  Note that if the fine delay really does
change over time (like if it changed from 40ps per to 80ps per), this
could be a non-starter.

2. The really important thing is to find failure points and make sure
that we don't pick phases that are close to them.  As long as dw_mmc
was aware that requesting 80 degrees might give you anywhere between
53 and 107 degrees it could still gather good information.  If it saw
a failure when that failed then it probably shouldn't pick 45 or 90
degrees.  We could add some logic to the clock phase API for this.
