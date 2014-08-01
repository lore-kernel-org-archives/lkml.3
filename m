Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030AbaHAFGt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 01:06:49 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:52406 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491AbaHAFGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 01:06:47 -0400
Date: Thu, 31 Jul 2014 22:05:06 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Jerome Marchand <jmarchan@redhat.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-doc@vger.kernel.org,
        Hugh Dickins <hughd@google.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux390@de.ibm.com,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH 4/5] mm, shmem: Add shmem swap memory accounting
In-Reply-To: <1406036632-26552-5-git-send-email-jmarchan@redhat.com>
Message-ID: <alpine.LSU.2.11.1407312204000.3912@eggly.anvils>
References: <1406036632-26552-1-git-send-email-jmarchan@redhat.com> <1406036632-26552-5-git-send-email-jmarchan@redhat.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jul 2014, Jerome Marchand wrote:

> Adds get_mm_shswap() which compute the size of swaped out shmem. It
> does so by pagewalking the mm and using the new shmem_locate() function
> to get the physical location of shmem pages.
> The result is displayed in the new VmShSw line of /proc/<pid>/status.
> Use mm_walk an shmem_locate() to account paged out shmem pages.
> 
> It significantly slows down /proc/<pid>/status acccess speed when
> there is a big shmem mapping. If that is an issue, we can drop this
> patch and only display this counter in the inherently slower
> /proc/<pid>/smaps file (cf. next patch).
> 
> Signed-off-by: Jerome Marchand <jmarchan@redhat.com>

Definite NAK to this one.  As you guessed yourself, it is always a
mistake to add one potentially very slow-to-gather number to a stats
file showing a group of quickly gathered numbers.

Is there anything you could do instead?  I don't know if it's worth
the (little) extra mm_struct storage and maintenance, but you could
add a VmShmSize, which shows that subset of VmSize (total_vm) which
is occupied by shmem mappings.

It's ambiguous what to deduce when VmShm is less than VmShmSize:
the difference might be swapped out, it might be holes in the sparse
object, it might be instantiated in the object but never faulted
into the mapping: in general it will be a mix of all of those.
So, sometimes useful info, but easy to be misled by it.

As I say, I don't know if VmShmSize would be worth adding, given its
deficiencies; and it could be worked out from /proc/<pid>/maps anyway.

Hugh
