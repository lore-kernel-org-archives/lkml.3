Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759766AbaGXS7n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 14:59:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:43770 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759341AbaGXS7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 14:59:42 -0400
Date: Thu, 24 Jul 2014 20:59:38 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>,
        Jakub Jelinek <jakub@redhat.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Random panic in load_balance() with 3.16-rc
Message-ID: <20140724185938.GN3935@laptop>
References: <CA+55aFwQSmBAs=QH9jAZz5JY7YFrDeuPH1RjFH+YKVr2NQM38g@mail.gmail.com>
 <CA+55aFzDWritxv5RiqwcZ1qCKJQKK-Lw6StYFF7qx5YWgiCUTQ@mail.gmail.com>
 <20140723182518.GD3935@laptop>
 <CA+55aFyFT9n5wUNifEHY6+t2bEcD91kL7+dqXuBMSMJvLeDDJQ@mail.gmail.com>
 <20140723184111.GG3935@laptop>
 <CA+55aFwQfwfAP6U77_nD_mSvoygj=cZ09N644hKRtzgLnEqhZQ@mail.gmail.com>
 <20140723190230.GH3935@laptop>
 <CA+55aFyM1wqTLK0m4GQJ28f=z0iZE87=xk+1z-vm+PH1_d8nKw@mail.gmail.com>
 <53D064C7.5050807@daenzer.net>
 <CA+55aFyJhqiPv0kQ+51=Ei-zaAO+0JszxtnEyx-Gbto3SE00xw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyJhqiPv0kQ+51=Ei-zaAO+0JszxtnEyx-Gbto3SE00xw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 11:47:17AM -0700, Linus Torvalds wrote:
> However, that constant spilling part just counts as "too stupid to
> live". The real bug is this:
> 
>         movq    $load_balance_mask, -136(%rbp)  #, %sfp
>         subq    $184, %rsp      #,
> 
> where gcc creates the stack frame *after* having already used it to
> save that constant *deep* below the stack frame.
> 
> The x86-64 ABI specifies a 128-byte red-zone under the stack pointer,
> and this is ok by that limit. It looks like it's illegal (136 > 128),
> but the fact is, we've had four "pushq"s to update %rsp since loading
> the frame pointer, so it's just *barely* legal with the red-zoning.
> 
> But we build the kernel with -mno-red-zone. We do *not* follow the
> x86-64 ABI wrt redzoning, because we *cannot*: interrupts while in
> kernel mode *will* use the stack without a redzone. So that
> "-mno-red-zone" is not some "optional guideline". It's a hard and
> harsh requirement for the kernel, and gcc-4.9 is a buggy piece of shit
> for ignoring it. And your bug happens becuase you happen to hit an
> interrupt _just_ in that single instruction window (or perhaps hit
> some other similar case and corrupted kernel data structures earlier).

Ooh, shiny, I so missed all that (also didn't know about red-zones
etc..).

Glad this got sorted.
