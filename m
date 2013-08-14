Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933039Ab3HNSiN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 14:38:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:36076 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932768Ab3HNSiL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 14:38:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,878,1367996400"; 
   d="scan'208";a="362700696"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
CC: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "rjw@sisk.pl" <rjw@sisk.pl>, "lance.ortiz@hp.com" <lance.ortiz@hp.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 3/3] mce: acpi/apei: trace: Enable ghes memory error
 trace event
Thread-Topic: [PATCH 3/3] mce: acpi/apei: trace: Enable ghes memory error
 trace event
Thread-Index: AQHOlGVcQB6qi1wV3Ei8qYoYEneewpmMKjwAgAMKHwCAArfagIAAEviAgAADVICAAXiUgIAAFsAAgABQygCAAAdFgP//i8NwgAB3kgD//6n/UIABF7UAgABZNMA=
Date: Wed, 14 Aug 2013 18:38:09 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F31CBAAFA@ORSMSX106.amr.corp.intel.com>
References: <20130812083355.47c1bae8@samsung.com>
 <5208D80D.5030206@linux.vnet.ibm.com> <20130812125343.GE18018@pd.tnic>
 <520A16BD.30201@linux.vnet.ibm.com> <20130813124258.GC4077@pd.tnic>
 <520A6D98.9060204@linux.vnet.ibm.com> <20130813175809.GE4077@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F31CB8F53@ORSMSX106.amr.corp.intel.com>
 <20130813181004.GF4077@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F31CB9150@ORSMSX106.amr.corp.intel.com>
 <20130814054322.GA9158@pd.tnic>
In-Reply-To: <20130814054322.GA9158@pd.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r7EIcIdU009812

> Didn't we say at some point, "log only the panic messsage which kills
> the machine"?

We've wandered around different strategies here. We definitely want
the panic log.  Some people want all other "kernel exit" logs (shutdown,
reboot, kexec).  When there is enough space in the pstore backend we
might also want the "oops" that preceeded the panic.  (Of course when
the oops happens we don't know the future, so have to save it just in
case ... then if more "oops" happen we have to decide whether to keep
the old oops log, or save the newer one).

> However, we probably could use more the messages before that
> catastrophic event because they could give us hints about what lead to
> the panic but in that case maybe a limited pstore is the wrong logging
> medium.
Yes - longer logs are better.  Sad that the pstore backend devices are
measured in kilobytes :-)

> Actually, I can imagine the full serial/network logs of "special"
> tracepoints + dmesg to be the optimal thing.
If you guess the right "special" tracepoints to log - then yes.

> Actually, does the pstore act like a circular buffer? Because if it
> contains the last N relevant messages (for an arbitrary definition of
> relevant) before the system dies, then that could more helpful than only
> the error messages.
No - write speed for the persistent storage backing pstore (flash) means we
don't log as we go. We wait for a panic and then our registered function
gets called so we can snapshot what is in the console log at that point.
We also don't want to wear out the flash which may be soldered to the
motherboard.


> Ok, let's sort:

> * First we have the not-so-critical hw error messages. We want to carry
> those out-of-band, i.e. not in dmesg so that people don't have to parse
> and collect dmesg but have a specialized solution which gives them
> structured logs and tools can analyze, collect and ... those errors.

Agreed - we shouldn't clutter logs with details of corrected errors.
At most we should have a rate-limited log showing the count of corrected errors
so that someone who just watches dmesg knows they should go dig deeper
if they see some big number of corrected errors.

> * When a critical error happens, the above usage is not necessarily
> advantageous anymore in the sense that, in order to debug what caused
> the machine to crash, we don't simply necessarily want only the crash
> message but also the whole system activity that lead to it.

Yes.  There are people looking at various "flight recorder" modes for tracing
that keep logs of normal events in a circular buffer in RAM ... if these exist
they should be saved at crash time (and they are in the kexec/kdump path,
but I donâ€™t know if anyone does anything in the non-kdump case).

> In which case, we probably actually want to turn off/ignore the error
> logging tracepoints and write *only* to dmesg which goes out over serial
> and to pstore. Right?
Tracepoints for errors that are going to lead to system crash would only be
useful together with a flight recorder to make sure they get saved. I think
tracepoints for corrected errors are better than dmesg logs.

> Because in such cases I want to have *all* *relevant* messages that lead
> to the explosion + the explosion message itself.

In a perfect world yes - I don't know that we can achieve perfection - but we
can iterate through good, better, even better.  The really hard part of this is
figuring out what is *relevant* to save before a particular crash happens.

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
