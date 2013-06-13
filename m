Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757207Ab3FMOAA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 10:00:00 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:35729 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754858Ab3FMN76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 09:59:58 -0400
Date: Thu, 13 Jun 2013 15:59:53 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dirk Brandewie <dirk.brandewie@gmail.com>, linux-pm@vger.kernel.org,
        Len Brown <len.brown@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Michael Karcher <Michael.Karcher@fu-berlin.de>
Subject: Re: [REGRESSION] fan always on with 3.10-rc2
Message-ID: <20130613135952.GA16339@somewhere>
References: <15568618.SsOOjPSAq8@merkaba>
 <1825381.bJOGDrYABG@merkaba>
 <1461538.eEAU3Zp7hk@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1461538.eEAU3Zp7hk@merkaba>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 09, 2013 at 08:34:10PM +0200, Martin Steigerwald wrote:
> Am Samstag, 8. Juni 2013, 22:34:44 schrieb Martin Steigerwald:
> > Am Freitag, 24. Mai 2013, 13:03:18 schrieb Martin Steigerwald:
> > > Hi!
> > > 
> > > With 3.10-rc2 I see fan always or almost always on, even during extended
> > > periods of basically idling around. I did not notice this with 3.9. This is
> > > on an ThinkPad T520 with Intel Sandybridge i5-2520M dual core with
> > > hyperthreading at regularily 2,5 GhZ and Intel graphics (no nvidia).
> > > 
> > > I am using full hz:
> > > 
> > > martin@merkaba:~/Linux/Kernel/Mainline/Bugs/fan always on with 3.10.2-rc2> xzgrep NO_HZ config-3.10.0-rc2-tp520.xz
> > > CONFIG_NO_HZ_COMMON=y
> > > # CONFIG_NO_HZ_IDLE is not set
> > > CONFIG_NO_HZ_FULL=y
> > > CONFIG_NO_HZ_FULL_ALL=y
> > > CONFIG_NO_HZ=y
> > > CONFIG_RCU_FAST_NO_HZ=y
> > > 
> > > And P-State driver (which I used in 3.9 already as well).
> > > 
> > > Kernel config attached as xz. Use xzless or xzcat to display.
> > > 
> > > 
> > > What puzzles is output of powertop, especially:
> > 
> > Still present in 3.10-rc4.
> > 
> > I disabled P-State driver but then rpm seems to be even worse.
> > 
> > Around 2800 rpm all the time, was about 2650 with Intel P State driver.
> > 
> > Next I will try without CONFIG_NO_HZ_FULL and CONFIG_NO_HZ_FULL_ALL.
> 
> Okay, without these both the behavior is better. Fan still does not seem
> to get into non running state, which it was able to with earlier kernels
> (or userspaces?), but its down to a quiet 1950 rpm with Intel P-State driver
> enabled again. CC´d to people from thread "power management regression
> in linux 3.10? (related to CONFIG_NO_HZ_FULL)" which I think is related.
> 
> Powertop values make a lot more sense as well:
> 
> PowerTOP v2.0     Overview   Idle stats   Frequency stats   Device stats   Tunables                                     
> 
> 
>           Package   |             Core    |            CPU 0       CPU 1
>                     |                     | C0 active   1,4%        0,9%
>                     |                     | POLL        0,0%    0,0 ms  0,0%    0,0 ms
>                     |                     | C1E-SNB     7,7%    3,0 ms  2,9%    5,3 ms
> C2 (pc2)    1,1%    |                     |
> C3 (pc3)    7,2%    | C3 (cc3)    8,4%    | C3-SNB      8,2%    3,1 ms  3,0%   15,2 ms
> C6 (pc6)    4,9%    | C6 (cc6)    9,3%    | C6-SNB      7,0%    3,5 ms  6,2%   13,0 ms
> C7 (pc7)    9,9%    | C7 (cc7)   64,3%    | C7-SNB     73,4%    6,8 ms 84,0%   21,6 ms
> 
>                     |             Core    |            CPU 2       CPU 3
>                     |                     | C0 active   1,1%        0,9%
>                     |                     | POLL        0,0%    0,0 ms  0,0%    0,0 ms
>                     |                     | C1E-SNB    11,0%    6,9 ms  1,4%    4,8 ms
>                     |                     |
>                     | C3 (cc3)    9,3%    | C3-SNB      7,7%    5,8 ms  1,9%    6,0 ms
>                     | C6 (cc6)   10,0%    | C6-SNB      8,5%    7,4 ms  4,1%    4,9 ms
>                     | C7 (cc7)   64,9%    | C7-SNB     71,4%    8,2 ms 91,1%    7,1 ms
> 
> 
> 
> PowerTOP v2.0     Overview   Idle stats   Frequency stats   Device stats   Tunables                                     
> 
> 
>             Package |             Core    |            CPU 0       CPU 1
>                     |                     | Actual    2,0 GHz     2,4 GHz
> Idle        54,4%   | Idle        97,4%   | Idle        98,9%       98,2%
> 2,90 GHz     0,6%   | 2,90 GHz     0,1%   | 2,90 GHz     0,1%        0,1%
> 2,81 GHz     2,6%   | 3,10 GHz     0,2%   | 3,10 GHz     0,1%        0,1%
> 3,10 GHz     1,2%   | 2,10 GHz     0,1%   | 2,10 GHz     0,0%        0,0%
> 3,21 GHz     7,3%   | 3,21 GHz     0,9%   | 3,21 GHz     0,1%        0,9%
> 2,10 GHz     2,3%   | 2,81 GHz     0,2%   | 2,81 GHz     0,1%        0,1%
> 3,00 GHz     3,5%   | 3,00 GHz     0,0%   | 3,00 GHz     0,0%        0,0%
> 2,40 GHz     3,5%   | 2,40 GHz     0,1%   | 2,40 GHz     0,1%        0,1%
> 1,91 GHz     1,0%   | 1,91 GHz     0,1%   | 1,91 GHz     0,0%        0,0%
> 2,21 GHz     0,6%   | 2,21 GHz     0,1%   | 2,21 GHz     0,1%        0,1%
> 
>                     |             Core    |            CPU 2       CPU 3
>                     |                     | Actual    2,4 GHz     2,5 GHz
>                     | Idle        56,3%   | Idle        98,4%       57,7%
>                     | 2,90 GHz     0,5%   | 2,90 GHz     0,1%        0,9%
>                     | 2,81 GHz     2,5%   | 2,81 GHz     0,1%        6,4%
>                     | 3,10 GHz     1,1%   | 3,10 GHz     0,2%        2,2%
>                     | 3,21 GHz     6,7%   | 3,00 GHz     0,0%        2,4%
>                     | 3,00 GHz     3,5%   | 3,21 GHz     0,5%        3,4%
>                     | 2,71 GHz     2,4%   | 2,50 GHz     0,1%        3,3%
>                     | 2,50 GHz     1,1%   | 2,31 GHz     0,1%        0,4%
>                     | 2,31 GHz     0,2%   | 2,71 GHz     0,1%        1,0%
>                     | 2,60 GHz     1,0%   | 2,60 GHz     0,1%        2,7%
> 
> 
> If I haven´t stated it. This is on a ThinkPad T520 with dual core
> Sandybridge i5-2620M at 2.5 GHz (overclockable to 3.2 GhZ), now with
> Kernel 3.10-rc5. I didn´t test this one with the full hz stuff enabled, only
> rc2 and rc4.
> 
> > According to powertop CPU 0 is never idle

Note that CONFIG_NO_HZ_FULL is very power unfriendly because it forces CPU 0
to keep its periodic tick to handle timekeeping, even when idle. Paul McKenney is
working on a solution to solve this.

Thanks.
