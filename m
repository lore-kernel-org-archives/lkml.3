Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161040AbaKNNI2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 08:08:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60777 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933890AbaKNNI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 08:08:26 -0500
Date: Fri, 14 Nov 2014 14:08:22 +0100
From: Michal Hocko <mhocko@suse.cz>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Hugh Dickins <hughd@google.com>, Michel Lespinasse <walken@google.com>,
        Andrea Argangeli <andrea@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Daniel Forrest <dan.forrest@ssec.wisc.edu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: anon_vma accumulating for certain load still not addressed
Message-ID: <20141114130822.GC22857@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
back in 2012 [1] there was a discussion about a forking load which
accumulates anon_vmas. There was a trivial test case which triggers this
and can potentially deplete the memory by local user.

We have a report for an older enterprise distribution where nsd is
suffering from this issue most probably (I haven't debugged it throughly
but accumulating anon_vma structs over time sounds like a good enough
fit) and has to be restarted after some time to release the accumulated
anon_vma objects.

There was a patch which tried to work around the issue [2] but I do not
see any follow ups nor any indication that the issue would be addressed
in other way. 

The test program from [1] was running for around 39 mins on my laptop
and here is the result:

$ date +%s; grep anon_vma /proc/slabinfo
1415960225
anon_vma           11664  11900    160   25    1 : tunables    0    0    0 : slabdata    476    476      0

$ ./a # The reproducer

$ date +%s; grep anon_vma /proc/slabinfo
1415962592
anon_vma           34875  34875    160   25    1 : tunables    0    0    0 : slabdata   1395   1395      0

$ killall a
$ date +%s; grep anon_vma /proc/slabinfo
1415962607
anon_vma           11277  12175    160   25    1 : tunables    0    0    0 : slabdata    487    487      0

So we have accumulated 23211 objects over that time period before the
offender was killed which released all of them.

The proposed workaround is kind of ugly but do people have a better idea
than reference counting? If not should we merge it?

---
[1] https://lkml.org/lkml/2012/8/15/765
[2] https://lkml.org/lkml/2013/6/3/568
-- 
Michal Hocko
SUSE Labs
