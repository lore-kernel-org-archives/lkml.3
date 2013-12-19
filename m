Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756323Ab3LSVhp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 16:37:45 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:58209 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754699Ab3LSVhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 16:37:43 -0500
MIME-Version: 1.0
In-Reply-To: <20131219134244.GA32238@dhcp-26-207.brq.redhat.com>
References: <cover.1387140921.git.agordeev@redhat.com> <bbf6f73ef3e16e5dfd7d41fc1e4412f641acb0f3.1387140921.git.agordeev@redhat.com>
 <20131218003002.GA15119@google.com> <20131218132349.GA29552@dhcp-26-207.brq.redhat.com>
 <CAErSpo6Km5N+Cfpaj5JEsb966rwcBjrAT4SFvG6Q9QkwkDFXCA@mail.gmail.com> <20131219134244.GA32238@dhcp-26-207.brq.redhat.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 19 Dec 2013 14:37:22 -0700
Message-ID: <CAErSpo66Jh-8sbQr13r1LknfKWMt1zBd9xhm46XpCcW-X_TqnA@mail.gmail.com>
Subject: Re: [PATCH v4 9/9] PCI/MSI: Introduce pci_auto_enable_msi*() family helpers
To: Alexander Gordeev <agordeev@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tejun Heo <tj@kernel.org>, Ben Hutchings <bhutchings@solarflare.com>,
        David Laight <David.Laight@aculab.com>, Mark Lord <kernel@start.ca>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 6:42 AM, Alexander Gordeev <agordeev@redhat.com> wrote:
> On Wed, Dec 18, 2013 at 11:58:47AM -0700, Bjorn Helgaas wrote:
>> If rc == 13 and the device can only use 8, the extra 5 would be
>> ignored and wasted.
>>
>> If the waste is unacceptable, the driver can try this:
>>
>>     rc = pci_enable_msix_range(dev->pdev, dev->irqs, 16, 16);
>>     if (rc < 0) {
>>         rc = pci_enable_msix_range(dev->pdev, dev->irqs, 8, 8);
>>         if (rc < 0) {
>>             rc = pci_enable_msix_range(dev->pdev, dev->irqs, 4, 4);
>>             ...
>>     }
>
> I have troubles with this fallback logic. On each failed step we get an
> error and we do not know if this is indeed an error or an indication of
> insufficient MSI resources. Even -ENOSPC would not tell much, since it
> could be thrown from a lower level.
>
> By contrast, with the tri-state return value we can distinguish and bail
> out on errors right away.

I thought the main point of this was to get rid of interfaces that
were prone to misuse, and tri-state return values was a big part of
that.  All we really care about in the driver is success/failure.  I'm
not sure there's much to be gained by analyzing *why* we failed, and I
think it tends to make uncommon error paths more complicated than
necessary.  If we fail four times instead of bailing out after the
first failure, well, that doesn't sound terrible to me.  The last
failure can log the errno, which is enough for debugging.

> So the above is bit ungraceful for me. Combined with a possible waste in
> logs (if we're hitting the same error) it is quite enough for me to keep
> current the interfaces, at least for a time being.
>
>>     if (rc < 0) { /* error, couldn't allocate *any* interrupts */
>>     else { /* rc interrupts allocated (1, 2, 4, 8, or 16) */ }
>>
>> Bjorn
>
> --
> Regards,
> Alexander Gordeev
> agordeev@redhat.com
