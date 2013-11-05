Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893Ab3KEQmv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 11:42:51 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:59650 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147Ab3KEQmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 11:42:49 -0500
X-AuditID: cbfec7f5-b7ef66d00000795a-84-52792007d599
From: Tomasz Figa <t.figa@samsung.com>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: linux-next@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Chris Mason <chris.mason@fusionio.com>
Subject: Re: Boot failure on Arndale with next-20131105
Date: Tue, 05 Nov 2013 17:42:39 +0100
Message-id: <1451170.jb5zbRXgpt@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11.2 (Linux/3.11.5-gentoo; KDE/4.11.2; x86_64; ; )
In-reply-to: <CAHbNUh1Cw3bc4WR0VcD1H_eKYqGBtv_215_euh6mwTbZ41ejUw@mail.gmail.com>
References: <CAHbNUh1Cw3bc4WR0VcD1H_eKYqGBtv_215_euh6mwTbZ41ejUw@mail.gmail.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJLMWRmVeSWpSXmKPExsVy+t/xa7rsCpVBBh/3y1isvtvPZtG67jiL
	xeVdc9gsDi5sY7Ro/7uXzYHV40nTT2aPy2dLPe5c28Pm8XmTXABLFJdNSmpOZllqkb5dAlfG
	h91LmAuWO1U0T9jH1MDYZd3FyMkhIWAi0TP5GBOELSZx4d56ti5GLg4hgaWMEj/3nYZyupgk
	vnQ2soJUsQmoSXxueMQGYosI6Eg8WLSXBcRmFuhmlOg/IgliCwuYS5z6sRmshkVAVWLz8+9g
	NbwCmhIrNywEm8MvoC7xbttTsM2iAm4S038cZO5i5ODgFAiWmL+6BCQsJBAg8f5ZDytEq6DE
	j8n3oFbJS+zbP5UVwtaSWL/zONMERsFZSMpmISmbhaRsASPzKkbR1NLkguKk9FwjveLE3OLS
	vHS95PzcTYyQ4P66g3HpMatDjAIcjEo8vJYXyoOEWBPLiitzDzFKcDArifAe+18RJMSbklhZ
	lVqUH19UmpNafIiRiYNTqoExxO5o+POztvl53OZa6QHLNt0t/dL3vPPx/Hl336SvFgqX9j44
	p5PNLvbQMQOeHIkvyeXqYtP2PJhbXsEumVUyfUnxEqd97C8OCt1creor23rzT843YdsFL1we
	Gcxeq60yR9ZHhadbdW7E5ZCXcgarI/JUZ64y9dGLtm27vW+iwfT7ekc/b2VTYinOSDTUYi4q
	TgQAA3qqokwCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday 05 of November 2013 17:19:00 Tushar Behera wrote:
> Hi,
> 
> We are having a boot-time kernel panic on Samsung's Exynos5250-based
> Arndale board with next-20131105. Bisect points to following commit.
> 
> <<<
> commit febca1baea1cfe2d7a0271385d89b03d5fb34f94
> Author: Chris Mason <chris.mason@fusionio.com>
> Date:   Thu Oct 31 13:32:42 2013 -0600
> 
>     block: setup bi_vcnt on clones
> 
>     commit 9fc6286f347d changed the cloning code to make clones cheaper for
>     the case where we don't need to clone the iovec array.  But,
>     the new clone needs the bi_vnct from the original.
> 
>     Signed-off-by: Chris Mason <chris.mason@fusionio.com>
>     Signed-off-by: Jens Axboe <axboe@kernel.dk>
> >>>
> 
> Reverting above commit, Arndale is able to boot again.

I can confirm exactly the same behavior on Exynos 4210-based Trats board,
with exactly the same bisection results.

Also note that I spotted multiple build failures in block layer during
the bisection.

