Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756704Ab3H3RVY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 13:21:24 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:63633 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426Ab3H3RVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 13:21:23 -0400
MIME-Version: 1.0
Date: Fri, 30 Aug 2013 10:21:22 -0700
Message-ID: <CAOMFOmXfw2DkesOYip9VFDdUQgVN48qbJfuertPaSCz5aGdaeA@mail.gmail.com>
Subject: do_div() silently truncates "base" to 32bit
From: Anatol Pomozov <anatol.pomozov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        bernie@develer.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


I was debugging weird "zero divide" problem in CFQ code below


static u64 cfqg_prfill_avg_queue_size(struct seq_file *sf,
      struct blkg_policy_data *pd, int off)
{
    struct cfq_group *cfqg = pd_to_cfqg(pd);
    u64 samples = blkg_stat_read(&cfqg->stats.avg_queue_size_samples);
    u64 v = 0;

    if (samples) {
        v = blkg_stat_read(&cfqg->stats.avg_queue_size_sum);
        do_div(v, samples);
    }
    __blkg_prfill_u64(sf, pd, v);
    return 0;
}


do_div() crashes says "zero divide". It is weird because just a few
lines above we check divider for zero.


The problem comes from include/asm-generic/div64.h file that
implements do_div() as macros:

# define do_div(n,base) ({ \
    uint32_t __base = (base); \
    uint32_t __rem; \
    __rem = ((uint64_t)(n)) % __base; \
    (n) = ((uint64_t)(n)) / __base; \
    __rem; \
 })


Do you see the problem?

The problem here is that "base" argument is truncated to 32bit, but in
the function above "sample" is 64bit variable. If sample's 32 low bits
are zero - we have a crash. in fact we have incorrect behavior any
time when high 32bits are non-zero.


My question is why the base is 32bit? Why not to use 64bit arguments?

Ideally if this macros is converted to a function so compiler will
warn us about unexpected truncation like this. But in this case it
will be hard to do as "n" parameter both input and output.
