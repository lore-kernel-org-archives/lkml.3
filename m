Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751091AbaHME3d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 00:29:33 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:42898 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbaHME3b (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Wed, 13 Aug 2014 00:29:31 -0400
Date: Wed, 13 Aug 2014 12:29:13 +0800
From: joeyli <jlee@suse.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Takashi Iwai <tiwai@suse.de>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] Hibernate: save e820 table to snapshot header for
 comparison
Message-ID: <20140813042913.GB19409@linux-rxt1.site>
References: <1407751987-21448-1-git-send-email-jlee@suse.com>
 <20140812094136.GC3950@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140812094136.GC3950@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel, 

Thanks for your review, first!

On Tue, Aug 12, 2014 at 11:41:36AM +0200, Pavel Machek wrote:
> Hi!
> 
> > [    7.374714] e820: Check memory region: [mem 0x0000000100000000-0x000000187fffffff] usable
> > [    7.378041] PM: Image mismatch: memory map changed
> > [    7.381314] PM: Read 2398272 kbytes in 0.27 seconds (8882.48 MB/s)
> > [    7.385476] PM: Error -1 resuming
> > [    7.388730] PM: Failed to load hibernation image, recovering.
> > [    7.688989] PM: Basic memory bitmaps freed
> 
> Nice!
> 
> > +int save_mem_chk_map(struct mementry *mem_chk_map)
> 
> I'd prefer _chk_ -> _check_
>

OK, I will change the naming.
 
> > +{
> > +	int i;
> > +
> > +	for (i = 0; i < e820.nr_map; i++) {
> > +		struct e820entry *ei = &e820.map[i];
> > +
> > +		if (i > MEMCHKMAX)
> > +			break;
> 
> MEMCHKMAX -> MEM_CHECK_MAX?
> 
> What happens when there are more entries?
> 

Yes, the number 128 is from E820MAX, the legacy E820 BIOS limitation. My original thinking is keep
the size of swsusp_info in 4K then don't need change the swap accessing codes in swsusp_read() and
swsusp_write(). On the other hand, I have no machine that provides E820 entries more then 128.

hm.... but, yes, this is an magic number causes we didn't check the entries bigger than 128.
I will modify this patch to keep the pages of E820 table behind the swsusp_info header.

> > +bool check_mem_map(int mem_chk_entries, struct mementry *mem_chk_map)
> > +{
> > +	int i;
> > +	bool ret = true;
> > +
> > +	if (mem_chk_entries != e820.nr_map) {
> > +		pr_err("PM: memory check entry number %d:%d\n",
> > +			mem_chk_entries, e820.nr_map);
> > +		ret = false;
> > +		goto Print_map;
> > +	}
> 
> I'd change name to something like mem_map_matches() or mem_map_ok(),
> so that it is clear what true/false means.
> 
> Can you reduce ammount of gotos?
> 

OK, I will change naming and reduce goto.

> > +	for (i = 0; i < mem_chk_entries; i++) {
> > +		struct e820entry *ei = &e820.map[i];
> > +
> > +		if (i > MEMCHKMAX)
> > +			break;
> > +
> > +		/* check regions not E820_RAM or E820_RESERVED_KERN */
> > +		if (ei->type != E820_RAM && ei->type != E820_RESERVED_KERN) {
> > +			if (mem_chk_map[i].addr != ei->addr ||
> > +			    mem_chk_map[i].size != ei->size ||
> > +			    mem_chk_map[i].type != ei->type) {
> > +				ret = false;
> > +				goto Print_map;
> > +			}
> > +		}
> 
> Why don't you check RAM and RESERVED_KERN, too? If those changed, we
> don't want to resume, either, right?
> 

The RESERVED_KERN is boot_params.hdr.setup_data, reserved by kernel for
PCI RomImage and extend e820 entries. The E820_RAM and E820_RESERVED_KERN 
are saved in hibernate snapshot image and will restore to appropriate page
frame. If hibernate can not restore data to the original page frame, then
whole hibernate resume process will be stop. So I think don't need check
RAM and RESERVED_KERN because image saved it.

> (Plus, you only check ei->type; you should check mem_chk_map[].type,
> too AFAICT).
>

Yes, thanks for your suggestion, I will also check type of mem_chk_map.
 
> Thanks,
> 									Pavel

Thanks a lot!
Joey Lee
