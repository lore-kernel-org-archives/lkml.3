Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889AbaCMCjT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 22:39:19 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:55166 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbaCMCjR (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Wed, 12 Mar 2014 22:39:17 -0400
Subject: Re: [RESEND] Fast TSC calibration fails with v3.14-rc1 and later
From: joeyli <jlee@suse.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Julian Wollrath <jwollrath@web.de>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, John Stultz <john.stultz@linaro.org>,
        "Ted Ts'o" <tytso@mit.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.02.1403130049500.18573@ionos.tec.linutronix.de>
References: <20140310110410.5b2218f6@ilfaris>
	 <alpine.DEB.2.02.1403121722030.18573@ionos.tec.linutronix.de>
	 <alpine.DEB.2.02.1403121729060.18573@ionos.tec.linutronix.de>
	 <1554867.utJVyPuT6A@vostro.rjw.lan>
	 <alpine.DEB.2.02.1403130049500.18573@ionos.tec.linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 Mar 2014 10:38:27 +0800
Message-ID: <1394678307.26565.218.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 四，2014-03-13 於 01:54 +0100，Thomas Gleixner 提到：
> On Thu, 13 Mar 2014, Rafael J. Wysocki wrote:
> > Thus follow the original idea to execute acpi_early_init() before
> > efi_enter_virtual_mode() to help the EFI people for now and we can
> > revisit the other problem that commit 73f7d1ca3263 attempted to
> > address in the future (if really necessary).
> 
> It's not necessary at all. In fact we really want to get rid of the
> arch specific cmos stuff which is an historical leftover.
> 
> I talked to John Stultz earlier today and he agrees that there are
> only a few trivial things to add to the RTC subsystem to make this
> work.
> 

I sent rtc-acpitad driver for RTC subsystem on last month, I will send
second version.

For using TAD to set wall clock is because in ACPI 5.0 spec, there have
a "CMOS RTC Not Present" flag in FADT to indicate OSPM should use TAD
when this flag set:

CMOS RTC Not Present

If set, indicates that the CMOS RTC is either not implemented, or
does not exist at the legacy addresses. OSPM uses the Control
Method Time and Alarm Namespace device instead.


So, the original thinking of patch is using TAD to replace CMOS
interface in kernel for access RTC. The timekeeping_init() is the
earliest function to access CMOS RTC, that's why move TAD before it.

I hope can discuss about "CMOS RTC Not Present" flag. If hardware vendor
set this flag in FADT, should we avoid to access CMOS RTC interface in
any kernel code?

> >From the timekeeping POV there is absolutely no need to set the wall
> clock time early. The kernel boot phase does not care about wall time
> at all. We should have it done before we hit userspace, but not even
> that is a hard requirement.

I agree! If kernel boot phase does not care about wall time, then we
don't need parse DSDT for access TAD too early.

> 
> That TAD/EFI time mess is not going to happen before that is solved.
> 
> Thanks,
> 
> 	tglx
> 

ACPI TAD return local time and timezone information so kernel can adjust
wall time then don't need userspace involve. 


Thanks a lot!
Joey Lee

