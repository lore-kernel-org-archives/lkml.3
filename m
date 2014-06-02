Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375AbaFBQEG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 12:04:06 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:65376 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522AbaFBQEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 12:04:04 -0400
MIME-Version: 1.0
In-Reply-To: <20140602091427.GD3224@quack.suse.cz>
References: <1397587118-1214-1-git-send-email-dh.herrmann@gmail.com>
	<alpine.LSU.2.11.1405132118330.4401@eggly.anvils>
	<537396A2.9090609@cybernetics.com>
	<alpine.LSU.2.11.1405141456420.2268@eggly.anvils>
	<CANq1E4QgSbD9G70H7W4QeXbZ77_Kn1wV7edwzN4k4NjQJS=36A@mail.gmail.com>
	<20140602044259.GV10092@bbox>
	<20140602091427.GD3224@quack.suse.cz>
Date: Mon, 2 Jun 2014 18:04:02 +0200
Message-ID: <CANq1E4T-4dc=r0mpedY-CfDmxCO4YmDfUX4-DRP1y6darAuSWQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] File Sealing & memfd_create()
From: David Herrmann <dh.herrmann@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: Minchan Kim <minchan@kernel.org>, Hugh Dickins <hughd@google.com>,
        Tony Battersby <tonyb@cybernetics.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Michael Kerrisk <mtk.manpages@gmail.com>, Ryan Lortie <desrt@desrt.ca>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>,
        Greg Kroah-Hartman <greg@kroah.com>,
        John Stultz <john.stultz@linaro.org>,
        Kristian Hogsberg <krh@bitplanet.net>,
        Lennart Poettering <lennart@poettering.net>,
        Daniel Mack <zonque@gmail.com>, Kay Sievers <kay@vrfy.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Mon, Jun 2, 2014 at 11:14 AM, Jan Kara <jack@suse.cz> wrote:
> On Mon 02-06-14 13:42:59, Minchan Kim wrote:
>> On Mon, May 19, 2014 at 01:44:25PM +0200, David Herrmann wrote:
>> > I tried doing the page-replacement in the last 4 days, but honestly,
>> > it's far more complex than I thought. So if no-one more experienced
>> > with mm/ comes up with a simple implementation, I'll have to delay
>> > this for some more weeks.
>> >
>> > However, I still wonder why we try to fix this as part of this
>> > patchset. Using FUSE, a DIRECT-IO call can be delayed for an arbitrary
>> > amount of time. Same is true for network block-devices, NFS, iscsi,
>> > maybe loop-devices, ... This means, _any_ once mapped page can be
>> > written to after an arbitrary delay. This can break any feature that
>> > makes FS objects read-only (remounting read-only, setting S_IMMUTABLE,
>> > sealing, ..).
>> >
>> > Shouldn't we try to fix the _cause_ of this?
>>
>> I didn't follow this patchset and couldn't find what's your most cocern
>> but at a first glance, it seems you have troubled with pinned page.
>> If so, it's really big problem for CMA and I think peterz's approach(ie,
>> mm_mpin) is really make sense to me.
>   Well, his concern are pinned pages (and also pages used for direct IO and
> similar) but not because they are pinned but because they can be modified
> while someone holds reference to them. So I'm not sure Peter's patches will
> help here.

Correct, the problem is not accounting for pinned-pages, but waiting
for them to get released. Furthermore, Peter's patches make VM_PINNED
an optional feature, so we'd still miss all the short-term GUP users.
Sadly, that means we cannot even use it to test for pending GUP users.

Thanks
David
