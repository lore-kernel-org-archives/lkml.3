Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722AbaAJWYL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 17:24:11 -0500
Received: from mta-out.inet.fi ([195.156.147.13]:56562 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751263AbaAJWYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 17:24:07 -0500
Date: Sat, 11 Jan 2014 00:23:15 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Alex Thorlton <athorlton@sgi.com>, Mel Gorman <mgorman@suse.de>,
        Andrea Arcangeli <aarcange@redhat.com>
Cc: linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rik van Riel <riel@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Al Viro <viro@zeniv.linux.org.uk>, Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] mm: thp: Add per-mm_struct flag to control THP
Message-ID: <20140110222315.GA7931@node.dhcp.inet.fi>
References: <1389383718-46031-1-git-send-email-athorlton@sgi.com>
 <20140110202310.GB1421@node.dhcp.inet.fi>
 <20140110220155.GD3066@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140110220155.GD3066@sgi.com>
User-Agent: Mutt/1.5.22.1-rc1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 10, 2014 at 04:01:55PM -0600, Alex Thorlton wrote:
> On Fri, Jan 10, 2014 at 10:23:10PM +0200, Kirill A. Shutemov wrote:
> > Do you know what cause the difference? I prefer to fix THP instead of
> > adding new knob to disable it.
> 
> The issue is that when you touch 1 byte of an untouched, contiguous 2MB
> chunk, a THP will be handed out, and the THP will be stuck on whatever
> node the chunk was originally referenced from.  If many remote nodes
> need to do work on that same chunk, they'll be making remote accesses.
> With THP disabled, 4K pages can be handed out to separate nodes as
> they're needed, greatly reducing the amount of remote accesses to
> memory.

I think this problem *potentially* could be fixed by NUMA balancer.
(Although, I don't really know how balancer works...)

If we see NUMA hint faults for addresses in different 4k pages inside huge
page from more then one node, we could split the huge page.

Mel, is it possible? Do we collect enough info to make the decision?

-- 
 Kirill A. Shutemov