# skip: [c198aee7e9a801d32cee4607453871cff7c43e6c] ceph: Convert to immutable biovecs
git bisect skip c198aee7e9a801d32cee4607453871cff7c43e6c
# skip: [3d75d579a04be023552b45f791cd95f5b6a45ba6] block: Kill bio_segments()/bi_vcnt usage
git bisect skip 3d75d579a04be023552b45f791cd95f5b6a45ba6
# skip: [f2da8e013088387e5e61930b715ff0defea9aa58] aoe: Convert to immutable biovecs
git bisect skip f2da8e013088387e5e61930b715ff0defea9aa58
# skip: [44931ee84c6362ec8d9b97b02432760035a2b639] block: Kill bio_pair_split()
git bisect skip 44931ee84c6362ec8d9b97b02432760035a2b639
# skip: [d4fbf2c24290f237cf5989d8e4c8507969ae2299] rbd: Refactor bio cloning, don't clone biovecs
git bisect skip d4fbf2c24290f237cf5989d8e4c8507969ae2299
# skip: [cc4067bd8adeb5507829b7ae8f17211aab5d1e9d] block: Kill bio_iovec_idx(), __bio_iovec()
git bisect skip cc4067bd8adeb5507829b7ae8f17211aab5d1e9d
# skip: [a040a44b1c2b56fed3ebef3734681b6fe473fd33] dm: Refactor for new bio cloning/splitting
git bisect skip a040a44b1c2b56fed3ebef3734681b6fe473fd33
# skip: [948809ba161cce4060977970e1133a66fffc3449] block: Introduce new bio_split()
git bisect skip 948809ba161cce4060977970e1133a66fffc3449
# skip: [7e814b148e1127be7c32bb438ceaadb0b6e33042] block: Remove bi_idx hacks
git bisect skip 7e814b148e1127be7c32bb438ceaadb0b6e33042
# skip: [3dbdffcc4c1ffb7d7ac631be55cd5aab3b258614] block: Immutable bio vecs
git bisect skip 3dbdffcc4c1ffb7d7ac631be55cd5aab3b258614
# skip: [919b8823a6ef27103fe3abd05026f87ad85ed1ad] block: Convert drivers to immutable biovecs
git bisect skip 919b8823a6ef27103fe3abd05026f87ad85ed1ad
# skip: [5fbc9c23b291ac8d8ffe73cbc55cd7cb9c57fd04] block: Convert bio_copy_data() to bvec_iter
git bisect skip 5fbc9c23b291ac8d8ffe73cbc55cd7cb9c57fd04
# skip: [2771aecc0cc33d70747c8335239c20c9ff87ac67] block: Generic bio chaining
git bisect skip 2771aecc0cc33d70747c8335239c20c9ff87ac67
# skip: [9fc6286f347d00528adcdcf12396d220f47492ed] block: Don't save/copy bvec array anymore, share when cloning
git bisect skip 9fc6286f347d00528adcdcf12396d220f47492ed
# skip: [85bf1bd38f53e93712a149a8c31abe6936494d64] block: Rename bio_split() -> bio_pair_split()
git bisect skip 85bf1bd38f53e93712a149a8c31abe6936494d64
# skip: [5d1f127c3e0c57d64ce75ee04a0db2b40a3e21df] block: Convert bio_for_each_segment() to bvec_iter
git bisect skip 5d1f127c3e0c57d64ce75ee04a0db2b40a3e21df
# skip: [eb225c28a0b3f730b50f096946aee5eef2cb9969] bio-integrity: Convert to bvec_iter
git bisect skip eb225c28a0b3f730b50f096946aee5eef2cb9969

Full bisect log:

