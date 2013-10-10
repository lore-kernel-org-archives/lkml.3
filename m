Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350Ab3JJSKK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 14:10:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16565 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756344Ab3JJSKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 14:10:03 -0400
Date: Thu, 10 Oct 2013 14:09:37 -0400
From: Peter Jones <pjones@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Matt Fleming <matt@console-pimps.org>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86/efi: Add EFI framebuffer earlyprintk support
Message-ID: <20131010180937.GD18821@fenchurch.internal.datastacks.com>
References: <1381423261-30566-1-git-send-email-matt@console-pimps.org>
 <20131010172844.GA26430@gmail.com>
 <20131010173710.GA18821@fenchurch.internal.datastacks.com>
 <20131010174521.GA27218@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131010174521.GA27218@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 07:45:21PM +0200, Ingo Molnar wrote:
> 
> * Peter Jones <pjones@redhat.com> wrote:
> 
> > On Thu, Oct 10, 2013 at 07:28:44PM +0200, Ingo Molnar wrote:
> > > 
> > > Is a non-32-bit framebuffer a possibility? If yes then it might be nice to 
> > > emit an informative printk() here, so that users who try to enable EFI 
> > > early-printk can at least see why it's not working. (Assuming they get to 
> > > look at regular printk output, on a safe/working kernel.)
> > 
> > Not really - the spec allows RGBx, BGRx, and for custom bit masks, but
> > they're define like:
> > 
> > typedef struct {
> > 	UINT32 RedMask;
> > 	UINT32 GreenMask;
> > 	UINT32 BlueMask;
> > 	UINT32 ReservedMask;
> > } EFI_PIXEL_BITMASK;
> 
> Hm, that structure does not show up anywhere in the kernel that I can see.

It's the thing being interpretted in arch/x86/boot/compressed/eboot.c in
setup_gop() in the code that looks like:

        if (pixel_format == PIXEL_RGB_RESERVED_8BIT_PER_COLOR) {
		si->lfb_depth = 32;
		si->lfb_linelength = pixels_per_scan_line * 4;
		...
	} else if (pixel_format == PIXEL_BGR_RESERVED_8BIT_PER_COLOR) {
		...
	} else if (pixel_format == PIXEL_BIT_MASK) {
		find_bits(pixel_info.red_mask, &si->red_pos, &si->red_size);
		...
	...

> How are those mask values to be interpreted? As regular bitmasks? Are bits 
> in the masks set to 1 consecutively, starting from bit 0?

So, the spec actually has some sample code in it:

INTN
GetPixelElementSize (
IN EFI_PIXEL_BITMASK *PixelBits
)
{
	INTN HighestPixel = -1;
	INTN BluePixel;
	INTN RedPixel;
	INTN GreenPixel;
	INTN RsvdPixel;
	BluePixel = FindHighestSetBit (PixelBits->BlueMask);
	RedPixel = FindHighestSetBit (PixelBits->RedMask);
	GreenPixel = FindHighestSetBit (PixelBits->GreenMask);
	RsvdPixel = FindHighestSetBit (PixelBits->ReservedMask);
	HighestPixel = max (BluePixel, RedPixel);
	HighestPixel = max (HighestPixel, GreenPixel);
	HighestPixel = max (HighestPixel, RsvdPixel);
	return HighestPixel;
}
EFI_PHYSICAL_ADDRESS NewPixelAddress;
EFI_PHYSICAL_ADDRESS CurrentPixelAddress;
EFI_GRAPHICS_OUTPUT_MODE_INFORMATION OutputInfo;
INTN PixelElementSize;

switch (OutputInfo.PixelFormat) {
	case PixelBitMask:
		PixelElementSize = GetPixelElementSize (&OutputInfo.PixelInformation);
		break;
	case PixelBlueGreenRedReserved8BitPerColor:
	case PixelRedGreenBlueReserved8BitPerColor:
		PixelElementSize = sizeof (EFI_GRAPHICS_OUTPUT_BLT_PIXEL);
		break;
}

Which makes this painfully clear.

> Also, the main question would be, what is the typical value for 
> si->lfb_depth. 32 on almost all EFI systems? All around the map? Depends 
> on what graphics state the EFI bootloader passes us?

Yes, 32 on almost all systems that implement a framebuffer console at
all.

-- 
        Peter
