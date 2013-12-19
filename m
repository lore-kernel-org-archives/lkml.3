Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755704Ab3LSTOs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 14:14:48 -0500
Received: from www.sr71.net ([198.145.64.142]:42636 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753631Ab3LSTOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 14:14:47 -0500
Message-ID: <52B345A3.6090700@sr71.net>
Date: Thu, 19 Dec 2013 11:14:43 -0800
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Pravin B Shelar <pshelar@nicira.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>, Pekka Enberg <penberg@kernel.org>
Subject: Re: [RFC][PATCH 0/7] re-shrink 'struct page' when SLUB is on.
References: <20131213235903.8236C539@viggo.jf.intel.com>	<20131216160128.aa1f1eb8039f5eee578cf560@linux-foundation.org>	<52AF9EB9.7080606@sr71.net>	<0000014301223b3e-a73f3d59-8234-48f1-9888-9af32709a879-000000@email.amazonses.com>	<52B23CAF.809@sr71.net> <20131218164109.5e169e258378fac44ec5212d@linux-foundation.org>
In-Reply-To: <20131218164109.5e169e258378fac44ec5212d@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2013 04:41 PM, Andrew Morton wrote:
> So your scary patch series which shrinks struct page while retaining
> the cmpxchg_double() might reclaim most of this loss?

Well, this is cool.  Except for 1 case out of 14 (1024 bytes with the
alloc all / free all loops), my patched kernel either outperforms or
matches both of the existing cases.

To recap, we have two workloads, essentially the time to free an "old"
kmalloc which is not cache-warm (mode=0) and the time to free one which
is warm since it was just allocated (mode=1).

This is tried for 3 different kernel configurations:
1. The default today, SLUB with a 64-byte 'struct page' using cmpxchg16
2. Same kernel source as (1), but with SLUB's compile-time options
   changed to disable CMPXCHG16 and not align 'struct page'
3. Patched kernel to internally align th SLUB data so that we can both
   have an unaligned 56-byte 'struct page' and use the CMPXCHG16
   optimization.

> https://docs.google.com/spreadsheet/ccc?key=0AgUCVXtr5IwedDNXb1FLNEFqVHdSNDF6YktYZTBndEE&usp=sharing

I'll respin the patches a bit and send out another version with some
small updates.
