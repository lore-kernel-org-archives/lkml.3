Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710AbaKCV6O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 16:58:14 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:49878 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbaKCV6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 16:58:12 -0500
Date: Mon, 03 Nov 2014 16:58:07 -0500 (EST)
Message-Id: <20141103.165807.2039166055692354811.davem@davemloft.net>
To: kirill@shutemov.name
Cc: hannes@cmpxchg.org, akpm@linux-foundation.org, mhocko@suse.cz,
        vdavydov@parallels.com, tj@kernel.org, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3] mm: embed the memcg pointer directly into struct
 page
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141103215206.GB24091@node.dhcp.inet.fi>
References: <20141103210607.GA24091@node.dhcp.inet.fi>
	<20141103213628.GA11428@phnom.home.cmpxchg.org>
	<20141103215206.GB24091@node.dhcp.inet.fi>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 03 Nov 2014 13:58:11 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill@shutemov.name>
Date: Mon, 3 Nov 2014 23:52:06 +0200

> On Mon, Nov 03, 2014 at 04:36:28PM -0500, Johannes Weiner wrote:
>> On Mon, Nov 03, 2014 at 11:06:07PM +0200, Kirill A. Shutemov wrote:
>> > On Sat, Nov 01, 2014 at 11:15:54PM -0400, Johannes Weiner wrote:
>> > > Memory cgroups used to have 5 per-page pointers.  To allow users to
>> > > disable that amount of overhead during runtime, those pointers were
>> > > allocated in a separate array, with a translation layer between them
>> > > and struct page.
>> > > 
>> > > There is now only one page pointer remaining: the memcg pointer, that
>> > > indicates which cgroup the page is associated with when charged.  The
>> > > complexity of runtime allocation and the runtime translation overhead
>> > > is no longer justified to save that *potential* 0.19% of memory.
>> > 
>> > How much do you win by the change?
>> 
>> Heh, that would have followed right after where you cut the quote:
>> with CONFIG_SLUB, that pointer actually sits in already existing
>> struct page padding, which means that I'm saving one pointer per page
>> (8 bytes per 4096 byte page, 0.19% of memory), plus the pointer and
>> padding in each memory section.  I also save the (minor) translation
>> overhead going from page to page_cgroup and the maintenance burden
>> that stems from having these auxiliary arrays (see deleted code).
> 
> I read the description. I want to know if runtime win (any benchmark data?)
> from moving mem_cgroup back to the struct page is measurable.
> 
> If the win is not significant, I would prefer to not occupy the padding:
> I'm sure we will be able to find a better use for the space in struct page
> in the future.

I think the simplification benefits completely trump any performan
metric.
