Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750819AbaFIEEG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 00:04:06 -0400
Received: from ns.horizon.com ([71.41.210.147]:55534 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750706AbaFIED6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 00:03:58 -0400
Date: 9 Jun 2014 00:03:55 -0400
Message-ID: <20140609040355.8126.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, tytso@mit.edu
Subject: Re: [RFC PATCH] drivers/char/random.c: Is reducing locking range like this safe?
Cc: hpa@linux.intel.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        price@mit.edu
In-Reply-To: <20140609021820.2038.qmail@ns.horizon.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sigh, adventures in "unable to mount root filesystem" currently underway.

Tested on a different computer without patches (half size, since it's
an older machine):

Writing 16 MiB:
16777216 bytes (17 MB) copied, 0.289169 s, 58.0 MB/s
16777216 bytes (17 MB) copied, 0.289378 s, 58.0 MB/s

Writing while reading:
16777216 bytes (17 MB) copied, 0.538839 s, 31.1 MB/s
4194304 bytes (4.2 MB) copied, 0.544769 s, 7.7 MB/s
16777216 bytes (17 MB) copied, 0.537425 s, 31.2 MB/s
4194304 bytes (4.2 MB) copied, 0.544259 s, 7.7 MB/s

16777216 bytes (17 MB) copied, 0.740495 s, 22.7 MB/s
4194304 bytes (4.2 MB) copied, 0.879353 s, 4.8 MB/s
4194304 bytes (4.2 MB) copied, 0.879629 s, 4.8 MB/s
16777216 bytes (17 MB) copied, 0.7262 s, 23.1 MB/s
4194304 bytes (4.2 MB) copied, 0.877035 s, 4.8 MB/s
4194304 bytes (4.2 MB) copied, 0.880627 s, 4.8 MB/s

16777216 bytes (17 MB) copied, 0.996933 s, 16.8 MB/s
4194304 bytes (4.2 MB) copied, 1.24551 s, 3.4 MB/s
4194304 bytes (4.2 MB) copied, 1.26138 s, 3.3 MB/s
4194304 bytes (4.2 MB) copied, 1.2664 s, 3.3 MB/s
16777216 bytes (17 MB) copied, 0.969144 s, 17.3 MB/s
4194304 bytes (4.2 MB) copied, 1.25311 s, 3.3 MB/s
4194304 bytes (4.2 MB) copied, 1.26076 s, 3.3 MB/s
4194304 bytes (4.2 MB) copied, 1.25887 s, 3.3 MB/s

Summarized:
0 readers: 0.289169 0.289378
1 reader:  0.538839 0.537425	(+86%)
2 readers: 0.740495 0.726200	(+153%)
3 readers: 0.996933 0.969144	(+240%)

That seems... noticeable.  Causing iterrupt latency problems is defintiely
a theoretical extrapolation, however.

For comparison, on this system, dd from /dev/zero runs at 1 GB/s per
thread for up to 4 threads with no interference.

*Really* confusingly, dd from /dev/zero to tmpfs runs at 450 MB/s (per
thread) for 2 to 4 threads, but 325 MB/s for 1 thread.  NFclue.
(This is writing to separate files; writing the the same file is
slower.)

dd from tmpfs to tmpfs runs at about 380 MB/s, again independent
of the number of threads up to the number of CPUs.
