Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758876Ab3FMTfZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 15:35:25 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:57428 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999Ab3FMTfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 15:35:24 -0400
Date: Thu, 13 Jun 2013 12:35:14 -0700
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kent Overstreet <koverstreet@google.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Jens Axboe <axboe@kernel.dk>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Jeff Layton <jlayton@redhat.com>,
        "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH] Percpu tag allocator
Message-ID: <20130613193514.GD13970@mtj.dyndns.org>
References: <1371009804-11596-1-git-send-email-koverstreet@google.com>
 <20130612163854.91da28042ab7a943b69a5970@linux-foundation.org>
 <20130613020536.GA10979@localhost>
 <20130612200311.7f9d938a.akpm@linux-foundation.org>
 <20130613185318.GB12075@mtj.dyndns.org>
 <20130613120439.fe56d178a1143089136fdacc@linux-foundation.org>
 <20130613191507.GB13970@mtj.dyndns.org>
 <20130613122339.239a721d097a64435817a780@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130613122339.239a721d097a64435817a780@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jun 13, 2013 at 12:23:39PM -0700, Andrew Morton wrote:
> > The lowest number guarantee makes them different.  Maybe tag
> > allocation can be layered on top as a caching layer, I don't know, but
> > at any rate we need at least two different operation modes.
> 
> Why?  Tag allocation doesn't care about the values - just that they be
> unique.

Hmmm?  Confused.  I was talking about other existing idr users which
need lowest-available allocation.  Tag allocation doesn't care.  ID
allocators do.

> > Maybe we can layer things so that we have percpu layer on top of
> > id[r|a] and, say, mapping id to point is still done by idr, or the
> > percpu tag allocator uses ida for tag chunk allocations, but it's
> > still gonna be something extra on top.
> 
> It's not obvious that explicit per-cpu is needed.  Get an ID from
> ida_get_new_above(), multiply it by 16 and store that in device-local
> storage, along with a 16-bit bitmap.  Blam, 30 lines of code and the
> ida_get_new_above() cost is reduced 16x and it's off the map.

I'm fairly sure it'd have to be per-cpu.  The idr allocation is
reduced 16x but now each of those 16 slots needs to be allocated.  The
problem hasn't gone away and we do need some sort of utility to help
that as drivers tend to resort to things like linear bitmap scan
combined with test_and_set_bit() making one cacheline extremely hot.

> Or perhaps you can think of something smarter, but first you have to
> start thinking of solutions rather than trying to find problems :(

I don't know.  It's pretty clear to me that we at least need two
different operation modes from the two conflicting requirements - one
with strict allocation ordering and the other with very high
scalability.  Please note that I'm not saying they both can't be built
into id[r|a], but we *need* two different operation modes.

Thanks.

-- 
tejun
