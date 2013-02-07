Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759157Ab3BGR1I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 12:27:08 -0500
Received: from 8bytes.org ([85.214.48.195]:39654 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759012Ab3BGR1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 12:27:06 -0500
Date: Thu, 7 Feb 2013 18:27:01 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Gleb Natapov <gleb@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Don Zickus <dzickus@redhat.com>, Prarit Bhargava <prarit@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] intel_iommu: Disable vfio and kvm interrupt assignment
 when unsafe
Message-ID: <20130207172701.GX25591@8bytes.org>
References: <5fc782f401fc7bb0cd829b2316d7f29eb2595036.1360206266.git.luto@amacapital.net>
 <20130207113340.GW25591@8bytes.org>
 <CALCETrUzX9efPafJ0W2vxU-KgQ_FOxQ4YqGDKbw5z6d1P0ZYEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrUzX9efPafJ0W2vxU-KgQ_FOxQ4YqGDKbw5z6d1P0ZYEQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Thu Feb  7 18:27:03 2013
X-DSPAM-Confidence: 0.9991
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5113e3e722971694662064
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2013 at 08:29:42AM -0800, Andy Lutomirski wrote:
> On Thu, Feb 7, 2013 at 3:33 AM, Joerg Roedel <joro@8bytes.org> wrote:
> > On Wed, Feb 06, 2013 at 07:08:24PM -0800, Andy Lutomirski wrote:
> >> -     if (x2apic_present)
> >> -             WARN(1, KERN_WARNING
> >> -                     "Failed to enable irq remapping.  You are vulnerable to irq-injection attacks.\n");
> >> -
> >> +     irq_remapping_is_secure = 0;
> >>       return -1;
> >>  }
> >
> > Why do you remove this warning? It seems unrelated to the rest of the
> > patch.
> 
> The idea is that setting irq_remapping_is_secure = 0 makes you (much
> less) vulnerable to irq-injection attacks: you're vulnerable to
> malicious hardware but not to attack via vfio or kvm, because those
> paths are disabled.
> 
> I'd have no problem leaving the warning in and letting whoever manages
> to trigger it and get annoyed fix it.  FWIW, it's actually likely to
> be interesting if the warning hits.

Hmm, looking into the intel_irq_remapping.c version in the tip tree
makes me wonder even more.

First, I wonder why the warning only hits when an x2apic is present. The
function is not x2apic-specific and the vulnerability also exists in
xapic mode. So that dependency can be removed.

Second, I think that it should be a pr_warn instead of a full WARN. When
IRQ remapping could not be enabled it's most likely because of the BIOS
or the hardware. So a message in the kernel log will do and the
backtrace provides no additional value.

Same is true for the warning in the function iommu_set_irq_remapping():

       if (sts & DMA_GSTS_CFIS)
                WARN(1, KERN_WARNING
                        "Compatibility-format IRQs enabled despite intr remapping;\n"
                        "you are vulnerable to IRQ injection.\n");

>From what I can see this condition depends only on the hardware too. So
a simple pr_warn() provides the same amount of information.


Regards,

	Joerg



