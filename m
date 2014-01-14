Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908AbaANRcK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 12:32:10 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:44933 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbaANRcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 12:32:07 -0500
MIME-Version: 1.0
In-Reply-To: <20140114085040.GA6873@dhcp-26-207.brq.redhat.com>
References: <cover.1389103215.git.agordeev@redhat.com> <7fe2a5563efac19c87213a48b58cae6b4d76c91d.1389103215.git.agordeev@redhat.com>
 <20140113191220.GA6525@google.com> <20140114085040.GA6873@dhcp-26-207.brq.redhat.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 14 Jan 2014 10:31:46 -0700
Message-ID: <CAErSpo7QSLsbKL=rPj0Uavf1y8A+mxdXhdW-hK689xzGw7O=rw@mail.gmail.com>
Subject: Re: [PATCH 3/7] ahci: Use new interfaces for MSI/MSI-X enablement
To: Alexander Gordeev <agordeev@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 1:50 AM, Alexander Gordeev <agordeev@redhat.com> wrote:
> On Mon, Jan 13, 2014 at 12:12:20PM -0700, Bjorn Helgaas wrote:
>> > -   nvec = rc;
>> > -   rc = pci_enable_msi_block(pdev, nvec);
>> > -   if (rc)
>> > +   if (pci_enable_msi_range(pdev, nvec, nvec) < 0)
>> >             goto intx;
>> >
>> >     return nvec;
>> >
>> >  single_msi:
>> > -   rc = pci_enable_msi(pdev);
>> > -   if (rc)
>> > +   if (pci_enable_msi_range(pdev, 1, 1) < 0)
>>
>> This part doesn't seem like an improvement.  There are a hundred or so
>> callers of pci_enable_msi() that only want a single MSI.  Is there any
>> benefit in changing them to use pci_enable_msi_range()?
>
> In this particular case it reads better to me as one sees on the screen
> pci_enable_msi_range(pdev, nvec, nvec) and pci_enable_msi_range(pdev, 1, 1)
> calls. That allows to avoid switching in mind between negative-or-positive
> return in the former call and negative-or-zero return from pci_enable_msi()
> if we had it.
>
> But in most cases when single MSI is enabled we do cause complication
> with the patterns below (which I expect I am going be hated for ;) ):

I don't want to touch those hundred pci_enable_msi() callers at all.
So I think we should have something like this:

    /* Return 0 for success (one MSI enabled) or negative errno */
    static inline int pci_enable_msi(struct pci_dev *dev)
    {
        int rc;

        rc = pci_enable_msi_range(pdev, 1, 1);
        if (rc == 1)
            return 0;
        return rc;
    }
