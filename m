Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240AbaDKHom (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 03:44:42 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:56626 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753559AbaDKHok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 03:44:40 -0400
Date: Fri, 11 Apr 2014 08:44:28 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Koen Kooi <koen@dominion.thruhere.net>,
        Matt Fleming <matt.fleming@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Kees Cook <keescook@chromium.org>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: "54b52d87268034859191d671505bb1cfce6bd74d - x86/efi: Build our
 own EFI services pointer table" breaks boot on thinkpad t440s
Message-ID: <20140411074428.GA22042@console-pimps.org>
References: <AF4406ED-6B0B-4E15-A329-04162E0ADC8A@dominion.thruhere.net>
 <20140410121146.GA17021@console-pimps.org>
 <20140411072044.GA15418@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140411072044.GA15418@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Apr, at 09:20:44AM, Ingo Molnar wrote:
> 
> Might be prudent to do the same in __file_size32(), instead of 
> truncating silently, especially is that function too has a u64 output 
> AFAICS.
 
This change isn't required for __file_size32() because we only use that
function if the firmware is 32-bit. The signature of
EFI_FILE_PROTOCOL.GetInfo() looks like this,

  EFI_STATUS (*EFI_FILE_GET_INFO) (
	EFI_FILE_PROTOCOL *This,
	EFI_GUID 	  *InformationType,
	UINTN		  *BufferSize,
	void		  *Buffer
  );

UINTN translates to unsigned long, so for 32-bit firmware is u32. The
firmware will never write 64-bits to &info_sz in __file_size32().

> Also, while reviewing the file I noticed that there's "u32 fb_base", 
> which is recovered like:
> 
>                 status = __gop_query64(gop64, &info, &size, &fb_base);
> 
> but ->frame_buffer_base is u64. Is it always guaranteed u32?

Good catch. ->frame_buffer_base isn't always u32, but we only have u32
bits in which to store it (struct screen_info.lfb_base), so we
implicitly truncate it,

static efi_status_t
__gop_query64(struct efi_graphics_output_protocol_64 *gop64,

[...]

        *fb_base = mode->frame_buffer_base;

But you raise a good point - it would probably make more sense to
complain loudly if we get an address above 0xffffffff.

-- 
Matt Fleming, Intel Open Source Technology Center
