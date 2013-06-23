Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751621Ab3FWLVi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 07:21:38 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51492 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953Ab3FWLVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 07:21:35 -0400
Date: Sun, 23 Jun 2013 13:21:33 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
Cc: tj@kernel.org
Subject: Re: SATA hdd refuses to reallocate a sector?
Message-ID: <20130623112133.GA4837@amd.pavel.ucw.cz>
References: <20130623101940.GA4448@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130623101940.GA4448@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2013-06-23 12:19:40, Pavel Machek wrote:
> Hi!
> 
> This may very well be hw problem, but...
> 
> I have error on sda4. I tried to make hdd reallocate it by writing
> zeros there, but it will not. Is there special kind of write that
> needs to be done to force reallocation?
> 
> Would it be possible to indicate errors when writing to known-bad
> sector?

Uhuh. Seems like I have few consecutive bad sectors, and kernel is not
willing to overwrite them in one pass...?

root@amd:~# time cat /dev/zero > /dev/sda4
cat: write error: No space left on device

real 9m47.083s
user 0m0.264s
sys  1m24.424s
root@amd:~# time cat /dev/sda4  | wc -c
cat: /dev/sda4: Input/output error
8959361024

real	5m9.784s
user	0m0.544s
sys	2m11.620s
root@amd:~# time cat /dev/sda1  | wc -c
797852160

real	0m23.479s
user	0m0.040s
sys	0m5.492s
root@amd:~# time cat /dev/zero > /dev/sda4
cat: write error: No space left on device

real 7m51.619s
user 0m0.460s
sys  1m23.280s
root@amd:~# time cat /dev/sda4  | wc -c
cat: /dev/sda4: Input/output error
8958947328

real	5m25.973s
user	0m0.564s
sys	2m6.508s
root@amd:~# 

...Ok, lets try with dd.

root@amd:~# dd if=/dev/sda4 of=/dev/zero bs=1 skip=8958947328
dd: reading `/dev/sda4': Input/output error
0+0 records in
0+0 records out
0 bytes (0 B) copied, 5.05805 s, 0.0 kB/s
root@amd:~# dd if=/dev/sda4 of=/dev/zero bs=1 skip=8958947328
dd: reading `/dev/sda4': Input/output error
0+0 records in
0+0 records out
0 bytes (0 B) copied, 5.1051 s, 0.0 kB/s
root@amd:~# dd if=/dev/zero of=/dev/sda4 bs=1 seek=8958947328
dd: writing `/dev/sda4': Input/output error
3585+0 records in
3584+0 records out
3584 bytes (3.6 kB) copied, 2.63182 s, 1.4 kB/s
root@amd:~# 

...at least errors are propagated to dd. Aha, bad idea, I need to do
bigger block size so that I don't force reads...?

Better, but still not good:

root@amd:~# dd if=/dev/sda4 of=/dev/zero bs=4096
skip=$[8958947328/4096]
dd: reading `/dev/sda4': Input/output error
0+0 records in
0+0 records out
0 bytes (0 B) copied, 5.12378 s, 0.0 kB/s
root@amd:~# dd if=/dev/zero of=/dev/sda4 bs=4096
seek=$[8958947328/4096]
dd: writing `/dev/sda4': No space left on device
1746674+0 records in
1746673+0 records out
7154376192 bytes (7.2 GB) copied, 219.494 s, 32.6 MB/s
root@amd:~# dd if=/dev/sda4 of=/dev/zero bs=4096
skip=$[8958947328/4096]
dd: reading `/dev/sda4': Input/output error
101+0 records in
101+0 records out
413696 bytes (414 kB) copied, 4.94643 s, 83.6 kB/s
root@amd:~# 

Next try...

root@amd:~# dd if=/dev/zero of=/dev/sda4 bs=4096
seek=$[8958947328/4096]
dd: writing `/dev/sda4': No space left on device
1746674+0 records in
1746673+0 records out
7154376192 bytes (7.2 GB) copied, 241.291 s, 29.7 MB/s
root@amd:~# sync
root@amd:~# dd if=/dev/sda4 of=/dev/zero bs=4096
skip=$[8958947328/4096]
dd: reading `/dev/sda4': Input/output error
102+0 records in
102+0 records out
417792 bytes (418 kB) copied, 12.4968 s, 33.4 kB/s
root@amd:~# 

I don't think badblocks utility does what I need...?

I tried re-running dd few time, even with conf=fsync; but 

1) errors during write do not get reported

2) no more sectors are reallocated

root@amd:~# dd if=/dev/zero of=/dev/sda4 bs=4096
seek=$[8958947328/4096] conv=fsync
dd: writing `/dev/sda4': No space left on device
1746674+0 records in
1746673+0 records out
7154376192 bytes (7.2 GB) copied, 188.11 s, 38.0 MB/s
root@amd:~# dd if=/dev/sda4 of=/dev/zero bs=4096
skip=$[8958947328/4096]
dd: reading `/dev/sda4': Input/output error
102+0 records in
102+0 records out
417792 bytes (418 kB) copied, 6.20669 s, 67.3 kB/s
root@amd:~# 

Any ideas? Thanks,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
