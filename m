Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936Ab3JLRtj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 13:49:39 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:51903 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566Ab3JLRth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 13:49:37 -0400
Date: Sat, 12 Oct 2013 19:49:34 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Fleming <matt.fleming@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Jones <pjones@redhat.com>
Subject: Re: [PATCH] x86/efi: Add EFI framebuffer earlyprintk support
Message-ID: <20131012174934.GA18849@gmail.com>
References: <1381423261-30566-1-git-send-email-matt@console-pimps.org>
 <20131010172844.GA26430@gmail.com>
 <20131011140039.GF12321@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131011140039.GF12321@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Matt Fleming <matt@console-pimps.org> wrote:

> On Thu, 10 Oct, at 07:28:44PM, Ingo Molnar wrote:
> > Btw., could we perhaps remap the whole framebuffer at init time, or is it 
> > too large? If early_ioremap() fails for whatever reason then that will 
> > emit a WARN_ON(), which will recurse in a fairly nasty way ...
>  
> The framebuffer memory will be quite large, so I don't think it makes 
> sense to map it all this early, because it's likely we'll run out of 
> fixmap entries.

Fair enough.

> > > +static __init void early_efi_clear_screen(void)
> > > +{
> > > +	struct screen_info *si;
> > > +	int y;
> > > +
> > > +	si = &boot_params.screen_info;
> > > +	for (y = 0; y < si->lfb_height; y++)
> > > +		early_efi_clear_line(y);
> > 
> > Looks a bit superfluous to introduce 'si' just for that single use?
>  
> I did this to reduce the length of the "for (y = 0..." line.

But that line looks fine with that included. If it goes slightly above 80 
chars that's still OK IMHO.

> > > +static void early_efi_write_char(void *dst, char c, int h)
> > > +{
> > > +	const u8 *src;
> > > +	u32 fgcolor = 0xaaaaaa;
> > 
> > That's RGB grey, right? Why not 0xffffff for a very visible white?
>  
> The VGA earlyprintk code uses the equivalent grey, AFAIK, which is why I 
> picked this value.

The VGA code should be changed to white too I suspect ;-)

> > > +		if (efi_y + font->height >= si->lfb_height) {
> > > +			early_efi_clear_screen();
> > > +			efi_y = 0;
> > 
> > So, if I understand it correctly this clears the screen and starts at 
> > the top when we scroll off the bottom, right?
> > 
> > That might make the recovery of oopses hard when the number of log 
> > lines is unlucky.
> > 
> > Would scrolling a few lines up instead, via a well-calculated memcpy 
> > and memset be doable?
>  
> Yeah we can do that. I thought about this originally but decided against 
> it because I figured it would complicate the code unnecessarily. But it 
> turned out to be fairly trivial.

Cool!

> > > +	if (!font)
> > > +		return -ENODEV;
> > > +
> > > +	early_efi_clear_screen();
> > 
> > Assuming we implement scrolling above, here too it might make sense to 
> > scroll up the framebuffer - if the crash is early enough then some 
> > firmware and boot stub info might still be present in the framebuffer?
> 
> It's possible that some info will be in the framebuffer, but we can't 
> begin writing immediately after the boot stub info because we don't know 
> the last xy coordinates the firmware wrote to.
> 
> But yeah, leaving it intact and beginning our output from the last line 
> of the framebuffer makes more sense than clearing the screen entirely.

Especially with scrolling it should not matter where the previous info is 
on the screen: if we start with a scroll event then we can make some space 
at the bottom and start our printout there, or so.

Thanks,

	Ingo
