Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759109Ab3GZOjU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 10:39:20 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:41762 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757011Ab3GZOjS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 10:39:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Zheng, Lv" <lv.zheng@intel.com>
Cc: "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH 06/13] ACPI/IPMI: Add reference counting for ACPI operation region handlers
Date: Fri, 26 Jul 2013 16:49:23 +0200
Message-ID: <3196577.UQScsUKI1B@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1AE640813FDE7649BE1B193DEA596E8802435B7C@SHSMSX101.ccr.corp.intel.com>
References: <cover.1370652213.git.lv.zheng@intel.com> <2501577.sf07PMEtR1@vostro.rjw.lan> <1AE640813FDE7649BE1B193DEA596E8802435B7C@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 26, 2013 01:54:00 AM Zheng, Lv wrote:
> > From: Rafael J. Wysocki [mailto:rjw@sisk.pl]
> > Sent: Friday, July 26, 2013 5:29 AM
> > 
> > On Tuesday, July 23, 2013 04:09:43 PM Lv Zheng wrote:
> > > This patch adds reference couting for ACPI operation region handlers to fix
> > > races caused by the ACPICA address space callback invocations.
> > >
> > > ACPICA address space callback invocation is not suitable for Linux
> > > CONFIG_MODULE=y execution environment.
> > 
> > Actually, can you please explain to me what *exactly* the problem is?
> 
> OK.  I'll add race explanations in the next revision.
> 
> The problem is there is no "lock" held inside ACPICA for invoking operation
> region handlers.
> Thus races happens between the acpi_remove/install_address_space_handler and
> the handler/setup callbacks.

I see.  Now you're trying to introduce something that would prevent those
races from happening, right?

> This is correct per ACPI specification.
> As if there is interpreter locks held for invoking operation region handlers,
> the timeout implemented inside the operation region handlers will make all
> locking facilities (Acquire or Sleep,...) timed out.
> Please refer to ACPI specification "5.5.2 Control Method Execution":
> Interpretation of a Control Method is not preemptive, but it can block. When
> a control method does block, OSPM can initiate or continue the execution of
> a different control method. A control method can only assume that access to
> global objects is exclusive for any period the control method does not block.
> 
> So it is pretty much likely that ACPI IO transfers are locked inside the
> operation region callback implementations.
> Using locking facility to protect the callback invocation will risk dead locks.

No.  If you use a single global lock around all invocations of operation region
handlers, it won't deadlock, but it will *serialize* things.  This means that
there won't be two handlers executing in parallel.  That may or may not be bad
depending on what those handlers actually do.

Your concern seems to be that if one address space handler is buggy and it
blocks indefinitely, executing it under such a lock would affect the other
address space handlers and in my opinion this is a valid concern.

So the idea seems to be to add wrappers around acpi_install_address_space_handler()
and acpi_remove_address_space_handler (but I don't see where the latter is called
after the change?), such that they will know when it is safe to unregister the
handler.  That is simple enough.

However, I'm not sure it is needed in the context of IPMI.  Your address space
handler's context is NULL, so even it if is executed after
acpi_remove_address_space_handler() has been called for it (or in parallel),
it doesn't depend on anything passed by the caller, so I don't see why the
issue can't be addressed by a proper synchronization between
acpi_ipmi_exit() and acpi_ipmi_space_handler().

Clearly, acpi_ipmi_exit() should wait for all already running instances of
acpi_ipmi_space_handler() to complete and all acpi_ipmi_space_handler()
instances started after acpi_ipmi_exit() has been called must return
immediately.

I would imagine an algorithm like this:

acpi_ipmi_exit()
 1. Take "address space handler lock".
 2. Set "unregistering address space handler" flag.
 3. Check if "count of currently running handlers" is 0.  If so,
    call acpi_remove_address_space_handler(), drop the lock (possibly clear the
    flag) and return.
 4. Otherwise drop the lock and go to sleep in "address space handler wait queue".
 5. When woken up, take "address space handler lock" and go to 3.

acpi_ipmi_space_handler()
 1. Take "address space handler lock".
 2. Check "unregistering address space handler" flag.  If set, drop the lock
    and return.
 3. Increment "count of currently running handlers".
 4. Drop the lock.
 5. Do your work.
 6. Take "address space handler lock".
 7. Decrement "count of currently running handlers" and if 0, signal the
    tasks waiting on it to wake up.
 8. Drop the lock.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
