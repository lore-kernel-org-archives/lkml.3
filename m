Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751772AbaEZH4b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 03:56:31 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:65446 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbaEZH4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 03:56:30 -0400
Message-ID: <1401090987.5339.79.camel@marge.simpson.net>
Subject: Re: balance storm
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Libo Chen <libo.chen@huawei.com>
Cc: tglx@linutronix.de, mingo@elte.hu, LKML <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, Li Zefan <lizefan@huawei.com>
Date: Mon, 26 May 2014 09:56:27 +0200
In-Reply-To: <5382AF2E.1040407@huawei.com>
References: <5382AF2E.1040407@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-05-26 at 11:04 +0800, Libo Chen wrote: 
> hi,
>     my box has 16 cpu (E5-2658,8 core, 2 thread per core), i did a test on
> 3.4.24stable, startup 50 same process, every process is sample:
> 
>  	#include <unistd.h>
> 
>  	int main()
>  	{
>           	for (;;)
>           	{
>                   	unsigned int i = 0;
>                  	 while (i< 100){
>                      	 i++;
>                   	}
>                   	usleep(100);
>           	}
> 
>          	 return 0;
>   	}
> 
> the result is process uses 15% cpu time, perf tool shows 70w migrations in 5 second.

My 8 socket 64 core DL980 running 256 copies (3.14-rt5) munches ~4%/copy
per top, and does roughly 1 sh*tload migrations, nano-work loop or not.
Turn SD_SHARE_PKG_RESOURCES off at MC (not a noop here), and consumption
drops to ~2%/copy, and migrations ('course) mostly go away.

vogelweide:/abuild/mike/:[0]# perf stat -a -e sched:sched_migrate_task -- sleep 5

 Performance counter stats for 'system wide':

              3108      sched:sched_migrate_task                                    

       5.001367910 seconds time elapsed

(turns SD_SHARE_PKG_RESOURCES back on)

vogelweide:/abuild/mike/:[0]# perf stat -a -e sched:sched_migrate_task -- sleep 5

 Performance counter stats for 'system wide':

           4182334      sched:sched_migrate_task                                    

       5.001365023 seconds time elapsed

vogelweide:/abuild/mike/:[0]# 

