Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759032Ab3BGUwA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 15:52:00 -0500
Received: from 8bytes.org ([85.214.48.195]:39899 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757578Ab3BGUv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 15:51:59 -0500
Date: Thu, 7 Feb 2013 21:51:53 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Gleb Natapov <gleb@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Don Zickus <dzickus@redhat.com>, Prarit Bhargava <prarit@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] intel_iommu: Disable vfio and kvm interrupt assignment
 when unsafe
Message-ID: <20130207205152.GA2849@8bytes.org>
References: <5fc782f401fc7bb0cd829b2316d7f29eb2595036.1360206266.git.luto@amacapital.net>
 <20130207113340.GW25591@8bytes.org>
 <CALCETrUzX9efPafJ0W2vxU-KgQ_FOxQ4YqGDKbw5z6d1P0ZYEQ@mail.gmail.com>
 <20130207172701.GX25591@8bytes.org>
 <CALCETrWGgpipHVnutSdfqBWw1GoyrdJV7vTMxagtYC8Zzr8HzA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWGgpipHVnutSdfqBWw1GoyrdJV7vTMxagtYC8Zzr8HzA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Thu Feb  7 21:51:57 2013
X-DSPAM-Confidence: 0.9992
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 511413ed22971709630759
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2013 at 09:53:45AM -0800, Andy Lutomirski wrote:
> On Thu, Feb 7, 2013 at 9:27 AM, Joerg Roedel <joro@8bytes.org> wrote:
> > Hmm, looking into the intel_irq_remapping.c version in the tip tree
> > makes me wonder even more.
> 
> Is this the version I'm based on (intel_irq_remapping: Clean up x2apic
> optout security warning mess), or something else?

The current tip/master branch with your previous patches included. Btw.
commit af8d102f99 (which introduces the CFIS check) is also bogus. It
claims to cleanup warning messages but does more, like explicitly
clearing DMA_GCMD_CFI in the global command register. This should have
been a seperate patch with a seperate commit-msg.

Now to the two warnings. First of:

        if (sts & DMA_GSTS_CFIS)
                WARN(1, KERN_WARNING
                        "Compatibility-format IRQs enabled despite intr remapping;\n"
                        "you are vulnerable to IRQ injection.\n");

This one can be removed completly as it will never trigger. The CFIS bit
you check here (according to the VT-d spec) has the same value as what
you write into GCMD.CFI (which you set to 0 earlier in the function).

The other warning:

        if (x2apic_present)
                WARN(1, KERN_WARNING
                        "Failed to enable irq remapping.  You are vulnerable to irq-injection attacks.\n");

Here you should remove the x2apic_present check as this is the
error-path for xapic and x2apic. The vulnerability exists with xapic
too.

> What's the general rule here?  If this warning hits, then my
> understanding of the Intel VT-d spec is wrong, and I don't think that
> firmware can cause it.  A buggy hypervisor could, I suppose.

A buggy hypervisor can not cause the CFIS-check warning. In my
understanding only broken hardware can cause it, but that would be known
already in the form of a hardware erratum. As I said above, after some
reading in the VT-d spec I think the warning can go away (Even clearing
GCMD.CFI can be removed as the value is never set in the VT-d driver, so
the bit is always written as 0 by Linux).

With this in mind, I also think that the patch this thread is about does
not make much sense. It just adds more code to handle a case that could
never happen.

Regards,

	Joerg


