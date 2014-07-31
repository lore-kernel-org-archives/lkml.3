Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303AbaGaKbU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 06:31:20 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:40003 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbaGaKbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 06:31:18 -0400
Date: Thu, 31 Jul 2014 11:31:10 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Matt Fleming <matt.fleming@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Srihari Vijayaraghavan <linux.bug.reporting@gmail.com>
Subject: Re: [PATCH] efi-bgrt: Add error handling; inform the user when
 ignoring the BGRT
Message-ID: <20140731103110.GC15082@console-pimps.org>
References: <20140730192331.GA23730@jtriplet-mobl1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140730192331.GA23730@jtriplet-mobl1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jul, at 12:23:32PM, Josh Triplett wrote:
> Gracefully handle failures to allocate memory for the image, which might
> be arbitrarily large.
> 
> efi_bgrt_init can fail in various ways as well, usually because the
> BIOS-provided BGRT structure does not match expectations.  Add
> appropriate error messages rather than failing silently.
> 
> Reported-by: Srihari Vijayaraghavan

This could really do with an email address appending.

> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=81321
> Signed-off-by: Josh Triplett <josh@joshtriplett.org>
> ---
>  arch/x86/platform/efi/efi-bgrt.c | 36 ++++++++++++++++++++++++++++++------
>  1 file changed, 30 insertions(+), 6 deletions(-)

[...]

> @@ -61,14 +81,18 @@ void __init efi_bgrt_init(void)
>  		early_iounmap(image, sizeof(bmp_header));
>  	bgrt_image_size = bmp_header.size;
>  
> -	bgrt_image = kmalloc(bgrt_image_size, GFP_KERNEL);
> -	if (!bgrt_image)
> +	bgrt_image = kmalloc(bgrt_image_size, GFP_KERNEL | __GFP_NOWARN);
> +	if (!bgrt_image) {
> +		pr_err("Ignoring BGRT: failed to allocate memory for image (wanted %zu bytes)\n",
> +		       bgrt_image_size);
>  		return;

I'm not sure that using __GFP_NOWARN is the right thing to do here. If
for some reason we can't handle the BGRT image we should include checks
in the BGRT code, rather than relying on the page-allocation machinery
to save us.

Let's just use an explicit limit on the size of the BGRT image we're
willing to handle.

Either way, this hunk shouldn't be mixed in with the improved error
logging changes, it needs to be a separate patch.

-- 
Matt Fleming, Intel Open Source Technology Center
