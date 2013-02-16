Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab3BPTic (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 14:38:32 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:55911 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136Ab3BPTib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 14:38:31 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFzTR5nBLXHe4MKtN6E7xrs3=xsbMd1aprr8Ax4mu96onw@mail.gmail.com>
References: <CA+55aFz50VvnMjoDCbg01N+rMu5vscu88kr0SV3tWLjaiL0TeA@mail.gmail.com>
	<20130213111007.GA11367@gmail.com>
	<CA+55aFxrjsVkBwUdjmc4MYvEsjEyCJZ7AFpGrWvbbQFB3EVtHA@mail.gmail.com>
	<alpine.LFD.2.02.1302140012460.22263@ionos>
	<20130214144510.GC25282@gmail.com>
	<20130214145424.GA26071@gmail.com>
	<20130214150810.GA26095@gmail.com>
	<CAE9FiQXc=7+TMwbfd20YiHNfOHX_kUOzYcVm8-uaP2R_C_1RRg@mail.gmail.com>
	<20130215114425.GD26955@gmail.com>
	<CA+55aFzTR5nBLXHe4MKtN6E7xrs3=xsbMd1aprr8Ax4mu96onw@mail.gmail.com>
Date: Sat, 16 Feb 2013 11:38:31 -0800
X-Google-Sender-Auth: iY3ofF_zeohnUCg_Nyttv3dyJJI
Message-ID: <CAE9FiQVnBeNEOgH4b+=FywMCnR-u7afADXK2KaiU+aSR+UcDYw@mail.gmail.com>
Subject: Re: [-rc7 regression] Buggy commit: "mm: use aligned zone start for
 pfn_to_bitidx calculation"
From: Yinghai Lu <yinghai@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, Greg KH <gregkh@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@ftp.linux.org.uk>,
        "Theodore Ts'o" <tytso@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>,
        Laura Abbott <lauraa@codeaurora.org>, Mel Gorman <mgorman@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 16, 2013 at 10:26 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Feb 15, 2013 at 3:44 AM, Ingo Molnar <mingo@kernel.org> wrote:
>>>
>>> c060f943d092 may be related as you config does not have
>>> CONFIG_SPARSEMEM defined.
>>
>> Right, that's the commit causing the x86 regression:
>>
>>  c060f943d0929f3e429c5d9522290584f6281d6e is the first bad commit
>>  commit c060f943d0929f3e429c5d9522290584f6281d6e
>>  Date:   Fri Jan 11 14:31:51 2013 -0800
>>
>>      mm: use aligned zone start for pfn_to_bitidx calculation
>
> Ok, looking more at this, I don't really want to revert it, and I have
> an idea of what is wrong.
>
> When we allocate the zone use bitmap, we do not take the
> zone_start_pfn into account. So I *think* that what happens is that
> "pfn_to_bitidx()" simply overruns the allocation for unaligned zonesm
> and the spinlock just happens to be right after (or the overrun causes
> some other memory corruption that then indirectly causes the spinlock
> corruption).
>
> So I'm wondering if the fix is simply something like the attached
> patch. It takes the zone_start_pfn into account when allocating the
> zone bitmap.

Yes, that is right fix.

but you forgot to update setup_usemap() for SPARSEMEM

static inline void setup_usemap(struct pglist_data *pgdat,
                                struct zone *zone, unsigned long zonesize) {}

Thanks

Yinghai
