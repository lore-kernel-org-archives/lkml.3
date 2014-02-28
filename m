Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751787AbaB1UOp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 15:14:45 -0500
Received: from mail-ve0-f175.google.com ([209.85.128.175]:51215 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbaB1UOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 15:14:44 -0500
MIME-Version: 1.0
In-Reply-To: <20140228161506.62889d46@samsung.com>
References: <cover.1387588711.git.luto@amacapital.net> <15eccfa508fd0f55230c4274e3e968f91a123b73.1387588711.git.luto@amacapital.net>
 <20140219151626.GA13973@katana> <CALCETrVBPzGqaXbZVgUZMw7D5U5YnUMJOEsw1r=TceLYjJ39JA@mail.gmail.com>
 <20140220035128.14da0f79.m.chehab@samsung.com> <3908561D78D1C84285E8C5FCA982C28F31DCC6F8@ORSMSX106.amr.corp.intel.com>
 <CALCETrVwSj3KGcPqQD2Kd9W5FCHyPWLukCVr0BZLdQc_Fgz4qA@mail.gmail.com> <20140228161506.62889d46@samsung.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 28 Feb 2014 12:14:22 -0800
Message-ID: <CALCETrVjnUwbVDKGx1=VAhrQSw=fXg8Fh90s3yc7vDeBqj=cgg@mail.gmail.com>
Subject: Re: [PATCH v6 4/4] i2c, i2c_imc: Add DIMM bus code
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Jean Delvare <khali@linux-fr.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>, Rui Wang <ruiv.wang@gmail.com>,
        "Luck, Tony" <tony.luck@intel.com>, Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 28, 2014 11:15 AM, "Mauro Carvalho Chehab" <m.chehab@samsung.com> wrote:
>
> Em Wed, 19 Feb 2014 17:39:07 -0800
> Andy Lutomirski <luto@amacapital.net> escreveu:
>
> > On Wed, Feb 19, 2014 at 11:03 AM, Luck, Tony <tony.luck@intel.com> wrote:
> > >> (I'm c/c Tony here, as he also shared the same concern that I had on a
> > >> previous feedback about using I2C to talk with the DIMM).
> > >
> > > Correct - I've heard the same issues that reads on I2C can be misinterpreted
> > > as writes ... and oops, you have a brick.
> >
> > Is this true on DDR3 DIMMs, i.e. anything that's compatible with
> > LGA2011?  If you plug a DIMM into an LGA2011 board's memory slot,
> > then, one way or another, it's very likely that there will be TSOD
> > traffic, if for no other purpose than to determine that there is no
> > TSOD present.  TSOD traffic consists of reads and writes, both with
> > and without register numbers.  (Sorry, I can never remember the smbus
> > terminology here -- the relevant transactions are two-byte reads and
> > two-byte writes, both with a command specified and without one.  One
> > of the bits in the iMC SMBUS registers tells the controller which kind
> > of read to use to probe the thermometer.)
>
> An update on that: I double-checked with a DIMM manufacturer.
> I was told that some DIMM models have write protect circuits but
> others don't.
>
> So, yeah, accessing it could eventually brick the DIMM, depending
> on the DIMM model, if such driver won't block I2C write ops or
> if the BIOS is also trying to access the bus at the same time.

I'm not sure I buy the argument about blocking writes -- as far as I
know, i2c-i801 on desktop platforms has exactly the same issue.  Or
maybe I'm misunderstanding you.

I'd be okay with adding code to block writes to SPD addresses, but I'm
not sure I see the point.  If root wants to brick a DIMM, I'm sure
root can find a way.

On the other hand, racing with BIOS is a real problem.  I'd like to
know how Intel plans to handle this.  I suspect that POLL_EN is the
right bit to use, but the docs are vague, and there could be strange
BIOSes out there.

(Grr.  Everything would be saner if SMM didn't exist.)

--Andy
