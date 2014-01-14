Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752428AbaANEGs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 23:06:48 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:36997 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbaANEGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 23:06:44 -0500
To: Kent Overstreet <kmo@daterainc.com>
Cc: Hugh Dickins <hughd@google.com>, Jens Axboe <axboe@kernel.dk>,
        Shaohua Li <shli@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: Re: next bio iters break discard?
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <alpine.LSU.2.11.1401121909160.1239@eggly.anvils>
	<20140114023346.GN9037@kmo>
Date: Mon, 13 Jan 2014 23:06:33 -0500
In-Reply-To: <20140114023346.GN9037@kmo> (Kent Overstreet's message of "Mon,
	13 Jan 2014 18:33:46 -0800")
Message-ID: <yq161pnmcl2.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130005 (Ma Gnus v0.5) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Kent" == Kent Overstreet <kmo@daterainc.com> writes:

Kent,

Kent> I think for discards we can deal with this easily enough -
Kent> __blk_recalc_rq_segments() will have to special case them - but
Kent> there's a similar (but worse) issue with WRITE_SAME, and looking
Kent> at the code it does attempt to merge WRITE_SAME requests too.

DISCARD bios have no payload going down the stack. They get a payload
attached in the sd driver and will therefore have a single bvec at
completion time.

WRITE_SAME bios have a single bvec payload throughout their lifetime.

For both these types of requests we never attempt to merge the actual
payloads. But the block range worked on may shrink or grow as the bio is
split or merged going down the stack.

IOW, DISCARD, WRITE SAME and the impending COPY requests do not have a
1:1 mapping between the block range worked on and the size of any bvecs
attached. Your recent changes must have changed the way we handled that
in the past.

I'll take a look tomorrow...

-- 
Martin K. Petersen	Oracle Linux Engineering
