Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877AbaHETWs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 15:22:48 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:40746 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438AbaHETWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 15:22:46 -0400
Message-ID: <53E12F04.3000509@codeaurora.org>
Date: Tue, 05 Aug 2014 12:22:44 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: frowand.list@gmail.com
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
References: <53E02C7C.4090206@gmail.com> <53E03475.6070007@codeaurora.org> <53E03CEC.3060108@gmail.com>
In-Reply-To: <53E03CEC.3060108@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/14 19:09, Frank Rowand wrote:
> On 8/4/2014 6:33 PM, Stephen Boyd wrote:
>> On 08/04/14 17:59, Frank Rowand wrote:
>>> Stephen,
>>>
>>> I made some changes to drivers/tty/serial/msm_serial.c to allow kgdb
>>> to work with the dragon board (which has a qcom,msm-uartdm-v1.4 serial
>>> port).
>>>
>>> I will reply to this email with the patches.
>>>
>>> With these fixes, kgdb properly communicates with the dragon board, but
>>> following the continue command, the serial driver does not get any stale
>>> (UART_IMR_RXSTALE) interrupts until 48 characters have been read, which
>>> triggers a high water interrupt.  After the high water interrupt has been
>>> processed, the driver resumes properly getting stale interrupts.
>>>
>>> I am hoping you can help me figure out how to get the stale interrupt to
>>> occur for the first character after gdb continues, instead of having to
>>> first get a high water interrupt.
>>>
>>> Patch 2 adds a framework to fix up the state of the driver and/or hardware
>>> after gdb continues.  Patch 3 is a series of experiments trying to fix
>>> things up for msm_serial.  I don't have complete documentation and
>>> understanding of the hardware, so some of the experiments might be less
>>> than intelligent.
>>>
>>> Can you give me some suggestions of What should I be doing in the fix up
>>> function?
>> Hmm... I've never gotten the serial console to come back after
>> continuing because I only have one serial port and I use it for the
>> console so switching it into kgdb makes me lose the console. How do you
>> work around this? Use adb shell?
> I use kdmx2 to share the host serial port between gdb for kgdb and minicom
> for the console input and output.  I had to update kdmx2 to work in my
> environment.  You can download it from:
>
>    http://elinux.org/images/a/a7/Kdmx-2.00_v140730a.tar.gz
>
> Whenever that link is updated, the new link can be found at:
>
>    http://elinux.org/Kgdb

Cool. Thanks for the pointer.

>
>> I think the big problem is
>>
>>     msm_write(port, UARTDM_DMEN_RX_SC_ENABLE, UARTDM_DMEN)
>>
>> in msm_poll_init() which forces the uart into single character mode.
> Yep, most of my fixes deal with the fact that in single character mode
> echo fifo word only contains a single character of data.  All of that
> works now.  So my only problem is not getting a stale interrupt until
> after I've gotten a high water interrupt.
>
>> That causes all sorts of problems but is required to make the get_char
>> stuff work cleanly. I really wanted the msm_poll_get_char_dm_1p3() to
>> work for the 1.4 version of the hardware but I guess they made the
>> hardware different again for some unknown reason so it doesn't work. I
>> never got around to figuring it out or talking to the hardware people.
>> It took a while to develop the 1p3 version of the get_char code because
>> of the "fifo" centric design.
>>
>> Do you know if that 1p3 version of the code works for you on 1.3
>> hardware? Just curious if that actually has the same bugs or not. I
>> probably won't have much time to look at this anytime soon, but I'll try
>> and send an email off to the hardware designers to figure out a way to
>> avoid switching the mode.
>>
> I don't have any 1.3 hardware on my desk.  I'll have to see if I can find
> some when I get a chance.  I did try telling the driver that I was using
> 1.3 hardware even though it is 1.4; I had to make some changes to
> msm_poll_get_char_dm_1p3() to make it kind of sort of work, but not well.
> Instead of spending more time on that I just went back to making the single
> character mode work.
>
>

I tried it and it doesn't work either. Typing lots of characters finally
unjams it like you see on 1.4 hardware.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

