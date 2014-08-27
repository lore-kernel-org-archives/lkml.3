Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933700AbaH0MQJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 08:16:09 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:49357 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933451AbaH0MQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 08:16:06 -0400
Date: Wed, 27 Aug 2014 13:15:59 +0100
From: Sitsofe Wheeler <sitsofe@gmail.com>
To: Dexuan Cui <decui@microsoft.com>
Cc: KY Srinivasan <kys@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PANIC, hyperv] BUG: unable to handle kernel paging request at
 ffff880077800004 (hv_ringbuffer_write)
Message-ID: <20140827121559.GA14286@sucs.org>
References: <20140820092630.GA1478@sucs.org>
 <EE124450C0AAF944A40DD71E61F878C994F314@SINEX14MBXC417.southpacific.corp.microsoft.com>
 <20140825174132.GA17681@sucs.org>
 <EE124450C0AAF944A40DD71E61F878C995E93E@SINEX14MBXC419.southpacific.corp.microsoft.com>
 <20140827104408.GC1827@sucs.org>
 <EE124450C0AAF944A40DD71E61F878C996493E@SINEX14MBXC419.southpacific.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <EE124450C0AAF944A40DD71E61F878C996493E@SINEX14MBXC419.southpacific.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 11:30:54AM +0000, Dexuan Cui wrote:
> > -----Original Message-----
> > From: Sitsofe Wheeler
> > On Tue, Aug 26, 2014 at 10:30:54AM +0000, Dexuan Cui wrote:
> > 
> > > Actually I found the direct cause of the panic: sometimes
> > > vmbus_post_msg() can return 4 (HV_STATUS_INVALID_ALIGNMENT), but
> > > vmbus_open() doesn't propagate this error to the caller
> > > synthvid_connect_vsp(), and vmbus_open() " goto error1"  and frees the
> > > ringbuffer! So later the access to ring_buffer->read_index is caught
> > > by CONFIG_DEBUG_PAGEALLOC.
> > >
> > > I don't see any "invalid alignment" here... and I can't explain why
> > > vcpus=4 seems OK... Debugging WIP.
> I think I found out why we got HV_STATUS_INVALID_ALIGNMENT:
> according to Hypervisor Top Level Functional Specification(available at
> http://blogs.msdn.com/b/virtual_pc_guy/archive/2014/02/17/updated-hypervisor-top-level-functional-specification.aspx),

That document is massive!

> do_hypercall() fails due to HV_STATUS_INVALID_ALIGNMENT, if "the
> specified input or output GPA pointer is not aligned to 8 bytes",
> or, "the specified input or output parameter lists spans pages".
> Here the 'input' can rarely across the page boundary, especially when 
> CONFIG_DEBUG_PAGEALLOC is on.

It can also be returned when "The input or output GPA pointer is not within
the bounds of the GPA space." but I'm guessing that's not the case here?

> I'm making a patch for this. 

Thanks! Could these alignment problems have been the cause of all sorts
of intermittent errors like https://lkml.org/lkml/2014/7/11/870 (which
was caused by support being added for a bigger receive buffer)?

> > I rebased your patch on top of the K.Y.'s "Drivers: hv: vmbus: Eliminate
> > calls to BUG_ON()" patch set (see below). The combination no longer
> > triggers the bug and it doesn't take too long to boot but the network
> > interface fails to work (which I believe is .
> the sentence is accidently trimmed here? :-)

*Cough* That bit in brackets shouldn't be there. I've been unable to
link that stacktrace to an existing issue (I thought it might have been
https://lkml.org/lkml/2014/8/19/227 but that seems unlikely).

> > Rebased vmbus open fixes patch.
> The patch doesn't resolve all the issues.

OK.

> > Boot dmesg output (there's no line that mentions retries). The
> > framebuffer window also didn't resize itself:
> > 
> > [    7.848030] hv_vmbus: registering driver hyperv_fb
> > [    7.859759] hyperv_fb: Unable to open vmbus channel
> > [    7.871812] hyperv_fb: Unable to connect to VSP
> We still see hyperv_fb can't work.

How come things didn't work even though the retries message (which is
presumably printed if we exceed 10 attempts) was never printed?

-- 
Sitsofe | http://sucs.org/~sits/
