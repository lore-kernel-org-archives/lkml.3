Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933165AbaJ3MWp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 08:22:45 -0400
Received: from mx2.ptsecurity.com ([31.44.93.4]:50868 "EHLO mx1.ptsecurity.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932947AbaJ3MWo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 08:22:44 -0400
X-Greylist: delayed 902 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Oct 2014 08:22:44 EDT
From: Serge Kosyrev <skosyrev@ptsecurity.com>
To: <linux-kernel@vger.kernel.org>
Subject: Fun with looping binds over proc
Date: Thu, 30 Oct 2014 15:07:37 +0300
Message-ID: <87vbn1222e.fsf@ptsecurity.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good day!

First, let me show how it looks and feels on my system:

[deepfire@andromedae:~/repro-kernel-loop-mount]$ uname -a
Linux andromedae 3.14.22 #1-NixOS SMP Thu Jan 1 00:00:01 UTC 1970 x86_64 GNU/Linux

[deepfire@andromedae:~/repro-kernel-loop-mount]$ ls
repro.sh

[deepfire@andromedae:~/repro-kernel-loop-mount]$ cat repro.sh 
#!/bin/sh

test -d dir/rec  || mkdir -p dir/rec 
test -d dir/proc || mkdir -p dir/proc
 
mount --bind . dir/rec
mount --make-private --make-unbindable dir/rec
mount none -t proc dir/proc
umount dir/rec
umount dir/proc

[deepfire@andromedae:~/repro-kernel-loop-mount]$ time sudo ./repro.sh 

real    0m0.045s
user    0m0.012s
sys     0m0.007s

[deepfire@andromedae:~/repro-kernel-loop-mount]$ time sudo ./repro.sh 

real    0m0.035s
user    0m0.009s
sys     0m0.009s

[deepfire@andromedae:~/repro-kernel-loop-mount]$ time sudo ./repro.sh 

real    0m0.042s
user    0m0.012s
sys     0m0.010s

[deepfire@andromedae:~/repro-kernel-loop-mount]$ time sudo ./repro.sh 

real    0m0.039s
user    0m0.013s
sys     0m0.011s

[deepfire@andromedae:~/repro-kernel-loop-mount]$ time sudo ./repro.sh 

real    0m0.043s
user    0m0.009s
sys     0m0.011s

[deepfire@andromedae:~/repro-kernel-loop-mount]$ time sudo ./repro.sh 

real    0m0.048s
user    0m0.011s
sys     0m0.013s

[deepfire@andromedae:~/repro-kernel-loop-mount]$ time sudo ./repro.sh 

real    0m0.052s
user    0m0.016s
sys     0m0.012s

[deepfire@andromedae:~/repro-kernel-loop-mount]$ time sudo ./repro.sh 

real    0m0.059s
user    0m0.008s
sys     0m0.031s

[deepfire@andromedae:~/repro-kernel-loop-mount]$ time sudo ./repro.sh 

real    0m0.067s
user    0m0.005s
sys     0m0.042s

[deepfire@andromedae:~/repro-kernel-loop-mount]$ time sudo ./repro.sh 

real    0m0.116s
user    0m0.011s
sys     0m0.088s

[deepfire@andromedae:~/repro-kernel-loop-mount]$ time sudo ./repro.sh 

real    0m0.291s
user    0m0.009s
sys     0m0.262s

[deepfire@andromedae:~/repro-kernel-loop-mount]$ time sudo ./repro.sh 

real    0m0.857s
user    0m0.011s
sys     0m0.819s

[deepfire@andromedae:~/repro-kernel-loop-mount]$ time sudo ./repro.sh 

real    0m1.710s
user    0m0.012s
sys     0m1.634s

[deepfire@andromedae:~/repro-kernel-loop-mount]$ time sudo ./repro.sh 

real    0m3.186s
user    0m0.010s
sys     0m3.023s

[deepfire@andromedae:~/repro-kernel-loop-mount]$ time sudo ./repro.sh 

real    0m6.732s
user    0m0.013s
sys     0m6.032s

[deepfire@andromedae:~/repro-kernel-loop-mount]$ time sudo ./repro.sh 

real    0m14.541s
user    0m0.008s
sys     0m12.115s

                        *    *    *

Some extra data points:

1. Exchanging the two umounts results in expected behavior
2. Exchanging the two umounts absolves the need in 'mount --make-private --make-unbindable dir/rec'
3. I don't see it on 3.12.something Ubuntu kernels

-- 
regards,
Серёга Косырев
