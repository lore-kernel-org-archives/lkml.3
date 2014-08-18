Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751616AbaHRBLl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 21:11:41 -0400
Received: from mga11.intel.com ([192.55.52.93]:48353 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751096AbaHRBLk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 21:11:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,882,1400050800"; 
   d="scan'208,223";a="586135997"
Message-ID: <1408324292.2339.66.camel@rzhang1-toshiba>
Subject: Re: 3.16-rcX crashes on resume from Suspend-To-RAM
From: Zhang Rui <rui.zhang@intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: markus@gutschke.com, Mika Westerberg <mika.westerberg@linux.intel.com>,
        Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
Date: Mon, 18 Aug 2014 09:11:32 +0800
In-Reply-To: <1558893.86R7jAYGB3@vostro.rjw.lan>
References: <CALGCz1qs2A7BCbcK3vzYRxJeOESVKc7c9kcSpP0NrQFLr1UpUg@mail.gmail.com>
	 <CALGCz1p8=gPBqf6z-YpRzSE=raNJmJw-OKCsLwne3raCr4Y-1g@mail.gmail.com>
	 <CALGCz1ofVwspov3QU1rk3z5HBRuDuKxwk1Qkx2xM3vFAVLzS2g@mail.gmail.com>
	 <1558893.86R7jAYGB3@vostro.rjw.lan>
Content-Type: multipart/mixed; boundary="=-EGBPE3aieT5ZYPzOrZ55"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-EGBPE3aieT5ZYPzOrZ55
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Sat, 2014-08-16 at 02:46 +0200, Rafael J. Wysocki wrote:
> On Friday, August 15, 2014 10:17:42 AM Markus Gutschke wrote:
> > Just wondering if any of you had any other ideas of what I could try
> > to help debug this problem?
> 
> My theory is that there is a device in your system that we don't have a driver
> for, but it had been enumerated as a PNP device before the change that triggered
> the problem for you and we turned it off during suspend as part of the default
> ACPI PNP device handling.

I had the same assumption before, thus I checked the difference of
platform devices and pnp devices, and found that there are three devices
enumerated to platform bus instead of PNP bus after the ACPI enumeration
rework patches. They are PNP0800, PNP0200 and PNP0C04 devices, thus I
made a debug patch to add those ids to the acpi_pnp scan handler id list
so that they will stay in PNP bus. But the problem still exists after
applying the debug patch.
> 
> The reason why you're seeing a crash with the "platform" test level is most
> likely that the _WAK control method does something unusual on your system.
> 
an easy way to check this is to apply the debug patch attached and
re-test "platform" test level.

thanks,
rui
> The LNXSYBUS:00 thing from dmesg probably is a red herring.
> 
> I need the output of acpidump from the affected system, but please attach it
> to the bug entry at https://bugzilla.kernel.org/show_bug.cgi?id=80911 that
> Rui has created for this issue.
> 
> Also please check the list of PNP devices under
> 
> /sys/bus/pnp/devices/
> 
> before and after the commit you have found by bisection and let me know if
> there are any differences.
> 
> 
> > On Tue, Aug 12, 2014 at 9:11 AM, Markus Gutschke <markus@gutschke.com> wrote:
> > > As I said earlier in this thread, echo'ing "devices" into "pm_test"
> > > does not result in a crash; but doing so for "platform" does.
> > >
> > > Markus
> > >
> > > On Aug 12, 2014 1:26 AM, "Zhang Rui" <rui.zhang@intel.com> wrote:
> > >>
> > >> On Sat, 2014-08-09 at 03:14 -0700, Markus Gutschke wrote:
> > >> > I am back and have physical access to the machine now.
> > >> >
> > >> great!
> > >>
> > >> > I re-ran the test just to be sure, and I can confirm that "platform"
> > >> > does in fact result in a crash.
> > >> >
> > >> what about "devices"?
> > >> I mean
> > >>
> > >> # echo devices > /sys/power/pm_test
> > >>
> > >> and see if that triggers the crash.
> > >>
> > >> > Furthermore, I ran the test that Rui asked for. I suspended, resumed,
> > >> > and upon crashing power-cycled the machine ASAP. "dmesg" suggests that
> > >> > the problem is with LNXSYBUS:00 That doesn't tell me much, but
> > >> > hopefully it makes sense to you guys.
> > >> >
> > >> [    0.930093]   Magic number: 10:810:122
> > >> [    0.930185] acpi LNXSYBUS:00: hash matches
> > >>
> > >> This looks weird, ACPI will do nothing for LNXSYBUS devices during
> > >> resume.
> > >> Rafael, any thought on this?
> > >>
> > >> thanks,
> > >> rui
> > >>
> 


--=-EGBPE3aieT5ZYPzOrZ55
Content-Disposition: attachment;
	filename*0=0001-80911-Debug-patch-to-skip-_WAK-in-platform-pm_test-m.pat;
	filename*1=ch
Content-Type: text/x-patch;
	name="0001-80911-Debug-patch-to-skip-_WAK-in-platform-pm_test-m.patch";
	charset="UTF-8"
Content-Transfer-Encoding: 7bit

>From 1a51cb80cf581a0aa228dd82aaf45f4e250d0d59 Mon Sep 17 00:00:00 2001
From: Zhang Rui <rui.zhang@intel.com>
Date: Mon, 18 Aug 2014 09:09:07 +0800
Subject: [PATCH] 80911: Debug patch to skip _WAK in platform pm_test mode

---
 kernel/power/suspend.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
index 6dadb25..402f0ca 100644
--- a/kernel/power/suspend.c
+++ b/kernel/power/suspend.c
@@ -270,11 +270,12 @@ static int suspend_enter(suspend_state_t state, bool *wakeup)
 		printk(KERN_ERR "PM: Some devices failed to power down\n");
 		goto Platform_finish;
 	}
-	error = platform_suspend_prepare_late(state);
-	if (error)
-		goto Platform_wake;
 
 	if (suspend_test(TEST_PLATFORM))
+		goto Platform_test;
+
+	error = platform_suspend_prepare_late(state);
+	if (error)
 		goto Platform_wake;
 
 	/*
@@ -319,8 +320,8 @@ static int suspend_enter(suspend_state_t state, bool *wakeup)
 
  Platform_wake:
 	platform_suspend_wake(state);
+ Platform_test:
 	dpm_resume_start(PMSG_RESUME);
-
  Platform_finish:
 	platform_suspend_finish(state);
 	return error;
-- 
1.8.3.2


--=-EGBPE3aieT5ZYPzOrZ55--

