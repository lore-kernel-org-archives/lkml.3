Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858Ab3EFIkH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 04:40:07 -0400
Received: from plane.gmane.org ([80.91.229.3]:39754 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752761Ab3EFIkF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 04:40:05 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Oliver Schinagl <oliver+list@schinagl.nl>
Subject: Re: device tree not the answer in the ARM world [was: Re: running
 Debian on a Cubieboard]
Date: Mon, 06 May 2013 10:22:22 +0200
Message-ID: <km7p8v$7jq$1@ger.gmane.org>
References: <CAPweEDym3TSEKWB1PsRWZ77irkTPF-Qdm9nRGfRBrv72CQ8zJA@mail.gmail.com> <51872CF6.5070409@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 7of9.schinagl.nl
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
In-Reply-To: <51872CF6.5070409@gmail.com>
Cc: debian-arm@lists.debian.org, arm-netbook@lists.phcomp.co.uk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note, I'm not qualified nor important or anything really to be part of 
this discussion or mud slinging this may turn into, but I do fine some 
flaws in the reasoning here that If not pointed out, may get grossly 
overlooked.

On 06-05-13 06:09, Robert Hancock wrote:
> On 05/05/2013 06:27 AM, Luke Kenneth Casson Leighton wrote:
>> this message came up on debian-arm and i figured that it is worthwhile
>> endeavouring to get across to people why device tree cannot and will
>> not ever be the solution it was believed to be, in the ARM world.
>>
>> [just a quick note to david who asked this question on the debian-arm
>> mailing list: any chance you could use replies with plaintext in
>> future?  converting from HTML to text proved rather awkward and
>> burdensome, requiring considerable editing.  the generally-accepted
>> formatting rules for international technical mailing lists are
>> plaintext only and 7-bit characters]
>>
>> On Sun, May 5, 2013 at 11:14 AM, David Goodenough
>> <david.goodenough@btconnect.com> wrote:
>>> On Sunday 05 May 2013, Luke Kenneth Casson Leighton wrote:

<snip>

>> * is there a BIOS?  no.  so all the boot-up procedures including
>> ultra-low-level stuff like DDR3 RAM timings initialisation, which is
>> normally the job of the BIOS - must be taken care of BY YOU (usually
>> in u-boot) and it must be done SPECIFICALLY CUSTOMISED EACH AND EVERY
>> SINGLE TIME FOR EVERY SINGLE SPECIFIC HARDWARE COMBINATION.
Isn't on ARM DDR init done by SPL/U-Boot? I've come quite accustomed to 
this for the A10. Right now, we have a dedicated u-boot_spl for each 
memory configuration as the values are hardcoded. A long term plan for 
this platform is to possibly parse the DT or Read those settings from 
somewhere and dynamically configure them, but in the end, memory init is 
done by SPL, and to me, it makes perfect sense to do that there.

So yes, every single ARM SoC/platform will need its own dedicated 
SPL/U-boot. Kinda like a bios? But if you want to boot from LAN (I think 
that's what this discussion was about?) you need U-boot loaded by SPL 
anyway. Can you boot a generic linux install (say from CD) on arm? 
Usually no, the onboard boot loader only knows a very specific boot 
path, often flash, mmc etc etc. Those need to be able to bring up the 
memory too (SPL) so you'll need some specific glue for your platform 
anyhow. I'm not sure if DT was supposed to solve that problem? If that 
where the case, was DT to replace the BIOS too?

>>
>> * is there ACPI present?  no.  so anything related to power
>> management, fans (if there are any), temperature detection (if there
>> is any), all of that must be taken care of BY YOU.
Again, I only know about 1 specific SoC, but for the A10, you have/need 
an external Power Manamgent IC, basically, a poor man's ACPI if you 
must. If you don't have this luxury, yes, you'll need a special driver. 
But how is that different from not having DT? You still need to write 
'something' for this? A driver etc?
>>
>>   * what about the devices?  here's where it becomes absolute hell on
>> earth as far as attempting to "streamline" the linux kernel into a
>> "one size fits all" monolithic package.
Well that's where DT tries to help, doesn't it.
>>
>> the classic example i give here is the HTC Universal, which was a
>> device that, after 3 years of dedicated reverse-engineering, finally
>> had fully-working hardware with the exception of write to its on-board
>> NAND.  the reason for the complexity is in the hardware design, where
>> not even 110 GPIO pins of the PXA270 were enough to cover all of the
>> peripherals, so they had to use a custom ASIC with an additional 64
>> GPIO pins.  it turned out that *that* wasn't enough either, so in
>> desperation the designers used the 16 GPIO pins of the Ericsson 3G
>> Radio ROM, in order to do basic things like switch on the camera flash
>> LED.
So, nofi, you have some shitty engineerd device, that can't fit into 
this DT solution, and thus DT must be broken? Though with proper drivers 
and proper PINCTRL setup this may actually even work :p
>>
>> the point is: each device that's designed using an ARM processor is
>> COMPLETELY AND UTTERLY DIFFERENT from any other device in the world.
>>
>> when i say "completely and utterly different", i am not just talking
>> about the processor, i am not just talking about the GPIO, or even the
>> buses: i'm talking about the sensors, the power-up mechanisms, the
>> startup procedures - everything.  one device uses GPIO pin 32 for
>> powering up and resetting a USB hub peripheral, yet for another device
>> that exact same GPIO pin is used not even as a GPIO but as an
>> alternate multiplexed function e.g. as RS232 TX pin!
I think PINCTRL tries to solve this, in combination with? DT?
>>
>> additionally, there are complexities in the bring-up procedure for
>> devices, where a hardware revision has made a mistake (or made too
>> many cost savings), and by the skin of their teeth the kernel
>> developers work out a bring-up procedure. the example i give here is
>> the one of the HTC Blueangel, where the PXA processor's GPIO was used
>> (directly) to power the device.  unfortunately, there simply wasn't
>> enough current.  but that's ok!  why?  because what they did was:
>>
>> * bring up the 3.3v GPIO (power to the GSM chip)
>> * bring up the 2nd 3.3v GPIO
>> * pull the GPIO pin connected to the GSM "reset" chip
>> * wait 5 milliseconds
>> * **PULL EVERYTHING BACK DOWN AGAIN**
>> * wait 1 millisecond
>> * bring up the 1st 3.3v GPIO (again)
>> * wait 10 milliseconds
>> * bring up the 2nd 3.3v GPIO (again)
>> * wait 5 milliseconds
>> * pull up the "RESET" GPIO
>> * wait 10 milliseconds
>> * pull the "RESET" GPIO down
>> * ***AGAIN*** do the reset GPIO.
>>
>> this procedure was clearly designed to put enough power into the
>> capacitors of the on-board GSM chip so that it could start up (and
>> crash) then try again (crash again), and finally have enough power to
>> not drain itself beyond its capacity.
So again horribly shitty designed solution.
I only can see this as 'one kernel to rule them all' won't apply here 
and some extra hacks will be required, simply because there's hacks 
required on the hardware side.
>>
>> ... the pointed question is: how the bloody hell are you going to
>> represent *that* in "device tree"???  and why - even if it was
>> possible to do - should you burden other platforms with such an insane
>> boot-up procedure even if they *did* use the exact same chipset?
You are not supposed to, again, it's a horribly hack-ish device and thus 
can only be served by ugly hacks.
>>
>> ... but these devices, because they are in a huge market with
>> ever-changing prices and are simply overwhelmed with choice for
>> low-level I2C, I2S devices etc, each made in different countries, each
>> with their NDAs, simply don't use the same peripheral chips.  and even
>> if they did, they certainly don't use them in the same way!
>>
>> again, the example that i give here is of the Phillips UDA1381 which
>> was quite a common sound IC used in Compaq iPAQ PDAs (designed by
>> HTC).  so, of course, when HTC did the Himalaya, they used the same
>> sound IC.
>>
>> .... did they power it up in the exact same way across both devices?
>>
>> no.
>>
>> did they even use the same *interfaces* across both devices?
>>
>> no.
>>
>> why not?
>>
>> because the UDA1381 can be used *either* in I2S mode *or* in SPI mode,
>> and one [completely independent] team used one mode, and the other
>> team used the other.
Afaik, there's several IC's that work that way, and there's drivers for 
them in that way. I haven't seen this being applied in DT, but i'm sure 
this can reasonably easy be adapted into DT.
>>
>> so when it came to looking at the existing uda1381.c source code, and
>> trying to share that code across both platforms, could i do that?
>>
>> no.
Why not? And if not, because the driver is written badly? So it needs a 
rewrite because it's been written without taking into account that it 
can interface either in SPI mode or in I2C mode? Then that will have to 
be done.

<snip>

>> are you beginning to see the sheer scope of the problem, here?  can
>> you see now why russell is so completely overwhelmed? are you
>> beginning to get a picture as to why device tree can never solve the
>> problem?
>
> I think part of the answer has to come from the source of all of these
> problems: there seems to be this culture in the ARM world (and, well,
> the embedded world generally) where the HW designers don't care what
> kind of mess they cause the people who have to write and maintain device
> drivers and kernels that run on the devices. In the PC world designers
> can't really do many crazy things as the people doing drivers will tell
> them "What is this crap? There's no way we can make this work properly
> in Windows". In the embedded world the attitude is more like "Hey, it's
> Linux, it's open, we know you can put in a bunch of crazy hacks to make
> this mess we created work reasonably". So the designers have no reason
> to make things behave in a standardized and/or sane manner.
This will level itself out in the end I suppose. Once a proper 
infrastructure is in place (working DT, reasonably well adopted etc, 
drivers rewritten/fixed etc). Once that all is in place, engineers will 
hopefully think twice. They have two options, either adapt their design 
(within reason and cost) to more closely match the 'one kernel to rule 
them all' approach, and reap its benefits, or apply hacks like the HTC 
example above and are then responsible for hacking around the code to 
get it to work. Their choice eventually.

>
> Obviously this is a longer-term solution and won't help with existing
> devices, but in the long run device designers may need to realize the
> kind of mess they're creating for the poor software people and try to
> achieve some more standardization and device discoverability. Given the
> market dominance of Linux in many parts of the embedded world, one
> thinks this should be achievable.
There we go, long term, I don't think DT is half as bad and In time, 
we'll see if it was really bad or not to bad at all.
>
>>
>> the best that device tree does in the ARM world is add an extra burden
>> for device development, because there is so little that can actually
>> be shared between disparate hardware platforms - so much so that it is
>> utterly hopeless and pointless for a time-pressured product designer
>> to even consider going down that route when they *know* it's not going
>> to be of benefit for them.
That's like say, why bother using the Linux kerenl, when it's pointless 
to use and they might as well use a much simpler in house designed 
kernel. Or just a bare metal system. If they can see the benefits of 
using the Linux kernel, then surely they must see the benefit from 
possibly (not forceably, choice) using the DT. Personally, I think in 
the long run, DT will be the better choice. Allowing you to use a 
same/similar kernel for different products is still a win in my opinion. 
And again, if this isn't important (now, who knows later) they have the 
choice to hack things around and do as they please, with all pro's and 
con's of that later.

>>
>> you also have to bear in mind that the SoC vendors don't really talk
>> to each other.  you also have to bear in mind that they are usually
>> overwhelmed by the ignorance of the factories and OEMs that use their
>> SoCs - a situation that's not helped in many cases by their failure to
>> provide adequate documentation [but if you're selling 50 million SoCs
>> a year through android and the SoC is, at $7.50, a small part of the
>> BOM, why would you care about or even answer requests for adequate
>> documentation??] - so it's often the SoC vendors that have to write
>> the linux kernel source code themselves.  MStar Semi take this to its
>> logical GPL-violating extreme by even preventing and prohibiting
>> *everyone* from gaining access to even the *product* designs.  if they
>> like your idea, they will design it for you - in total secrecy - from
>> start to finish.  and if not, you f*** off.
Besides the obvious violation here (gpl-violations.org knows about 
this?) doesn't make it right. Yes they violate the GPL, don't provide 
docs etc. But think of this long term, once we have better arm SoC 
support with DT, why would they bother doing all the work, over and over 
(in secret) again? Wouldn't it also be much easier for them to follow 
mainline?

Simple example. I see little touch screen drivers in the kernel now. I 
also see several 'drivers' for them out in the wild. Some are reference 
drivers with little adoptions, some are rewrites and most hack in 
support for their chip. I'm sure that's partially the reason why they do 
a lot in house, to get things working.

Now if said touch screen driver is in mainline, with flexible DT 
support, all you have to do to get this TS driver working is make a DT 
definition in your DT and it 'just works (tm)'. Why would they then 
bother redoing/hacking things together? Isn't it cheaper for them to 
follow mainline in that sense?

>>
>> [*0] allwinner use "script.fex".  it's an alternative to device-tree
>> and it's a hell of a lot better.  INI config file format.
>> standardised across *all* hardware that uses the A10.
IMO fex is just a basic DT parallel development thing. Is it better? Is 
it similar? I would think so. I mean, it's a definition file, that gets 
loaded at boot, and parsed by drivers. Basically what DT does as well, 
albeit in a more complicated (and future proof?) way?

 >> _and_ there is a GUI application
 >> which helps ODMs to customise the linux kernel for their clients...
As for the GUI application, who says that's not possible for DT? Just 
needs someone to write it I guess :) Besides, that still doesn't mean 
anything. Lazy engineers who don't know what they are doing will write 
crappy stuff. Be it DT or 'fex'. I've seen completly wrong fex files 
myself (tablets with sata ports enabled, even though there is no sata 
port to name 'an' example). Maybe because DT is a little harder that'll 
force them to think before implementing.

 >> WITHOUT RECOMPILING THE LINUX KERNEL AT ALL.
 >> it even allows
 >> setting of the pin mux functions.   the designers of
 >> devicetree could learn a lot from what allwinner have achieved.
And you don't need to recompile the kernel at all when using DT do you? 
That would totally defy its purpose.



Again, I know very little about this all. But do feel DT is atleast one 
step (maybe out of several) in the right direction.

