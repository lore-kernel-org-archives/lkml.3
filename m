Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274AbaKDUZP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 15:25:15 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:55387 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbaKDUZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 15:25:13 -0500
MIME-Version: 1.0
In-Reply-To: <20141104201620.GL7996@ZenIV.linux.org.uk>
References: <1415096851-17209-1-git-send-email-jack@suse.cz>
 <20141104153940.GH7996@ZenIV.linux.org.uk> <54592D49.4070704@amacapital.net>
 <CALCETrViY8biMs=D9XKAJx-9m5iEEUCbpzmOR2QFVyxcdoczxQ@mail.gmail.com> <20141104201620.GL7996@ZenIV.linux.org.uk>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 4 Nov 2014 12:24:52 -0800
Message-ID: <CALCETrUgPj=LdLDhdt9AequiMYFSV6B2A6HBVwSsJvyMu1X+6A@mail.gmail.com>
Subject: Re: [PATCH 0/4 v3] fs: Remove i_devices from struct inode
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 4, 2014 at 12:16 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Tue, Nov 04, 2014 at 11:52:22AM -0800, Andy Lutomirski wrote:
>
>> Let me try again, though: what if a chardev inode replaced i_cdev with
>> NULL and dropped its kobj reference in iput_final?  This would add a
>> bit over overhead to things that repeatedly open and close the same
>> device node, but I doubt this matters much.
>
> How is it different from what Jan proposed?  The whole problem is that
> iput_final() is too late.  We could clean the reference on close, all
> right, and have it looked up again on every open, but I'm not at all sure
> that situation with opening/closing cdev is never a hot path, especially with
> udev playing silly buggers, etc.

I thought the issue was inodes on the LRU list holding references open.

Anyway, the only expensive part of recreating the reference seems to
be kobj_lookup, and that doesn't look so bad.  If there's a case where
the performance impact would matter at all, maybe that's an argument
for fixing it.

And is udev really opening the same device node more than once?  I can
see once for blkid and such, but I don't see where a second open call
would come from.

--Andy
