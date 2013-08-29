Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569Ab3H2Hbf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 03:31:35 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:50234 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895Ab3H2Hbe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 03:31:34 -0400
Message-ID: <1377761464.4817.22.camel@marge.simpson.net>
Subject: Re: Kernel migration eat CPUs
From: Mike Galbraith <bitbucket@online.de>
To: Alexey Vlasov <renton@renton.name>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, Mike Galbraith <bitbucket@online.de>
Date: Thu, 29 Aug 2013 09:31:04 +0200
In-Reply-To: <20130822150046.GF13676@beaver>
References: <20130822150046.GF13676@beaver>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0
X-Provags-ID: V02:K0:/oScIoB1z88/pCwgVJ9ymMBn6b3pWGWdp0diDXa14ws
 ZK+m1F/cJT7BZFA5Z05ufmiytbe0RI1p6a/0+c8XLlCNuVxJD+
 mu9j//N60qo187+xtNgiKGUdgsph5XW87w/OU2BUroYpLRrtb8
 VfHkuugSqNUEdOh4zOmupyvxhju5oNXXImjdUq9Y3gJbgo0m+T
 OUa/Qh/2zwibzwoJDT9ZLfUtYLhTlAsCaDy4MFesj9PkwFklNX
 pWyirAhf+sAcGwer5Q+1bIKIpbtEHTDG/KOh6RR1Wx8LYYDtob
 yJDc1MZgNm7HL1mkcrt64RpRNUuRDuhfY8ts3QOzmuUXvs/2gk
 EM4I7iHD9MdBcoUQ4YTazKPRaDlAuRRCXEJyzhi4So792GBI5I
 fvtKj7EMJlXuw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(CCs)

On Thu, 2013-08-22 at 19:00 +0400, Alexey Vlasov wrote: 
> Hi,
> 
> Beginning from 3.7 including 3.10 kernel, I noticed that from time to
> time all CPUs turn out to be busy 100% and at the moment websites of my
> clients work slowly or don’t work at all.
> 
> top screen:
> https://www.dropbox.com/s/psuk2cwn6exinyd/3.9.cpu_migration.jpg
> 
> All CPUs are busy with kernel threads migration for about 3-5 minutes.
> Exactly how often it periodically happens I don’t know, but it happens
> once in 1-3 hours.
> 
> Approximately 30 my servers work on kernel 2.6.35 and there’s no such
> problem there. We use kernels 3.7 – 3.9 on 5 servers and I see such
> effect everywhere. If you downgrade on 2.6.35, then migration doesn’t
> eat CPUs.
> 
> These servers are used for usual LAMP shared hosting.
> 
> Can I get migration as if on the kernel 2.6.35 or can this feature be
> disabled?

I've not seen anything like this since the below went into 3.6, nor
heard of same.  Before that, migration threads could _appear_ to eat CPU
under certain circumstances.  Perhaps perf top -p <pick-a-thread> while
the problem is happening will show something.  

commit 8f6189684eb4e85e6c593cd710693f09c944450a
Author: Mike Galbraith <mgalbraith@suse.de>
Date:   Sat Aug 4 05:44:14 2012 +0200

    sched: Fix migration thread runtime bogosity
    
    Make stop scheduler class do the same accounting as other classes,
    
    Migration threads can be caught in the act while doing exec balancing,
    leading to the below due to use of unmaintained ->se.exec_start.  The
    load that triggered this particular instance was an apparently out of
    control heavily threaded application that does system monitoring in
    what equated to an exec bomb, with one of the VERY frequently migrated
    tasks being ps.
    
    %CPU   PID USER     CMD
    99.3    45 root     [migration/10]
    97.7    53 root     [migration/12]
    97.0    57 root     [migration/13]
    90.1    49 root     [migration/11]
    89.6    65 root     [migration/15]
    88.7    17 root     [migration/3]
    80.4    37 root     [migration/8]
    78.1    41 root     [migration/9]
    44.2    13 root     [migration/2]

