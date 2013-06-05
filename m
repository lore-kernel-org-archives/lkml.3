Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756893Ab3FERQV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 13:16:21 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:37689 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756432Ab3FERQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 13:16:20 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com
Subject: [PATCH 0/3] RFC: timekeeping: rtc: change hctosys mechanism
Date: Wed,  5 Jun 2013 19:15:37 +0200
Message-Id: <1370452540-3319-1-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <51ADEE76.7090504@ahsoftware.de>
References: <51ADEE76.7090504@ahsoftware.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

because it wasn't that much work, I've already rewritten the hctosys
mechanism without discussing the changes further before.

So the following patches are RFC (and incomplete but imho perfectly,
usable) see below under missing) and I hope they will find friends and at
least one reviewer which doesn't had a bad day.


To describe the changes, I first quote what I've added to
Documentation/kernel-parameters.txt:

	hctosys=	[KNL] Specifies the driver (RTC) name which sets the
			time at	boot, if and only if userspace hasn't set the
			time before the driver will be loaded. If hctosys will
			not be specified, the first available hardware clock
			with a valid time will be used.
			Use a non-existent name (e.g. hctosys=none) if you want
			to avoid that a hardware clock will set the time.
			Currently there exist a special name "persistent" for
			the persistent clock found on some systems (e.g. the
			CMOS clock on x86 platforms which might be handled
			by the driver named rtc_cmos too).

What the patches do change:

- Default functionality: hopefully nothing changes.
  The only user visible change is that /proc/dev/rtc doesn't appear on
  systems on which a "persistent" clock still is used. But I think this
  is logically more correct, than what currently happens:
  /proc/dev/rtc outputs data from an RTC which doesn't have to be what
  is really used (persistent clock).
  Therefor /proc/dev/rtc now only appears, if a RTC-driver is used for
  hctosys and not if a "persistent" clock is used. Unfortunately the later
  is still true on most systems (at least for x86*).

- CONFIG_RTC_HCTOSYS is gone.
  On systems with a "persistent" clock, CONFIG_RTC_HCTOSYS was meaningless,
  because those systems always used the "persistent" clock and so already
  ignored CONFIG_RTC_HCTOSYS. Now this functionality is always on, if a
  hardware clock ("persistent" clock or RTC-driver) is used for hctosys.

- CONFIG_RTC_HCTOSYS_DEVICE is gone.
  This config option never really specified which RTC is used, it only
  specified which RTC is used in kind of the order of their appearance
  to the system. With the new kernel-parameter hctosys= it is now at least
  possible to specify the type of the used RTC. Of course, if more RTCs of
  the same type (same driver) are available, the first of them will be used.

- The hctosys functionality works even when userspace alreads has started.
  Without these changes, hctosys was invoked either at initialization of
  the timekeeping system (for "persistent" clock) or at late_init, both
  happens before userspace is started.
  To avoid problems with that change there is now an additional rule:
  Userspace comes first. If the userspace sets the system clock before
  any hardware clock was available, the hardware clock will not change
  the system clock.

The last point above is also the reason why I did those changes at all
(to support USB RTCs).


What's missing:

I don't know much about those "persistent" clocks and I haven't had a
deep look at them. That's especially true for the suspend/resume
mechanism used by them. The mechanism I want to use is the following:
The RTC subsystem now maintains the ID of the RTC device which was used
for hctosys (in rtc_hctosys_dev_id) and therefor specifies the device
which should be used to adjust the time after resume. Additionaly the
(new) flag systime_was_set will be set to false at suspend and on resume
this flag will be set to true if either the clock will be adjusted by
the device used for hctosys or by userspace (through do_settimeofday()).

That all should already work as expected for RTCs, what's missing for
"persistent" clocks is that the flag systime_was_set is set to false on
suspend and set to true on resume. Currently it just stays at true
(which is set through hctosys if a "persistent" clock is found.
But because "persistent" clocks don't go away (as it is possible with
RTCs by removing the driver or the RTC itself), nor do "persistent"
clocks might have two instances, this shouldn't be a problem at all.


And last but not least, I have to add a disclaimer:

This changes aren't company driven. That means until now I was the only
person who has seen, reviewed and tested them and I spend only a limited
amount of (my spare) time for that. I did (quick) tests with x86 and ARM
systems, with and without RTCs, with and without "persistent" clocks.
I also tested suspend/resume on x86. But in any case, don't expect I
didn't make failures. I did those changes in my "private" mode and not in
my "professional" mode, which makes a difference (at least in the amount
of time I spend for review and testing). But don't be scared, even my
"private" mode might spend more time for QA than many companies (are able
and willing to) do. ;)


Regards,

Alexander Holler

PS: Parts of the above documentation might be added to one of the following
patches to document them better in git too. I've written the above
documentation after I've done the patches and will wait for feedback before
I change them again. I've already done more than I initially wanted to do.

PPS: The new hctosys mechanism provides an additional feature some people
might like: HA for RTCs. If a system has two hardware clocks and one of
them will fail such that it provides an invalid time (in regard to
rtc_valid_tm()), the second one will be used.

