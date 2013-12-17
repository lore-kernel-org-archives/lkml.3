Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063Ab3LQAq5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 19:46:57 -0500
Received: from www.sr71.net ([198.145.64.142]:43276 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691Ab3LQAqz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 19:46:55 -0500
Message-ID: <52AF9EB9.7080606@sr71.net>
Date: Mon, 16 Dec 2013 16:45:45 -0800
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Pravin B Shelar <pshelar@nicira.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>, Pekka Enberg <penberg@kernel.org>
Subject: Re: [RFC][PATCH 0/7] re-shrink 'struct page' when SLUB is on.
References: <20131213235903.8236C539@viggo.jf.intel.com> <20131216160128.aa1f1eb8039f5eee578cf560@linux-foundation.org>
In-Reply-To: <20131216160128.aa1f1eb8039f5eee578cf560@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2013 04:01 PM, Andrew Morton wrote:
> On Fri, 13 Dec 2013 15:59:03 -0800 Dave Hansen <dave@sr71.net> wrote:
>> SLUB depends on a 16-byte cmpxchg for an optimization.  For the
>> purposes of this series, I'm assuming that it is a very important
>> optimization that we desperately need to keep around.
> 
> What if we don't do that.

I'll do some testing and see if I can coax out any delta from the
optimization myself.  Christoph went to a lot of trouble to put this
together, so I assumed that he had a really good reason, although the
changelogs don't really mention any.

I honestly can't imagine that a cmpxchg16 is going to be *THAT* much
cheaper than a per-page spinlock.  The contended case of the cmpxchg is
way more expensive than spinlock contention for sure.

fc9bb8c768's commit message says:
>     The doublewords must be properly aligned for cmpxchg_double to work.
>     Sadly this increases the size of page struct by one word on some architectures.
>     But as a resultpage structs are now cacheline aligned on x86_64.

I'm not sure what aligning them buys us though.  I think I just
demonstrated that cache footprint is *way* more important than alignment.
