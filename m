Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988AbaEPLsk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 07:48:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40744 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754146AbaEPLsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 07:48:39 -0400
Date: Fri, 16 May 2014 13:47:57 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Don Zickus <dzickus@redhat.com>
Cc: acme@ghostprotocols.net, peterz@infradead.org,
        LKML <linux-kernel@vger.kernel.org>, namhyung@gmail.com,
        eranian@google.com, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 6/6] perf: Add dcacheline sort
Message-ID: <20140516114757.GD19475@krava.brq.redhat.com>
References: <1399999697-65875-1-git-send-email-dzickus@redhat.com>
 <1399999697-65875-7-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399999697-65875-7-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 12:48:17PM -0400, Don Zickus wrote:
> In perf's 'mem-mode', one can get access to a whole bunch of details specific to a
> particular sample instruction.  A bunch of those details relate to the data
> address.
> 
> One interesting thing you can do with data addresses is to convert them into a unique
> cacheline they belong too.  Organizing these data cachelines into similar groups and sorting
> them can reveal cache contention.
> 
> This patch creates an alogorithm based on various sample details that can help group
> entries together into data cachelines and allows 'perf report' to sort on it.
> 
> The algorithm relies on having proper mmap2 support in the kernel to help determine
> if the memory map the data address belongs to is private to a pid or globally shared.
> 
> The alogortithm is as follows:
> 
> o group cpumodes together
> o group entries with discovered maps together
> o sort on major, minor, inode and inode generation numbers
> o if userspace anon, then sort on pid
> o sort on cachelines based on data addresses

needs some collumn width refresh or something..? ;-)

# Overhead  Data Cacheline         
# ........  .......................
#
     5.42%  [k] 0xffff8801ed832c40 
     5.29%  [.] sys_errlist@@GLIBC_2.12+0xffffffcbf7dfc1ff                       
     3.16%  [k] 0xffffffffff5690c0 


also I've got again perf hanged up on opening device file

[jolsa@krava perf]$ sudo strace -p 29445
Process 29445 attached
open("/dev/snd/pcmC0D0p", O_RDONLY^CProcess 29445 detached

another one I recall was /dev/dri/card0 touched by X server

I guess those device files allow to mmap memory and we recorded
memory access there.. we need check for this and do not try to
open device files


jirka
