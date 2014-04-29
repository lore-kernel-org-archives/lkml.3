Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964915AbaD2SD0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 14:03:26 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:49701 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933692AbaD2SDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 14:03:25 -0400
MIME-Version: 1.0
X-Originating-IP: [46.139.80.5]
In-Reply-To: <CA+55aFwJ0mAnkP6rwv3_nDHZ1U3SH_pbRCj-bBN5SdRVR2FCZA@mail.gmail.com>
References: <20140429160139.GA3113@tucsk.piliscsaba.szeredi.hu>
	<CA+55aFwJ0mAnkP6rwv3_nDHZ1U3SH_pbRCj-bBN5SdRVR2FCZA@mail.gmail.com>
Date: Tue, 29 Apr 2014 20:03:24 +0200
Message-ID: <CAJfpegvbzQc2y12_MV6MZ398ggjkc1w73Px7pXViGnSm=+syNA@mail.gmail.com>
Subject: Re: dcache shrink list corruption?
From: Miklos Szeredi <miklos@szeredi.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 7:43 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Tue, Apr 29, 2014 at 9:01 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> This was reported by IBM for 3.12, but if my analysis is right, it affects
>> current kernel as well as older ones.
>>
>> So the question is: does anything protect the shrink list from concurrent
>> modification by one or more dput() instances?
>
> Ugh. I don't see anything. The shrinking list is a private list, so
> adding on its own would be entirely safe, and I think that's where the
> "we don't need no steenking locking" comes from.
>
> But yes, the dentries are then visible on the hash chains, and there
> can be concurrent removals from the list.
>
> That new global lock smells, though - and if we want to use a global
> lock, we should simply use the existing per-superblock LRU lock, not
> make up some new global one. The moving case already holds it, can't
> we just take it in the add/del case? Was there some reason you didn't
> do that?

Because we no longer have that.  It now uses the list_lru thing, with
a "per-node" lock, whatever that one is.

Introducing a new per-sb lock should be OK.

Another idea, which could have subtler effects, is simply not to kill
a dentry that is on the shrink list (indicated by
DCACHE_SHRINK_LIST), since it's bound to get killed anyway.  But
that's a change in behaviour...

>
> Let me think about it, maybe there's some trick we can do by virtue of
> the list head being private and us holding the dentry lock. So at
> least on addition, we have *two* of the tree involved nodes locked.
> Does that perhaps allow for any lockless games to be played?

I don't understand how that could be made to work.
