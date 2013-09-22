Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713Ab3IVVBy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 17:01:54 -0400
Received: from plane.gmane.org ([80.91.229.3]:59495 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751647Ab3IVVBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 17:01:53 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?ISO-8859-1?Q?J=F6rg-Volker_Peetz?= <jvpeetz@web.de>
Subject: Re: [PATCH,RFC] random: make fast_mix() honor its name
Date: Sun, 22 Sep 2013 23:01:42 +0200
Message-ID: <523F5AB6.8070107@web.de>
References: <20130910211009.GI29237@thunk.org> <522F984C.2070909@linaro.org> <20130910223326.GD11063@thunk.org> <522FB9F1.3070905@linaro.org> <20130911005047.GA13315@thunk.org> <20130912210717.GC3809@logfs.org> <20130912233155.GB5279@thunk.org> <20130916154026.GA23345@logfs.org> <20130921212510.GD8606@thunk.org> <20130921214118.GE8606@thunk.org> <20130922030553.GA21422@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: p5b37bf44.dip0.t-ipconnect.de
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130821 Icedove/17.0.8
In-Reply-To: <20130922030553.GA21422@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Theodore,

Theodore Ts'o wrote, on 09/22/2013 05:05:
> The following fast_mix function, with the loop unrolling, is about 70%
> slower than your proposed version, but it's still four times faster
> than the original byte-based fast_mix function.  This is what I'm
> considering using as a compromise.
> 
> Any comments or objections?
> 
>      					- Ted
> 
> static void fast_mix(struct fast_pool *f, __u32 input[4])
> {
> 	__u32		w;
> 	int i;
> 	unsigned	input_rotate = f->rotate;
> 
> #if 0
> 	for (i = 0; i < 4; i++) {
> 		w = rol32(input[i], input_rotate) ^ f->pool[i] ^
> 			f->pool[(i + 3) & 3];
> 		f->pool[i] = (w >> 3) ^ twist_table[w & 7];
> 		input_rotate = (input_rotate + (i ? 7 : 14)) & 31;
> 	}
> #else   /* loop unrolled for speed */
> 	w = rol32(input[0], input_rotate) ^ f->pool[0] ^ f->pool[3];
> 	f->pool[0] = (w >> 3) ^ twist_table[w & 7];
> 	input_rotate = (input_rotate + 14) & 31;
> 	w = rol32(input[1], input_rotate) ^ f->pool[1] ^ f->pool[0];
> 	f->pool[1] = (w >> 3) ^ twist_table[w & 7];
> 	input_rotate = (input_rotate + 7) & 31;
> 	w = rol32(input[2], input_rotate) ^ f->pool[2] ^ f->pool[1];
> 	f->pool[2] = (w >> 3) ^ twist_table[w & 7];
> 	input_rotate = (input_rotate + 7) & 31;
> 	w = rol32(input[3], input_rotate) ^ f->pool[3] ^ f->pool[2];
> 	f->pool[3] = (w >> 3) ^ twist_table[w & 7];
> 	input_rotate = (input_rotate + 7) & 31;
> #endif
> 	f->count += 16;
> 	f->rotate = input_rotate;
> }
> 

just out of interest I would like to ask why this mixing function has to be that
complicated. For example, even if the input is always 0 and the pool is seeded
with pool[0] = 1 (as in your test program) this algorithm generates some
(predictable) pseudo-random numbers in the pool. Is this necessary?

To just mix in some random input filling the whole pool (seeded again with
pool[0] = 1) something as "simple" as

          f->pool[0] = rol32(input[0], f->pool[2] & 31) ^ f->pool[1];
          f->pool[1] = rol32(input[1], f->pool[3] & 31) ^ f->pool[2];
          f->pool[2] = rol32(input[2], f->pool[0] & 31) ^ f->pool[3];
          f->pool[3] = rol32(input[3], f->pool[1] & 31) ^ f->pool[0];

would suffice, although I didn't do any statistical tests.

Best regards,
Jörg-Volker.
-- 


