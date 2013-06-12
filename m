Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757975Ab3FLUmU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 16:42:20 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:34678 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756176Ab3FLUmT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 16:42:19 -0400
Date: Wed, 12 Jun 2013 15:42:15 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: Slow swap-in with SSD
To: Martin Steigerwald <ms@teamix.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <201306111634.36327.ms@teamix.de> (from ms@teamix.de on Tue Jun
	11 09:34:36 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1371069735.2776.100@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2013 09:34:36 AM, Martin Steigerwald wrote:
> Hi!
> 
> Using Linux 3.10-rc5 on an ThinkPad T520 with Intel Sandybridge  
> i5-2620M,
> 8 GiB RAM and Intel SSD 320. Currently I have Zcache enabled to test  
> the
> effects of it but I observed similar figures on kernels without  
> Zcache.
> 
> If I let the kernel swap out for example with
> 
> stress -m 1 --vm-keep --vm-bytes 5G
> 
> or so, then swapping out is pretty fast, I have seen values around
> 100-200 MiB/s
> 
> But on issuing a swapoff command to swap stuff in again, the swap in  
> is
> abysmally slow, just a few MiB/s (see below).
> 
> I wonder why is that so? The SSD is basically idling around on  
> swap-in.

Transaction granularity. Swapping out can queue up large batches of  
pages because you can queue up more outgoing pages while the others are  
still writing. Swapping _in_ you don't know what you need next until  
you resume the process, so you fault in 4k, schedule DMA, resume the  
process when it completes, fault on the next page, schedule more DMA,  
rinse repeat. Programs don't really execute linearly, so you wind up  
with round trip latency to and from device each time.

The problem with doing readahead on swapin is that programs jump around  
randomly calling a function here and a function there, so you dunno  
which other pages it'll need until it requests them. (Speculatively  
faulting in pages when the system is starved of memory usually just  
makes the memory shortage worse. This code only runs when there's a  
shortage of physical pages.)

Having an ssd just exacerbates the problem, because with the device  
itself sped up the round trip latency from all the tiny transactions  
comes to dominate.

Rob