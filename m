Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348Ab3ALTle (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 14:41:34 -0500
Received: from talus.maths.usyd.edu.au ([129.78.68.1]:43348 "EHLO
	talus.maths.usyd.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116Ab3ALTld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 14:41:33 -0500
X-smtpdoor-from: psz@maths.usyd.edu.au
X-smtpdoor-want-Message-ID: <201301121941.r0CJf5ps017150@como.maths.usyd.edu.au>
Date: Sun, 13 Jan 2013 06:41:05 +1100
From: paul.szabo@sydney.edu.au
Message-Id: <201301121941.r0CJf5ps017150@como.maths.usyd.edu.au>
To: linux-mm@kvack.org
Subject: Re: [RFC] Reproducible OOM with just a few sleeps
Cc: 695182@bugs.debian.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The issue is a regression with PAE, reproduced and verified on Ubuntu,
on my home PC with 3GB RAM.

My PC was running kernel linux-image-3.2.0-35-generic so it showed:
  psz@DellE520:~$ uname -a
  Linux DellE520 3.2.0-35-generic #55-Ubuntu SMP Wed Dec 5 17:45:18 UTC 2012 i686 i686 i386 GNU/Linux
  psz@DellE520:~$ free -l
               total       used       free     shared    buffers     cached
  Mem:       3087972     692256    2395716          0      18276     427116
  Low:        861464      71372     790092
  High:      2226508     620884    1605624
  -/+ buffers/cache:     246864    2841108
  Swap:     20000920     258364   19742556
Then it handled the "sleep test"
  bash -c 'n=0; while [ $n -lt 33000 ]; do sleep 600 & ((n=n+1)); ((m=n%500)); if [ $m -lt 1 ]; then echo -n "$n - "; date; free -l; sleep 1; fi; done'
just fine, stopped only by "max user processes" (default setting of
"ulimit -u 23964"), or raising that limit stopped when the machine ran
out of PID space; there was no OOM.

Installing and running the PAE kernel so it showed:
  psz@DellE520:~$ uname -a
  Linux DellE520 3.2.0-35-generic-pae #55-Ubuntu SMP Wed Dec 5 18:04:39 UTC 2012 i686 i686 i386 GNU/Linux
  psz@DellE520:~$ free -l
               total       used       free     shared    buffers     cached
  Mem:       3087620     681188    2406432          0     167332     352296
  Low:        865208     214080     651128
  High:      2222412     467108    1755304
  -/+ buffers/cache:     161560    2926060
  Swap:     20000920          0   20000920
and re-trying the "sleep test", it ran into OOM after 18000 or so sleeps
and crashed/froze so I had to press the POWER button to recover.

Cheers, Paul

Paul Szabo   psz@maths.usyd.edu.au   http://www.maths.usyd.edu.au/u/psz/
School of Mathematics and Statistics   University of Sydney    Australia
