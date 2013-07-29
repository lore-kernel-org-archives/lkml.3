Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053Ab3G2B4r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 21:56:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:52620 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752037Ab3G2B4n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 21:56:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,766,1367996400"; 
   d="scan'208";a="353315328"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: RE: [PATCH 06/13] ACPI/IPMI: Add reference counting for ACPI
 operation region handlers
Thread-Topic: [PATCH 06/13] ACPI/IPMI: Add reference counting for ACPI
 operation region handlers
Thread-Index: AQHOh3wWhtcRfGeNDUSAzJ7WvM5MAZl1Zu+AgADNjlCAAFUQgIAEYZFA
Date: Mon, 29 Jul 2013 01:56:38 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E880243628D@SHSMSX101.ccr.corp.intel.com>
References: <cover.1370652213.git.lv.zheng@intel.com>
 <2501577.sf07PMEtR1@vostro.rjw.lan>
 <1AE640813FDE7649BE1B193DEA596E8802435B7C@SHSMSX101.ccr.corp.intel.com>
 <3196577.UQScsUKI1B@vostro.rjw.lan>
In-Reply-To: <3196577.UQScsUKI1B@vostro.rjw.lan>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r6T1un8k023122

> On Friday, July 26, 2013 10:49 PM Rafael J. Wysocki wrote:
> > On Friday, July 26, 2013 01:54:00 AM Zheng, Lv wrote:
> > > On Friday, July 26, 2013 5:29 AM Rafael J. Wysocki wrote:
> > > On Tuesday, July 23, 2013 04:09:43 PM Lv Zheng wrote:
> > > > This patch adds reference couting for ACPI operation region
> > > > handlers to fix races caused by the ACPICA address space callback
> invocations.
> > > >
> > > > ACPICA address space callback invocation is not suitable for Linux
> > > > CONFIG_MODULE=y execution environment.
> > >
> > > Actually, can you please explain to me what *exactly* the problem is?
> >
> > OK.  I'll add race explanations in the next revision.
> >
> > The problem is there is no "lock" held inside ACPICA for invoking
> > operation region handlers.
> > Thus races happens between the
> > acpi_remove/install_address_space_handler and the handler/setup
> callbacks.
> 
> I see.  Now you're trying to introduce something that would prevent those
> races from happening, right?

Yes. Let me explain this later in this email.

> 
> > This is correct per ACPI specification.
> > As if there is interpreter locks held for invoking operation region
> > handlers, the timeout implemented inside the operation region handlers
> > will make all locking facilities (Acquire or Sleep,...) timed out.
> > Please refer to ACPI specification "5.5.2 Control Method Execution":
> > Interpretation of a Control Method is not preemptive, but it can
> > block. When a control method does block, OSPM can initiate or continue
> > the execution of a different control method. A control method can only
> > assume that access to global objects is exclusive for any period the control
> method does not block.
> >
> > So it is pretty much likely that ACPI IO transfers are locked inside
> > the operation region callback implementations.
> > Using locking facility to protect the callback invocation will risk dead locks.
> 
> No.  If you use a single global lock around all invocations of operation region
> handlers, it won't deadlock, but it will *serialize* things.  This means that
> there won't be two handlers executing in parallel.  That may or may not be
> bad depending on what those handlers actually do.
> 
> Your concern seems to be that if one address space handler is buggy and it
> blocks indefinitely, executing it under such a lock would affect the other address
> space handlers and in my opinion this is a valid concern.

It can be expressed in more detailed ways:

The interpreter runs control methods in the following style according to the ACPI spec.
CM1_Enter -> EnterInter -> CM1_Running -> OpRegion1 -> ExitInter -> EnterInter                            -> CM1_running -> ExitInter -> CM1_Exit
CM2_Enter -> EnterInter ->                                       -> CM2_Running -> OpRegion1 -> ExitInter -> EnterInter               -> CM2_running -> ExitInter -> CM2_Exit

EnterInter: Enter interpreter lock
ExitInter: Leave interpreter lock

Let me introduce two situations:

1. If we hold global "mutex" before "EnterInter", then no second control method can be run "NotSerialized".
If the CM1 just have some codes waiting for a hardware flag and CM2 can access other hardware IOs to trigger this flag, then nothing can happen any longer.
This is a practical bug as what we have already seen in "NotSerialized" marked ACPI control methods behave in the interpreter mode executed in serialized way - kernel parameter "acpi_serialize".

2. If we hold global "mutex" after "EnterInter" and Before OpRegion1
If we do things this way, then all IO accesses are serialized, if we have something in an IPMI operation region failed due to timeout, then any other system IOs that should happen in parallel will just happen after 5 seconds.  This is not an acceptable experience.

> 
> So the idea seems to be to add wrappers around
> acpi_install_address_space_handler()
> and acpi_remove_address_space_handler (but I don't see where the latter is
> called after the change?), such that they will know when it is safe to unregister
> the handler.  That is simple enough.

An obvious bug, it should be put between the while (atomic_read() > 1) block and the final atomic_dec().

> However, I'm not sure it is needed in the context of IPMI.

I think I do this just because I need a quick fix to test IPMI bug-fix series.
The issue is highly related to ACPI interpreter design, and codes should be implemented inside ACPICA.
And there is not only ACPI_ROOT_OBJECT based address space handlers, but also non-ACPI_ROOT_OBJECT based address space handlers, this patch can't protect the latter ones.

> Your address space
> handler's context is NULL, so even it if is executed after
> acpi_remove_address_space_handler() has been called for it (or in parallel), it
> doesn't depend on anything passed by the caller, so I don't see why the issue
> can't be addressed by a proper synchronization between
> acpi_ipmi_exit() and acpi_ipmi_space_handler().
> 
> Clearly, acpi_ipmi_exit() should wait for all already running instances of
> acpi_ipmi_space_handler() to complete and all acpi_ipmi_space_handler()
> instances started after acpi_ipmi_exit() has been called must return
> immediately.
> 
> I would imagine an algorithm like this:
> 
> acpi_ipmi_exit()
>  1. Take "address space handler lock".
>  2. Set "unregistering address space handler" flag.
>  3. Check if "count of currently running handlers" is 0.  If so,
>     call acpi_remove_address_space_handler(), drop the lock (possibly clear
> the
>     flag) and return.
>  4. Otherwise drop the lock and go to sleep in "address space handler wait
> queue".
>  5. When woken up, take "address space handler lock" and go to 3.
> 
> acpi_ipmi_space_handler()
>  1. Take "address space handler lock".
>  2. Check "unregistering address space handler" flag.  If set, drop the lock
>     and return.
>  3. Increment "count of currently running handlers".
>  4. Drop the lock.
>  5. Do your work.
>  6. Take "address space handler lock".
>  7. Decrement "count of currently running handlers" and if 0, signal the
>     tasks waiting on it to wake up.
>  8. Drop the lock.

Yes, it can also work, but the fix will go inside IPMI.
And I agree that the codes should not appear in the IPMI context since the issue is highly ACPI interpreter related.
What if we just stop doing any further work on this patch and just mark it as RFC or a test patch for information purpose.
It is only useful for the testers.

Thanks and best regards
-Lv

> 
> Thanks,
> Rafael
> 
> 
> --
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
