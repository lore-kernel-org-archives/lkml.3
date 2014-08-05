Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbaHECJy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 22:09:54 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:64958 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723AbaHECJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 22:09:51 -0400
Message-ID: <53E03CEC.3060108@gmail.com>
Date: Mon, 04 Aug 2014 19:09:48 -0700
From: Frank Rowand <frowand.list@gmail.com>
Reply-To: frowand.list@gmail.com
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        linux-serial@vger.kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net
Subject: Re: [request for help] tty: serial: kgdb: fix msm_serial for kgdb
References: <53E02C7C.4090206@gmail.com> <53E03475.6070007@codeaurora.org>
In-Reply-To: <53E03475.6070007@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/4/2014 6:33 PM, Stephen Boyd wrote:
> On 08/04/14 17:59, Frank Rowand wrote:
>> Stephen,
>>
>> I made some changes to drivers/tty/serial/msm_serial.c to allow kgdb
>> to work with the dragon board (which has a qcom,msm-uartdm-v1.4 serial
>> port).
>>
>> I will reply to this email with the patches.
>>
>> With these fixes, kgdb properly communicates with the dragon board, but
>> following the continue command, the serial driver does not get any stale
>> (UART_IMR_RXSTALE) interrupts until 48 characters have been read, which
>> triggers a high water interrupt.  After the high water interrupt has been
>> processed, the driver resumes properly getting stale interrupts.
>>
>> I am hoping you can help me figure out how to get the stale interrupt to
>> occur for the first character after gdb continues, instead of having to
>> first get a high water interrupt.
>>
>> Patch 2 adds a framework to fix up the state of the driver and/or hardware
>> after gdb continues.  Patch 3 is a series of experiments trying to fix
>> things up for msm_serial.  I don't have complete documentation and
>> understanding of the hardware, so some of the experiments might be less
>> than intelligent.
>>
>> Can you give me some suggestions of What should I be doing in the fix up
>> function?
> 
> Hmm... I've never gotten the serial console to come back after
> continuing because I only have one serial port and I use it for the
> console so switching it into kgdb makes me lose the console. How do you
> work around this? Use adb shell?

I use kdmx2 to share the host serial port between gdb for kgdb and minicom
for the console input and output.  I had to update kdmx2 to work in my
environment.  You can download it from:

   http://elinux.org/images/a/a7/Kdmx-2.00_v140730a.tar.gz

Whenever that link is updated, the new link can be found at:

   http://elinux.org/Kgdb

> 
> I think the big problem is
> 
>     msm_write(port, UARTDM_DMEN_RX_SC_ENABLE, UARTDM_DMEN)
> 
> in msm_poll_init() which forces the uart into single character mode.

Yep, most of my fixes deal with the fact that in single character mode
echo fifo word only contains a single character of data.  All of that
works now.  So my only problem is not getting a stale interrupt until
after I've gotten a high water interrupt.

> That causes all sorts of problems but is required to make the get_char
> stuff work cleanly. I really wanted the msm_poll_get_char_dm_1p3() to
> work for the 1.4 version of the hardware but I guess they made the
> hardware different again for some unknown reason so it doesn't work. I
> never got around to figuring it out or talking to the hardware people.
> It took a while to develop the 1p3 version of the get_char code because
> of the "fifo" centric design.
> 
> Do you know if that 1p3 version of the code works for you on 1.3
> hardware? Just curious if that actually has the same bugs or not. I
> probably won't have much time to look at this anytime soon, but I'll try
> and send an email off to the hardware designers to figure out a way to
> avoid switching the mode.
> 

I don't have any 1.3 hardware on my desk.  I'll have to see if I can find
some when I get a chance.  I did try telling the driver that I was using
1.3 hardware even though it is 1.4; I had to make some changes to
msm_poll_get_char_dm_1p3() to make it kind of sort of work, but not well.
Instead of spending more time on that I just went back to making the single
character mode work.

-Frank

