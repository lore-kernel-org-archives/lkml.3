Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936145Ab3DITxI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 15:53:08 -0400
Received: from mail-qe0-f45.google.com ([209.85.128.45]:36950 "EHLO
	mail-qe0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936080Ab3DITxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 15:53:05 -0400
Date: Tue, 9 Apr 2013 12:52:59 -0700
From: Tejun Heo <tj@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Vivek Goyal <vgoyal@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, Milan Broz <gmazyland@gmail.com>,
        dm-devel@redhat.com, Andi Kleen <andi@firstfloor.org>,
        dm-crypt@saout.de, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Christian Schmidt <schmidt@digadd.de>
Subject: Re: dm-crypt parallelization patches
Message-ID: <20130409195259.GL6186@mtj.dyndns.org>
References: <20130328185327.GF14088@htj.dyndns.org>
 <20130328193343.GA15969@redhat.com>
 <20130328194443.GG14088@htj.dyndns.org>
 <20130328203808.GC15969@redhat.com>
 <20130328204522.GA25501@mtj.dyndns.org>
 <Pine.LNX.4.64.1304091242350.10025@file.rdu.redhat.com>
 <20130409175753.GA6186@mtj.dyndns.org>
 <Pine.LNX.4.64.1304091402150.10025@file.rdu.redhat.com>
 <20130409181031.GC6186@mtj.dyndns.org>
 <Pine.LNX.4.64.1304091450410.26327@file.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1304091450410.26327@file.rdu.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 09, 2013 at 03:42:16PM -0400, Mikulas Patocka wrote:
> If I drop ifdefs, it doesn't compile (because other cgroup stuff it 
> missing).
> 
> So I enabled bio cgroups.
> 
> bio_associate_current can't be used, because by the time we allocate the 
> outgoing write bio, we are no longer in the process that submitted the 
> original bio.

Oh, I suppose it'd need some massaging to selectively turn off the
cgroup part.

> Anyway, I tried to reproduce in dm-crypt what bio_associate_current does - 

and we probably need to change that to bio_associate_task().

> in the submitting process I record "ioc" and "css" fields in "dm_crypt_io" 
> structure and set these fields on all outgoing bios. It has no effect on 
> performance, it is as bad as if I hadn't done it.

A good way to verify that the tagging is correct would be configuring
io limits in block cgroup and see whether the limits are correctly
applied when going through dm-crypt (please test with direct-io or
reads, writeback is horribly broken, sorry).working correctly, maybe
plugging is the overriding factor?

Thanks.

-- 
tejun
