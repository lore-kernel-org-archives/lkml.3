Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751607Ab3HTHV7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 03:21:59 -0400
Received: from mail-vb0-f42.google.com ([209.85.212.42]:51492 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259Ab3HTHV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 03:21:57 -0400
MIME-Version: 1.0
X-Google-Sender-Delegation: getarunks@gmail.com
In-Reply-To: <20130820055153.GH27005@ZenIV.linux.org.uk>
References: <CAKZGPANQz5-uyf=uSp_0HxBq1_uH053H0XOohpAaWsbeoy7zhw@mail.gmail.com>
	<20130820055153.GH27005@ZenIV.linux.org.uk>
Date: Tue, 20 Aug 2013 12:51:56 +0530
X-Google-Sender-Auth: vuatiPb4h7XUd-ZjHcsWQY33PwM
Message-ID: <CAKZGPAN3W_FFHcxnatFJNQ9VDt-TL9c2Wyddqvdz98612U4gzQ@mail.gmail.com>
Subject: Re: [PATCH v1] seq_file: Fix overflow condition in seq_commit
From: Arun KS <arunks.linux@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <matthew@wil.cx>,
        Bruce Fields <bfields@fieldses.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, vinayak menon <vinayakm.list@gmail.com>,
        Nagachandra P <nagachandra@gmail.com>, Vikram MP <mp.vikram@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al Viro,

On Tue, Aug 20, 2013 at 11:21 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Tue, Aug 20, 2013 at 10:55:40AM +0530, Arun KS wrote:
>> >From 932a134abeac597f18c86c513704709ad154994b Mon Sep 17 00:00:00 2001
>> From: Arun KS <arun.ks@broadcom.com>
>> Date: Mon, 19 Aug 2013 12:06:33 +0530
>> Subject: seq_file: Fix overflow condition in seq_commit
>>
>> seq_path()/seq_commit() is treating a d_path() failure as an overflow
>> condition, but it isn't.
>>
>> seq_read handles overflow by reallocating more buffer. And this
>> continues in a loop utill we increase the size of seq buf beyond
>> KMALLOC_MAX_SIZE and hence a WARN_ON.
>>
>> [  363.192565] ------------[ cut here ]------------
>> [  363.199462] WARNING: at mm/slab_common.c:377 kmalloc_slab+0x34/0x9c()
>> [  363.208557] Modules linked in:
>> [  363.212219] CPU: 1 PID: 1742 Comm: Binder_2 Tainted: G        W3.10.0+ #17
>> [  363.222930] [<c00151c4>] (unwind_backtrace+0x0/0x11c)
>> from[<c0011a24>] (show_stack+0x10/0x14)
>> [  363.235229] [<c0011a24>] (show_stack+0x10/0x14) from
>> [<c0059fb0>](warn_slowpath_common+0x4c/0x68)
>> [  363.247253] [<c0059fb0>] (warn_slowpath_common+0x4c/0x68)
>> from[<c0059fe4>] (warn_slowpath_null+0x18/0x1c)
>> [  363.259307] [<c0059fe4>] (warn_slowpath_null+0x18/0x1c)
>> from[<c00fa400>] (kmalloc_slab+0x34/0x9c)
>> [  363.270812] [<c00fa400>] (kmalloc_slab+0x34/0x9c) from
>> [<c010ec20>](__kmalloc+0x14/0x1fc)
>> [  363.281433] [<c010ec20>] (__kmalloc+0x14/0x1fc) from
>> [<c012ef70>](seq_read+0x24c/0x438)
>> [  363.291992] [<c012ef70>] (seq_read+0x24c/0x438) from
>> [<c011389c>](vfs_read+0xac/0x124)
>> [  363.302398] [<c011389c>] (vfs_read+0xac/0x124) from
>> [<c0113a38>](SyS_read+0x3c/0x60)
>> [  363.312591] [<c0113a38>] (SyS_read+0x3c/0x60) from
>> [<c000e180>](ret_fast_syscall+0x0/0x48)
>> [  363.323303] ---[ end trace 46c6467e2db7bcd4 ]---
>>
>> Pass -ENOBUFS to seq_commit to signal an overflow condition and a
>> negative value for all other errors.
>
> Excuse me, _what_ other errors?  Please, explain what errors can
> be returned by d_path/__d_path/dentry_path.  Normally all of those
> return ERR_PTR(-ENAMETOOLONG) if the pathname to be generated would
> not fit into a buffer.  In which case the only sane behaviour is
> to use a bigger buffer.

d_path expects the pathname to be less than 64 bytes. If its more than
64, it returns -ENAMETOOLONG.

File:fs/dcache.c

char *dynamic_dname(struct dentry *dentry, char *buffer, int buflen,
                        const char *fmt, ...)
{
        va_list args;
        char temp[64];
        int sz;

        va_start(args, fmt);
        sz = vsnprintf(temp, sizeof(temp), fmt, args) + 1;
        va_end(args);

        if (sz > sizeof(temp) || sz > buflen)
                return ERR_PTR(-ENAMETOOLONG);

        buffer += buflen - sz;
        return memcpy(buffer, temp, sz);
}

The string name which give error is,
"dev/ashmem/CursorWindow:
/data/data/com.android.providers.settings/databases/settings.db"

when sz>sizeof(temp), dynamic_dname returns -ENAMETOOLONG.
In this instance, sz is coming as 100.

This always happens from shared mem, after shmem_dname function was
added by the following commit.

commit 3451538a114d738a6528b1da58e19e7d8964c647
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Thu Feb 14 22:38:02 2013 -0500

    shmem_setup_file(): use d_alloc_pseudo() instead of d_alloc()

    Note that provided ->d_dname() reproduces what we used to get for
    those guys in e.g. /proc/self/maps; it might be a good idea to change
    that to something less ugly, but for now let's keep the existing
    user-visible behaviour

    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>


Thanks,
Arun


>
> Could you please post the reproducer for that trace of yours?
> I might be missing something obvious, of course, but AFAICS you
> are just papering over a bug somewhere else.  If you really
> manage to get d_path() with output that wouldn't fit into 128Mb,
> you have a whole lot of unpleasant problems beyond a warning in
> seq_read().  And silent truncation of pathnames that don't happen
> to fit into what's left of the default buffer is simply wrong -
> 4095-byte pathnames are perfectly fine.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
