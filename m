Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147Ab3KERie (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 12:38:34 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:48988 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732Ab3KERic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 12:38:32 -0500
Message-ID: <52792D13.70704@wwwdotorg.org>
Date: Tue, 05 Nov 2013 10:38:27 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Tomasz Figa <t.figa@samsung.com>, Tushar Behera <tushar.behera@linaro.org>
CC: linux-next@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Chris Mason <chris.mason@fusionio.com>
Subject: Re: Boot failure on Arndale with next-20131105
References: <CAHbNUh1Cw3bc4WR0VcD1H_eKYqGBtv_215_euh6mwTbZ41ejUw@mail.gmail.com> <1451170.jb5zbRXgpt@amdc1227>
In-Reply-To: <1451170.jb5zbRXgpt@amdc1227>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2013 09:42 AM, Tomasz Figa wrote:
> Hi,
> 
> On Tuesday 05 of November 2013 17:19:00 Tushar Behera wrote:
>> Hi,
>>
>> We are having a boot-time kernel panic on Samsung's Exynos5250-based
>> Arndale board with next-20131105. Bisect points to following commit.
>>
>> <<<
>> commit febca1baea1cfe2d7a0271385d89b03d5fb34f94
>> Author: Chris Mason <chris.mason@fusionio.com>
>> Date:   Thu Oct 31 13:32:42 2013 -0600
>>
>>     block: setup bi_vcnt on clones
>>
>>     commit 9fc6286f347d changed the cloning code to make clones cheaper for
>>     the case where we don't need to clone the iovec array.  But,
>>     the new clone needs the bi_vnct from the original.
>>
>>     Signed-off-by: Chris Mason <chris.mason@fusionio.com>
>>     Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> >>>
>>
>> Reverting above commit, Arndale is able to boot again.
> 
> I can confirm exactly the same behavior on Exynos 4210-based Trats board,
> with exactly the same bisection results.

Despite the backtrace looking different, reverting that commit also
solves the boot failures on the Tegra-based "Beaver" board.

> Also note that I spotted multiple build failures in block layer during
> the bisection.

I note that compiling next-20131105 generates quite a few warnings re:
uninitialized variables. Reverting the commit doesn't solve those.

> block/blk-merge.c: In function ‘blk_bio_map_sg’:
> block/blk-merge.c:133:8: warning: ‘bvprv.bv_len’ may be used uninitialized in this function [-Wmaybe-uninitialized]
> block/blk-merge.c:233:23: note: ‘bvprv.bv_len’ was declared here
> block/blk-merge.c:133:8: warning: ‘bvprv.bv_offset’ may be used uninitialized in this function [-Wmaybe-uninitialized]
> block/blk-merge.c:233:23: note: ‘bvprv.bv_offset’ was declared here
> block/blk-merge.c:133:8: warning: ‘bvprv.bv_page’ may be used uninitialized in this function [-Wmaybe-uninitialized]
> block/blk-merge.c:233:23: note: ‘bvprv.bv_page’ was declared here
> block/blk-merge.c: In function ‘blk_rq_map_sg’:
> block/blk-merge.c:133:8: warning: ‘bvprv.bv_page’ may be used uninitialized in this function [-Wmaybe-uninitialized]
> block/blk-merge.c:171:23: note: ‘bvprv.bv_page’ was declared here
> block/blk-merge.c:133:8: warning: ‘bvprv.bv_offset’ may be used uninitialized in this function [-Wmaybe-uninitialized]
> block/blk-merge.c:171:23: note: ‘bvprv.bv_offset’ was declared here
> block/blk-merge.c:133:8: warning: ‘bvprv.bv_len’ may be used uninitialized in this function [-Wmaybe-uninitialized]
> block/blk-merge.c:171:23: note: ‘bvprv.bv_len’ was declared here
> block/blk-merge.c: In function ‘attempt_merge’:
> block/blk-merge.c:108:7: warning: ‘end_bv.bv_offset’ may be used uninitialized in this function [-Wmaybe-uninitialized]
> block/blk-merge.c:89:17: note: ‘end_bv.bv_offset’ was declared here
> block/blk-merge.c:108:7: warning: ‘end_bv.bv_page’ may be used uninitialized in this function [-Wmaybe-uninitialized]
> block/blk-merge.c:89:17: note: ‘end_bv.bv_page’ was declared here
> block/blk-merge.c:108:7: warning: ‘end_bv.bv_len’ may be used uninitialized in this function [-Wmaybe-uninitialized]
> block/blk-merge.c:89:17: note: ‘end_bv.bv_len’ was declared here

