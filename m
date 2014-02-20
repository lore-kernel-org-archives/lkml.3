Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965AbaBTXn7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 18:43:59 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:58124 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844AbaBTXn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:43:56 -0500
MIME-Version: 1.0
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F31DCD1E1@ORSMSX106.amr.corp.intel.com>
References: <cover.1387588711.git.luto@amacapital.net> <15eccfa508fd0f55230c4274e3e968f91a123b73.1387588711.git.luto@amacapital.net>
 <20140219151626.GA13973@katana> <CALCETrVBPzGqaXbZVgUZMw7D5U5YnUMJOEsw1r=TceLYjJ39JA@mail.gmail.com>
 <20140220035128.14da0f79.m.chehab@samsung.com> <3908561D78D1C84285E8C5FCA982C28F31DCC6F8@ORSMSX106.amr.corp.intel.com>
 <CALCETrVwSj3KGcPqQD2Kd9W5FCHyPWLukCVr0BZLdQc_Fgz4qA@mail.gmail.com> <3908561D78D1C84285E8C5FCA982C28F31DCD1E1@ORSMSX106.amr.corp.intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 20 Feb 2014 15:43:34 -0800
Message-ID: <CALCETrWcL6oN=qA0wRCQaCD07+Z_evTWR7cqRT-V4QM+iEGpRw@mail.gmail.com>
Subject: Re: [PATCH v6 4/4] i2c, i2c_imc: Add DIMM bus code
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Jean Delvare <khali@linux-fr.org>, Guenter Roeck <linux@roeck-us.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rui Wang <ruiv.wang@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 8:42 AM, Luck, Tony <tony.luck@intel.com> wrote:
>> NV-DIMM control registers are exposed via i2c, presumably because
>> trying to access them through the memory pins would be a giant mess.
>> So, one way or another, something needs to be able to initiate
>> transactions to access those registers.  BIOS will do some initial
>> setup, but the OS will need to poke at these registers, too.  (The
>> actual docs are covered by NDA.  I suspect that this will change if
>> the manufacturers ever want these things to be widely used, though,
>> since these things really want a full-featured kernel driver so that
>> things like pmfs will work cleanly.)
>>
>> As a secondary benefit, having access to the TSOD and SPD is nice,
>> albeit far from critical.
>>
>> AFAICT Intel actively working on NV-DIMM-related things, so maybe
>> Intel will contribute an engineer who help :)
>
> Yes - we have people looking at pmfs and NV-DIMMs.  I don't know
> the internal details ... to keep these accesses safe may require letting
> the platform BIOS code perform them (via some ACPI thingy) ... messy
> and slow - but probably workable if these registers are only required
> for some maintenance/configuration usage patterns.  Not so good if
> they are in the high frequency read/write path (but I2C in the critical
> path sounds like a recipe for failure).

As far as I know, they're not involved in reads and writes, but they
are useful periodically to keep everything happy.

I suppose that *shudder* calling an ACPI method to initiate an i2c
transaction aimed at a DIMM slot isn't *that* bad.  On the other hand,
if we're supposed to issue an ACPI call to ask "is it okay to start
using this device now", then won't we need to reflash firmware every
time we switch NV-DIMM vendors?  Ugh!

In any case, let's hold off on merging this until Intel and/or the
ACPI people figure out what's going on.  This driver is IMO not worth
it just to access SPD and TSOD.  (Actually, I think I could write a
separate TSOD driver that just asks the memory controller to report
cached temperature values.  That should be almost entirely non-scary.)

--Andy
