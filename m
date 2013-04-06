Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758079Ab3DFSWD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 14:22:03 -0400
Received: from smtprelay.restena.lu ([158.64.1.62]:34979 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756626Ab3DFSWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 14:22:02 -0400
X-Greylist: delayed 638 seconds by postgrey-1.27 at vger.kernel.org; Sat, 06 Apr 2013 14:22:02 EDT
Date: Sat, 6 Apr 2013 20:11:14 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Vassilis Virvilis <v.virvilis@biovista.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Debugging COW (copy on write) memory after fork: Is it possible
 to dump only the private anonymous memory of a process?
Message-ID: <20130406201114.6477d1e4@neptune.home>
In-Reply-To: <515E9F0C.1000204@biovista.com>
References: <515E9F0C.1000204@biovista.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.16; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 05 April 2013 Vassilis Virvilis <v.virvilis@biovista.com> wrote:
> Hello, sorry if this is off topic. Just point me to the right direction. 
> Please cc me also in the reply.
> 
> Question
> --------
> 
> Is it possible to dump only the private anonymous memory of a process?

I don't know if that's possible, but from your background you could
probably work around it be mmap()ing the memory you need and once
initialized mark all of that memory read-only (if you mmap very large
chunks you can even benefit from huge-pages).

Any of the forked processes that tried to access the memory would then
get a signal if they ever tried to write to the data (and thus unsharing it)


If you allocate and initialize all of your memory in little malloc()'ed
chunks it's possibly glibc's memory housekeeping that unshares all those
pages over time.

Bruno

> Background
> ----------
> 
> I have a process where it reads and it initializes a large portion of 
> the memory (around 2.3GB). This memory is effectively read only from 
> that point and on. After the initialization I fork the process to 
> several children in order to take advantage of the multicore 
> architecture of modern cpus. The problem is that finally the program 
> ends up requiring number_of_process * 2.3GB memory effectively entering 
> swap thrashing and destroying the performance.
> 
> Steps so far
> ------------
> 
> The first thing I did is to monitor the memory. I found about 
> /proc/$pid/smaps and the http://wingolog.org/pub/mem_usage.py.
> 
> What happens is the following
> 
>      The program starts reads from disk and has 2.3GB of private mappings
>      The program forks. Immediately the 2.3GB become shared mapping 
> between the parent and the child. Excellent so far.
>      As the time goes and the child starts performing its tasks the 
> shared memory is slowly migrating to the private mappings of each 
> process effectively blowing up the memory requirements.
> 
> I thought that if I could see (dump) the private mappings of each 
> process I could see from the data why the shared mappings are being 
> touched so I tried to dump the core with gcore and by playing with 
> /proc/$pid/coredump_filter like this
> 
> echo 0x1 > /proc/$pid/coredump_filter
> gcore $pid
> 
> Unfortunately it always dumps 2.3GB despite the setting in 
> /proc/$pid/coredump_filter which says private anonymous mappings.
> 
> I have researched the question in google.
> 
> I even posted it in stack overflow.
> 
> Any other ideas?
> 
> Thanks in advance
> 
> 	Vassilis Virvilis
