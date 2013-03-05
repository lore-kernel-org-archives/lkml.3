Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758448Ab3CESVz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 13:21:55 -0500
Received: from zill.ext.symas.net ([69.43.206.106]:44340 "EHLO
	zill.ext.symas.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755899Ab3CESVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 13:21:54 -0500
X-Greylist: delayed 1457 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Mar 2013 13:21:54 EST
Message-ID: <5136320E.8030109@symas.com>
Date: Tue, 05 Mar 2013 09:57:34 -0800
From: Howard Chu <hyc@symas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:22.0) Gecko/20100101 Firefox/22.0 SeaMonkey/2.19a1
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: mmap vs fs cache
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm testing our memory-mapped database code on a small VM. The machine has 
32GB of RAM and the size of the DB on disk is ~44GB. The database library 
mmaps the entire file as a single region and starts accessing it as a tree of 
B+trees. Running on an Ubuntu 3.5.0-23 kernel, XFS on a local disk.

If I start running read-only queries against the DB with a freshly started 
server, I see that my process (OpenLDAP slapd) quickly grows to an RSS of 
about 16GB in tandem with the FS cache. (I.e., "top" shows 16GB cached, and 
slapd is 16GB.)
If I confine my queries to the first 20% of the data then it all fits in RAM 
and queries are nice and fast.

if I extend the query range to cover more of the data, approaching the size of 
physical RAM, I see something strange - the FS cache keeps growing, but the 
slapd process size grows at a slower rate. This is rather puzzling to me since 
the only thing triggering reads is accesses through the mmap region. 
Eventually the FS cache grows to basically all of the 32GB of RAM (+/- some 
text/data space...) but the slapd process only reaches 25GB, at which point it 
actually starts to shrink - apparently the FS cache is now stealing pages from 
it. I find that a bit puzzling; if the pages are present in memory, and the 
only reason they were paged in was to satisfy an mmap reference, why aren't 
they simply assigned to the slapd process?

The current behavior gets even more aggravating: I can run a test that spans 
exactly 30GB of the data. One would expect that the slapd process should 
simply grow to 30GB in size, and then remain static for the remainder of the 
test. Instead, the server grows to 25GB, the FS cache grows to 32GB, and 
starts stealing pages from the server, shrinking it back down to 19GB or so.

If I do an "echo 1 > /proc/sys/vm/drop_caches" at the onset of this condition, 
the FS cache shrinks back to 25GB, matching the slapd process size.
This then frees up enough RAM for slapd to grow further. If I don't do this, 
the test is constantly paging in data from disk. Even so, the FS cache 
continues to grow faster than the slapd process size, so the system may run 
out of free RAM again, and I have to drop caches multiple times before slapd 
finally grows to the full 30GB. Once it gets to that size the test runs 
entirely from RAM with zero I/Os, but it doesn't get there without a lot of 
babysitting.

2 questions:
   why is there data in the FS cache that isn't owned by (the mmap of) the 
process that caused it to be paged in in the first place?
   is there a tunable knob to discourage the page cache from stealing from the 
process?

-- 
   -- Howard Chu
   CTO, Symas Corp.           http://www.symas.com
   Director, Highland Sun     http://highlandsun.com/hyc/
   Chief Architect, OpenLDAP  http://www.openldap.org/project/
