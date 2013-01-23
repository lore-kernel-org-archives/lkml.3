Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600Ab3AWJWU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 04:22:20 -0500
Received: from mail-qa0-f42.google.com ([209.85.216.42]:60047 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754472Ab3AWJWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 04:22:18 -0500
MIME-Version: 1.0
In-Reply-To: <1358932355.12502.68.camel@smile>
References: <1358758844-24711-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1358758844-24711-2-git-send-email-andriy.shevchenko@linux.intel.com>
	<CAOh2x==FoW5Sh5KFt9iO+_04dEbwsQHJX3rsTWNqFiZqTbPn6A@mail.gmail.com>
	<1358846546.12502.57.camel@smile>
	<CAKohpo=m-s4+q+4v2v+8nzC32FRzJAb58no2hZLV_5QqTj4wig@mail.gmail.com>
	<1358932355.12502.68.camel@smile>
Date: Wed, 23 Jan 2013 14:52:17 +0530
Message-ID: <CAKohpo=BHGukSQJJGUS=H++qzxME3aEEQZR8QiyHPU8LabHsSw@mail.gmail.com>
Subject: Re: [PATCH 2/2] dw_dmac: return proper residue value
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 January 2013 14:42, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> Ah, you mean the dma_cookie_status returns DMA_SUCCESS in case
> active_list is empty, don't you?

Bingo!!

> Yesterday I spent in testing of different approaches. First of all, the
> calculation of the sent amount is nicer when ctlhi/ctllo is used and it
> works fine. But the approach, when we substract length of sent
> descriptors, is losing data. Namely, we have no information how big is
> the master descriptor (it has total length of the entire chain). So, I'm
> thinking how to solve this one. Otherwise it seems simpler than mine
> first idea.

I was planning to give you another review comment which i thought i will
give later :)

It looks to be a bit wrong to have individual lengths in all descriptors leaving
the first one :)

This is the descriptor struct:

struct dw_desc {
	/* FIRST values the hardware uses */
	struct dw_lli			lli;

	/* THEN values for driver housekeeping */
	struct list_head		desc_node;
	struct list_head		tx_list;
	struct dma_async_tx_descriptor	txd;
	size_t				len;
};

Firstly i believe we can have a union of both list_heads as only one is used
at any time. Can you patch it down?

Second to solve your problem, you can add another field here: total_len.
I know it will consume 4 bytes per desc but i think that's the drawback we need
to accept.
