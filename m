Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946AbaG3TgK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 15:36:10 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53149 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755766AbaG3TgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 15:36:08 -0400
Message-ID: <53D948D4.6080603@ti.com>
Date: Wed, 30 Jul 2014 15:34:44 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, Richard Zhu <r65037@freescale.com>,
        Marek Vasut <marex@denx.de>, Randy Dunlap <rdunlap@infradead.org>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        <linux-pci@vger.kernel.org>, Jingoo Han <jg1.han@samsung.com>,
        <linux-kernel@vger.kernel.org>, Kishon Vijay Abraham I <kishon@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v7 4/5] PCI: add PCI controller for keystone PCIe h/w
References: <1405961925-27248-1-git-send-email-m-karicheri2@ti.com> <1405961925-27248-5-git-send-email-m-karicheri2@ti.com> <20140722223527.GA27965@google.com> <53CEEB1C.9020202@ti.com> <20140722235200.GC27965@google.com> <20140723174228.GB11270@obsidianresearch.com>
In-Reply-To: <20140723174228.GB11270@obsidianresearch.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2014 01:42 PM, Jason Gunthorpe wrote:
> On Tue, Jul 22, 2014 at 05:52:00PM -0600, Bjorn Helgaas wrote:
>> If there is a hardware defect, a PCI quirk is a reasonable way to work
>> around it, since that's the main purpose of quirks.  fixup_mpss_256()
>> is an example of something that sounds superficially similar.
>
> It was my suggestion to engage the PCI-E tuning code. By my
> understanding the HW bug is that read response segmentation at the
> host bridge does not work - so all read requests from any downstream
> device must have responses that fit within a single packet.
>

In the case of Keystone PCI, when I set the MRSS to 256 in the EP, PCI 
controller is able to function properly. Keystone spec says.

• Maximum outbound payload size of 128 bytes
• Maximum inbound payload size of 256 bytes
• Maximum remote read request size of 256 bytes

I am interpreting the "Maximum remote read request size" to indicate it 
can's handle if it exceeds the limit. It has an outbound payload size of 
128 bytes. So in this case a read request would results in 2 completion 
packets. So it seems to be able to segment up to maximum 256 bytes of 
read request. Where do I find the requirement in PCI spec that "read 
response segmentation at the host bridge does not work" ?

> This is completely against how the spec envisions things working,
> segmentation is a mandatory function. As you point out there is no
> parameter bounding the maximum read request size that a completer will
> accept.
>
> So, the only fix is that every downstream device must always have a
> MRSS set to less than the MPS of the host bridge.

Why this can't be the default behavior in the PCI core? Any cons?

Murali
>
> Which means the tuning code must be involved somehow, as that code
> controls the MRSS of unrelated devices...
>
> Regards,
> Jason

