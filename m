Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759203Ab3FCXJ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 19:09:26 -0400
Received: from mail-qe0-f52.google.com ([209.85.128.52]:65152 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758645Ab3FCXJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 19:09:18 -0400
Date: Mon, 3 Jun 2013 16:09:13 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] percpu-refcount: Don't use silly cmpxchg()
Message-ID: <20130603230913.GE29989@mtj.dyndns.org>
References: <1370039205-14071-1-git-send-email-koverstreet@google.com>
 <1370300549-2177-1-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370300549-2177-1-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 03, 2013 at 04:02:29PM -0700, Kent Overstreet wrote:
> The cmpxcgh() was just to ensure the debug check didn't race, which was
> a bit excessive. The caller is supposed to do the appropriate
> synchronization, which means percpu_ref_kill() can just do a simple
> store.
> 
> Signed-off-by: Kent Overstreet <koverstreet@google.com>

Applied to percpu/for-3.11.

The only concern I have left now is that we now have bitwise-and and
test instead of just test in the hot path (get/put) to test whether
the percpu part is alive.  As x86 has single and-and-test instruction
which doesn't require an output register, this only adds a single
instruction but this may lead to more overhead on other architectures.

The and-and-test was added because RCU free needs to have access to
the percpu pointer after the pointer is killed and can be removed by
adding another field to struct percpu_ref which remembers the pointer
separately from the original percpu pointer, which I think is a better
trade-off given that it makes the hot path lighter and adding another
pointer field to struct percpu_ref isn't really gonna affect anything.
Plus, it'd also make the code simpler.

Anyways, it's not a big concern at this point and we can address it
later.

Thanks a lot, everyone!

-- 
tejun
