Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934013AbaD2RnJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 13:43:09 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:40118 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932491AbaD2RnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 13:43:07 -0400
MIME-Version: 1.0
In-Reply-To: <20140429160139.GA3113@tucsk.piliscsaba.szeredi.hu>
References: <20140429160139.GA3113@tucsk.piliscsaba.szeredi.hu>
Date: Tue, 29 Apr 2014 10:43:05 -0700
X-Google-Sender-Auth: XkaQUG3XKhKtnnju_olzA43aupI
Message-ID: <CA+55aFwJ0mAnkP6rwv3_nDHZ1U3SH_pbRCj-bBN5SdRVR2FCZA@mail.gmail.com>
Subject: Re: dcache shrink list corruption?
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 9:01 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> This was reported by IBM for 3.12, but if my analysis is right, it affects
> current kernel as well as older ones.
>
> So the question is: does anything protect the shrink list from concurrent
> modification by one or more dput() instances?

Ugh. I don't see anything. The shrinking list is a private list, so
adding on its own would be entirely safe, and I think that's where the
"we don't need no steenking locking" comes from.

But yes, the dentries are then visible on the hash chains, and there
can be concurrent removals from the list.

That new global lock smells, though - and if we want to use a global
lock, we should simply use the existing per-superblock LRU lock, not
make up some new global one. The moving case already holds it, can't
we just take it in the add/del case? Was there some reason you didn't
do that?

Let me think about it, maybe there's some trick we can do by virtue of
the list head being private and us holding the dentry lock. So at
least on addition, we have *two* of the tree involved nodes locked.
Does that perhaps allow for any lockless games to be played?

               Linus
