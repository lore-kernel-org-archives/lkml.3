Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751642AbaLQVRj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 16:17:39 -0500
Received: from mail.skyhub.de ([78.46.96.112]:56660 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470AbaLQVRh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 16:17:37 -0500
Date: Wed, 17 Dec 2014 22:17:33 +0100
From: Borislav Petkov <bp@alien8.de>
To: Calvin Owens <calvinowens@fb.com>
Cc: linux-edac@vger.kernel.org, tony.luck@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v3 0/4] RAS: Correctable Errors Collector thing
Message-ID: <20141217211733.GB8457@pd.tnic>
References: <1404242623-10094-1-git-send-email-bp@alien8.de>
 <CAMY-HrCRS0RcBO0sMtwOKwYmS_+q89Kpr5Y0WyhpfQdapaQzLA@mail.gmail.com>
 <20141217022603.GB7152@mail.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141217022603.GB7152@mail.thefacebook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 06:26:03PM -0800, Calvin Owens wrote:
> Hmm. I can definitely imagine that in a scenario where you're testing
> hardware you would want to know about all the corrected errors in
> userspace. You could just tail dmesg watching for the message below,
> but that's somewhat crappy.

Oh yeah, we have the tracepoints for that - structured error logs. And
yes, we will definitely have a cec=disable or similar cmdline switch to
turn it off.

> Also, figuring out what physical DIMM on the motherboard a given
> physical address is on is rather messy as I understand it, since it
> varies between manufacturers. I'm not sure supporting that inside the
> kernel is a good idea, so people who care about this would still need
> some way to get the errors in userspace too.

Right, the edac drivers are all an attempt to do that pinpointing. It
doesn't always work optimally though.

There's also drivers/acpi/acpi_extlog.c which happens with fw support
and should be much more useful; it is a new thing from Intel though and
needs to spread out first.

> Somehow exposing the array tracking the errors could be interesting,
> although I'm not sure how useful that would actually be in practice.

Yeah, that's in debugfs, see the 4th patch: "[PATCH -v3 4/4] MCE, CE:
Add debugging glue".

> That would also get more complicated as this starts to handle things
> like corrected cache and bus errors.

Right, I'm not sure what we even want to do with those, if at all. And
what rates are those and whether we can even do proper - and what kind
of - recovery using them. This thing wants to deal with memory errors
only, for now at least.

> This should definitely be configurable IMO: different people will
> want to manage this in different ways. We're very aggressive about
> offlining pages with corrected errors, for example.

Ok, that sounds interesting. So you're saying, you would want to
configure the overflow count at which to offline the page. What else?
Decay time too?

Currently, we run do_spring_cleaning() when the fill levels reach
CLEAN_ELEMS, i.e., every time we do CLEAN_ELEMS insertion/incrementation
operations, we decay the currently present elements.

I can imagine where we want to control those aspects like wait until the
array fills up with PFNs and run the decaying then. Or we don't run the
decaying at all and offline pages the moment they reach saturation. And
so on and so on...

> I'll keep an eye out for buggy machines to test on ;)

Cool, thanks.

> > * As to why we're putting this in the kernel and enabling it by default:
> > a userspace daemon is much more fragile than doing this in the kernel.
> > And regardless of distro, everyone gets this.
> 
> I very much agree.

Cool, thanks for the insights.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
