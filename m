Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050Ab3EVKeN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 06:34:13 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:45222 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755882Ab3EVKeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 06:34:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Toshi Kani <toshi.kani@hp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, isimatu.yasuaki@jp.fujitsu.com,
        vasilis.liaskovitis@profitbricks.com, Len Brown <lenb@kernel.org>,
        linux-mm@kvack.org
Subject: Re: [PATCH 2/2 v2, RFC] Driver core: Introduce offline/online callbacks for memory blocks
Date: Wed, 22 May 2013 12:42:50 +0200
Message-ID: <2525744.qpOuRMa9WS@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <519C4D6E.6080902@cn.fujitsu.com>
References: <1576321.HU0tZ4cGWk@vostro.rjw.lan> <1824290.fKsAJTo9gA@vostro.rjw.lan> <519C4D6E.6080902@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, May 22, 2013 12:45:34 PM Tang Chen wrote:
> Hi Rafael,
> 
> On 05/21/2013 07:15 PM, Rafael J. Wysocki wrote:
> ......
> >>> +		mem->state = to_state;
> >>> +		if (to_state == MEM_ONLINE)
> >>> +			mem->last_online = online_type;
> >>
> >> Why do we need to remember last online type ?
> >>
> >> And as far as I know, we can obtain which zone a page was in last time it
> >> was onlined by check page->flags, just like online_pages() does. If we
> >> use online_kernel or online_movable, the zone boundary will be
> >> recalculated.
> >> So we don't need to remember the last online type.
> >>
> >> Seeing from your patch, I guess memory_subsys_online() can only handle
> >> online and offline. So mem->last_online is used to remember what user has
> >> done through the original way to trigger memory hot-remove, right ? And
> >> when
> >> user does it in this new way, it just does the same thing as user does last
> >> time.
> >>
> >> But I still think we don't need to remember it because if finally you call
> >> online_pages(), it just does the same thing as last time by default.
> >>
> >> online_pages()
> >> {
> >> 	......
> >> 	if (online_type == ONLINE_KERNEL ......
> >>
> >> 	if (online_type == ONLINE_MOVABLE......
> >>
> >> 	zone = page_zone(pfn_to_page(pfn));
> >>
> >> 	/* Here, the page will be put into the zone which it belong to last
> >> time. */
> >
> > To be honest, it wasn't entirely clear to me that online_pages() would do the
> > same thing as last time by default.  Suppose, for example, that the previous
> > online_type was ONLINE_MOVABLE.  How online_pages() is supposed to know that
> > it should do the move_pfn_zone_right() if we don't tell it to do that?  Or
> > is that unnecessary, because it's already been done previously?
> 
> Yes, it is unnecessary. move_pfn_zone_right/left() will modify the zone 
> related
> bits in page->flags. But when the page is offline, the zone related bits in
> page->flags will not change. So when it is online again, by dafault, it 
> will
> be in the zone which it was in last time.
> 
> ......
> 
> >>
> >> I just thought of it. Maybe I missed something in your design. Please tell
> >> me if I'm wrong.
> >
> > Well, so what should be passed to __memory_block_change_state() in
> > memory_subsys_online()?  -1?
> 
> If you want to keep the last time status, you can pass ONLINE_KEEP.
> Or -1 is all right.
> 
> Thanks. :)

OK, thanks for the info.

Since the $subject patch is on my acpi-hotplug branch which has gone public
already (and cannot be rebased), I'll prepare a patch with the change you're
recommending on top of it.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
