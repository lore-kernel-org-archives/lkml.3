Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759166Ab3CGEqh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 23:46:37 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:63538 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754718Ab3CGEqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 23:46:36 -0500
MIME-Version: 1.0
Date: Wed, 6 Mar 2013 20:46:35 -0800
X-Google-Sender-Auth: i_2XNWudXSBIC_9ylJatggwAoQc
Message-ID: <CANeU7Qn-5b5U_64QzFt-beP-PyAJgzz=z1100F0v5WbWqZwZOQ@mail.gmail.com>
Subject: Suggestion for fixing the variable length array used in the kernel.
From: Christopher Li <sparse@chrisli.org>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Linux-Sparse <linux-sparse@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am looking at the current sparse warning on the kernel source.
One category of those warning are produce by the variable length array.
We all know that the kernel stack has a limit so we don't want to allocate
too much stack to the variable size array.

Is there a recommended way to fix those warnings? Is it worth while to
fix it at all? I am looking forward to some kind of guideline how to handle
this.


Some of them has estimated size limited, like the one fournd in decode_rs.c

	/* Err+Eras Locator poly and syndrome poly The maximum value
	 * of nroots is 8. So the necessary stack size will be about
	 * 220 bytes max.
	 */
	uint16_t lambda[nroots + 1], syn[nroots];
	uint16_t b[nroots + 1], t[nroots + 1], omega[nroots + 1];
	uint16_t root[nroots], reg[nroots + 1], loc[nroots];

Some of them did not said the size estimation but you kind of know
they are not likely to blow up the stack:
In xen_flush_tlb_others

	struct {
		struct mmuext_op op;
#ifdef CONFIG_SMP
		DECLARE_BITMAP(mask, num_processors);
#else
		DECLARE_BITMAP(mask, NR_CPUS);
#endif
	} *args;

And also some of them are harder to tell from the context if
there will be a size limit:

int snd_pcm_hw_refine(struct snd_pcm_substream *substream,
		      struct snd_pcm_hw_params *params)
{
	unsigned int k;
	struct snd_pcm_hardware *hw;
	struct snd_interval *i = NULL;
	struct snd_mask *m = NULL;
	struct snd_pcm_hw_constraints *constrs = &substream->runtime->hw_constraints;
	unsigned int rstamps[constrs->rules_num]; <---------------------------------


Chris
