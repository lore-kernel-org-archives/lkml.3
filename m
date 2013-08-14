Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760263Ab3HNXfV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 19:35:21 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:4439 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758100Ab3HNXfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 19:35:20 -0400
Message-ID: <1376523242.10300.403.camel@misato.fc.hp.com>
Subject: Re: [PATCH v2] mm/hotplug: Verify hotplug memory range
From: Toshi Kani <toshi.kani@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com,
        dave@sr71.net, isimatu.yasuaki@jp.fujitsu.com, tangchen@cn.fujitsu.com,
        vasilis.liaskovitis@profitbricks.com
Date: Wed, 14 Aug 2013 17:34:02 -0600
In-Reply-To: <20130814150901.cd430738912a893d74769e1b@linux-foundation.org>
References: <1376162252-26074-1-git-send-email-toshi.kani@hp.com>
	 <20130814150901.cd430738912a893d74769e1b@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-08-14 at 15:09 -0700, Andrew Morton wrote:
> On Sat, 10 Aug 2013 13:17:32 -0600 Toshi Kani <toshi.kani@hp.com> wrote:
> 
> > add_memory() and remove_memory() can only handle a memory range aligned
> > with section.  There are problems when an unaligned range is added and
> > then deleted as follows:
> > 
> >  - add_memory() with an unaligned range succeeds, but __add_pages()
> >    called from add_memory() adds a whole section of pages even though
> >    a given memory range is less than the section size.
> >  - remove_memory() to the added unaligned range hits BUG_ON() in
> >    __remove_pages().
> > 
> > This patch changes add_memory() and remove_memory() to check if a given
> > memory range is aligned with section at the beginning.  As the result,
> > add_memory() fails with -EINVAL when a given range is unaligned, and
> > does not add such memory range.  This prevents remove_memory() to be
> > called with an unaligned range as well.  Note that remove_memory() has
> > to use BUG_ON() since this function cannot fail.
> > 
> > ...
> >
> > --- a/mm/memory_hotplug.c
> > +++ b/mm/memory_hotplug.c
> > @@ -1069,6 +1069,22 @@ out:
> >  	return ret;
> >  }
> >  
> > +static int check_hotplug_memory_range(u64 start, u64 size)
> > +{
> > +	u64 start_pfn = start >> PAGE_SHIFT;
> > +	u64 nr_pages = size >> PAGE_SHIFT;
> > +
> > +	/* Memory range must be aligned with section */
> > +	if ((start_pfn & ~PAGE_SECTION_MASK) ||
> > +	    (nr_pages % PAGES_PER_SECTION) || (!nr_pages)) {
> > +		pr_err("Section-unaligned hotplug range: start 0x%llx, size 0x%llx\n",
> > +				start, size);
> 
> Printing a u64 is problematic.  Here you assume that u64 is implemented
> as unsigned long long.  But it can be implemented as unsigned long, by
> architectures which use include/asm-generic/int-l64.h.  Such an
> architecture will generate a compile warning here, but I can't
> immediately find a Kconfig combination which will make that happen.

Oh, I see.  Should I add the casting below and resend it to you?

                (unsigned long long)start, (unsigned long long)size);

Thanks,
-Toshi

