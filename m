Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192AbaH3Vjv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 17:39:51 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:53997 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbaH3Vjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 17:39:49 -0400
Date: Sun, 31 Aug 2014 00:39:45 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Jens Axboe <axboe@fb.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: /proc/diskstats buglet
Message-ID: <20140830213944.GA24163@p183.telecom.by>
References: <CACVxJT8LW4NOj7ksbcmfHig7MjJTK3AabZbnzWcNPNfznwPKrw@mail.gmail.com>
 <53FC9FF5.7060106@fb.com>
 <CACVxJT_usd+8bDnctx6+4kgozE1GDONA+a+W+QWaa_tzuKCUEg@mail.gmail.com>
 <53FCA148.6020002@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53FCA148.6020002@fb.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 09:01:28AM -0600, Jens Axboe wrote:
> On 08/26/2014 09:00 AM, Alexey Dobriyan wrote:
> > On Tue, Aug 26, 2014 at 5:55 PM, Jens Axboe <axboe@fb.com> wrote:
> >> On 08/26/2014 08:47 AM, Alexey Dobriyan wrote:
> >>> Found and reproduced some time ago, almost forgot about :-)
> >>>
> >>> In part_round_stats_single(), ->stamp field is written but without
> >>> locking SMP-wise.
> >>>
> >>>     part->stamp = now;
> >>>
> >>> So, if two processes read /proc/diskstats, it is possible for "now -
> >>> part->stamp" value to become negative.
> >>>
> >>> And indeed this can happen:
> >>>
> >>> now 4294755500, ->stamp 4294755501
> >>> ------------[ cut here ]------------
> >>> WARNING: CPU: 0 PID: 1950 at block/blk-core.c:1229
> >>> part_round_stats_single+0xc0/0xd0()
> >>>  ...
> >>>  [<ffffffff811963f0>] part_round_stats_single+0xc0/0xd0
> >>>  [<ffffffff81196447>] part_round_stats+0x47/0x70
> >>>  [<ffffffff811a069d>] diskstats_show+0x8d/0x4b0
> >>>  ...
> >>>
> >>> Dunno how important used fields in /proc/diskstats but they can be
> >>> clearly bogus.
> >>
> >> Easiest fix is probably just to do the now - part->stamp math earlier,
> >> and ignore <= 0 instead of just now == part->stamp. I think that should
> >> be good enough for disk stats, and (most importantly), it would avoid
> >> the warning.
> >>
> >> Speaking of the warning, I don't see where that is. Where is it from?
> > 
> > I inserted the warning to be sure bug exists and I am not misreading the code.
> 
> Ah got it, that makes sense. Care to send a patch to just ignore <= 0
> now - part->stamp?

It will be still possible for 2 contexts to execute part_round_stats_single()
simultaneously. Should lead to double accounting?

	Alexey
