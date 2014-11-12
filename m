Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302AbaKLPZy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 10:25:54 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:20774 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171AbaKLPZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 10:25:53 -0500
X-IronPort-AV: E=Sophos;i="5.07,369,1413244800"; 
   d="scan'208";a="191999069"
From: David Vrabel <david.vrabel@citrix.com>
To: <linux-kernel@vger.kernel.org>
CC: David Vrabel <david.vrabel@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>,
        <xen-devel@lists.xenproject.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCHv2 0/3]: dma,x86,xen: reduce SWIOTLB usage in Xen guests
Date: Wed, 12 Nov 2014 15:25:03 +0000
Message-ID: <1415805906-27316-1-git-send-email-david.vrabel@citrix.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On systems where DMA addresses and physical addresses are not 1:1
(such as Xen PV guests), the generic dma_get_required_mask() will not
return the correct mask (since it uses max_pfn).

Some device drivers (such as mptsas, mpt2sas) use
dma_get_required_mask() to set the device's DMA mask to allow them to use
only 32-bit DMA addresses in hardware structures.  This results in
unnecessary use of the SWIOTLB if DMA addresses are more than 32-bits,
impacting performance significantly.

This series allows Xen PV guests to override the default
dma_get_required_mask() with one that calculated the DMA mask from the
maximum MFN (and not the PFN).

The first patch removes a duplicated function between ia64 and common
since we want a common implementation usage by ia64 and x86.

Changes in v2:
- split x86 and xen changes into separate patches

David

