Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750963AbaCTECs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 00:02:48 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:53544 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbaCTECd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 00:02:33 -0400
MIME-Version: 1.0
In-Reply-To: <20140320034829.GW18016@ZenIV.linux.org.uk>
References: <20140319213754.GA25719@rabbit.intern.cm-ag>
	<20140319213945.25858.14175.stgit@rabbit.intern.cm-ag>
	<20140320034829.GW18016@ZenIV.linux.org.uk>
Date: Wed, 19 Mar 2014 21:02:33 -0700
X-Google-Sender-Auth: CvjNxcDpt46t3_AKbp1DoQnHjZQ
Message-ID: <CA+55aFzsD3cvmQN_JFRkiNrQ=0G474_fi0Ki5hCyonxd8vw=pA@mail.gmail.com>
Subject: Re: [PATCH] fs/namespace: don't clobber mnt_hash.next while umounting [v2]
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Max Kellermann <mk@cm4all.com>, max@duempel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 8:48 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> NAK.  Nice catch, the bug is real, but the fix is wrong.  For one thing,
> you have missed detach_mnt()/attach_mnt(), so you are not covering
> all places where the sucker might be removed from the list.  For another,
> I don't believe that this is the right approach.
>
> The *only* thing we care about is not getting stuck in __lookup_mnt().

Quite frankly, if that's the main issue, then may I suggest aiming to
use a 'hlist' instead of a doubly-linked list? Those have the
advantage that they are NULL-terminated.

Yeah, hlists have some disadvantages too, which might not make them
work in this case, but really, for mnt_hash? hlists are generally
*exactly* what you want for hash lists, because the head is smaller.
And because of the NULL termination rather than having the head used
in the middle of a circular list, you don't get the termination
problems when moving entries across chains.

I did not look whether there was some reason a hlist isn't appropriate
here. Maybe you can tell me. Or go "yeah, a hlist would work nicely".

                Linus
