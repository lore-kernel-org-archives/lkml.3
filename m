Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308AbaKLPza (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 10:55:30 -0500
Received: from mail.emea.novell.com ([130.57.118.101]:53466 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929AbaKLPz2 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:8:1>);
	Wed, 12 Nov 2014 10:55:28 -0500
Message-Id: <546390FC0200007800046E50@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.1 
Date: Wed, 12 Nov 2014 15:55:24 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "David Vrabel" <david.vrabel@citrix.com>
Cc: <x86@kernel.org>, "Thomas Gleixner" <tglx@linutronix.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        <xen-devel@lists.xenproject.org>,
        "Boris Ostrovsky" <boris.ostrovsky@oracle.com>,
        "Ingo Molnar" <mingo@redhat.com>, <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Xen-devel] [PATCH 3/3] x86/xen: use the maximum MFN to
 calculate the required DMA mask
References: <1415805906-27316-1-git-send-email-david.vrabel@citrix.com>
 <1415805906-27316-4-git-send-email-david.vrabel@citrix.com>
In-Reply-To: <1415805906-27316-4-git-send-email-david.vrabel@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 12.11.14 at 16:25, <david.vrabel@citrix.com> wrote:
> +u64
> +xen_swiotlb_get_required_mask(struct device *dev)
> +{
> +	u64 max_mfn;
> +
> +	max_mfn = HYPERVISOR_memory_op(XENMEM_maximum_ram_page, NULL);
> +
> +	return DMA_BIT_MASK(fls64(max_mfn << PAGE_SHIFT) + 1);
> +}

The value the hypercall returns is exclusive and an unsigned long.
Hence I'd suggest

u64
xen_swiotlb_get_required_mask(struct device *dev)
{
	unsigned long max_mfn;

	max_mfn = HYPERVISOR_memory_op(XENMEM_maximum_ram_page, NULL);

	return DMA_BIT_MASK(__fls(max_mfn - 1) + 1 + PAGE_SHIFT);
}

Jan

