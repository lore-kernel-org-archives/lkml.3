Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751690AbaIJNoG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 09:44:06 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:34029 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbaIJNoE (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Wed, 10 Sep 2014 09:44:04 -0400
Date: Wed, 10 Sep 2014 21:43:47 +0800
From: joeyli <jlee@suse.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Lee, Chun-Yi" <joeyli.kernel@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Takashi Iwai <tiwai@suse.de>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Hibernate: Do not assume the first e820 area to be RAM
Message-ID: <20140910134347.GB18567@linux-rxt1.site>
References: <1407754252-22779-1-git-send-email-jlee@suse.com>
 <1561567.ev2pEO8C5v@vostro.rjw.lan>
 <CAE9FiQUROUAxFk8_gtMp0Fu6aBLbL8GtKhJg0Y-01s4n3BDjtw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQUROUAxFk8_gtMp0Fu6aBLbL8GtKhJg0Y-01s4n3BDjtw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yinghai, 

Thanks for your review, first!

On Tue, Sep 09, 2014 at 11:08:45PM -0700, Yinghai Lu wrote:
> On Mon, Sep 8, 2014 at 3:52 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > On Monday, August 11, 2014 06:50:52 PM Lee, Chun-Yi wrote:
> >> In arch/x86/kernel/setup.c::trim_bios_range(), the codes introduced
> >> by 1b5576e6 (base on d8a9e6a5), it updates the first 4Kb of memory
> >> to be E820_RESERVED region. That's because it's a BIOS owned area
> >> but generally not listed in the E820 table:
> >>
> >> [    0.000000] e820: BIOS-provided physical RAM map:
> >> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000096fff] usable
> >> [    0.000000] BIOS-e820: [mem 0x0000000000097000-0x0000000000097fff] reserved
> >> ...
> >> [    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
> >> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> >>
> >> But the region of first 4Kb didn't register to nosave memory:
> >>
> >> [    0.000000] PM: Registered nosave memory: [mem 0x00097000-0x00097fff]
> >> [    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000fffff]
> >>
> >> The codes in e820_mark_nosave_regions() assumes the first e820 area to be
> >> RAM, so it causes the first 4Kb E820_RESERVED region ignored when register
> >> to nosave. This patch removed assumption of the first e820 area.
> >>
> >> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> >> Cc: Len Brown <len.brown@intel.com>
> >> Cc: Pavel Machek <pavel@ucw.cz>
> >> Cc: Thomas Gleixner <tglx@linutronix.de>
> >> Cc: Ingo Molnar <mingo@redhat.com>
> >> Cc: "H. Peter Anvin" <hpa@zytor.com>
> >> Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
> >
> > Thomas, Ingo, Peter, any objections here?
> >
> > If not, do you want to handle it or do you want me to do that?
> 
> Did it address any regression?
> 

I found this situation when comparing the e820 region with nosave memory address.
But, I don't know any real machine which has bug report against this.

> >
> >> ---
> >>  arch/x86/kernel/e820.c | 7 +++----
> >>  1 file changed, 3 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
> >> index 988c00a..d595240 100644
> >> --- a/arch/x86/kernel/e820.c
> >> +++ b/arch/x86/kernel/e820.c
> >> @@ -682,18 +682,17 @@ void __init parse_e820_ext(u64 phys_addr, u32 data_len)
> >>   * hibernation (32 bit) or software suspend and suspend to RAM (64 bit).
> >>   *
> >>   * This function requires the e820 map to be sorted and without any
> >> - * overlapping entries and assumes the first e820 area to be RAM.
> >> + * overlapping entries.
> >>   */
> >>  void __init e820_mark_nosave_regions(unsigned long limit_pfn)
> >>  {
> >>       int i;
> >>       unsigned long pfn;
> >>
> >> -     pfn = PFN_DOWN(e820.map[0].addr + e820.map[0].size);
> >> -     for (i = 1; i < e820.nr_map; i++) {
> >> +     for (i = 0; i < e820.nr_map; i++) {
> >>               struct e820entry *ei = &e820.map[i];
> >>
> >> -             if (pfn < PFN_UP(ei->addr))
> >> +             if (i > 0 && pfn < PFN_UP(ei->addr))
> >>                       register_nosave_region(pfn, PFN_UP(ei->addr));
> 
> could avoid the i > 0 checking.
> 
> >>
> >>               pfn = PFN_DOWN(ei->addr + ei->size);
> >>
> >
> 
> following would be better ?
> 
> @@ -682,15 +682,14 @@ void __init parse_e820_ext(u64 phys_addr, u32 data_len)
>   * hibernation (32 bit) or software suspend and suspend to RAM (64 bit).
>   *
>   * This function requires the e820 map to be sorted and without any
> - * overlapping entries and assumes the first e820 area to be RAM.
> + * overlapping entries.
>   */
>  void __init e820_mark_nosave_regions(unsigned long limit_pfn)
>  {
>      int i;
> -    unsigned long pfn;
> +    unsigned long pfn = 0;
> 
> -    pfn = PFN_DOWN(e820.map[0].addr + e820.map[0].size);
> -    for (i = 1; i < e820.nr_map; i++) {
> +    for (i = 0; i < e820.nr_map; i++) {
>          struct e820entry *ei = &e820.map[i];
> 
>          if (pfn < PFN_UP(ei->addr))

Yes, thanks for your suggestion, your change can avoid the i > 0 checking.
I will send v2 patch to add your improvement.


Thanks a lot!
Joey Lee
