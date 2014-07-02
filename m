Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288AbaGBSYS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 14:24:18 -0400
Received: from www.sr71.net ([198.145.64.142]:42745 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754536AbaGBSYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 14:24:16 -0400
Message-ID: <53B44E4E.6020706@sr71.net>
Date: Wed, 02 Jul 2014 11:24:14 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: David Nellans <david@nellans.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "riel@redhat.com" <riel@redhat.com>,
        "mgorman@suse.de" <mgorman@suse.de>
Subject: Re: [PATCH 7/7] x86: mm: set TLB flush tunable to sane value (33)
References: <20140701164845.8D1A5702@viggo.jf.intel.com> <20140701164856.3020D644@viggo.jf.intel.com> <53B44C9A.9070808@nellans.org>
In-Reply-To: <53B44C9A.9070808@nellans.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2014 11:16 AM, David Nellans wrote:
> Intuition here is that invalidate caused refills will almost always
> be serviced from the L2 or better since we've recently walked to
> modify the page needing flush and thus pre-warmed the caches for any
> refill? Or is this an artifact of the flush/refill test setup?

There are lots of caches in place, not just the CPU's normal L1/2/3
memory caches.  See "4.10.3 Paging-Structure Caches" in the Intel SDM.
I _believe_ TLB misses can be serviced from these caches and their
purpose is to avoid going out to memory (or the memory caches).

So I think the effect that we're seeing is from _all_ of the caches,
plus prefetching.  If you start a prefetch for a TLB miss before you
actually start to run the instruction needing the TLB entry, you will
pay less than the entire cost of going out to memory (or the memory caches).
