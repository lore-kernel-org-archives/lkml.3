Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751702AbaKFMZw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 07:25:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48717 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660AbaKFMZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 07:25:48 -0500
Message-ID: <545B68C9.2060107@suse.cz>
Date: Thu, 06 Nov 2014 13:25:45 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>, Norbert Preining <preining@logic.at>
CC: linux-kernel@vger.kernel.org
Subject: Re: khugepaged / firefox going wild in 3.18-rc
References: <20141104232027.GO13232@auth.logic.tuwien.ac.at> <alpine.DEB.2.10.1411041559170.2720@chino.kir.corp.google.com> <20141105001026.GQ13232@auth.logic.tuwien.ac.at> <20141105001243.GR13232@auth.logic.tuwien.ac.at> <alpine.DEB.2.10.1411041615270.5391@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.10.1411041615270.5391@chino.kir.corp.google.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2014 01:20 AM, David Rientjes wrote:
> On Wed, 5 Nov 2014, Norbert Preining wrote:
> 
>> Hi David,
>> 
>> one more thing, attached dmesg output with some page faults,
>> maybe this is connected?
>> 
> 
> Hmm, I'm not aware of any mm->mmap_sem starvation issues in 3.18-rc, maybe 
> this is a duplicate of another issue that someone has reported that I 
> haven't seen.  The lengthy output of echo t > /proc/sysrq-trigger should 
> give a clue as to what is holding it or perhaps this is a more generic 
> rwsem issue.

Could be that another task holds the mmap_sem during THP allocation attempt on
its own page fault, and compaction goes in some kind of infinite loop. There are
two other threads that look similar:

http://article.gmane.org/gmane.linux.kernel.mm/124451/match=isolate_freepages_block+very+high+intermittent+overhead

https://lkml.org/lkml/2014/11/4/144

I suggested testing a commit revert in one thread, and a possible fix in the
other. If you can reproduce this well, that would be very useful.

khugepaged using CPU also points to either the address space scanning, or
compaction going wrong. Since 8b1645685ac it shouldn't hold mmap_sem during
compaction, but that still leaves page faulters to possibly hold it.

So yeah we would need the stacks of processes that do hog the CPU's, not those
that sleep. As David suggested, a /proc/pid/stack could work. Also can you
please provide /proc/zoneinfo ?

Thanks,
Vlastimil

