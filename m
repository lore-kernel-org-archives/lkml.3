Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956AbaI2L4X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 07:56:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:37389 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbaI2L4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 07:56:22 -0400
Date: Mon, 29 Sep 2014 13:56:20 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: dave@sr71.net, linux-kernel@vger.kernel.org, mingo@kernel.org,
        eranian@google.com, x86@kernel.org, Andi Kleen <ak@linux.intel.com>,
        torvalds@linux-foundation.org,
        Vitaly Mayatskikh <v.mayatskih@gmail.com>
Subject: Re: [PATCH 2/2] x86: Only do a single page fault for
 copy_from_user_nmi
Message-ID: <20140929115620.GH5430@worktop>
References: <1411774277-4198-1-git-send-email-andi@firstfloor.org>
 <1411774277-4198-3-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411774277-4198-3-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 04:31:17PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> When copy_from_user_nmi faults the copy_user_tail code ends
> up "replaying" the page faults to compute the exact tail bytes,
> (added with 112958).

That is a wrong way to quote commits in two ways;

  1) Linus 'requires' you use 12 character abreviated hashes (because
     we've already seen collisions with the default 8), yet you use 6.

  2) the recommended quoting style is:

    1129585a08ba ("x86: introduce copy_user_handle_tail() routine")

You _should_ know this.

> So we do an expensive page fault. And then we do it *again*.
> 
> This ends up being very expensive in the PMI handler for any
> page fault on a stack access, and is one the more common
> causes for the NMI handler exceeding its runtime limit.
> 
>   1)   0.109 us    |        copy_from_user_nmi();
>   1)               |        copy_from_user_nmi() {
>   1)               |          __do_page_fault() {
>   1)               |            bad_area_nosemaphore() {
>   1)               |              __bad_area_nosemaphore() {
>   1)               |                no_context() {
>   1)               |                  fixup_exception() {
>   1)               |                    search_exception_tables() {
>   1)   0.079 us    |                      search_extable();
>   1)   0.409 us    |                    }
>   1)   0.757 us    |                  }
>   1)   1.106 us    |                }
>   1)   1.466 us    |              }
>   1)   1.793 us    |            }
>   1)   2.233 us    |          }
>   1)               |          copy_user_handle_tail() {
>   1)               |            __do_page_fault() {
>   1)               |              bad_area_nosemaphore() {
>   1)               |                __bad_area_nosemaphore() {
>   1)               |                  no_context() {
>   1)               |                    fixup_exception() {
>   1)               |                      search_exception_tables() {
>   1)   0.060 us    |                        search_extable();
>   1)   0.412 us    |                      }
>   1)   0.764 us    |                    }
>   1)   1.074 us    |                  }
>   1)   1.389 us    |                }
>   1)   1.665 us    |              }
>   1)   2.002 us    |            }
>   1)   2.784 us    |          }
>   1)   6.230 us    |        }
> 
> The NMI code actually doesn't care about the exact tail value. It only
> needs to know if a fault happened (!= 0)

For now, changing the semantics of the function seems like a sure way to
fail in the future though.

> So check for in_nmi() in copy_user_tail and don't bother with the exact
> tail check. This way we save the extra ~2.7us.
> 
> In theory we could also duplicate the whole copy_*_ path for cases
> where the caller doesn't care about the exact bytes. But that
> seems overkill for just this issue, and I'm not sure anyone
> else cares about how fast this is. The simpler check works
> as well for now.

So I don't get that code, but why not fix it in general? Taking two
faults seems silly.
