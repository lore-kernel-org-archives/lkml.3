Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932375AbaFSJUl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 05:20:41 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:39921 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932271AbaFSJUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 05:20:37 -0400
Date: Thu, 19 Jun 2014 12:20:32 +0300
From: Gleb Natapov <gleb@kernel.org>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        mgorman@suse.de, yinghai@kernel.org, isimatu.yasuaki@jp.fujitsu.com,
        guz.fnst@cn.fujitsu.com, laijs@cn.fujitsu.com, kvm@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        mtosatti@redhat.com
Subject: Re: [RFC PATCH 1/1] Move two pinned pages to non-movable node in kvm.
Message-ID: <20140619092031.GA429@minantech.com>
References: <1403070600-6083-1-git-send-email-tangchen@cn.fujitsu.com>
 <20140618061230.GA10948@minantech.com>
 <53A136C4.5070206@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53A136C4.5070206@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CCing Marcelo,

On Wed, Jun 18, 2014 at 02:50:44PM +0800, Tang Chen wrote:
> Hi Gleb,
> 
> Thanks for the quick reply. Please see below.
> 
> On 06/18/2014 02:12 PM, Gleb Natapov wrote:
> >On Wed, Jun 18, 2014 at 01:50:00PM +0800, Tang Chen wrote:
> >>[Questions]
> >>And by the way, would you guys please answer the following questions for me ?
> >>
> >>1. What's the ept identity pagetable for ?  Only one page is enough ?
> >>
> >>2. Is the ept identity pagetable only used in realmode ?
> >>    Can we free it once the guest is up (vcpu in protect mode)?
> >>
> >>3. Now, ept identity pagetable is allocated in qemu userspace.
> >>    Can we allocate it in kernel space ?
> >What would be the benefit?
> 
> I think the benefit is we can hot-remove the host memory a kvm guest
> is using.
> 
> For now, only memory in ZONE_MOVABLE can be migrated/hot-removed. And the
> kernel
> will never use ZONE_MOVABLE memory. So if we can allocate these two pages in
> kernel space, we can pin them without any trouble. When doing memory
> hot-remove,
> the kernel will not try to migrate these two pages.
But we can do that by other means, no? The patch you've sent for instance.

> 
> >
> >>
> >>4. If I want to migrate these two pages, what do you think is the best way ?
> >>
> >I answered most of those here: http://www.mail-archive.com/kvm@vger.kernel.org/msg103718.html
> 
> I'm sorry I must missed this email.
> 
> Seeing your advice, we can unpin these two pages and repin them in the next
> EPT violation.
> So about this problem, which solution would you prefer, allocate these two
> pages in kernel
> space, or migrate them before memory hot-remove ?
> 
> I think the first solution is simpler. But I'm not quite sure if there is
> any other pages
> pinned in memory. If we have the same problem with other kvm pages, I think
> it is better to
> solve it in the second way.
> 
> What do you think ?
Remove pinning is preferable. In fact looks like for identity pagetable
it should be trivial, just don't pin. APIC access page is a little bit
more complicated since its physical address needs to be tracked to be
updated in VMCS.

--
			Gleb.
