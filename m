Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561AbaJCTog (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 15:44:36 -0400
Received: from cassarossa.samfundet.no ([193.35.52.29]:33420 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823AbaJCTof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 15:44:35 -0400
Date: Fri, 3 Oct 2014 21:44:29 +0200
From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
To: linux-kernel@vger.kernel.org
Subject: Slowdown due to threads bouncing between HT cores
Message-ID: <20141003194428.GA27084@sesse.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Operating-System: Linux 3.16.3 on a x86_64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I did a chess benchmark of my new machine (2x E5-2650v3, so 20x2.3GHz
Haswell-EP), and it performed a bit worse than comparable Windows setups.
It looks like the scheduler somehow doesn't perform as well with
hyperthreading; HT is on in the BIOS, but I'm only using 20 threads
(chess scales sublinearly, so using all 40 usually isn't a good idea),
so really, the threads should just get one core each and that's it.
It looks like they are bouncing between cores, reducing overall performance
by ~20% for some reason. (The machine is otherwise generally idle.)

First some details to reproduce more easily. Kernel version is 3.16.3, 64-bit
x86, Debian stable (so gcc 4.7.2). The benchmark binary is a chess engine
knows as Stockfish; this is the compile I used (because that's what everyone
else is benchmarking with):

  http://abrok.eu/stockfish/builds/dbd6156fceaf9bec8e9ff14f99c325c36b284079/linux64modernsse/stockfish_13111907_x64_modern_sse42

Stockfish is GPL, so the source is readily available if you should need it.

The benchmark is run with by just running the binary, then giving it these
commands one by one:

uci
setoption name Threads value 20
setoption name Hash value 1024
position fen rnbq1rk1/pppnbppp/4p3/3pP1B1/3P3P/2N5/PPP2PP1/R2QKBNR w KQ – 0 7
go wtime 7200000 winc 30000 btime 7200000 binc 30000

After ~3 minutes, it will output “bestmove d1g4 ponder f8e8”. A few lines
above that, you'll see a line with something similar to “nps 13266463”.
That's nodes per second, and you want it to be higher.

So, benchmark:

 - Default: 13266 kN/sec
 - Change from ondemand to performance on all cores: 14600 kN/sec
 - taskset -c 0-19 (locking affinity to only one set of hyperthreads):
   17512 kN/sec

There is some local variation, but it's typically within a few percent.
Does anyone know what's going on? I have CONFIG_SCHED_SMT=y and
CONFIG_SCHED_MC=y.

/* Steinar */
-- 
Homepage: http://www.sesse.net/
