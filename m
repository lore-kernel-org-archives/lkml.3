Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933921AbaFQUc6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 16:32:58 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:31007 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933882AbaFQUcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 16:32:54 -0400
Message-ID: <53A0A5E7.60908@oracle.com>
Date: Tue, 17 Jun 2014 16:32:39 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: mm: shm: hang in shmem_fallocate
References: <52AE7B10.2080201@oracle.com> <52F6898A.50101@oracle.com> <alpine.LSU.2.11.1402081841160.26825@eggly.anvils> <52F82E62.2010709@oracle.com> <539A0FC8.8090504@oracle.com> <alpine.LSU.2.11.1406151921070.2850@eggly.anvils>
In-Reply-To: <alpine.LSU.2.11.1406151921070.2850@eggly.anvils>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2014 10:29 PM, Hugh Dickins wrote:
> On Thu, 12 Jun 2014, Sasha Levin wrote:
>> > On 02/09/2014 08:41 PM, Sasha Levin wrote:
>>> > > On 02/08/2014 10:25 PM, Hugh Dickins wrote:
>>>> > >> Would trinity be likely to have a thread or process repeatedly faulting
>>>> > >> in pages from the hole while it is being punched?
>>> > > 
>>> > > I can see how trinity would do that, but just to be certain - Cc davej.
>>> > > 
>>> > > On 02/08/2014 10:25 PM, Hugh Dickins wrote:
>>>> > >> Does this happen with other holepunch filesystems?  If it does not,
>>>> > >> I'd suppose it's because the tmpfs fault-in-newly-created-page path
>>>> > >> is lighter than a consistent disk-based filesystem's has to be.
>>>> > >> But we don't want to make the tmpfs path heavier to match them.
>>> > > 
>>> > > No, this is strictly limited to tmpfs, and AFAIK trinity tests hole
>>> > > punching in other filesystems and I make sure to get a bunch of those
>>> > > mounted before starting testing.
>> > 
>> > Just pinging this one again. I still see hangs in -next where the hang
>> > location looks same as before:
>> > 
> Please give this patch a try.  It fixes what I can reproduce, but given
> your unexplained page_mapped() BUG in this area, we know there's more
> yet to be understood, so perhaps this patch won't do enough for you.
> 
> 
> [PATCH] shmem: fix faulting into a hole while it's punched
> 
> Trinity finds that mmap access to a hole while it's punched from shmem
> can prevent the madvise(MADV_REMOVE) or fallocate(FALLOC_FL_PUNCH_HOLE)
> from completing, until the reader chooses to stop; with the puncher's
> hold on i_mutex locking out all other writers until it can complete.
> 
> It appears that the tmpfs fault path is too light in comparison with
> its hole-punching path, lacking an i_data_sem to obstruct it; but we
> don't want to slow down the common case.
> 
> Extend shmem_fallocate()'s existing range notification mechanism, so
> shmem_fault() can refrain from faulting pages into the hole while it's
> punched, waiting instead on i_mutex (when safe to sleep; or repeatedly
> faulting when not).
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>

No shmem_fallocate issues observed in the past day, works for me. Thanks Hugh!


Thanks,
Sasha
