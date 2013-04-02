Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932326Ab3DBK4b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 06:56:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35350 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760842Ab3DBK42 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 06:56:28 -0400
Date: Tue, 2 Apr 2013 11:56:25 +0100
From: Mel Gorman <mgorman@suse.de>
To: Cyril Hrubis <chrubis@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/mmap: Check for RLIMIT_AS before unmapping
Message-ID: <20130402105625.GA12855@suse.de>
References: <20130402095402.GA6568@rei>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20130402095402.GA6568@rei>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 02, 2013 at 11:54:03AM +0200, Cyril Hrubis wrote:
> This patch fixes corner case for MAP_FIXED when requested mapping length
> is larger than rlimit for virtual memory. In such case any overlapping
> mappings are unmapped before we check for the limit and return ENOMEM.
> 
> The check is moved before the loop that unmaps overlapping parts of
> existing mappings. When we are about to hit the limit (currently mapped
> pages + len > limit) we scan for overlapping pages and check again
> accounting for them.
> 
> This fixes situation when userspace program expects that the previous
> mappings are preserved after the mmap() syscall has returned with error.
> (POSIX clearly states that successfull mapping shall replace any
> previous mappings.)
> 
> This corner case was found and can be tested with LTP testcase:
> 
> testcases/open_posix_testsuite/conformance/interfaces/mmap/24-2.c
> 
> In this case the mmap, which is clearly over current limit, unmaps
> dynamic libraries and the testcase segfaults right after returning into
> userspace.
> 
> I've also looked at the second instance of the unmapping loop in the
> do_brk(). The do_brk() is called from brk() syscall and from vm_brk().
> The brk() syscall checks for overlapping mappings and bails out when
> there are any (so it can't be triggered from the brk syscall). The
> vm_brk() is called only from binmft handlers so it shouldn't be
> triggered unless binmft handler created overlapping mappings.
> 
> Signed-off-by: Cyril Hrubis <chrubis@suse.cz>

Reviewed-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
