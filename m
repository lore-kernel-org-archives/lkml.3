Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838Ab3JHKVJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:21:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:50718 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756812Ab3JHKVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:21:05 -0400
Message-ID: <1381227659.15686.11.camel@marge.simpson.net>
Subject: Re: perf: perf sched lat segfault - bisected
From: Mike Galbraith <bitbucket@online.de>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Date: Tue, 08 Oct 2013 12:20:59 +0200
In-Reply-To: <1381227252.15686.9.camel@marge.simpson.net>
References: <1381221715.15686.3.camel@marge.simpson.net>
	 <CABPqkBRMa7rawfvQ2Sunc2tr87s_WqT_7GYac6+x=SNZoJSueg@mail.gmail.com>
	 <1381227252.15686.9.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:xoGir/QXvju1Dp6LDw2QZHl75RMZlVW2/86NoMKAIDx
 ogZErbi4nf/pSK1TCod+Q6qKkaAiDWWAdfL3BiIiucKWYKg2c2
 YVds/Gvjxj7HE4BLR0STW/FXDxepuU0ILZfjjKY5gjdqFxpvIk
 a6MiaiwF5zOETUvGUAN+akyEUmCJoNAm/JhbZtji+sEm9blQgV
 uKOBg853h/UpqmCEZ+ggEpopeJ8exIlHuQwQMRgYX7rji3KiHK
 GQMI3e3GNFu820zzq5seUjRQeM/xeVDkafH2Ficn5BowoDOCGk
 fdyERzd2X06L3JtSXYYgjIDaznLSBrZ1JvBsT5dq33acev0XVg
 BvgP6xsfrO62z5UigQ3fYbtHzykbgA7uwcc6xgayegUtjMGKDP
 55HrBo72d/K3Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-08 at 12:14 +0200, Mike Galbraith wrote: 
> On Tue, 2013-10-08 at 11:23 +0200, Stephane Eranian wrote: 
> > On Tue, Oct 8, 2013 at 10:41 AM, Mike Galbraith <bitbucket@online.de> wrote:
> > > Box: Q6600
> > >
> > > Reproducer:
> > > perf sched record -- sleep 1
> > > perf sched lat (boom)
> > >
> > I don't understand the test case here.
> > If I do this, perf sched lat complains of no trace records
> > and no kernel crash. Could you provide the full cmdline?
> 
> Hm.  That was it, just like so.
> 
> marge:/usr/local/src/kernel/linux-3.x.git/tools/perf # ./perf sched record -- sleep 1
> [ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 0.763 MB perf.data (~33348 samples) ]
> marge:/usr/local/src/kernel/linux-3.x.git/tools/perf # ./perf sched lat
> Segmentation fault
> marge:/usr/local/src/kernel/linux-3.x.git/tools/perf #

commit 72f3bdf7fd1003373b454bf923d3a196bbc36600
Author: Mike Galbraith <mgalbraith@suse.de>
Date:   Tue Oct 8 12:18:37 2013 +0200

    Revert "perf tools: Add attr->mmap2 support"
    
    This reverts commit 5c5e854bc760a2e2c878df3cfcf2afa4febcd511.

commit a8af8531d08d3edb37a7d67d1a4dc2e1f2f4da58
Author: Mike Galbraith <mgalbraith@suse.de>
Date:   Tue Oct 8 12:18:23 2013 +0200

    Revert "perf trace: Add mmap2 handler"
    
    This reverts commit 384c671e33a7ddf905f2c60b433b9883f0e5a605.

marge:/usr/local/src/kernel/linux-3.x.git/tools/perf # ./perf sched
record -- sleep 1
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.647 MB perf.data (~28289 samples) ]
marge:/usr/local/src/kernel/linux-3.x.git/tools/perf # perf sched lat
marge:/usr/local/src/kernel/linux-3.x.git/tools/perf #

(emitted this) 

 ---------------------------------------------------------------------------------------------------------------
  Task                  |   Runtime ms  | Switches | Average delay ms | Maximum delay ms | Maximum delay at     |
 ---------------------------------------------------------------------------------------------------------------
  kworker/3:2:383       |      0.073 ms |        1 | avg:    0.020 ms | max:    0.020 ms | max at: 7197.856052 s
  sleep:24717           |      1.163 ms |        3 | avg:    0.011 ms | max:    0.022 ms | max at: 7196.884445 s
  kworker/2:1:36        |      0.097 ms |        1 | avg:    0.007 ms | max:    0.007 ms | max at: 7197.796023 s
  haveged:3547          |      0.023 ms |        2 | avg:    0.006 ms | max:    0.009 ms | max at: 7197.796345 s
  rcu_sched:9           |      0.126 ms |       14 | avg:    0.006 ms | max:    0.021 ms | max at: 7196.897051 s
  ntpd:4185             |      0.034 ms |        1 | avg:    0.004 ms | max:    0.004 ms | max at: 7197.746409 s
  kded4:4594            |      0.058 ms |        1 | avg:    0.004 ms | max:    0.004 ms | max at: 7197.422130 s
  evolution:15686       |      0.065 ms |        1 | avg:    0.004 ms | max:    0.004 ms | max at: 7196.915715 s
  pickup:21579          |      0.062 ms |        1 | avg:    0.004 ms | max:    0.004 ms | max at: 7197.329185 s
  JS Watchdog:20053     |      0.020 ms |        1 | avg:    0.004 ms | max:    0.004 ms | max at: 7197.623752 s
  perf:24716            |      3.330 ms |        1 | avg:    0.004 ms | max:    0.004 ms | max at: 7197.885690 s
  plasma-desktop:4685   |      1.632 ms |        2 | avg:    0.004 ms | max:    0.005 ms | max at: 7196.933762 s
  master:4307           |      0.104 ms |        2 | avg:    0.004 ms | max:    0.005 ms | max at: 7197.329136 s
  Xorg:4331             |      0.485 ms |        4 | avg:    0.003 ms | max:    0.005 ms | max at: 7197.010801 s
  ksoftirqd/2:18        |      0.014 ms |        1 | avg:    0.003 ms | max:    0.003 ms | max at: 7196.897039 s
  alsa-sink:5282        |      0.000 ms |      200 | avg:    0.003 ms | max:    0.003 ms | max at: 7196.905149 s
  migration/3:22        |      0.000 ms |        1 | avg:    0.002 ms | max:    0.002 ms | max at: 7196.884423 s
 -----------------------------------------------------------------------------------------
  TOTAL:                |      7.285 ms |      237 |
 ---------------------------------------------------

