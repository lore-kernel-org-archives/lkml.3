Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544Ab3CGJgV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 04:36:21 -0500
Received: from mail-qe0-f45.google.com ([209.85.128.45]:43299 "EHLO
	mail-qe0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754905Ab3CGJgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 04:36:18 -0500
Date: Thu, 7 Mar 2013 17:36:15 +0800 (HKT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] ARM: mm: disable kmap_high_get() for SMP
In-Reply-To: <20130307081258.GA14839@lge.com>
Message-ID: <alpine.LFD.2.03.1303071721540.28820@syhkavp.arg>
References: <1362372667-953-1-git-send-email-iamjoonsoo.kim@lge.com> <alpine.LFD.2.03.1303051642110.28820@syhkavp.arg> <20130307081258.GA14839@lge.com>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Mar 2013, Joonsoo Kim wrote:

> Hello, Nicolas.
> 
> On Tue, Mar 05, 2013 at 05:36:12PM +0800, Nicolas Pitre wrote:
> > On Mon, 4 Mar 2013, Joonsoo Kim wrote:
> > 
> > > With SMP and enabling kmap_high_get(), it makes users of kmap_atomic()
> > > sequential ordered, because kmap_high_get() use global kmap_lock().
> > > It is not welcome situation, so turn off this optimization for SMP.
> > 
> > I'm not sure I understand the problem.
> > 
> > The lock taken by kmap_high_get() is released right away before that 
> > function returns and therefore this is not actually serializing 
> > anything.
> 
> Yes, you understand what I want to say correctly.
> Sorry for bad explanation.
> 
> Following is reasons why I send this patch with RFC tag.
> 
> If we have more cpus, performance degration is possible although
> it is very short time to holding the lock in kmap_high_get().
> 
> And kmap has maximum 512 entries(512 * 4K = 2M) and some mobile devices 
> has 2G memory(highmem 1G>), so probability for finding matched entry
> is approximately < 1/512. This probability can be more decreasing
> for device which have more memory. So I think that waste time to find
> matched entry is more than saved time.
> 
> Above is my humble opinion, so please let me know what I am missing.

Please look at the kmap_high_get() code again.  It performs no 
searching at all.  What it does is:

- lock the kmap array against concurrent changes

- if the given page is not highmem, unlock and return NULL

- otherwise increment that page reference count, unlock, and return the 
  mapped address for that page.

There is almost zero cost to this function, independently of the number 
of kmap entries, whereas it does save much bigger costs elsewhere when 
it is successful.


Nicolas
