Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946459Ab3BHOoT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 09:44:19 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:58996 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194Ab3BHOoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 09:44:18 -0500
Date: Fri, 8 Feb 2013 06:44:08 -0800
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, zab@redhat.com, bcrl@kvack.org,
        jmoyer@redhat.com, axboe@kernel.dk, viro@zeniv.linux.org.uk,
        tytso@mit.edu, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 23/32] Generic dynamic per cpu refcounting
Message-ID: <20130208144408.GY2875@htj.dyndns.org>
References: <1356573611-18590-1-git-send-email-koverstreet@google.com>
 <1356573611-18590-26-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356573611-18590-26-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing Andrew)

On Wed, Dec 26, 2012 at 06:00:02PM -0800, Kent Overstreet wrote:
> This implements a refcount with similar semantics to
> atomic_get()/atomic_dec_and_test(), that starts out as just an atomic_t
> but dynamically switches to per cpu refcounting when the rate of
> gets/puts becomes too high.
> 
> It also implements two stage shutdown, as we need it to tear down the
> percpu counts. Before dropping the initial refcount, you must call
> percpu_ref_kill(); this puts the refcount in "shutting down mode" and
> switches back to a single atomic refcount with the appropriate barriers
> (synchronize_rcu()).
> 
> It's also legal to call percpu_ref_kill() multiple times - it only
> returns true once, so callers don't have to reimplement shutdown
> synchronization.
> 
> For the sake of simplicity/efficiency, the heuristic is pretty simple -
> it just switches to percpu refcounting if there are more than x gets
> in one second (completely arbitrarily, 4096).
> 
> It'd be more correct to count the number of cache misses or something
> else more profile driven, but doing so would require accessing the
> shared ref twice per get - by just counting the number of gets(), we can
> stick that counter in the high bits of the refcount and increment both
> with a single atomic64_add(). But I expect this'll be good enough in
> practice.
> 
> Signed-off-by: Kent Overstreet <koverstreet@google.com>

What's the status of this series?  The percpu-refcnt part is still
going through review and the merge window is opening up pretty soon.
Kent, Andrew?

Thanks.

-- 
tejun
