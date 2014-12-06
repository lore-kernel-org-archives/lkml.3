Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036AbaLFIlN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 03:41:13 -0500
Received: from 1wt.eu ([62.212.114.60]:37963 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751154AbaLFIlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 03:41:11 -0500
Date: Sat, 6 Dec 2014 09:41:08 +0100
From: Willy Tarreau <w@1wt.eu>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Mariusz Gorski <marius.gorski@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: staging: panel: suggestions needed
Message-ID: <20141206084108.GA3404@1wt.eu>
References: <20141202080214.GA4762@sudip-PC>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141202080214.GA4762@sudip-PC>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sudip,

[ CCing Mariusz who's currently cleaning up the driver ]

On Tue, Dec 02, 2014 at 01:32:14PM +0530, Sudip Mukherjee wrote:
> Hi,
> I have been looking at your panel driver, and am attaching a 20x4 alphanueric
> lcd to it. Will start testing it in a few days as and when I get time. Looks
> like, it is receiving mostly checkpatch and sparse cleanups.

yes mostly.

> Just wanted your opinion on few things I was thinking:
> 	1) Number of lines you have fixed to 2 and 40 char per line. since I am
> 	going to connect 20x4 , i need to remember that after displaying 20
> 	character in 1st line, next char will come to 3rd line. instead why
> 	don't we make the option of number of line to 4 ?

Feel free to do so. I never had the luck to own a 4-line LCD so this
was never even planned. And yes, I remember something about 4-line LCDs
using tricks such as 2x40 addressing being split into 4x20.

> 	2) The lcd commands you are writing to the lcd in an escape sequence
> 	while writing to the lcd. Instead of that why don't we use ioctl for
> 	lcd commands, and writing to the device will involve only sending data
> 	to lcd ?

Because you cannot send that from a script. It's just as if you had to use
an ioctl to clear your terminal, inverse its video or to move its cursor,
it would not be very convenient.

> 	3) You have given fixed minor number in your code. Any problem if we
> 	make it dynamic ?

No objection, but I think we should keep a config option to bind to the
old minor. The rationale behind this is that this driver is mostly used
in embedded systems with a fixed /dev.

> 	4) For now I am only attaching a LCD, but I also want to attach a
> 	keypad to it. Can you please let me know about the schematic of the
> 	keypad connection? I can find out from the code, but I have not yet
> 	seen the keypad code.

It used to be documented as an ASCII-art diagram but I can't find that
anymore :-/ IIRC you had to wire buttons between some of the outputs and
some of the inputs. From what I remember, it was possible to detect that
an input is :
  - tied to ground
  - tied to a data line
  - tied to a control line

I found this comment in the old source file :
  "document 24 keys keyboard (3 rows of 8 cols, 32 diodes + 2 inputs)"

So maybe we only use data lines and not control lines.

And the keypad code periodically scans all outputs and notes inputs states.
The Nexcom profile works with the keypad, though I don't have the wiring
in mind. It uses 4 keys. It should be easy to find that from the code
though.

Hmmm I found an old description of 2001 (kernel 2.2.18) from the one of the
first circuit I made (with a serial lcd). It involved the smartcard detector
(now removed) and 6 keys :

strobe -> lcd.strobe
d0 -> lcd.serial.din (serial) + lcd.parallel.d0 + keypad.k0
d1 -> d7 => lcd.parallel.d1-d7 + keypad.k1-k7
ack <- smartcard.dout
busy <-
pe <-  (keypad common1 if more than 8 keys)
select <- keypad common0
autofeed -> lcd.serial.backlight / lcd.parallel.rs
error <- smartcard.detector
init -> 
select_in ->

And here's the module load command I used to run :
insmod /tmp/panel-0.8.0.o parport=0 lcd_enabled=2 keypad_enabled=1 lcd_width=16 lcd_hwidth=16 lcd_height=2

Hoping this helps,
Willy

