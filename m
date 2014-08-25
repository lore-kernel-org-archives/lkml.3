Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933198AbaHYRll (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 13:41:41 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:39431 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933147AbaHYRli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 13:41:38 -0400
Date: Mon, 25 Aug 2014 18:41:32 +0100
From: Sitsofe Wheeler <sitsofe@gmail.com>
To: Dexuan Cui <decui@microsoft.com>
Cc: KY Srinivasan <kys@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>
Subject: Re: [PANIC, hyperv] BUG: unable to handle kernel paging request at
 ffff880077800004 (hv_ringbuffer_write)
Message-ID: <20140825174132.GA17681@sucs.org>
References: <20140820092630.GA1478@sucs.org>
 <EE124450C0AAF944A40DD71E61F878C994F314@SINEX14MBXC417.southpacific.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <EE124450C0AAF944A40DD71E61F878C994F314@SINEX14MBXC417.southpacific.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dexuan,

On Mon, Aug 25, 2014 at 02:02:21PM +0000, Dexuan Cui wrote:
> > -----Original Message-----
> > From: Sitsofe Wheeler
> > Sent: Wednesday, August 20, 2014 17:27 PM
> > 
> > While booting a Hyper-V 3.17.0-rc1 guest on a 2012 R2 host a BUG was
> > triggered while registering hyperv_fb which in turn caused a panic.
> > Various kernel debugging options (CONFIG_DEBUG_PAGEALLOC,
> > CONFIG_SLUB_DEBUG=y...) were on at the time. This only seems to happen
> > if the guest is being booted with only one CPU allocated to it.
>  
> I can reproduce the exact issue with the same commit + your kconfig + UP
> guest (SMP guest seems ok.)

Thanks for getting back - I was wondering if my mails had dropped into a
black hole as I haven't heard anything on any of them for a few days
(and no one had mentioned they had been able to reproduce the issues
reported).

> > [    7.645526] hv_vmbus: registering driver hyperv_fb
> > [    7.657553] BUG: unable to handle kernel paging request at
> > ffff880077800004
> > [    7.658224] IP: [<ffffffff8159a7ac>] hv_ringbuffer_write+0x7c/0x150
> > [    7.658224] PGD 2da9067 PUD 2dac067 PMD 7fa27067 PTE
> > 8000000077800060
> > [    7.658224] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
> It seems 
> hv_ringbuffer_write() -> 
>     hv_get_ringbuffer_availbytes():
>         reading rbi->ring_buffer->read_index causes a page fault.
> 
> It looks rbi->ring_buffer was unmapped somehow according to the
> semantics of CONFIG_DEBUG_PAGEALLOC??? Or, was there a memory
> corruption somewhere?
> 
> It looks the panic will disappear if the guest isn't configured with a 
> "Network Adapter ".

This sounds very fishy as if network setup has left things in a bad
state. What is baffles me is the whole UP vs SMP thing - why would UP
make this show up consistently? Perhaps some assertions could be added
to check that rbi->ring_buffer still has sane values in it after
operations on it are finished?

I guess you could try switching things around and using
kmemcheck (https://www.kernel.org/doc/Documentation/kmemcheck.txt ). If
the whole area close to rbi->ring_buffer->read_index is being stomped on
it should show up. If it's just being set to a duff value or freed that
going to be harder to track down although poisoning before freeing
should allow us to distinguish that case...

>From your analysis this doesn't sound framebuffer related - perhaps we
could drop the linuxfb CC's on these mails going forward?

-- 
Sitsofe | http://sucs.org/~sits/
