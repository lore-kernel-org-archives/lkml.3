Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933273Ab3FSAAP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 20:00:15 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:33722 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932644Ab3FSAAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 20:00:13 -0400
Message-ID: <1371599989.22206.6.camel@misato.fc.hp.com>
Subject: Re: [Part3 PATCH v2 0/4] Support hot-remove local pagetable pages.
From: Toshi Kani <toshi.kani@hp.com>
To: Vasilis Liaskovitis <vasilis.liaskovitis@profitbricks.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>, tglx@linutronix.de, mingo@elte.hu,
        hpa@zytor.com, akpm@linux-foundation.org, tj@kernel.org, trenn@suse.de,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, mgorman@suse.de,
        minchan@kernel.org, mina86@mina86.com, gong.chen@linux.intel.com,
        lwoodman@redhat.com, riel@redhat.com, jweiner@redhat.com,
        prarit@redhat.com, x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Date: Tue, 18 Jun 2013 17:59:49 -0600
In-Reply-To: <20130618170515.GC4553@dhcp-192-168-178-175.profitbricks.localdomain>
References: <1371128636-9027-1-git-send-email-tangchen@cn.fujitsu.com>
	 <20130618170515.GC4553@dhcp-192-168-178-175.profitbricks.localdomain>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-06-18 at 19:05 +0200, Vasilis Liaskovitis wrote:
> Hi,
> 
> On Thu, Jun 13, 2013 at 09:03:52PM +0800, Tang Chen wrote:
> > The following patch-set from Yinghai allocates pagetables to local nodes.
> > v1: https://lkml.org/lkml/2013/3/7/642
> > v2: https://lkml.org/lkml/2013/3/10/47
> > v3: https://lkml.org/lkml/2013/4/4/639
> > v4: https://lkml.org/lkml/2013/4/11/829
> > 
> > Since pagetable pages are used by the kernel, they cannot be offlined.
> > As a result, they cannot be hot-remove.
> > 
> > This patch fix this problem with the following solution:
> > 
> >      1.   Introduce a new bootmem type LOCAL_NODE_DATAL, and register local
> >           pagetable pages as LOCAL_NODE_DATAL by setting page->lru.next to
> >           LOCAL_NODE_DATAL, just like we register SECTION_INFO pages.
> > 
> >      2.   Skip LOCAL_NODE_DATAL pages in offline/online procedures. When the
> >           whole memory block they reside in is offlined, the kernel can
> >           still access the pagetables.
> >           (This changes the semantics of offline/online a little bit.)
> 
> This could be a design problem of part3: if we allow local pagetable memory
> to not be offlined but allow the offlining to return successfully, then
> hot-remove is going to succeed. But the direct mapped pagetable pages are still
> mapped in the kernel. The hot-removed memblocks will suddenly disappear (think
> physical DIMMs getting disabled in real hardware, or in a VM case the
> corresponding guest memory getting freed from the emulator e.g. qemu/kvm). The
> system can crash as a result.
> 
> I think these local pagetables do need to be unmapped from kernel, offlined and
> removed somehow - otherwise hot-remove should fail. Could they be migrated
> alternatively e.g. to node 0 memory?  But Iiuc direct mapped pages cannot be
> migrated, correct?
> 
> What is the original reason for local node pagetable allocation with regards
> to memory hotplug? I assume we want to have hotplugged nodes use only their local
> memory, so that there are no inter-node memory dependencies for hot-add/remove.
> Are there other reasons that I am missing?

I second Vasilis.  The part1/2/3 series could be much simpler & less
riskier if we focus on the SRAT changes first, and make the local node
pagetable changes as a separate item.  Is there particular reason why
they have to be done at a same time?

Thanks,
-Toshi


