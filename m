Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693Ab3GIJWe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 05:22:34 -0400
Received: from smtp1.uu.se ([130.238.7.54]:53005 "EHLO smtp1.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753315Ab3GIJWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 05:22:32 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <20955.54667.360558.574423@pilspetsen.it.uu.se>
Date: Tue, 9 Jul 2013 11:19:07 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Joe Perches <joe@perches.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Tim Abbott" <tabbott@ksplice.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] lib: One less subtraction in binary search iterations.
Newsgroups: gmane.linux.kernel
In-Reply-To: <51DBC021.5040805@synopsys.com>
References: <1373152062-28164-1-git-send-email-wedsonaf@gmail.com>
	<1373173169.1943.1.camel@joe-AO722>
	<CANeycqqGYKs+Q+_6zpjfdQ+y-QBZLD+jGdU9-YJi9XaYXyCv-w@mail.gmail.com>
	<51DBC021.5040805@synopsys.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vineet Gupta writes:
 > On 07/09/2013 09:21 AM, Wedson Almeida Filho wrote:
 > > On Sat, Jul 6, 2013 at 9:59 PM, Joe Perches <joe@perches.com> wrote:
 > >>
 > >> Not correct.
 > >>
 > >>>       while (start < end) {
 > >>> -             size_t mid = start + (end - start) / 2;
 > >>> +             size_t mid = (start + end) / 2;
 > >>
 > >>         size_t start = 0x80000000;
 > >>         size_t end   = 0x80000001;
 > > 
 > > Good point, they aren't equivalent in all cases.
 > > 
 > > For the overflow to happen though, we need an array with at least
 > > N/2+1 entries, where N is the address space size. The array wouldn't
 > > fit in addressable memory if the element size is greater than 1, so
 > > this can only really happen when the element size is 1. Even then, it
 > > would require the kernel range to be greater than half of all
 > > addressable memory, and allow an allocation taking that much memory. I
 > > don't know all architectures where linux runs, but I don't think such
 > > configuration is likely to exist.
 > > 
 > 
 > It does. In ARC port (arch/arc), the untranslated address space starts at
 > 0x8000_0000 and this is where kernel is linked at. So all ARC kernel addresses
 > (code/data) lie in that range. This means you don't need special corner case for
 > this trip on ARC - it will break rightaway - unless I'm missing something.

start and end aren't addresses but array indices relative to 'base'.
So even on ARC you should be safe, as long as no array has SIZE_MAX/2
or more elements.

I'm however far from convinced this micro-optimization is worth the
obvious source code quality reduction.  Surely the eliminated subtraction
is in the noise compared to the multiplies, indirect function calls,
and memory dereferences (in the cmp functions)?

It should be possible to eliminate the multiplies, since no array can
cross the -1/0 address boundary.  But even that is questionable: does
anyone have perf data showing that bsearch performance is a problem?
