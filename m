Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943Ab3FGJuf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 05:50:35 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38380 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487Ab3FGJue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 05:50:34 -0400
Date: Fri, 7 Jun 2013 10:50:13 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, jslaby@suse.cz,
        linux-serial@vger.kernel.org, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, Chanho Min <chanho.min@lge.com>,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
Subject: Re: amba pl011: where to submit a fix for x86 builds
Message-ID: <20130607095013.GU18614@n2100.arm.linux.org.uk>
References: <20130607093854.GA3429@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130607093854.GA3429@mail.gnudd.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 11:38:54AM +0200, Alessandro Rubini wrote:
> Hello.
> This is cc'd to $(get_maintainer.pl -f drivers/tty/serial/amba-pl011.c)
> and x86 maintainers too.
> 
> While working on the pci-to-amba bridge driver (to be resubmitted in
> the next days) I have to deal with the problem of pl011 not building,
> after phys_to_page was introduced, by Chanho Min (Cc: here) in commit
> 
>    cb06ff1 ARM: PL011: Add support for Rx DMA buffer polling.
> 
> because x86 has no phys_to_page.
> 
> The fix I use is trivially this:
> 
>   -       sg_set_page(&sg->sg, phys_to_page(dma_addr),
>   +       sg_set_page(&sg->sg, virt_to_page(sg->buf),
> 
> (virt_to_page is slower, but other sg_get_page() users do the same
> and other solutions are more convoluted).

... and thereby breaks ARM, because sg->buf is not part of the kernel
direct mapped RAM region.

I don't think there's a portable way to do the above, because the DMA
coherent API doesn't really support translating the allocated memory
region to a struct page pointer.
