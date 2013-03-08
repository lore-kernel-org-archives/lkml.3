Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933293Ab3CHHqs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 02:46:48 -0500
Received: from zill.ext.symas.net ([69.43.206.106]:51783 "EHLO
	zill.ext.symas.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283Ab3CHHqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 02:46:47 -0500
Message-ID: <5139975F.9070509@symas.com>
Date: Thu, 07 Mar 2013 23:46:39 -0800
From: Howard Chu <hyc@symas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:22.0) Gecko/20100101 Firefox/22.0 SeaMonkey/2.19a1
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>, Jan Kara <jack@suse.cz>
CC: linux-kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: mmap vs fs cache
References: <5136320E.8030109@symas.com> <20130307154312.GG6723@quack.suse.cz> <20130308020854.GC23767@cmpxchg.org>
In-Reply-To: <20130308020854.GC23767@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Weiner wrote:
> On Thu, Mar 07, 2013 at 04:43:12PM +0100, Jan Kara wrote:

>>> 2 questions:
>>>    why is there data in the FS cache that isn't owned by (the mmap
>>> of) the process that caused it to be paged in in the first place?
>
> The filesystem cache is shared among processes because the filesystem
> is also shared among processes.  If another task were to access the
> same file, we still should only have one copy of that data in memory.

That's irrelevant to the question. As I already explained, the first 16GB that 
was paged in didn't behave this way. Perhaps "owned" was the wrong word, since 
this is a MAP_SHARED mapping. But the point is that the memory is not being 
accounted in slapd's process size, when it was before, up to 16GB.

> It sounds to me like slapd is itself caching all the data it reads.

You're misreading the information then. slapd is doing no caching of its own, 
its RSS and SHR memory size are both the same. All it is using is the mmap, 
nothing else. The RSS == SHR == FS cache, up to 16GB. RSS is always == SHR, 
but above 16GB they grow more slowly than the FS cache.

> If that is true, shouldn't it really be using direct IO to prevent
> this double buffering of filesystem data in memory?

There is no double buffering.

>>>    is there a tunable knob to discourage the page cache from stealing
>>> from the process?
>
> Try reducing /proc/sys/vm/swappiness, which ranges from 0-100 and
> defaults to 60.

I've already tried setting it to 0 with no effect.

-- 
   -- Howard Chu
   CTO, Symas Corp.           http://www.symas.com
   Director, Highland Sun     http://highlandsun.com/hyc/
   Chief Architect, OpenLDAP  http://www.openldap.org/project/
