Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141AbaHLJlm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 05:41:42 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58538 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754987AbaHLJlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 05:41:39 -0400
Date: Tue, 12 Aug 2014 11:41:36 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        Takashi Iwai <tiwai@suse.de>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Lee, Chun-Yi" <jlee@suse.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] Hibernate: save e820 table to snapshot header for
 comparison
Message-ID: <20140812094136.GC3950@amd.pavel.ucw.cz>
References: <1407751987-21448-1-git-send-email-jlee@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407751987-21448-1-git-send-email-jlee@suse.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> [    7.374714] e820: Check memory region: [mem 0x0000000100000000-0x000000187fffffff] usable
> [    7.378041] PM: Image mismatch: memory map changed
> [    7.381314] PM: Read 2398272 kbytes in 0.27 seconds (8882.48 MB/s)
> [    7.385476] PM: Error -1 resuming
> [    7.388730] PM: Failed to load hibernation image, recovering.
> [    7.688989] PM: Basic memory bitmaps freed

Nice!

> +int save_mem_chk_map(struct mementry *mem_chk_map)

I'd prefer _chk_ -> _check_

> +{
> +	int i;
> +
> +	for (i = 0; i < e820.nr_map; i++) {
> +		struct e820entry *ei = &e820.map[i];
> +
> +		if (i > MEMCHKMAX)
> +			break;

MEMCHKMAX -> MEM_CHECK_MAX?

What happens when there are more entries?

> +bool check_mem_map(int mem_chk_entries, struct mementry *mem_chk_map)
> +{
> +	int i;
> +	bool ret = true;
> +
> +	if (mem_chk_entries != e820.nr_map) {
> +		pr_err("PM: memory check entry number %d:%d\n",
> +			mem_chk_entries, e820.nr_map);
> +		ret = false;
> +		goto Print_map;
> +	}

I'd change name to something like mem_map_matches() or mem_map_ok(),
so that it is clear what true/false means.

Can you reduce ammount of gotos?

> +	for (i = 0; i < mem_chk_entries; i++) {
> +		struct e820entry *ei = &e820.map[i];
> +
> +		if (i > MEMCHKMAX)
> +			break;
> +
> +		/* check regions not E820_RAM or E820_RESERVED_KERN */
> +		if (ei->type != E820_RAM && ei->type != E820_RESERVED_KERN) {
> +			if (mem_chk_map[i].addr != ei->addr ||
> +			    mem_chk_map[i].size != ei->size ||
> +			    mem_chk_map[i].type != ei->type) {
> +				ret = false;
> +				goto Print_map;
> +			}
> +		}

Why don't you check RAM and RESERVED_KERN, too? If those changed, we
don't want to resume, either, right?

(Plus, you only check ei->type; you should check mem_chk_map[].type,
too AFAICT).

Thanks,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
