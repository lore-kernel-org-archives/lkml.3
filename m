Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945984AbaD3SmF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 14:42:05 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:46593 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945941AbaD3SmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 14:42:03 -0400
MIME-Version: 1.0
X-Originating-IP: [46.139.80.5]
In-Reply-To: <20140430183650.GQ18016@ZenIV.linux.org.uk>
References: <20140429211851.GA32204@dastard>
	<20140429214842.GL18016@ZenIV.linux.org.uk>
	<CA+55aFwcWcyRpwv3us9BbnsjUEfEr1mRjz4RWbcy_tSnZjc_Sw@mail.gmail.com>
	<20140429232013.GM18016@ZenIV.linux.org.uk>
	<20140430023142.GN18016@ZenIV.linux.org.uk>
	<CA+55aFypNxsjJTq_rc2Jx4p_3scJo2VWdt=e8n-9eJ-ZQphnpQ@mail.gmail.com>
	<20140430040436.GO18016@ZenIV.linux.org.uk>
	<20140430154958.GC3113@tucsk.piliscsaba.szeredi.hu>
	<20140430160345.GP18016@ZenIV.linux.org.uk>
	<CAJfpegu+q3sT=8==9K5t4=qeJH2azFcBGeMXUtK3LVSEEzXTUA@mail.gmail.com>
	<20140430183650.GQ18016@ZenIV.linux.org.uk>
Date: Wed, 30 Apr 2014 20:42:01 +0200
Message-ID: <CAJfpegu+=zidycJwcBPjuDLP-ZnGisOGQpD8GKhD-Wz6eNzd9g@mail.gmail.com>
Subject: Re: dcache shrink list corruption?
From: Miklos Szeredi <miklos@szeredi.hu>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 8:36 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Wed, Apr 30, 2014 at 07:33:38PM +0200, Miklos Szeredi wrote:
>> On Wed, Apr 30, 2014 at 6:03 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>> > On Wed, Apr 30, 2014 at 05:49:58PM +0200, Miklos Szeredi wrote:
>> >> > FWIW, the first two are really straightforward expanding the function
>> >> > into its only callsite.  The last needs more splitup.  Not sure if the
>> >> > following is good enough, but it ought to be at least somewhat cleaner.
>> >> > Combined change is identical to the original, so it doesn't invalidate
>> >> > the testing so far...
>> >>
>> >> Hmm, patches look okay, but I'm wondering if we really need the morgue list and
>> >> the waiting.  Why not just skip dentries that are presently being handled by
>> >> dentry_kill()?
>> >
>> > Who will be freeing them?  If we do that from dentry_kill(), we are back to
>> > needing them removed from shrink list by something called by dput().  And
>> > if we do that from shrink_dentry_list(), we'd damn better wait for
>> > dentry_iput() et.al. to finish.
>>
>> We can do it from dput if the shrinker gets there first and from the
>> shrinker if dput manages to finish before.  See the updated patch in
>> the previous mail.
>
> Er?  The only patch I see is removal of RCU from shrink_dentry_list(), which
> is fine, but doesn't do anything of that sort.  What was the Message-ID?

Message-ID: <20140430154958.GC3113@tucsk.piliscsaba.szeredi.hu>

>
> Let me see if I understand what you are proposing:
>         dentry_kill(dentry, 0) seeing DCACHE_DENTRY_KILLED
>                 check DCACHE_MAY_FREE, free it's been set
>         dentry_kill(dentry, 1) seeing that we are on shrinker list
>                 leave on the list, do the work on killing, retake ->d_lock,
>                 if we are still on shrinker list
>                         set DCACHE_MAY_FREE,
>                 else
>                         free it
>
> That would probably work...

Exactly.

Thanks,
Miklos
