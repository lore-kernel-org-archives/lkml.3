Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846Ab3IIVMF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 17:12:05 -0400
Received: from nm11-vm9.access.bullet.mail.gq1.yahoo.com ([216.39.63.249]:29659
	"EHLO nm11-vm9.access.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755460Ab3IIVMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 17:12:02 -0400
X-Yahoo-Newman-Id: 99292.31523.bm@smtp119.sbc.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: LxeTI2MVM1mvnpQAt5yE6PsWOhenDLH3sF8jDIRpliAwqXG
 mmL.X4twef_tqclKHOU6BwcN7KJ3K.RwKwmb_uzEVIx9V4zz5tK3GkNw.p9x
 zr.huQo7Tm49C6ppX7W9zpU98AgNuUNsbpATAvmMMawboV3o5FskQcw9TA7H
 MCcdRIlJAZqCJeFoMp2PF6SnVHi38ZDQqkW5790rrKzZwg5B0NuTjjNmlyoU
 .a7HlpPgtbC7FTmqVttXuPVbqd8pFI.LIPVIuAMv9cYz0rqPOwKBLJglUmV2
 J8uPZe2dRyzhlJ8xE1zV27e_tE07WXEMboihm7rUI5hfTPl2ELKsuOKp.DiZ
 NjEcsBJvNu0Rrab24OtC6RAiKuw9MrInzy2z15Ye3palKcuhjFUMf_UDsj6T
 k6eaaHHX916nDow_d9wXYq9swCMnBrVHFYcI5tEVzAF1w4SvpL_IXdmjP_l1
 pvIdrDnV7CVnRQuMeY4wxSXAAvCXN7TBSK1WOQ7cUWULKUvrtF45209i3RNr
 nRYD4I7ubfBjOP6iPvNtJi2vlLHNTOoCUtRb6NIs.V6LxH8miWeH43mpicOb
 twIv5.cl1IE7Gq_2TFTAyvD1gn2jB.shlLe2A1y3MnIZ_EEki93YAg_ZQ7hL
 2mt.qBqA-
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
X-Rocket-Received: from [192.168.1.4] (danielfsantos@99.70.244.137 with )
        by smtp119.sbc.mail.gq1.yahoo.com with SMTP; 09 Sep 2013 21:12:00 +0000 UTC
Message-ID: <522E39B5.4090906@att.net>
Date: Mon, 09 Sep 2013 16:12:21 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: Daniel Santos <daniel.santos@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130730 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: linux-gpio <linux-gpio@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>,
        linux-spi <linux-spi@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: "Virtual" Interrupts -- Need help please
References: <522BC27A.5080303@att.net> <20130909110640.GV29403@sirena.org.uk>
In-Reply-To: <20130909110640.GV29403@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2013 06:06 AM, Mark Brown wrote:
> On Sat, Sep 07, 2013 at 07:19:06PM -0500, Daniel Santos wrote:
>
>> So do i create an IRQ domain and then call generic_handle_irq() from
>> my URB complete() function? If so, which type of IRQ Domain is
>> appropriate for this? Unlike typical platform devices, these are
>> dynamically added and removed throughout the life of the kernel,
>> adding to the challenge.  So, if I understand correctly, my base IRQ
>> number needs to be dynamically generated.  How should I manage this?
> Unless you have a particular reason for using something else you should
> be using a linear domain - that's the default, it's very simple to work
> with.

Cool, thank you.

>> I have some secondary (and less important) questions about how to
>> integrate this with device drivers that want a DT / open firmware
>> config (which I know almost nothing about at this time), but that
>> can wait.
> Could you be more specific about what you mean by "integrate" here?

Hmm.  Well one shortcoming of my driver has been lacking a way to tell 
the spi protocol driver which IRQ to use for interrupts.  Yet another 
oversight on my behalf, as struct spi_device contains an int irq field 
just for this purpose. *sigh*  Well, at least that's one problem put to 
rest, but I should probably elaborate further on this.  Sorry in advance 
for the long response.

One of my original requirements for this driver is that it is reusable 
for different devices that use the MCP2210, not just my own hardware.  
There are a number of ways to accomplish this, but I'm still new to 
Linux device drivers, so I don't know how an "abstract driver" would 
work other than just making it a library that doesn't register its self 
as a driver.  The theory is that you should be able to specify your own 
USB vid/pid and have your driver probe on that, then feed the generic 
MCP2210 driver/library your board wiring information and any parameters 
your other drivers need (spi or gpio-driven peripherals on the board) 
and let the MCP2210 driver/library do potentially everything else for 
you, unless your device has some needs that aren't covered.

Another requirement is for my specific device to vary its hardware 
somewhat, but (possibly) use the same vid/pid for these.  Maybe this is 
some cardinal sin and a unique pid and model number for each variant is 
called for (like I said, I'm still new to this stuff). None the less, 
I've dealt with these two problems by creating an encoding scheme (which 
I've dubbed "Creek", since I figured I was up one if it didn't work) 
that compresses the data so that it will fit easily in the 256 bytes of 
user-EEPROM on the chip.

At the time I wrote this, I knew very little about the device tree and 
nothing about this Open Firmware format, so now I want to make sure I'm 
not re-inventing some wheel or circumventing a standard unnecessarily.  
Then, as I was working on figuring out how to propagate IRQs, I noticed 
that the irq_domain_add_linear() accepted a pointer to struct 
device_node and didn't not accept NULL. This made me think that I was 
missing something.

So basically, it's a can of worms. :)  I wanted to get the interrupts 
working first so I could confront this once I had a fully working 
driver, but I suppose there's no time like the present.

So more specifically, on the EEPROM, I'm now storing the following 
(basically, everything in my struct board_config: 
https://github.com/daniel-santos/mcp2210-linux/blob/master/mcp2210.h#L483):
* an optional name for the device or pin (for GPIOs, this is the name 
they get exported with)
* an optional modalias for spi devices (defaults to "spidev") -- which 
of course I know mixes OS with hardware, but should be easily 
translatable for drivers for lessor operating systems.
* for spi devices, mode, min & max bitrate and timing requirements 
(various delay values)
* for gpios and the MCP2210's dedicated "interrupt counter" pin, an 
optional interrupt offset for producing IRQs
* for gpios, the interrupt edge type (the dedicated interrupt counter 
manages this elsewhere)
* how often it wants to have it's gpios and the "interrupt counter" 
polled (if applicable)
* and soon to be added: an interrupt offset for SPI devices that want to 
consume IRQs (but only those generated by this MCP2210 device)

So in summary, I need to make sure that what I'm doing 1.) makes sense, 
2.) adheres to standards (unless the standard fails to fulfill the 
real-world requirements) and 3.) doesn't unnecessarily introduce a new 
way to do something that's already done better elsewhere.

Thanks,
Daniel
