Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935812Ab3DIS53 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 14:57:29 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:33669 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762666Ab3DIS51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 14:57:27 -0400
Date: Tue, 9 Apr 2013 11:57:21 -0700
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Mike Snitzer <snitzer@redhat.com>, Milan Broz <gmazyland@gmail.com>,
        dm-devel@redhat.com, Andi Kleen <andi@firstfloor.org>,
        dm-crypt@saout.de, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Christian Schmidt <schmidt@digadd.de>
Subject: Re: dm-crypt parallelization patches
Message-ID: <20130409185721.GF6186@mtj.dyndns.org>
References: <20130328185327.GF14088@htj.dyndns.org>
 <20130328193343.GA15969@redhat.com>
 <20130328194443.GG14088@htj.dyndns.org>
 <20130328203808.GC15969@redhat.com>
 <20130328204522.GA25501@mtj.dyndns.org>
 <Pine.LNX.4.64.1304091242350.10025@file.rdu.redhat.com>
 <20130409175753.GA6186@mtj.dyndns.org>
 <Pine.LNX.4.64.1304091402150.10025@file.rdu.redhat.com>
 <20130409181031.GC6186@mtj.dyndns.org>
 <20130409184248.GO6320@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130409184248.GO6320@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Apr 09, 2013 at 02:42:48PM -0400, Vivek Goyal wrote:
> I guess plugging boundary is more important than issuing order as 
> block layer should take care of mering the bio and put in right
> order (attempt_plug_merge()).

Yeah, the exact order probably doesn't affect things too much but it's
just a nice design principle to follow - if you're gonna step in in
the middle and meddle with requests, preserve as much context as
reasonably possible, and it's not like preserving that order is
difficult.

> But to make use of plugging boundary, one would probably still need
> submission using single thread.

It doesn't have to a specific task.  Whoever finishes the last bio /
segment / whatever in the plugging domain can issue all of them.  I
probably am missing details but the overall mechanism can be pretty
simple.  Just keep the bios from the same plugging domain in the
received order along with an atomic counter and issue them all when
the counter hits zero.  No need to fiddle with sorting or whatever.

> And if one is using single thread for submission, one will still get
> good performance (even if you are not using bio_associate_current()), as
> by default all bio will go to submitting thread's context.

And destroy all per-ioc and cgroup logics in block layer in the
process.

Thanks.

-- 
tejun
