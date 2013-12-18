Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480Ab3LRS7M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 13:59:12 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:56292 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221Ab3LRS7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 13:59:10 -0500
MIME-Version: 1.0
In-Reply-To: <20131218132349.GA29552@dhcp-26-207.brq.redhat.com>
References: <cover.1387140921.git.agordeev@redhat.com> <bbf6f73ef3e16e5dfd7d41fc1e4412f641acb0f3.1387140921.git.agordeev@redhat.com>
 <20131218003002.GA15119@google.com> <20131218132349.GA29552@dhcp-26-207.brq.redhat.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 18 Dec 2013 11:58:47 -0700
Message-ID: <CAErSpo6Km5N+Cfpaj5JEsb966rwcBjrAT4SFvG6Q9QkwkDFXCA@mail.gmail.com>
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

On Wed, Dec 18, 2013 at 6:23 AM, Alexander Gordeev <agordeev@redhat.com> wrote:
> On Tue, Dec 17, 2013 at 05:30:02PM -0700, Bjorn Helgaas wrote:
>
> Hi Bjorn,
>
> Thank you for the review!
>
> Sorry for a heavy skipping - I just wanted to focus on a principal
> moment in your suggestion and then go on with the original note.
>
>> I only see five users of pci_enable_msi_block() (nvme, ath10k, wil6210,
>> ipr, vfio); we can easily convert those to use pci_enable_msi_range() and
>> then remove pci_enable_msi_block().
>
>> It would be good if pci_enable_msix() could be implemented in terms of
>> pci_enable_msix_range(nvec, nvec), with a little extra glue to handle the
>> positive return values.
>
> So you want to get rid of the tri-state "low-level" pci_enable_msi_block()
> and pci_enable_msix(), right? I believe we can not do this, since we need
> to support a non-standard hardware which (a) can not be asked any arbitrary
> number of vectors within a range and (b) needs extra magic to enable MSI
> operation.
>
> I.e. below is a snippet from a real device driver Mark Lord has sent in a
> previous conversation:
>
>         xx_disable_all_irqs(dev);
>         do {
>                 if (nvec < 2)
>                         xx_prep_for_1_msix_vector(dev);
>                 else if (nvec < 4)
>                         xx_prep_for_2_msix_vectors(dev);
>                 else if (nvec < 8)
>                         xx_prep_for_4_msix_vectors(dev);
>                 else if (nvec < 16)
>                         xx_prep_for_8_msix_vectors(dev);
>                 else
>                         xx_prep_for_16_msix_vectors(dev);
>                 nvec = pci_enable_msix(dev->pdev, dev->irqs, dev->num_vectors);
>         } while (nvec > 0);
>
> The same probably could have been done with pci_enable_msix_range(nvec, nvec)
> call and checking for -ENOSPC errno, but IMO it would be less graceful and
> reliable, since -ENOSPC might come from anywhere.
>
> IOW, I believe we need to keep the door open for custom MSI-enablement (loop)
> implementations.

I think this can still be done even with pci_enable_msix_range().
Here's what I'm thinking, tell me where I'm going wrong:

    rc = pci_enable_msix_range(dev->pdev, dev->irqs, 1, 16);
    if (rc < 0) { /* error */ }
    else { /* rc interrupts allocated */ }

If rc == 13 and the device can only use 8, the extra 5 would be
ignored and wasted.

If the waste is unacceptable, the driver can try this:

    rc = pci_enable_msix_range(dev->pdev, dev->irqs, 16, 16);
    if (rc < 0) {
        rc = pci_enable_msix_range(dev->pdev, dev->irqs, 8, 8);
        if (rc < 0) {
            rc = pci_enable_msix_range(dev->pdev, dev->irqs, 4, 4);
            ...
    }

    if (rc < 0) { /* error, couldn't allocate *any* interrupts */
    else { /* rc interrupts allocated (1, 2, 4, 8, or 16) */ }

Bjorn
