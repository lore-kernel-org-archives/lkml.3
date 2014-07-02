Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142AbaGBNd2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 09:33:28 -0400
Received: from 8bytes.org ([85.214.48.195]:38481 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752448AbaGBNdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 09:33:04 -0400
Date: Wed, 2 Jul 2014 15:32:59 +0200
From: Joerg Roedel <joro@8bytes.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Bill Sumner <bill.sumner@hp.com>, "Hoemann, Jerry" <jerry.hoemann@hp.com>,
        indou.takao@jp.fujitsu.com, bhe@redhat.com, linux-pci@vger.kernel.org,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, doug.hatch@hp.com,
        ishii.hironobu@jp.fujitsu.com, bhelgaas@google.com, zhenhua@hp.com
Subject: Re: [PATCH 0/8] iommu/vt-d: Fix crash dump failure caused by legacy
 DMA/IO
Message-ID: <20140702133258.GN26537@8bytes.org>
References: <1398386198-19304-1-git-send-email-bill.sumner@hp.com>
 <1398854973.12733.23.camel@i7.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398854973.12733.23.camel@i7.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Jul  2 15:33:02 2014
X-DSPAM-Confidence: 0.9990
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 53b40a0e20861010628624
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Wed, Apr 30, 2014 at 11:49:33AM +0100, David Woodhouse wrote:
> There could be all kinds of existing mappings in the DMA page tables,
> and I'm not sure it's safe to preserve them. What prevents the crashdump
> kernel from trying to use any of the physical pages which are
> accessible, and which could thus be corrupted by stray DMA?
> 
> In fact, the old kernel could even have set up 1:1 passthrough mappings
> for some devices, which would then be able to DMA *anywhere*. Surely we
> need to prevent that?

Ideally we would prevent that, yes. But the problem is that a failed DMA
transaction might put the device into an unrecoverable state. Usually
any in-flight DMA transactions should only target buffers set up by the
previous kernel and not corrupt any data.

> After the last round of this patchset, we discussed a potential
> improvement where you point every virtual bus address at the *same*
> physical scratch page.

That is a solution to prevent the in-flight DMA failures. But what
happens when there is some in-flight DMA to a disk to write some inodes
or a new superblock. Then this scratch address-space may cause
filesystem corruption at worst.

So with this in mind I would prefer initially taking over the
page-tables from the old kernel before the device drivers re-initialize
the devices.


	Joerg


