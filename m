Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965132Ab3DJQtL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 12:49:11 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:38635 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936102Ab3DJQtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 12:49:09 -0400
Message-ID: <1365611810.32127.100.camel@misato.fc.hp.com>
Subject: Re: [PATCH v2 2/3] resource: Add release_mem_region_adjustable()
From: Toshi Kani <toshi.kani@hp.com>
To: David Rientjes <rientjes@google.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linuxram@us.ibm.com,
        guz.fnst@cn.fujitsu.com, tmac@hp.com, isimatu.yasuaki@jp.fujitsu.com,
        wency@cn.fujitsu.com, tangchen@cn.fujitsu.com, jiang.liu@huawei.com
Date: Wed, 10 Apr 2013 10:36:50 -0600
In-Reply-To: <alpine.DEB.2.02.1304092315180.3916@chino.kir.corp.google.com>
References: <1365440996-30981-1-git-send-email-toshi.kani@hp.com>
	 <1365440996-30981-3-git-send-email-toshi.kani@hp.com>
	 <alpine.DEB.2.02.1304092315180.3916@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-09 at 23:16 -0700, David Rientjes wrote:
> On Mon, 8 Apr 2013, Toshi Kani wrote:
> 
> > Added release_mem_region_adjustable(), which releases a requested
> > region from a currently busy memory resource.  This interface
> > adjusts the matched memory resource accordingly even if the
> > requested region does not match exactly but still fits into.
> > 
> > This new interface is intended for memory hot-delete.  During
> > bootup, memory resources are inserted from the boot descriptor
> > table, such as EFI Memory Table and e820.  Each memory resource
> > entry usually covers the whole contigous memory range.  Memory
> > hot-delete request, on the other hand, may target to a particular
> > range of memory resource, and its size can be much smaller than
> > the whole contiguous memory.  Since the existing release interfaces
> > like __release_region() require a requested region to be exactly
> > matched to a resource entry, they do not allow a partial resource
> > to be released.
> > 
> > There is no change to the existing interfaces since their restriction
> > is valid for I/O resources.
> > 
> > Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> > Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> 
> Should this emit a warning for attempting to free a non-existant region 
> like __release_region() does?

Since __release_region() is a void function, it needs to emit a warning
within the func.  I made release_mem_region_adjustable() as an int
function so that the caller can receive an error and decide what to do
based on its operation.  I changed the caller __remove_pages() to emit a
warning message in PATCH 3/3 in this case.

> I think it would be better to base this off my patch and surround it with 
> #ifdef CONFIG_MEMORY_HOTREMOVE as suggested by Andrew.  There shouldn't be 
> any conflicts.

Yes, I realized that CONFIG_MEMORY_HOTREMOVE was a better choice, but I
had to use CONFIG_MEMORY_HOTPLUG at this time.  So, thanks for doing the
cleanup!

Since it's already rc6, I will keep my patchset independent for now.  I
will make minor change to update CONFIG_MEMORY_HOTPLUG to
CONFIG_MEMORY_HOTREMOVE after your patch gets accepted -- either by
sending a separate patch (if my patchset is already accepted) or
updating my current patchset (if my patchset is not accepted yet).

Thanks!
-Toshi

