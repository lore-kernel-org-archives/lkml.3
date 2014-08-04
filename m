Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132AbaHDOxD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 10:53:03 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:36732 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbaHDOxB (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Mon, 4 Aug 2014 10:53:01 -0400
Date: Mon, 4 Aug 2014 22:52:47 +0800
From: joeyli <jlee@suse.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Hibernate: check unsafe page should not in e820 reserved
 region
Message-ID: <20140804145247.GD16024@linux-rxt1.site>
References: <1407148396-21405-1-git-send-email-jlee@suse.com>
 <s5hlhr4v32f.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hlhr4v32f.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Takashi, 

First, thanks for your review!

On Mon, Aug 04, 2014 at 02:42:32PM +0200, Takashi Iwai wrote:
> At Mon,  4 Aug 2014 18:33:16 +0800,
> Lee, Chun-Yi wrote:
> > 
> > When the machine doesn't well handle the e820 persistent when hibernate
> > resuming, then it may causes page fault when writing image to snapshot
> > buffer:
> > 
> > [   17.929495] BUG: unable to handle kernel paging request at ffff880069d4f000
> > [   17.933469] IP: [<ffffffff810a1cf0>] load_image_lzo+0x810/0xe40
> > [   17.933469] PGD 2194067 PUD 77ffff067 PMD 2197067 PTE 0
> > [   17.933469] Oops: 0002 [#1] SMP
> > ...
> > 
> > The ffff880069d4f000 page is in e820 reserved region of resume boot
> > kernel:
> > 
> > [    0.000000] BIOS-e820: [mem 0x0000000069d4f000-0x0000000069e12fff] reserved
> > ...
> > [    0.000000] PM: Registered nosave memory: [mem 0x69d4f000-0x69e12fff]
> > 
> > So snapshot.c mark the pfn to forbidden pages map. But, this
> > page is also in the memory bitmap in snapshot image because it's an
> > original page used by image kernel, so it will also mark as an
> > unsafe(free) page in prepare_image().
> > 
> > That means the page in e820 when resuming mark as "forbidden" and
> > "free", it causes get_buffer() treat it as an allocated unsafe page.
> > Then snapshot_write_next() return this page to load_image, load_image
> > writing content to this address, but this page didn't really allocated
> > . So, we got page fault.
> > 
> > Although the root cause is from BIOS, I think aggressive check and
> > significant message in kernel will better then a page fault for
> > issue tracking, especially when serial console unavailable.
> > 
> > This patch adds code in mark_unsafe_pages() for check does free pages in
> > nosave region. If so, then it print message and return fault to stop whole
> > S4 resume process:
> > 
> > [    8.166004] PM: Image loading progress:   0%
> > [    8.658717] PM: 0x6796c000 in e820 nosave regsion: [mem 0x6796c000-0x6796cfff]
> > [    8.918737] PM: Read 2511940 kbytes in 1.04 seconds (2415.32 MB/s)
> > [    8.926633] PM: Error -14 resuming
> > [    8.933534] PM: Failed to load hibernation image, recovering.
> > 
> > Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> > Cc: Len Brown <len.brown@intel.com>
> > Cc: Pavel Machek <pavel@ucw.cz>
> > Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
> > ---
> >  kernel/power/snapshot.c | 24 +++++++++++++++++++++++-
> >  1 file changed, 23 insertions(+), 1 deletion(-)
> > 
> > diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
> > index 98c3b34..e6db5a8 100644
> > --- a/kernel/power/snapshot.c
> > +++ b/kernel/power/snapshot.c
> > @@ -730,6 +730,28 @@ static void mark_nosave_pages(struct memory_bitmap *bm)
> >  	}
> >  }
> >  
> > +static bool is_nosave_page(unsigned long pfn)
> > +{
> > +	struct nosave_region *region;
> > +
> > +	if (list_empty(&nosave_regions))
> > +		return 0;
> 
> Just a nitpicking: this should be "false" for consistency.
> But, looking further at the code:
> 

Yes, should using return false;

> > +
> > +	list_for_each_entry(region, &nosave_regions, list) {
> > +		if (pfn >= region->start_pfn && pfn < region->end_pfn) {
> > +			pr_err("PM: %#010llx in e820 nosave regsion: "
> > +			       "[mem %#010llx-%#010llx]\n",
> > +			       (unsigned long long) pfn << PAGE_SHIFT,
> > +			       (unsigned long long) region->start_pfn << PAGE_SHIFT,
> > +			       ((unsigned long long) region->end_pfn << PAGE_SHIFT)
> > +					- 1);
> > +			return true;
> > +		}
> > +	}
> > +
> > +	return false;
> 
> I think the above empty check can be removed completely.
> 
> 
> Takashi

Thanks for your suggestion, I will remove the empty check.


Regards
Joey Lee
