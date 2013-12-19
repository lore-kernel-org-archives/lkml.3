Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018Ab3LSNhn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 08:37:43 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:35545 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547Ab3LSNhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 08:37:38 -0500
MIME-Version: 1.0
In-Reply-To: <s5hppotrn5l.wl%tiwai@suse.de>
References: <s5hlhzik3kk.wl%tiwai@suse.de>
	<CANq1E4TFKDduy71jCXy+8CMS1_OFxWEpsHY3AA0RUJPW4VE8hg@mail.gmail.com>
	<20131218092941.GA19210@gmail.com>
	<20131219000346.0f722b65@alan.etchedpixels.co.uk>
	<CANq1E4Q3KiLMC-ETFs+FAmTv3yWdCyqG2c+KzGFX4xZmcxLbJg@mail.gmail.com>
	<s5h61qlt7zm.wl%tiwai@suse.de>
	<CANq1E4TW3O9czVzX1bj4F5oMrDHZ+ZsLHLCk9ANsg2e14QXmfg@mail.gmail.com>
	<s5hppotrn5l.wl%tiwai@suse.de>
Date: Thu, 19 Dec 2013 14:37:35 +0100
Message-ID: <CANq1E4S-wKvCiz21QM=_YRZV5h9iOXsVxESCVy6w7Lh88AvR9Q@mail.gmail.com>
Subject: Re: cirrusdrmfb broken with simplefb
From: David Herrmann <dh.herrmann@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Thu, Dec 19, 2013 at 2:22 PM, Takashi Iwai <tiwai@suse.de> wrote:
> At Thu, 19 Dec 2013 13:36:38 +0100,
> David Herrmann wrote:
>>
>> Hi
>>
>> On Thu, Dec 19, 2013 at 12:06 PM, Takashi Iwai <tiwai@suse.de> wrote:
>> > At Thu, 19 Dec 2013 11:46:51 +0100,
>> > David Herrmann wrote:
>> >>
>> >> Hi
>> >>
>> >> On Thu, Dec 19, 2013 at 1:03 AM, One Thousand Gnomes
>> >> <gnomes@lxorguk.ukuu.org.uk> wrote:
>> >> >> > That bug always existed, simplefb is just the first driver to hit it
>> >> >> > (vesafb/efifb didn't use resources). I'm aware of the issue but as a
>> >> >> > workaround you can simply disable CONFIG_X86_SYSFB. That restores
>> >> >> > the old behavior.
>> >> >>
>> >> >> This looks like a regression, so we'll either need a fix or we'll have
>> >> >> to mark CONFIG_X86_SYSFB as CONFIG_BROKEN.
>> >> >
>> >> > Kernel bugzilla has entries for simplefb breaking both vesafb and matrox
>> >> > mga.
>> >>
>> >> Thanks for the hints. I've read through all I could find and tried to
>> >> provide some help.
>> >>
>> >> I'm kind of confused, most of them enable CONFIG_X86_SYSFB (which is
>> >> 'n' by default) but don't read the help text. I did my best to tell
>> >> people that this option requires CONFIG_FB_SIMPLE, but if you don't
>> >> read the help-text you won't notice that. Don't know what to do about
>> >> that..
>> >
>> > You can set FB_SIMPLE default value depending on X86_SYSFB, something
>> > like:
>> >
>> > --- a/drivers/video/Kconfig
>> > +++ b/drivers/video/Kconfig
>> > @@ -2455,6 +2455,7 @@ config FB_HYPERV
>> >  config FB_SIMPLE
>> >         bool "Simple framebuffer support"
>> >         depends on (FB = y)
>> > +       default y if X86_SYSFB
>> >         select FB_CFB_FILLRECT
>> >         select FB_CFB_COPYAREA
>> >         select FB_CFB_IMAGEBLIT
>>
>> The "default <wx> if <yz>" only works if the config hasn't been set at
>> all, yet. Even a "# CONFIG_* is unset" causes the "default" value to
>> be ignored.
>
> Yes.  I didn't suggest the strict dependency like below, just because
> I assumed you didn't add it intentionally.

It doesn't work. If CONFIG_FB=n this breaks.

>> How about adding "depends on (FB_SIMPLE = y)" for X86_SYSFB? I guess I
>> will try that and send a patch.
>
> That's in general a bad approach.  If the strict dependency is
> allowed, a more intuitive way is to give a reverse selection.  But
> then you'd need to correct the help text, too, as it's implemented
> already as a dependency.

Well, X86_SYSFB just changes the way x86-bootup code handles
firmware-framebuffers. The option makes sense with CONFIG_FB=n or also
CONFIG_DRM=n. However, currently the only driver that can profit from
this is FB_SIMPLE. So I decided to set X86_SYSFB=n as default and
no-one should ever bother (except for people who *really* want this).

Unfortunately, people still enable it without understanding it.
Changing FB_SIMPLE or other config options doesn't protect against
that, instead I need to make X86_SYSFB fool-proof so it's only
activated if people seriously *want* it.

Doing a "select FB_SIMPLE" doesn't work due to the non-recursive
behavior of "select". It will only enable FB_SIMPLE but not the
dependencies of FB_SIMPLE (eg., FB). So I'm now left with "depends on
(FB_SIMPLE = y)". And I actually like this, because there's no gain in
using X86_SYSFB if you don't have FB_SIMPLE enabled. And it hides
X86_SYSFB from all non-developers who currently shouldn't care anyway.
Most sysfb code is enabled regardless of X86_SYSFB, the option really
just controls the compatibility mode. And unless SimpleDRM is merged,
there's little gain by setting it for non-developers.

So I guess "depends on (FB_SIMPLE = y)" is the safest way. I will send
a patch for that. If you're still not convinced, I'd be glad to hear
your concerns. The only other idea I had is this:

config X86_SYSFB
         bool "Mark VGA/VBE/EFI FB as generic system framebuffer"
         depends on (FB_SIMPLE = y)
         default y

But I'm not sure I want the "default y" if FB_SIMPLE is active right
now. We can add it later without any problems.

Thanks
David

> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -2299,6 +2299,7 @@ source "drivers/rapidio/Kconfig"
>
>  config X86_SYSFB
>         bool "Mark VGA/VBE/EFI FB as generic system framebuffer"
> +       select SIMPLE_FB
>         help
>           Firmwares often provide initial graphics framebuffers so the BIOS,
>           bootloader or kernel can show basic video-output during boot for
>
>
> Takashi
