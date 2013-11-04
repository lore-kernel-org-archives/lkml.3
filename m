Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331Ab3KDMoM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 07:44:12 -0500
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:61112 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751311Ab3KDMoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 07:44:11 -0500
Message-ID: <1383569048.9623.16.camel@x220.thuisdomein>
Subject: Re: [PATCH] PCI: Workaround missing pci_set_master in pci drivers
From: Paul Bolle <pebolle@tiscali.nl>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 04 Nov 2013 13:44:08 +0100
In-Reply-To: <CAErSpo79xHn7RNNrbQBa49M464xryqjwi_iTPjTCnhEphkCvEg@mail.gmail.com>
References: <CAE9FiQV8ipnQ_vV68S-QHMrUrQTWQT_XObxyBeR=dOuw6fG1eg@mail.gmail.com>
	 <1380399187-4962-1-git-send-email-yinghai@kernel.org>
	 <20131003220628.GA14835@google.com>
	 <CAE9FiQVYZ2pRTs5Xsc2MKgUiWfLbSExLA-vF0HK2iy=tVw2OHA@mail.gmail.com>
	 <CAErSpo79xHn7RNNrbQBa49M464xryqjwi_iTPjTCnhEphkCvEg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Nov 2013 12:44:08.0644 (UTC) FILETIME=[8DE92040:01CED95B]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-10-04 at 09:55 -0600, Bjorn Helgaas wrote:
> On Thu, Oct 3, 2013 at 5:35 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> > On Thu, Oct 3, 2013 at 3:06 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> >> On Sat, Sep 28, 2013 at 01:13:07PM -0700, Yinghai Lu wrote:
> >>> @@ -1156,8 +1156,14 @@ static void pci_enable_bridge(struct pci
> >>>
> >>>       pci_enable_bridge(dev->bus->self);
> >>>
> >>> -     if (pci_is_enabled(dev))
> >>> +     if (pci_is_enabled(dev)) {
> >>> +             if (!dev->is_busmaster) {
> >>> +                     dev_warn(&dev->dev, "driver skip pci_set_master, fix it!\n");
> >>
> >> I know this is already in Linus' tree, but if we're going to enable
> >> bus mastering here, what's the point of the warning?  If somebody
> >> fixes the driver by adding a pci_set_master() call there, does that
> >> improve something?
> >
> > Help us to catch other offender and fix them.
> 
> What is improved by doing it in the driver instead of here?

After booting v3.12 for the first time on a laptop I noticed two new
warnings: 
    <4>[    4.427959] pcieport 0000:00:1c.4: driver skip pci_set_master, fix it!
    <4>[    4.448630] pcieport 0000:00:1c.1: driver skip pci_set_master, fix it!

These warnings aren't entirely clear, but luckily they are easily
greppable. It turns out they can be traced back to this patch.

So some further grepping, looking at the code, etc. suggests these
warnings could be silenced by calling pci_set_master() before calling
pci_enable_device(). Ie, reverse the current order of those calls in
drivers/pci/pcie/portdrv_core.c:pcie_port_device_register(). Is that
correct? But what should then be done if pci_enable_device() fails?

And Bjorn's question - what's the point of this warning if
pci_set_master() will be called anyway - also came up when I looked at
that code segment for the first time. But I'm not familiar with the PCI
code.


Paul Bolle

