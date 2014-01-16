Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655AbaAPBj5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 20:39:57 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:27220 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbaAPBjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 20:39:52 -0500
To: Kent Overstreet <kmo@daterainc.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hugh Dickins <hughd@google.com>, Jens Axboe <axboe@kernel.dk>,
        Shaohua Li <shli@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: next bio iters break discard?
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <alpine.LSU.2.11.1401121909160.1239@eggly.anvils>
	<20140114023346.GN9037@kmo> <yq161pnmcl2.fsf@sermon.lab.mkp.net>
	<20140114044841.GO9037@kmo> <yq1ob3el3mr.fsf@sermon.lab.mkp.net>
	<20140114222424.GA7333@moria.home.lan>
Date: Wed, 15 Jan 2014 20:39:42 -0500
In-Reply-To: <20140114222424.GA7333@moria.home.lan> (Kent Overstreet's message
	of "Tue, 14 Jan 2014 14:24:24 -0800")
Message-ID: <yq11u08yaap.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130005 (Ma Gnus v0.5) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Kent" == Kent Overstreet <kmo@daterainc.com> writes:

Kent> Side note, one of the things on my todo list/wishlist is make a
Kent> separate enum for bio type - bare flush, normal read/write, scsi
Kent> command, discard and write same. In particular with bi_size
Kent> meaning different things depending on the type of the command, I
Kent> think having an enum we can switch off of where appropriate
Kent> instead of a bunch of random flags will make things a hell of a
Kent> lot saner.

Yeah. That's one of the reasons we cleaned up the merge flags and
introduced bio_has_data() and bio_is_rw().

Kent> There's also that horrible hack in the scsi (?) code Christoph
Kent> added for discards - where the driver adds a page to the bio - if
Kent> the driver is counting the number of segments _after_ that god
Kent> only knows what is supposed to happen.

I manually do the bookkeeping in the SCSI disk driver. I.e. LLDs are
explicitly told to perform a 512-byte transfer. And when they're done I
complete bi_size bytes to the block layer. Kind of ugly but it's an
unfortunate side effect of bi_size being both the size of the
scatterlist and the block count. I did consider making them separate
entities but that means struct bio will grow for no reason for the
common case of read/write. Didn't seem worth the hassle...

Kent> Does the below patch look like what we want? I'm assuming that if
Kent> multiple WRITE_SAME bios are merged, since they're all writing the
Kent> same data we can consider the entire request to be a single
Kent> segment.

Looks OK to me.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
