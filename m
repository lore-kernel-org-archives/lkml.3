Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591Ab3JITq6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 15:46:58 -0400
Received: from smtp.peak6.com ([38.98.137.6]:1992 "EHLO smtp.peak6.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752471Ab3JITq5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 15:46:57 -0400
X-Greylist: delayed 900 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Oct 2013 15:46:56 EDT
X-AuditID: 0a64cb20-b7fb66d000002a78-3e-5255af2b006e
From: Shaun Thomas <sthomas@optionshouse.com>
To: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: Very odd memory behavior. Is this normal?
Thread-Topic: Very odd memory behavior. Is this normal?
Thread-Index: Ac7FHtzLTqQlbL5UQ7yx9cuUaAqt/g==
Date: Wed, 9 Oct 2013 19:31:54 +0000
Message-ID: <0683F5F5A5C7FE419A752A034B4A0B97973F7C13@sswchi5pmbx2.peak6.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.10.200.64]
Content-Type: text/plain; charset="us-ascii"
content-transfer-encoding: 8BIT
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFIsWRmVeSWpSXmKPExsXClcIrpqu9PjTIoKXRyOLyrjlsDowenzfJ
	BTBGNTDaJObl5ZcklqQqpKQWJ9sq+ReUZObnFXvklxanKrhkFifnJGbmphYpKWSm2CoZKykU
	5CQmp+am5pXYKiUWFKTmpSjZcSlgABugssw8hdS85PyUzLx0WyXPYH9dCwtTS11DJbt4ZJDQ
	yZJxZ+o89oK7ghUnpx9gbWBczdvFyMkhIWAi8efyC3YIW0ziwr31bCA2m4CuxKT+FWC2iICz
	xId9e8FsYQEjiYezL7NDxM0lbl/byAJh60lM2HYCyObgYBFQkTg6nxskzCvgK7G78zBYKyPQ
	+O+n1jCB2MwC4hK3nsxnglgrILFkz3lmCFtU4uXjf6wQtoLEghPnWSHqdSQW7P7EBmFrSyxb
	+JoZYr6gxMmZT1gmMArOQjJ2FpKWWUhaZiFpWcDIsopRvLgsMTkj07SgOLekwEivIDUx20wv
	L7VkEyM4Qk8r7GD83ml1iFGAg1GJh3dCd2iQEGtiWXFl7iFGCQ5mJRHewC6gEG9KYmVValF+
	fFFpTmrxIUYfYBBMZJYSTc4HJo+8knhDY1MDU0tTQ1NzU0MjHMJK4rz7mJYFCgmkAxNJdmpq
	QWoRzDgmDk6pBsZjv0MEtSwmf9st/T113mWG512fGxeauxt1hoqLC33ZoLbL4s/Skzv/mu3K
	Zu2e5dhorcsdynqpganA7tDSK394PY5M2Xi1yKF6ufR7pZzd0/MK/p6N4Jx2+caUHJUL0lHm
	B7PiDisee/Bm5aSH05S27P6YJfrDUsDlm8PSLMO1ayavZlVeFe6gxFKckWioxVxUnAgAESf4
	jP0CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Devs,

Ever since we moved from 2.6.* to 3.*, I've noticed some very odd MM behavior I'd like to run past you. It's pretty difficult to replicate, but I've figured out a fairly straightforward method. But first, the issue:

Our systems with 72GB of RAM on a 3.2 kernel eventually converge on this, from /proc/meminfo:

Active(file):   29059980 kB
Inactive(file): 29069296 kB

Basically some kind of even split across Inactive and Active, suggesting a hard IO loop that's purging as fast as it can promote. It's pretty easy to cause, too. If you have PostgreSQL handy, any DB that just barely fits in memory should be sufficient.

createdb pgbench
pgbench -i -s 4000 pgbench
pgbench -T 1800 -c 24 -S pgbench

I let that run for a while to cache everything, until read IO slows down to a trickle according to iostat. Memory at that point looks like this:

Active(file):   61056316 kB
Inactive(file):   249968 kB

And free -m looks like this:

             total       used       free     shared    buffers     cached
Mem:         72485      66963       5521          0          2      64183
-/+ buffers/cache:       2776      69708
Swap:         2047          0       2047

So I have 5GB available, 64GB cached... looks pretty normal. I leave the pgbench running, then in another terminal, I waste more memory than I have free:

python - <<EOF
foo = bytearray(8 * 1024 * 1024 * 1024)
from time import sleep
sleep(1000)
EOF

After a minute or two, Active and Inactive are even again, and IO to the underlying device is extremely high. In our case, that's 350MB/s in random reads. Every kernel I've tested does this. 3.2, 3.5, 3.8. I haven't been able to go higher than that, but the behavior seems pretty consistent. This is with zone_reclaim_mode disabled, and numactl --interleave=all doesn't change anything.

I get that it needs to balance memory, but this seems excessive somehow. I'm probably missing something, though. Any insight would be helpful, and I can try to provide anything else you need if this is a legitimate complaint.

Thanks!

--
Shaun Thomas
OptionsHouse | 141 W. Jackson Blvd | Suite 500 | Chicago IL, 60604
312-676-8870
sthomas@optionshouse.com



______________________________________________

See http://www.peak6.com/email_disclaimer/ for terms and conditions related to this email
