Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876AbaA1X37 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 18:29:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47908 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026AbaA1X36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 18:29:58 -0500
Date: Tue, 28 Jan 2014 15:29:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Hansen <dave@sr71.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cl@linux-foundation.org,
        penberg@kernel.org, mpm@selenic.com, pshelar@nicira.com
Subject: Re: [PATCH] mm: slub: fix page->_count corruption (again)
Message-Id: <20140128152956.d5659f56ae279856731a1ac5@linux-foundation.org>
In-Reply-To: <20140128231722.E7387E6B@viggo.jf.intel.com>
References: <20140128231722.E7387E6B@viggo.jf.intel.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Jan 2014 15:17:22 -0800 Dave Hansen <dave@sr71.net> wrote:

> Commit abca7c496 notes that we can not _set_ a page->counters
> directly, except when using a real double-cmpxchg.  Doing so can
> lose updates to ->_count.
> 
> That an absolute rule:
> 
>         You may not *set* page->counters except via a cmpxchg.
> 
> Commit abca7c496 fixed this for the folks who have the slub
> cmpxchg_double code turned off at compile time, but it left the
> bad alone.  It can still be reached, and the same bug triggered
> in two cases:
> 1. Turning on slub debugging at runtime, which is available on
>    the distro kernels that I looked at.
> 2. On 64-bit CPUs with no CMPXCHG16B (some early AMD x86-64
>    cpus, evidently)
> 
> There are at least 3 ways we could fix this:
> 
> 1. Take all of the exising calls to cmpxchg_double_slab() and
>    __cmpxchg_double_slab() and convert them to take an old, new
>    and target 'struct page'.
> 2. Do (1), but with the newly-introduced 'slub_data'.
> 3. Do some magic inside the two cmpxchg...slab() functions to
>    pull the counters out of new_counters and only set those
>    fields in page->{inuse,frozen,objects}.

This code is borderline insane.

Yes, struct page is special and it's worth spending time and doing
weird things to optimise it.  But sheesh.

An alternative is to make that cmpxchg quietly go away.  Is it more
trouble than it is worth?
