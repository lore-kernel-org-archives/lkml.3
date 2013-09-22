Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab3IVDGJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 23:06:09 -0400
Received: from imap.thunk.org ([74.207.234.97]:35557 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752599Ab3IVDGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 23:06:07 -0400
Date: Sat, 21 Sep 2013 23:05:53 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
        John Stultz <john.stultz@linaro.org>,
        Stephan Mueller <smueller@chronox.de>,
        LKML <linux-kernel@vger.kernel.org>, dave.taht@bufferbloat.net,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH,RFC] random: make fast_mix() honor its name
Message-ID: <20130922030553.GA21422@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	=?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
	John Stultz <john.stultz@linaro.org>,
	Stephan Mueller <smueller@chronox.de>,
	LKML <linux-kernel@vger.kernel.org>, dave.taht@bufferbloat.net,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>
References: <20130910211009.GI29237@thunk.org>
 <522F984C.2070909@linaro.org>
 <20130910223326.GD11063@thunk.org>
 <522FB9F1.3070905@linaro.org>
 <20130911005047.GA13315@thunk.org>
 <20130912210717.GC3809@logfs.org>
 <20130912233155.GB5279@thunk.org>
 <20130916154026.GA23345@logfs.org>
 <20130921212510.GD8606@thunk.org>
 <20130921214118.GE8606@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130921214118.GE8606@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following fast_mix function, with the loop unrolling, is about 70%
slower than your proposed version, but it's still four times faster
than the original byte-based fast_mix function.  This is what I'm
considering using as a compromise.

Any comments or objections?

     					- Ted

static void fast_mix(struct fast_pool *f, __u32 input[4])
{
	__u32		w;
	int i;
	unsigned	input_rotate = f->rotate;

#if 0
	for (i = 0; i < 4; i++) {
		w = rol32(input[i], input_rotate) ^ f->pool[i] ^
			f->pool[(i + 3) & 3];
		f->pool[i] = (w >> 3) ^ twist_table[w & 7];
		input_rotate = (input_rotate + (i ? 7 : 14)) & 31;
	}
#else   /* loop unrolled for speed */
	w = rol32(input[0], input_rotate) ^ f->pool[0] ^ f->pool[3];
	f->pool[0] = (w >> 3) ^ twist_table[w & 7];
	input_rotate = (input_rotate + 14) & 31;
	w = rol32(input[1], input_rotate) ^ f->pool[1] ^ f->pool[0];
	f->pool[1] = (w >> 3) ^ twist_table[w & 7];
	input_rotate = (input_rotate + 7) & 31;
	w = rol32(input[2], input_rotate) ^ f->pool[2] ^ f->pool[1];
	f->pool[2] = (w >> 3) ^ twist_table[w & 7];
	input_rotate = (input_rotate + 7) & 31;
	w = rol32(input[3], input_rotate) ^ f->pool[3] ^ f->pool[2];
	f->pool[3] = (w >> 3) ^ twist_table[w & 7];
	input_rotate = (input_rotate + 7) & 31;
#endif
	f->count += 16;
	f->rotate = input_rotate;
}
