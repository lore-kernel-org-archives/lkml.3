Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752301AbaFPNMV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 09:12:21 -0400
Received: from mail1.bemta14.messagelabs.com ([193.109.254.120]:33688 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750953AbaFPNMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 09:12:19 -0400
X-Env-Sender: Adam.Thomson.Opensource@diasemi.com
X-Msg-Ref: server-5.tower-193.messagelabs.com!1402924332!15466330!1
X-Originating-IP: [94.185.165.51]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
From: "Opensource [Adam Thomson]" <Adam.Thomson.Opensource@diasemi.com>
To: Jonathan Cameron <jic23@kernel.org>,
        "Opensource [Adam Thomson]" <Adam.Thomson.Opensource@diasemi.com>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Support Opensource" <Support.Opensource@diasemi.com>
Subject: RE: [PATCH 1/8] mfd: Add support for DA9150 combined charger &
 fuel-gauge device
Thread-Topic: [PATCH 1/8] mfd: Add support for DA9150 combined charger &
 fuel-gauge device
Thread-Index: AQHPhWXgDUdWLlzZUUOaNLuN4JENfJtyikMAgAEQ9UA=
Date: Mon, 16 Jun 2014 13:12:10 +0000
Message-ID: <2E89032DDAA8B9408CB92943514A0337AB4FD95E@SW-EX-MBX01.diasemi.com>
References: <cover.1402484954.git.Adam.Thomson.Opensource@diasemi.com>
 <bf472aa7fddd1e67a3d5b9024b5b621744146a27.1402484954.git.Adam.Thomson.Opensource@diasemi.com>
 <539DF8C6.8030009@kernel.org>
In-Reply-To: <539DF8C6.8030009@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.26.15]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s5GDCTWP030473

On Sun, Jun 15, 2014 at 20:49, Jonathan Cameron wrote: 

> Hi Adam,
> 
> Some general comments inline.
> 
> It's been a while since I've looked at any particularly similar parts,
> but it seems to me that a lot of indirection gets added here that
> if anything makes the codes slightly harder to follow...
> 
> Feel free to disagree with me though!

Will do :)

> To my mind all these wrappers add nothing significant so you might as well
> just call da9150->read_dev etc directly.
> 
> Also, what are the read_qif and write_qif for?  They don't seem to be used
> anywhere.

read_qif and write_qif are for the Fuel-Gauge functionality of the chip. The
associated driver will be submitted after acceptance of initial driver code,
and will make use of these functions.

The wrappers automatically choose the correct client to use (QIF uses a
different slave address to the main chip one). Means the child drivers only need
to pass through the da9150 struct and the rest is dealt with underneath.

> The only real reason I can see for these wrappers is because you want
> to hide the struct da9150 contents from the children of the mfd. As you
> aren't doing that, you might as well drop these in favour of direct
> calls to regmap_read and friends.

As I have a need to pass through the main da9150 struct point for the
aforementioned wrappers, it seemed cleaner and more consistent to have wrappers
for these as well, which did the job of regmap access. Means all HW access
uses the same kind of approach, and all sub-devices just need a point to the
main da9150 struct to be able to use the functions.

> I'll continue my tirade against obvious comments. Wrong format and
> adds nothing to what is here as init and exit functions are clearly
> doing what their name suggests (it's one of my pet hates ;)

I agree the comment doesn't add much in terms of description but for me it
breaks up the code to make it easier to follow. However if I get an overwhelming
hatred for this I can change it. Also, I know the rule regarding single/multiple
line comments but here again I feel it helps separate the code and makes it
easier to read.

> As a general good practice point, I'd rather that the driver supported
> more than one instance of the chip.. Hence you'd take a copy of da9150_devs
> to use here.  I guess it is relatively unlikely with one of these, but
> you never know ;)

Have followed the general methods for MFD here, and a number of drivers take the
same approach. Also, I think it would be undesirable to have multiple charger
chips of the same type in one platform. I agree generally it's best to support
multiple instances, but here I don't think we should.

> Why does this need it's own file?  Does the DA9150 support any other
> interfaces?

Yes, the DA9150 also has a SPI interface. At present the plan is to just add I2C
support for now, but in the future we may add SPI support, so have written the
code with this in mind.

> Why the indirection?  The da9150 only supports i2c as far as I can see.

As per my last comment. 

> I'd roll this into one line and not bother with the local variable...

Fair enough but I think this keeps the code cleaner, and to me it makes sense
for the actual logic to be in core file as that's interface agnostic.

> Drop comments on things that are self-evident.  Also these are one
> line comments so should be using the single line comment syntax.

As per my previous comment I think it just helps to break up the code and makes
it more readable. Will change it though if the general consensus is to remove
it.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
