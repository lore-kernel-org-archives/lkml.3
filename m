Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757Ab3LSOOD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 09:14:03 -0500
Received: from mail-ig0-f172.google.com ([209.85.213.172]:65127 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462Ab3LSOOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 09:14:00 -0500
MIME-Version: 1.0
In-Reply-To: <s5hlhzhrl8y.wl%tiwai@suse.de>
References: <s5hlhzik3kk.wl%tiwai@suse.de>
	<CANq1E4TFKDduy71jCXy+8CMS1_OFxWEpsHY3AA0RUJPW4VE8hg@mail.gmail.com>
	<20131218092941.GA19210@gmail.com>
	<20131219000346.0f722b65@alan.etchedpixels.co.uk>
	<CANq1E4Q3KiLMC-ETFs+FAmTv3yWdCyqG2c+KzGFX4xZmcxLbJg@mail.gmail.com>
	<s5h61qlt7zm.wl%tiwai@suse.de>
	<CANq1E4TW3O9czVzX1bj4F5oMrDHZ+ZsLHLCk9ANsg2e14QXmfg@mail.gmail.com>
	<s5hppotrn5l.wl%tiwai@suse.de>
	<CANq1E4S-wKvCiz21QM=_YRZV5h9iOXsVxESCVy6w7Lh88AvR9Q@mail.gmail.com>
	<s5hlhzhrl8y.wl%tiwai@suse.de>
Date: Thu, 19 Dec 2013 15:13:59 +0100
Message-ID: <CANq1E4QxEniHHpTOfrGmzPaSU+DLFfMkfZPsBpZ4aF0Nyda2ig@mail.gmail.com>
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

On Thu, Dec 19, 2013 at 3:03 PM, Takashi Iwai <tiwai@suse.de> wrote:
>> >> The "default <wx> if <yz>" only works if the config hasn't been set at
>> >> all, yet. Even a "# CONFIG_* is unset" causes the "default" value to
>> >> be ignored.
>> >
>> > Yes.  I didn't suggest the strict dependency like below, just because
>> > I assumed you didn't add it intentionally.
>>
>> It doesn't work. If CONFIG_FB=n this breaks.
>>
>> >> How about adding "depends on (FB_SIMPLE = y)" for X86_SYSFB? I guess I
>> >> will try that and send a patch.
>> >
>> > That's in general a bad approach.  If the strict dependency is
>> > allowed, a more intuitive way is to give a reverse selection.  But
>> > then you'd need to correct the help text, too, as it's implemented
>> > already as a dependency.
>>
>> Well, X86_SYSFB just changes the way x86-bootup code handles
>> firmware-framebuffers. The option makes sense with CONFIG_FB=n or also
>> CONFIG_DRM=n. However, currently the only driver that can profit from
>> this is FB_SIMPLE. So I decided to set X86_SYSFB=n as default and
>> no-one should ever bother (except for people who *really* want this).
>>
>> Unfortunately, people still enable it without understanding it.
>> Changing FB_SIMPLE or other config options doesn't protect against
>> that, instead I need to make X86_SYSFB fool-proof so it's only
>> activated if people seriously *want* it.
>
> It's not N as default.  It's just unset.  People don't take it
> seriously as default N unless you explicitly write it.  And, more
> importantly, your help text even suggests to choose Y as default (in
> the end of text).  And it doesn't mention how to enable simplefb
> although it's recommended.  So you can't expect that people do the
> right thing only from that.

Yepp, that was my fault.. Already changed to 'N' in the new patch.

>> Doing a "select FB_SIMPLE" doesn't work due to the non-recursive
>> behavior of "select".
>
> There is one single dependency in FB_SIMPLE, so it's relatively easy
> in this case.
>
>> It will only enable FB_SIMPLE but not the
>> dependencies of FB_SIMPLE (eg., FB). So I'm now left with "depends on
>> (FB_SIMPLE = y)". And I actually like this, because there's no gain in
>> using X86_SYSFB if you don't have FB_SIMPLE enabled. And it hides
>> X86_SYSFB from all non-developers who currently shouldn't care anyway.
>> Most sysfb code is enabled regardless of X86_SYSFB, the option really
>> just controls the compatibility mode. And unless SimpleDRM is merged,
>> there's little gain by setting it for non-developers.
>
> Then better to have mentioned in the text or changelog.  Or make it
> depends on CONFIG_EXPERT (it doesn't help much, though, but can be
> some excuse :)

I didn't expect it to blow up in my face this way.. probably should
have. But that's why the changelog didn't mention it. Regarding
CONFIG_EXPERT, I doubt that helps much and it's a little bit late for
an excuse ;)

>> So I guess "depends on (FB_SIMPLE = y)" is the safest way. I will send
>> a patch for that. If you're still not convinced, I'd be glad to hear
>> your concerns.
>
> Why not just select both FB and FB_SIMPLE from X86_SYSFB?
>
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -2299,6 +2299,8 @@ source "drivers/rapidio/Kconfig"
>
>  config X86_SYSFB
>         bool "Mark VGA/VBE/EFI FB as generic system framebuffer"
> +       select FB
> +       select SIMPLE_FB
>         help
>           Firmwares often provide initial graphics framebuffers so the BIOS,
>           bootloader or kernel can show basic video-output during boot for
>
>
> The "depends on" hides the option until the dependency is satisfied,
> so especially when the dependency go over different sections, it
> should be avoided.  The reverse selection can be problematic
> sometimes, but as long as the dependency chain is short, it works more
> easily.

Is the select-chain recursive? So are FB_SIMPLE-select lines recognized?
If yes, this could work. Although given the complaints about bad
simplefb performance compared to vesafb, I'm still not sure. Yeah,
this time people are to blame as they *explicitly* selected X86_SYSFB
instead of plain old vesafb, but it's still annoying to hear the
complaints.

I will think about it some more time and send a v2-patch later today
if nothing else comes to mind.

Thanks for the reviews!
David
