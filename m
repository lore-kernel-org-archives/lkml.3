Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936005Ab3BOQOO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 11:14:14 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:61922 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932675Ab3BOQON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 11:14:13 -0500
MIME-Version: 1.0
In-Reply-To: <20130215110401.GA31037@dhcp22.suse.cz>
References: <20130214120349.GD7367@suse.de>
	<20130214123926.599fcef8.akpm@linux-foundation.org>
	<20130215110401.GA31037@dhcp22.suse.cz>
Date: Fri, 15 Feb 2013 17:14:10 +0100
Message-ID: <CAJCc=ki+_PVT8fH43PoDVN2-5Wq0a1vQfFihJ_6F7==+RSAzYQ@mail.gmail.com>
Subject: Re: [PATCH] mm: fadvise: Drain all pagevecs if POSIX_FADV_DONTNEED
 fails to discard all pages
From: Rob van der Heij <rvdheij@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Hugh Dickins <hughd@google.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 February 2013 12:04, Michal Hocko <mhocko@suse.cz> wrote:
> On Thu 14-02-13 12:39:26, Andrew Morton wrote:
>> On Thu, 14 Feb 2013 12:03:49 +0000
>> Mel Gorman <mgorman@suse.de> wrote:
>>
>> > Rob van der Heij reported the following (paraphrased) on private mail.
>> >
>> >     The scenario is that I want to avoid backups to fill up the page
>> >     cache and purge stuff that is more likely to be used again (this is
>> >     with s390x Linux on z/VM, so I don't give it as much memory that
>> >     we don't care anymore). So I have something with LD_PRELOAD that
>> >     intercepts the close() call (from tar, in this case) and issues
>> >     a posix_fadvise() just before closing the file.
>> >
>> >     This mostly works, except for small files (less than 14 pages)
>> >     that remains in page cache after the face.
>>
>> Sigh.  We've had the "my backups swamp pagecache" thing for 15 years
>> and it's still happening.
>>
>> It should be possible nowadays to toss your backup application into a
>> container to constrain its pagecache usage.  So we can type
>>
>>       run-in-a-memcg -m 200MB /my/backup/program
>>
>> and voila.  Does such a script exist and work?
>
> The script would be as simple as:
> cgcreate -g memory:backups/`whoami`
> cgset -r memory.limit_in_bytes=200MB backups/`whoami`
> cgexec -g memory:backups/`whoami` /my/backup/program
>
> It just expects that admin sets up backups group which allows the user
> to create a subgroup (w permission on the directory) and probably set up
> some reasonable cap for all backups

Cool. This is promising enough to bridge my skills gap. It appears to
work as promised, but I would have to understand why it takes
significantly more CPU than my ugly posix_fadvise() call on close...

Rob