# bad: [98dd2f31c585ddcfb78ce14f8d0efcb52e5ed2e9] Add linux-next specific files for 20131105
# good: [355e62f5ad12b005c862838156262eb2df2f8dff] of/irq: Fix potential buffer overflow
git bisect start 'v3.13-sdhci-fail' '355e62f'
# good: [c2e1895eb0564667394c28e1ecd772ee6a27ea54] Merge remote-tracking branch 'crypto/master'
git bisect good c2e1895eb0564667394c28e1ecd772ee6a27ea54
# bad: [7f1546329db7b573f3a640d75cc1af40dc5ee9ed] Merge remote-tracking branch 'tip/auto-latest'
git bisect bad 7f1546329db7b573f3a640d75cc1af40dc5ee9ed
# bad: [07d76d00209c960eb8bcce9dfdf36e7edd458da3] Merge remote-tracking branch 'md/for-next'
git bisect bad 07d76d00209c960eb8bcce9dfdf36e7edd458da3
# good: [36753aaf7758b2089a55b3e67e6f1a9242462bb4] Merge remote-tracking branch 'drm-tegra/drm/for-next'
git bisect good 36753aaf7758b2089a55b3e67e6f1a9242462bb4
# good: [ca5f026efedeb01287863a9c7e1d5fdaf82d196d] Merge remote-tracking branch 'virtio/virtio-next'
git bisect good ca5f026efedeb01287863a9c7e1d5fdaf82d196d
# bad: [67b89a119b28377ced0ea844aed51f74976db36b] Merge remote-tracking branch 'block/for-next'
git bisect bad 67b89a119b28377ced0ea844aed51f74976db36b
# bad: [26f584573c613d2a7292d8c66dc063ae2bece90a] Merge branch 'for-3.13/core' into for-next
git bisect bad 26f584573c613d2a7292d8c66dc063ae2bece90a
# bad: [0023432f72015803e050e381f12a724e59eded74] dm: fix missing bi_remaining accounting
git bisect bad 0023432f72015803e050e381f12a724e59eded74
# good: [8b6df54182c8c775f346a0703ccb4c531c18a8f0] block: Use rw_copy_check_uvector()
git bisect good 8b6df54182c8c775f346a0703ccb4c531c18a8f0
# skip: [c198aee7e9a801d32cee4607453871cff7c43e6c] ceph: Convert to immutable biovecs
git bisect skip c198aee7e9a801d32cee4607453871cff7c43e6c
# skip: [3d75d579a04be023552b45f791cd95f5b6a45ba6] block: Kill bio_segments()/bi_vcnt usage
git bisect skip 3d75d579a04be023552b45f791cd95f5b6a45ba6
# bad: [febca1baea1cfe2d7a0271385d89b03d5fb34f94] block: setup bi_vcnt on clones
git bisect bad febca1baea1cfe2d7a0271385d89b03d5fb34f94
# skip: [f2da8e013088387e5e61930b715ff0defea9aa58] aoe: Convert to immutable biovecs
git bisect skip f2da8e013088387e5e61930b715ff0defea9aa58
# skip: [44931ee84c6362ec8d9b97b02432760035a2b639] block: Kill bio_pair_split()
git bisect skip 44931ee84c6362ec8d9b97b02432760035a2b639
# skip: [d4fbf2c24290f237cf5989d8e4c8507969ae2299] rbd: Refactor bio cloning, don't clone biovecs
git bisect skip d4fbf2c24290f237cf5989d8e4c8507969ae2299
# good: [971ecaf05e526fee159a3711a7ee831fe4d397ab] dm: Use bvec_iter for dm_bio_record()
git bisect good 971ecaf05e526fee159a3711a7ee831fe4d397ab
# skip: [cc4067bd8adeb5507829b7ae8f17211aab5d1e9d] block: Kill bio_iovec_idx(), __bio_iovec()
git bisect skip cc4067bd8adeb5507829b7ae8f17211aab5d1e9d
# skip: [a040a44b1c2b56fed3ebef3734681b6fe473fd33] dm: Refactor for new bio cloning/splitting
git bisect skip a040a44b1c2b56fed3ebef3734681b6fe473fd33
# skip: [948809ba161cce4060977970e1133a66fffc3449] block: Introduce new bio_split()
git bisect skip 948809ba161cce4060977970e1133a66fffc3449
# skip: [7e814b148e1127be7c32bb438ceaadb0b6e33042] block: Remove bi_idx hacks
git bisect skip 7e814b148e1127be7c32bb438ceaadb0b6e33042
# skip: [3dbdffcc4c1ffb7d7ac631be55cd5aab3b258614] block: Immutable bio vecs
git bisect skip 3dbdffcc4c1ffb7d7ac631be55cd5aab3b258614
# skip: [919b8823a6ef27103fe3abd05026f87ad85ed1ad] block: Convert drivers to immutable biovecs
git bisect skip 919b8823a6ef27103fe3abd05026f87ad85ed1ad
# skip: [5fbc9c23b291ac8d8ffe73cbc55cd7cb9c57fd04] block: Convert bio_copy_data() to bvec_iter
git bisect skip 5fbc9c23b291ac8d8ffe73cbc55cd7cb9c57fd04
# skip: [2771aecc0cc33d70747c8335239c20c9ff87ac67] block: Generic bio chaining
git bisect skip 2771aecc0cc33d70747c8335239c20c9ff87ac67
# skip: [9fc6286f347d00528adcdcf12396d220f47492ed] block: Don't save/copy bvec array anymore, share when cloning
git bisect skip 9fc6286f347d00528adcdcf12396d220f47492ed
# skip: [85bf1bd38f53e93712a149a8c31abe6936494d64] block: Rename bio_split() -> bio_pair_split()
git bisect skip 85bf1bd38f53e93712a149a8c31abe6936494d64
# skip: [5d1f127c3e0c57d64ce75ee04a0db2b40a3e21df] block: Convert bio_for_each_segment() to bvec_iter
git bisect skip 5d1f127c3e0c57d64ce75ee04a0db2b40a3e21df
# skip: [eb225c28a0b3f730b50f096946aee5eef2cb9969] bio-integrity: Convert to bvec_iter
git bisect skip eb225c28a0b3f730b50f096946aee5eef2cb9969
# good: [3d14ea51119f4afad8d0ac4d206923bca744684d] block: Convert bio_iovec() to bvec_iter
git bisect good 3d14ea51119f4afad8d0ac4d206923bca744684d
# good: [b62ad46ef438c94164b33cd58ad945ebc210c67b] block: fixup rq/bio dcache page flushing for ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE
git bisect good b62ad46ef438c94164b33cd58ad945ebc210c67b
# first bad commit: [febca1baea1cfe2d7a0271385d89b03d5fb34f94] block: setup bi_vcnt on clones

Best regards,
Tomasz

