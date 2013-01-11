Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461Ab3AKPgi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 10:36:38 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:64130 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022Ab3AKPgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 10:36:36 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Thierry Reding <thierry.reding@avionic-design.de>
Subject: Re: [PATCH 10/14] PCI: tegra: Move PCIe driver to drivers/pci/host
Date: Fri, 11 Jan 2013 15:36:14 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: Stephen Warren <swarren@wwwdotorg.org>, linux-tegra@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de> <50EF54B6.6010100@wwwdotorg.org> <20130111034015.GA28094@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20130111034015.GA28094@avionic-0098.adnet.avionic-design.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301111536.14799.arnd@arndb.de>
X-Provags-ID: V02:K0:qE8bigfUs63pD2lhbJh3qFhhH3lqHL4uaK3Yc5wD9Op
 ECUZmIL9nl2UjxBbvrN+ujTWGskoAonEDVe8ATKCUmFDd+gAeM
 U+PCoCjYYLjQ5zu11WrSlAtlnI6zxSzYUYRjr3rLl9d+SLfcjr
 ym+0YypWra51x8iNJjpdmrsnmfBeBTV2Jr41NgdKYcEuyMX98a
 Sp6KUnSFam71vS7TfXlmkWiaAWCTwC0sbySlNKBPWlBGYkL0m7
 3ZrUxC3bEpAU7EdR4IY180VORLb4CLZ7v47jp+daLfKssqBEsj
 DSjTVB4RzzqJlODoJfwvpqMRpNNn7RHPodot021YBXKkKfbs5s
 Ny7cFfqqmBbC8FzjItDs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 January 2013, Thierry Reding wrote:
> Right, it'll need #ifdefs around the arch_{setup,teardown}_msi_irq(). Or
> select PCI_MSI unconditionally. Once this is merged I was going to post
> a patch that enables PCI_MSI in tegra_defconfig anyway. But it might be
> better to keep it optional anyway since the remainder of the code copes
> with it properly.
> 
Actually, we need something better than that. You cannot define
arch_setup_msi_irq in a tegra specific pci host driver, because that
will seriously mess up other platforms in multiplatform configurations
by giving a link error when they also define this function, or with a
run-time error when they don't support it.

I think what we should do here is fix it the right way by adding
a pci host specific callback rather than an architecture specific
callback in drivers/pci/msi.c. There is already a default version
of arch_setup_msi_irqs (with s), and we can probably do the
same for arch_setup_msi_irq (without s) to fall back to the
arch version for most architectures.
Most architectures (at least powerpc, sparc, ia64 and x86) already
multiplex the msi handlers internally, but ARM does not because
there is only one implementation (iop33x) at the moment.

We can add a generix multiplex and then move architectures over to
use it.

	Arnd
