Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045Ab3DZOvD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 10:51:03 -0400
Received: from a10-48.smtp-out.amazonses.com ([54.240.10.48]:44118 "EHLO
	a10-48.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755986Ab3DZOvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 10:51:00 -0400
X-Greylist: delayed 506 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Apr 2013 10:51:00 EDT
Date: Fri, 26 Apr 2013 14:42:32 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Han Pingtian <hanpt@linux.vnet.ibm.com>
cc: LKML <linux-kernel@vger.kernel.org>, mhocko@suse.cz, penberg@kernel.org,
        rientjes@google.com, linux-mm@kvack.org
Subject: Re: OOM-killer and strange RSS value in 3.9-rc7
In-Reply-To: <20130426062436.GB4441@localhost.localdomain>
Message-ID: <0000013e46cba821-d5c54c99-3b5c-4669-9a54-9fb8f4ee516f-000000@email.amazonses.com>
References: <20130417094750.GB2672@localhost.localdomain> <20130417141909.GA24912@dhcp22.suse.cz> <20130418101541.GC2672@localhost.localdomain> <20130418175513.GA12581@dhcp22.suse.cz> <20130423131558.GH8001@dhcp22.suse.cz> <20130424044848.GI2672@localhost.localdomain>
 <20130424094732.GB31960@dhcp22.suse.cz> <0000013e3cb0340d-00f360e3-076b-478e-b94c-ddd4476196ce-000000@email.amazonses.com> <20130425060705.GK2672@localhost.localdomain> <0000013e427023d7-9456c313-8654-420c-b85a-cb79cc3c4ffc-000000@email.amazonses.com>
 <20130426062436.GB4441@localhost.localdomain>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.04.26-54.240.10.48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Apr 2013, Han Pingtian wrote:

> Could you give me some hints about how to verify them? Only I can do is
> adding two printk() statements to print the vaules in those two
> functions:

Ok thats good. nr->partial needs to be bigger than min_partial in order
for frees to occur. So they do occur.

> And looks like only printk() in __slab_free() is invoked. I got about 6764
> lines of something like this:
>
> --------------------------------------------------------------------------------
> Apr 26 01:04:05 riblp3 kernel: [    6.969775] In __slab_free(); kmalloc-8192: n->nr_partial=2, s->min_partial=6
> Apr 26 01:04:05 riblp3 kernel: [    6.970154] In __slab_free(); kmalloc-8192: n->nr_partial=3, s->min_partial=6
> Apr 26 01:04:05 riblp3 kernel: [    6.979489] In __slab_free(); kmalloc-8192: n->nr_partial=4, s->min_partial=6
> Apr 26 01:04:05 riblp3 kernel: [    6.979823] In __slab_free(); kmalloc-8192: n->nr_partial=5, s->min_partial=6
> Apr 26 01:04:05 riblp3 kernel: [    9.500383] In __slab_free(); kmalloc-8192: n->nr_partial=7, s->min_partial=6
> Apr 26 01:04:05 riblp3 kernel: [    9.509736] In __slab_free(); kmalloc-8192: n->nr_partial=7, s->min_partial=6
> Apr 26 01:04:08 riblp3 kernel: [   42.314395] In __slab_free(); kmalloc-8192: n->nr_partial=100, s->min_partial=6
> Apr 26 01:04:08 riblp3 kernel: [   42.410333] In __slab_free(); kmalloc-8192: n->nr_partial=100, s->min_partial=6
> Apr 26 01:04:09 riblp3 kernel: [   43.411851] In __slab_free(); kmalloc-8192: n->nr_partial=339, s->min_partial=6
> Apr 26 01:04:09 riblp3 kernel: [   43.411980] In __slab_free(); kmalloc-8192: n->nr_partial=338, s->min_partial=6
> Apr 26 01:04:09 riblp3 kernel: [   43.412083] In __slab_free(); kmalloc-8192: n->nr_partial=337, s->min_partial=6
> --------------------------------------------------------------------------------
> The s->min_partial is always "6" and most of n->nr_partial is bigger than
> its partner of the same line.

Thats the way it should be. But the mystery is still there. Why do the
pages not get freed? Can you add a printk in __free_slab to verify that it
actually gets called? Print s->name to see which slab is affected by the
free.

Is there any way I can run a powerpc kernel that shows the issue on x86
with an emulator?

