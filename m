Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759676Ab3CHXUm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 18:20:42 -0500
Received: from mail-ve0-f182.google.com ([209.85.128.182]:42794 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756158Ab3CHXUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 18:20:41 -0500
MIME-Version: 1.0
In-Reply-To: <20130308230734.GA28317@redhat.com>
References: <20130307021645.GA10173@redhat.com>
	<20130308150408.GA25399@redhat.com>
	<CA+55aFxAfWHdSH+45qgids1ByBxzieZnz_ujRXYGY-at1mg5eg@mail.gmail.com>
	<20130308191804.GA9774@redhat.com>
	<20130308192042.GA10305@redhat.com>
	<20130308193652.GA11692@redhat.com>
	<CA+55aFyE12rZ3DZUtTkonPjbcQiZNdAmys7w5zf7_Xry2z=-2A@mail.gmail.com>
	<20130308210432.GA21500@redhat.com>
	<CA+55aFyNAA3u2k_38iqRPN0EqtP=qXu1wu_vnXnAgQmp6NwGJA@mail.gmail.com>
	<20130308230734.GA28317@redhat.com>
Date: Fri, 8 Mar 2013 15:20:40 -0800
X-Google-Sender-Auth: Xvu8HElBZ4XTwWWoZzfGnUAmawA
Message-ID: <CA+55aFxKgZyqbn1M0sAL0CoLxmKSzAALYBTPLYVM7OpG_M_B=A@mail.gmail.com>
Subject: Re: BUG_ON(nd->inode != parent->d_inode);
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 8, 2013 at 3:07 PM, Dave Jones <davej@redhat.com> wrote:
>
> Ok, got something more meaningful out of the lookup_slow trace.
>
> [   66.082984] parent->dname.name  (06b6b6b6b6b6b6b)
> [   66.083637] parent =
>
> At first I thought AH-HA! SLAB POISON!
> But look closer.. it's shifted by 8 bits.

Or just the high byte has been cleared.

But yeah, if the parent has been free'd then that certainly explains
why the "impossible" test of

  nd->inode != parent->d_inode

would trigger. And it would explain any odd crashes at lookup time
too. In particular, the NULL pointer one you reference seems to be
dir->i_op->lookup being NULL, so calling it (understandable) ends up
doing bad things.

I really don't understand how the parent could be free'd early.
Dentries are freed by RCU, and the dentry lookup code is some of the
most well-tested out there. I don't see how /proc could mess that up,
unless it just completely screws up some refcounting thing or other.

                 Linus
