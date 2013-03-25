Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758745Ab3CYRQm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 13:16:42 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:34731 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758635Ab3CYRQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 13:16:40 -0400
X-AuditID: cbfee61b-b7f076d0000034b6-e4-515086768c15
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Minchan Kim <minchan@kernel.org>
Subject: Re: [RFC v7 00/11] Support vrange for anonymous page
Date: Mon, 25 Mar 2013 18:16:16 +0100
User-Agent: KMail/1.13.2 (Linux/3.5.0-rc2+; KDE/4.4.5; i686; ; )
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Michael Kerrisk <mtk.manpages@gmail.com>, Arun Sharma <asharma@fb.com>,
        John Stultz <john.stultz@linaro.org>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>, Neil Brown <neilb@suse.de>,
        Mike Hommey <mh@glandium.org>, Taras Glek <tglek@mozilla.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jason Evans <je@fb.com>, sanjay@google.com,
        Paul Turner <pjt@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Michel Lespinasse <walken@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
References: <1363073915-25000-1-git-send-email-minchan@kernel.org>
In-reply-to: <1363073915-25000-1-git-send-email-minchan@kernel.org>
MIME-version: 1.0
Message-id: <201303251816.16715.b.zolnierkie@samsung.com>
Content-type: Text/Plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsVy+t9jQd3ytoBAg70zOC3mrF/DZnF4/SYm
	iy3n7C1Wb/K1ePqpj8XixNxnrBZnfutazJw9m8mi7dg/FovLu+awWdxb85/V4vfBTnaL3sm9
	rBbLvr5ntzg14QG7xd75DSwWO1euYLX4e2U9i8XVRRtYLb4fOMpm8W9SrYOox+E375k9evd+
	ZfWY2PyO3ePp9inMHjtn3WX3WLCp1OPEk0tsHptWdQKJT5PYPe5c28PmcWLGbxaPB4c2s3j0
	Hehi9Xi/7yqbx+bT1R6fN8kFCERx2aSk5mSWpRbp2yVwZUyfs5ml4Dh/xaRlRg2M13m6GDk5
	JARMJHr+XWSBsMUkLtxbz9bFyMUhJDCdUWLZ+RssEE4Lk8TT3UvYQarYBKwkJravYgSxRQRU
	JP48/QdmCwvYSixseM4EYrMIqEo8uQMRFxVwkOicOgFsKrPAXlaJbSt2gq0TEnCS6HtwGKiB
	g4NTwFni7btCkDCvgKDEj8n3WEDCvAKWEu/+FYGEmQW0JJrfbGKEsOUlNq95yzyBUWAWko5Z
	SMpmISlbwMi8ilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4op9J72Bc1WBxiFGAg1GJh5cj
	LCBQiDWxrLgy9xCjBAezkgivlhBQiDclsbIqtSg/vqg0J7X4EKM0B4uSOO/BVutAIYH0xJLU
	7NTUgtQimCwTB6dUA6PLnfssUZxbkm3rdpvczuqOO8ZxxiHmY6h9pPv858f+ZJj9tXzb+bBH
	qXahXkmDSlTWKe+Hxz8sauRz/bN3qtXjR3Yn1hZEBIUci1K8Na+0WnFm/SmxpQ3FdXLXTxzu
	s7nxdJf3uVmdO6ef+BJSbiKymtd44Z4FxkLZ5WwTk9fFfZRQbzj7YaUSS3FGoqEWc1FxIgCm
	hKid5AIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Tuesday 12 March 2013 08:38:24 Minchan Kim wrote:
> First of all, let's define the term.
> From now on, I'd like to call it as vrange(a.k.a volatile range)
> for anonymous page. If you have a better name in mind, please suggest.
> 
> This version is still *RFC* because it's just quick prototype so
> it doesn't support THP/HugeTLB/KSM and even couldn't build on !x86.
> Before further sorting out issues, I'd like to post current direction
> and discuss it. Of course, I'd like to extend this discussion in
> comming LSF/MM.
> 
> In this version, I changed lots of thing, expecially removed vma-based
> approach because it needs write-side lock for mmap_sem, which will drop
> performance in mutli-threaded big SMP system, KOSAKI pointed out.
> And vma-based approach is hard to meet requirement of new system call by
> John Stultz's suggested semantic for consistent purged handling.
> (http://linux-kernel.2935.n7.nabble.com/RFC-v5-0-8-Support-volatile-for-anonymous-range-tt575773.html#none)
> 
> I tested this patchset with modified jemalloc allocator which was
> leaded by Jason Evans(jemalloc author) who was interest in this feature
> and was happy to port his allocator to use new system call.
> Super Thanks Jason!
> 
> The benchmark for test is ebizzy. It have been used for testing the
> allocator performance so it's good for me. Again, thanks for recommending
> the benchmark, Jason.
> (http://people.freebsd.org/~kris/scaling/ebizzy.html)
> 
> The result is good on my machine (12 CPU, 1.2GHz, DRAM 2G)
> 
> 	ebizzy -S 20
> 
> jemalloc-vanilla: 52389 records/sec
> jemalloc-vrange: 203414 records/sec
> 
> 	ebizzy -S 20 with background memory pressure
> 
> jemalloc-vanilla: 40746 records/sec
> jemalloc-vrange: 174910 records/sec

Could you please make the modified jemalloc/ebizzy available somewhere so
there is a easy way to test your patchset?

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung Poland R&D Center
