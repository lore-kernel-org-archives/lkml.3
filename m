Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751298Ab3A2G45 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 01:56:57 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:46101 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab3A2G4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 01:56:55 -0500
X-AuditID: 9c93016f-b7b70ae000000e36-bd-510772b52663
Date: Tue, 29 Jan 2013 15:56:56 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Will Deacon <will.deacon@arm.com>, Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 0/3] introduce static_vm for ARM-specific static
 mapped area
Message-ID: <20130129065656.GC5131@lge.com>
References: <1358990934-4893-1-git-send-email-iamjoonsoo.kim@lge.com>
 <20130128175106.GI23470@mudshark.cambridge.arm.com>
 <alpine.LFD.2.02.1301281300250.6300@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1301281300250.6300@xanadu.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 01:04:24PM -0500, Nicolas Pitre wrote:
> On Mon, 28 Jan 2013, Will Deacon wrote:
> 
> > Hello,
> > 
> > On Thu, Jan 24, 2013 at 01:28:51AM +0000, Joonsoo Kim wrote:
> > > In current implementation, we used ARM-specific flag, that is,
> > > VM_ARM_STATIC_MAPPING, for distinguishing ARM specific static mapped area.
> > > The purpose of static mapped area is to re-use static mapped area when
> > > entire physical address range of the ioremap request can be covered
> > > by this area.
> > > 
> > > This implementation causes needless overhead for some cases.
> > > For example, assume that there is only one static mapped area and
> > > vmlist has 300 areas. Every time we call ioremap, we check 300 areas for
> > > deciding whether it is matched or not. Moreover, even if there is
> > > no static mapped area and vmlist has 300 areas, every time we call
> > > ioremap, we check 300 areas in now.
> > > 
> > > If we construct a extra list for static mapped area, we can eliminate
> > > above mentioned overhead.
> > > With a extra list, if there is one static mapped area,
> > > we just check only one area and proceed next operation quickly.
> > > 
> > > In fact, it is not a critical problem, because ioremap is not frequently
> > > used. But reducing overhead is better idea.
> > > 
> > > Another reason for doing this work is for removing vm_struct list management,
> > > entirely. For more information, look at the following link.
> > > http://lkml.org/lkml/2012/12/6/184
> > 
> > First patch looks good (removing the unused vmregion stuff) but I'm not so
> > sure about the rest of it. If you really care about ioremap performance,
> > perhaps it would be better to have a container struct around the vm_struct
> > for static mappings and then stick them in an augmented rbtree so you can
> > efficiently find the mapping encompassing a particular physical address?
> 
> How can ioremap performance be a problem is the question I had since the 
> beginning.
> 
> Firstly, ioremap is _not_ meant to be used in performance critical 
> paths.
> 
> Secondly, there shouldn't be _that_ many entries on the vmlist such as 
> 300.  That sounds a bit excessive.
> 
> So please, can we discuss the reasons that motivated those patches in 
> the first place?  Maybe that's where the actual problem is.

Hello, Wiil and Nicolas.
First of all, thanks for reviewing.

There is another reason for doing this work.
As mentioned above, I try to remove list management for vm_struct(vmlist),
entirely. For that purpose, removing architecture dependency against vmlist
is needed. Below link is for my RFC patch trying to remove list management
for vm_struct.

http://lkml.org/lkml/2012/12/6/184

Removing dependency for other architectures is rather trivial, but for ARM,
it is not trivial case. So I prepared this patchset.
My description makes you missleading possibly.
Sorry for this.

Answer for your other questions is below.

I know ioremap is _not_ meant to be used in performance critical paths, and
I mentioned it earlier.
"In fact, it is not a critical problem, because ioremap is not frequently used.
But reducing overhead is better idea."

And, there are many entries on the vmlist for my test devices(Android phone).
I saw more than 300 entries in former days, but today, I re-check it and
find 230~250 entries.

Thanks.
