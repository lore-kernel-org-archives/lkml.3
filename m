Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810AbaGaQLl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 12:11:41 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:35319 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbaGaQLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 12:11:39 -0400
Date: Thu, 31 Jul 2014 09:11:33 -0700
From: josh@joshtriplett.org
To: Matt Fleming <matt@console-pimps.org>
Cc: Matt Fleming <matt.fleming@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Srihari Vijayaraghavan <linux.bug.reporting@gmail.com>
Subject: Re: [PATCH] efi-bgrt: Add error handling; inform the user when
 ignoring the BGRT
Message-ID: <20140731161133.GA12663@cloud>
References: <20140730192331.GA23730@jtriplet-mobl1>
 <20140731103110.GC15082@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140731103110.GC15082@console-pimps.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2014 at 11:31:10AM +0100, Matt Fleming wrote:
> On Wed, 30 Jul, at 12:23:32PM, Josh Triplett wrote:
> > @@ -61,14 +81,18 @@ void __init efi_bgrt_init(void)
> >  		early_iounmap(image, sizeof(bmp_header));
> >  	bgrt_image_size = bmp_header.size;
> >  
> > -	bgrt_image = kmalloc(bgrt_image_size, GFP_KERNEL);
> > -	if (!bgrt_image)
> > +	bgrt_image = kmalloc(bgrt_image_size, GFP_KERNEL | __GFP_NOWARN);
> > +	if (!bgrt_image) {
> > +		pr_err("Ignoring BGRT: failed to allocate memory for image (wanted %zu bytes)\n",
> > +		       bgrt_image_size);
> >  		return;
> 
> I'm not sure that using __GFP_NOWARN is the right thing to do here. If
> for some reason we can't handle the BGRT image we should include checks
> in the BGRT code, rather than relying on the page-allocation machinery
> to save us.
> 
> Let's just use an explicit limit on the size of the BGRT image we're
> willing to handle.

I started to add an explicit limit, but any reasonable limit (large
enough for modern screens) would be large enough that there's still a
non-trivial possibility of allocation failure.  And I think it makes
sense for BGRT image allocation to be non-fatal and minimally noisy
(just a single-line error, not a scary-looking allocation warning),
considering the highly optional and cosmetic nature of BGRT.  So, I
believe __GFP_NOWARN makes sense.

- Josh Triplett
