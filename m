Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757221Ab3JNSRY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 14:17:24 -0400
Received: from mga09.intel.com ([134.134.136.24]:50507 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755714Ab3JNSRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 14:17:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,493,1378882800"; 
   d="scan'208";a="392802940"
Date: Mon, 14 Oct 2013 11:17:21 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: Warning when calling radix_tree_insert on 3.12-rc4
Message-ID: <20131014181721.GA18408@xanatos>
References: <20131011221315.GE7094@xanatos>
 <20131014123034.GF19604@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131014123034.GF19604@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 02:30:34PM +0200, Jan Kara wrote:
>   Hello Sarah,
> 
> On Fri 11-10-13 15:13:15, Sarah Sharp wrote:
> > I'm testing out some changes to the xHCI USB host controller driver
> > (which uses a radix tree when a UAS device is attached to the host), and
> > I noticed the following warning:
> > 
> > Oct 11 14:42:08 xanatos kernel: [18165.819014] usb 2-2: new SuperSpeed USB device number 2 using xhci_hcd
> > Oct 11 14:42:08 xanatos kernel: [18165.836264] usb 2-2: New USB device found, idVendor=174c, idProduct=55aa
> > Oct 11 14:42:08 xanatos kernel: [18165.836271] usb 2-2: New USB device strings: Mfr=2, Product=3, SerialNumber=1
> > Oct 11 14:42:08 xanatos kernel: [18165.836275] usb 2-2: Product: Plugable USB3-SATA-UASP1
> > Oct 11 14:42:08 xanatos kernel: [18165.836279] usb 2-2: Manufacturer: ASM1053E
> > Oct 11 14:42:08 xanatos kernel: [18165.836291] usb 2-2: SerialNumber: 123456789045
> > Oct 11 14:42:08 xanatos kernel: [18165.847661] BUG: using smp_processor_id() in preemptible [00000000] code: modprobe/8759
> > Oct 11 14:42:08 xanatos kernel: [18165.847667] caller is radix_tree_node_alloc+0x5c/0xa0
>   Well, this warning seems to come from the __get_cpu_var() function. I don't
> see how my commit could have caused what you observe. It seems you are
> calling radix_tree_insert() for a radix tree which has atomic gfp mask set
> and you don't do radix_tree_preload() / radix_tree_preload_end() around
> that? That was always problematic and could lead to the above warning.

I see.  Ok, we'll need to fix that.  The code went into the kernel years
ago, but wasn't really tested until now.

Do we only need to call radix_tree_preload() and
radix_tree_preload_end() only around the radix_tree_insert()?  Or will
we need it around radix_tree_delete() as well?

> I'm not sure in which contexts xhci_update_stream_ring() can be called. But
> if you are guaranteed non-atomic context, then using radix_tree_preload()
> with a more relaxed gfp mask is good (lowers pressure on atomic allocations).
>
> If the context depends on the caller, things are more complex. Generally,
> you can use radix_tree_maybe_preload() but you have to set gfp mask
> argument according to the context. The function then figures out whether
> it's worth it to do a preload or not (but it always does preempt_disable()
> which will silence the warning).

There are a couple ways xhci_update_stream_ring() could be called:

 - xhci_alloc_stream_info can be called while the bandwidth mutex is
   held, so that must be in process context

 - xhci_ring_free is called when the command to disable a slot
   completes, in interrupt context.

 - xhci_ring_expansion during URB submission, which can happen in
   interrupt context.

So it looks like the context depends on the caller, and we'll have to
call radix_tree_maybe_preload().

Sarah Sharp
