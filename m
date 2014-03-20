Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751426AbaCTE6Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 00:58:16 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:44877 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854AbaCTE6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 00:58:15 -0400
MIME-Version: 1.0
In-Reply-To: <20140320042155.GY18016@ZenIV.linux.org.uk>
References: <20140319213754.GA25719@rabbit.intern.cm-ag>
	<20140319213945.25858.14175.stgit@rabbit.intern.cm-ag>
	<20140320034829.GW18016@ZenIV.linux.org.uk>
	<CA+55aFzsD3cvmQN_JFRkiNrQ=0G474_fi0Ki5hCyonxd8vw=pA@mail.gmail.com>
	<20140320042155.GY18016@ZenIV.linux.org.uk>
Date: Wed, 19 Mar 2014 21:58:14 -0700
X-Google-Sender-Auth: ujO3_51PQGwgnItac-GbuG3TFjA
Message-ID: <CA+55aFyXsRGGQH_R=vpriA854KkSz4fDyFUQOXbA-w3c+WHp2A@mail.gmail.com>
Subject: Re: [PATCH] fs/namespace: don't clobber mnt_hash.next while umounting [v2]
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Max Kellermann <mk@cm4all.com>, max@duempel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 9:21 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Er...  I have, actually, right in the part you've snipped ;-)

Heh. That's what I get for just reading the patch, and skimming the explanation.

> I would prefer to deal with (1) by turning mnt_hash into hlist; the problem
> with that is __lookup_mnt_last().  That sucker is only called under
> mount_lock, so RCU issues do not play there, but it's there and it
> complicates things.  There might be a way to get rid of that thing for
> good, but that's more invasive than what I'd be happy with for backports.

Yeah. I see what you're saying. That said, if we expect the mnt_hash
queues to be short (and they really should be), that whole
__lookup_mnt_last() could just be

    struct mount *p, *result = NULL;

    hlist_for_each_entry(p, head, mnt_hash)
        if (&p->mnt_parent->mnt == mnt && p->mnt_mountpoint == dentry)
            result = p;

    return result;

which is certainly simple.

Sure, it always walks the whole list, but as far as I can tell the
callers aren't exactly performance-critical, and we're talking about a
hlist that should be just a couple of entries in size..

So if that's the _only_ thing holding back using hlists, I'd say we
should just do the above trivial conversion.

             Linus
