Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756Ab3F1QvU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 12:51:20 -0400
Received: from smtp.citrix.com ([66.165.176.89]:8716 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754226Ab3F1QvT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 12:51:19 -0400
X-IronPort-AV: E=Sophos;i="4.87,960,1363132800"; 
   d="scan'208";a="34133867"
Message-ID: <51CDBF05.5070502@citrix.com>
Date: Fri, 28 Jun 2013 17:51:17 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120428 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: <xen-devel@lists.xen.org>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH 5/5] x86/xen: sync the CMOS RTC as well as the Xen wallclock
References: <1372329348-20841-1-git-send-email-david.vrabel@citrix.com> <1372329348-20841-6-git-send-email-david.vrabel@citrix.com> <alpine.DEB.2.02.1306281727240.4013@ionos.tec.linutronix.de> <51CDB0A1.6080409@citrix.com> <alpine.DEB.2.02.1306281805430.4013@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1306281805430.4013@ionos.tec.linutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/06/13 17:09, Thomas Gleixner wrote:
> On Fri, 28 Jun 2013, David Vrabel wrote:
>>
>> Before:
>>
>> Xen wallclock set when time is stepped.
>> Xen wallclock set every 11 minutes (by sync_cmos_clock()).
>> Hardware RTC never set.
>>
>> After:
>>
>> Xen wallclock set when time is stepped.
>> Xen wallclock set every 11 minutes (in pvclock gtod notifier).
> 
> Ah, you are emulating the sync_cmos_clock() behaviour for the xen
> wallclock via the periodic pvclock_gtod notifier call.
> 
>> Hardware RTC set every 11 minutes (by sync_cmos_clock()).
>>
>> I'll update the changelog to be more descriptive:
>>
>>   Adjustments to Xen's persistent clock via update_persistent_clock()
>>   don't actually persist, as the Xen wallclock is a software only clock
>>   and modifications to it do not modify the underlying CMOS RTC.
>>
>>   The x86_platform.set_wallclock hook can be used to keep the hardware
>>   RTC synchronized (as on bare metal).  If (in dom0) we make the Xen
>>   wallclock periodically synchronized by the pvclock_gtod notifier, the
>>   set_wallclock hook need not update the Xen wallclock and the native
>>   implementation can be used.
> 
> Yep. I'll pick that up.

If it helps, I've made this change as well as splitting the xen part of
the hrtimers patch out into a separate commit.

The following changes since commit 52efa9eb9ea36b457b23b1b5d3dd9ce64d110715:

  x86: increase precision of x86_platform.get/set_wallclock() (2013-06-26 18:07:16 +0100)

are available in the git repository at:
  git://xenbits.xen.org/people/dvrabel/linux.git wallclock-v8

David Vrabel (6):
      hrtimers: support resuming with two or more CPUs online (but stopped)
      time: pass flags instead of multiple bools to timekeeping_update()
      time: indicate that the clock was set in the pvclock gtod notifier chain
      xen: remove unnecessary call to clock_was_set() during resume
      x86/xen: sync the wallclock when the system time is set
      x86/xen: sync the CMOS RTC as well as the Xen wallclock

 arch/x86/xen/time.c          |   42 +++++++++++++++++++++++++++++++++++-------
 drivers/xen/manage.c         |    3 ---
 include/linux/pvclock_gtod.h |    7 +++++++
 kernel/hrtimer.c             |   15 ++++++++++++---
 kernel/time/timekeeping.c    |   39 ++++++++++++++++++++++++---------------
 5 files changed, 78 insertions(+), 28 deletions(-)

David
