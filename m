Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469Ab3HOKOi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 06:14:38 -0400
Received: from mail.skyhub.de ([78.46.96.112]:58513 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753319Ab3HOKOf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 06:14:35 -0400
Date: Thu, 15 Aug 2013 12:14:32 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "rjw@sisk.pl" <rjw@sisk.pl>, "lance.ortiz@hp.com" <lance.ortiz@hp.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] mce: acpi/apei: trace: Enable ghes memory error
 trace event
Message-ID: <20130815101432.GE27616@pd.tnic>
References: <20130812125343.GE18018@pd.tnic>
 <520A16BD.30201@linux.vnet.ibm.com>
 <20130813124258.GC4077@pd.tnic>
 <520A6D98.9060204@linux.vnet.ibm.com>
 <20130813175809.GE4077@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F31CB8F53@ORSMSX106.amr.corp.intel.com>
 <20130813181004.GF4077@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F31CB9150@ORSMSX106.amr.corp.intel.com>
 <20130814054322.GA9158@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F31CBAAFA@ORSMSX106.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F31CBAAFA@ORSMSX106.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 06:38:09PM +0000, Luck, Tony wrote:
> We've wandered around different strategies here. We definitely
> want the panic log. Some people want all other "kernel exit" logs
> (shutdown, reboot, kexec). When there is enough space in the pstore
> backend we might also want the "oops" that preceeded the panic. (Of
> course when the oops happens we don't know the future, so have to
> save it just in case ... then if more "oops" happen we have to decide
> whether to keep the old oops log, or save the newer one).

Ok, dmesg over serial and *only* oops+panic in pstore. Right.

> Yes - longer logs are better. Sad that the pstore backend devices are
> measured in kilobytes :-)

Right, so good ole serial again to the rescue! There's no room for full
dmesg in nvram because it needs space for the UEFI GUI and some other
crap :-)

> No - write speed for the persistent storage backing pstore (flash)
> means we don't log as we go. We wait for a panic and then our
> registered function gets called so we can snapshot what is in the
> console log at that point. We also don't want to wear out the flash
> which may be soldered to the motherboard.

I suspected as much. So we can forget about using *only* pstore for hw
errors logging. It would be cool to do so but the technology simply
doesn't give it.

> Agreed - we shouldn't clutter logs with details of corrected errors.
> At most we should have a rate-limited log showing the count of
> corrected errors so that someone who just watches dmesg knows they
> should go dig deeper if they see some big number of corrected errors.

/me nods.

> Yes. There are people looking at various "flight recorder" modes for
> tracing that keep logs of normal events in a circular buffer in RAM
> ... if these exist they should be saved at crash time (and they are in
> the kexec/kdump path, but I don’t know if anyone does anything in
> the non-kdump case).

Right, the cheapest solution is serial. Simply log everything to serial
because we can. But this is the key thing I wanted to emphasize:

For severe hardware errors we don't want to use any tracepoint -
actually it is even a bad thing to do so because they would get lost in
some side channels which, during a critical situation, might not get
written to anything/survive the crash, etc.

So what I'm saying is, we basically want severe hardware errors to land
to good old dmesg and to all consoles. No fancy TP stuff for them.

> Tracepoints for errors that are going to lead to system crash would
> only be useful together with a flight recorder to make sure they get
> saved. I think tracepoints for corrected errors are better than dmesg
> logs.

Yes, exactly.

> In a perfect world yes - I don't know that we can achieve perfection
> - but we can iterate through good, better, even better. The really
> hard part of this is figuring out what is *relevant* to save before a
> particular crash happens.

Well, if I have serial connected to the box, it will contain basically
everything the machine said, no?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
