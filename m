Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504Ab3ENRoo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 13:44:44 -0400
Received: from sentry-two.sandia.gov ([132.175.109.14]:60779 "EHLO
	sentry-two.sandia.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530Ab3ENRom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 13:44:42 -0400
X-WSS-ID: 0MMSUMG-0B-0E0-02
X-M-MSG: 
X-Server-Uuid: AF72F651-81B1-4134-BA8C-A8E1A4E620FF
Message-ID: <519277F6.4060808@sandia.gov>
Date: Tue, 14 May 2013 11:44:22 -0600
From: "Jim Schutt" <jaschut@sandia.gov>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402
 Thunderbird/17.0.5
MIME-Version: 1.0
To: "Alex Elder" <elder@inktank.com>
cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] libceph: ceph_pagelist_append might sleep while
 atomic
References: <1368110565-125922-1-git-send-email-jaschut@sandia.gov>
 <519269F2.1000907@inktank.com>
In-Reply-To: <519269F2.1000907@inktank.com>
X-TMWD-Spam-Summary: TS=20130514174422; ID=1; SEV=2.3.1;
 DFV=B2013022509; IFV=NA; AIF=B2013022509; RPD=5.03.0010; ENG=NA;
 RPDID=7374723D303030312E30413031303230322E35313932373746362E303035343A534346535441543838363133332C73733D312C6667733D30;
 CAT=NONE; CON=NONE; SIG=AAABAJsKIgAAAAAAAAAAAAAAAAAAAH0=
X-MMS-Spam-Filter-ID: B2013022509_5.03.0010
X-WSS-ID: 7D8CA87C2IW2788614-01-01
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-RSA-Inspected: yes
X-RSA-Classifications: public
X-RSA-Action: allow
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2013 10:44 AM, Alex Elder wrote:
> On 05/09/2013 09:42 AM, Jim Schutt wrote:
>> Ceph's encode_caps_cb() worked hard to not call __page_cache_alloc while
>> holding a lock, but it's spoiled because ceph_pagelist_addpage() always
>> calls kmap(), which might sleep.  Here's the result:
> 
> I finally took a close look at this today, Jim.  Sorry
> for the delay.
> 

No worries - thanks for taking a look.

> The issue is formatting the reconnect message--which will
> hold an arbitrary amount of data and therefore which we'll
> need to do some allocation (and kmap) for--in the face of
> having to hold the flock spinlock while doing so.
> 
> And as you found, ceph_pagelist_addpage(), which is called
> by ceph_pagelist_append(), calls kmap() even if it doesn't
> need to allocate anything.  This means that despite reserving
> the pages, those pages are in the free list and because they'll
> need to be the subject of kmap() their preallocation doesn't
> help.
> 
> Your solution was to pre-allocate a buffer, format the locks
> into that buffer while holding the lock, then append the
> buffer contents to a pagelist after releasing the lock.  You
> check for a changing (increasing) lock count while you format
> the locks, which is good.
> 
> So...  Given that, I think your change looks good.  It's a shame
> we can't format directly into the pagelist buffer but this won't
> happen much so it's not a big deal.  I have a few small suggestions,
> below.
> 
> I do find some byte order bugs though.   They aren't your doing,
> but I think they ought to be fixed first, as a separate patch
> that would precede this one.  The bug is that the lock counts
> that are put into the buffer (num_fcntl_locks and num_flock_locks)
> are not properly byte-swapped.  I'll point it out inline
> in your code, below.
> 
> I'll say that what you have is OK.  Consider my suggestions, and
> if you choose not to fix the byte order bugs, please let me know.

I'll happily fix up a v2 series with your suggestions addressed.
Thanks for catching those issues.  Stay tuned...

Thanks -- Jim


