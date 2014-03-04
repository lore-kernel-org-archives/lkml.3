Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319AbaCDRLS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 12:11:18 -0500
Received: from www.sr71.net ([198.145.64.142]:46168 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754354AbaCDRLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 12:11:17 -0500
Message-ID: <53160932.6060200@sr71.net>
Date: Tue, 04 Mar 2014 09:11:14 -0800
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Pradeep Sawlani <pradeep.sawlani@gmail.com>,
        Hugh Dickins <hughd@google.com>,
        Izik Eidus <izik.eidus@ravellosystems.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Chris Wright <chrisw@sous-sol.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        MEMORY MANAGEMENT <linux-mm@kvack.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Suri Maddhula <surim@amazon.com>, Matt Wilson <msw@amazon.com>,
        Anthony Liguori <aliguori@amazon.com>,
        Pradeep Sawlani <sawlani@amazon.com>
Subject: Re: [PATCH RFC 0/1] ksm: check and skip page, if it is already scanned
References: <1393901333-5569-1-git-send-email-pradeep.sawlani@gmail.com>
In-Reply-To: <1393901333-5569-1-git-send-email-pradeep.sawlani@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2014 06:48 PM, Pradeep Sawlani wrote:
> Patch uses two bits to detect if page is scanned, one bit for odd cycle
> and other for even cycle. This adds one more bit in page flags and
> overloads existing bit (PG_owner_priv_1).
> Changes are based of 3.4.79 kernel, since I have used that for verification.
> Detail discussion can be found at https://lkml.org/lkml/2014/2/13/624
> Suggestion(s) are welcome for alternative solution in order to avoid one more
> bit in page flags.

Allocate a big bitmap (depends on how many pages you are scanning).
Hash the page's pfn and index in to the bitmap.  If the bit is set,
don't scan the page.  If not set, then set it.  Vary the hash for each
scanning pass to reduce the same collision happening repeatedly.  Clear
the bitmap before each scan.

You'll get plenty of collisions, especially for a small table, but who
cares?

The other option is to bloat anon_vma instead, and only do one scan for
each anon_vma that shares the same root.  That's a bit more invasive though.
