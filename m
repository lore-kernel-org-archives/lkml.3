Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183Ab3BRVNP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 16:13:15 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:49367 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010Ab3BRVNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 16:13:14 -0500
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.4-dev
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: next-20130206 x86_64- high CPU usage, spinlock issue
From: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1361221949_2799P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 18 Feb 2013 16:12:29 -0500
Message-ID: <20493.1361221949@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020208.5122993E.00C3,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1361221949_2799P
Content-Type: text/plain; charset=us-ascii

Over the weekend, I had a number of occurrences of my laptop becoming
unresponsive for periods of up to several minutes.  gkrellm monitors showed
near 100% system time for both CPUs (and the way X and other userspace programs
were behaving was consistent with them being starved for CPU for extended
periods - at one point gkrellm was unable to update the display for over 4
minutes).  The problem would hit, everything would get sluggish/stop for
anywhere from 15 seconds or so to several minutes - and then it would just
as mysteriously go away for no apparent reason, only to return a bit later...

The only other clue I was able to get was running 'perf top' to see where
the CPU was going - anytime the kernel was in this state, I'd see the top
two entries were consistently delay_tsc and do_raw_read_lock:

 25.29%  [kernel]                                        [k] delay_tsc
 23.47%  [kernel]                                        [k] do_raw_read_lock
  8.01%  [kernel]                                        [k] ext4_es_reclaim_extents_count
  7.44%  [kernel]                                        [k] ftrace_likely_update
  2.80%  [kernel]                                        [k] lock_release
  2.79%  [kernel]                                        [k] do_raw_read_unlock
  2.65%  [kernel]                                        [k] lock_acquire

 15.33%  [kernel]                                        [k] delay_tsc
 14.02%  [kernel]                                        [k] do_raw_read_lock
  6.80%  libc-2.17.so                                    [.] re_search_internal
  5.55%  libmagic.so.1.0.0                               [.] 0x000000000000af9a
  5.16%  [kernel]                                        [k] ftrace_likely_update
  4.79%  [kernel]                                        [k] ext4_es_reclaim_extents_count

 22.94%  [kernel]                                        [k] delay_tsc
 19.84%  [kernel]                                        [k] do_raw_read_lock
  6.92%  [kernel]                                        [k] ext4_es_reclaim_extents_count
  6.79%  [kernel]                                        [k] ftrace_likely_update
  2.62%  libc-2.17.so                                    [.] re_search_internal

I'm not sure why ext4_es-reclaim_extents_count appears a lot - the workload
that was running at the time was seeing some memory pressure due to a large
Firefox process, and a 'find | xargs file' command causing a lot of inode and
data read I/O, but there shouldn't have been a lot of reclaims of extents as
not much was being written anyplace?

I can try to reproduce the issue - any suggestions how to efficiently tell
who/what is doing the contending in do_raw_read_lock?

--==_Exmh_1361221949_2799P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUSKZPAdmEQWDXROgAQKDsA/6A1KJTBr7hviOlpC4aBUtQiU3BlQ60+j4
qndEhbGU2V/TP2tdOrJfTgyoBMH315gpsz/yO1GC/pb5R6vAb2UfhfkJnoPNYtca
XNcrjI3XyrSzFRoMMSojyGvnazHZvi+ZR5c/rK9OWt4Y7pZReuai4W2WU7h+M0ng
B8a+nx5VAZ4pJJJpmA8PYYLa2oM7nChtFmk2hjS9E6ov2cCQk+GaBuiYemoDdp5Z
Wtc36OhgP5G8J4ESqpCrUc0wZAVh9S8sQ53JOH+t6oUCsAkpURxht+AyUbM/GaNn
Q2C7/OH0a8aCbGIggj/xdAzVTyj6jXFpzUYavCkmKrPnaQpQYUBG9CkpPO1hVggK
M7ch1wzXiPmyeNALxTE3wBppaa876bDNmKqRCwWtn0V6zz4T772wAZvLuc3/hd7v
x7OmXqBd/UGVPGLp6u7dNBch/eB6q5soB/LOUw7KANlTK97+jpsdtBSMRPDeO5Va
gThegSSBw6UnKLBZmU3cx3MTnpsMIeaXVBGlCsjj5CpQzWCt+01dBKty5v5/GBDt
vZ6fyY8H5MXpHAvL9bM7Ippkg2n5m7utQCq+45mxB+M+LLpZX2KjkYcAG3hf55Bj
V4IpmYnyIAAuSGIbcsFpxilZoUrUsLkNOpKsQcupCr/S1h8sA/cGcW6Db6E2Wpcv
DjYoMrKk2CE=
=eTJJ
-----END PGP SIGNATURE-----

--==_Exmh_1361221949_2799P--

