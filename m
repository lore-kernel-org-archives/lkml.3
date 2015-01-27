Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760033AbbA0VUu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 16:20:50 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:42326 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759982AbbA0VUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 16:20:47 -0500
Date: Wed, 28 Jan 2015 00:20:44 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Calvin Owens <calvinowens@fb.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Peter Feiner <pfeiner@google.com>,
        Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [PATCH] docs: procs -- Describe /proc/<pid>/map_files entry
Message-ID: <20150127212044.GO651@moon>
References: <20150127094103.GK651@moon>
 <CAGXu5jJ0oNeMq+gibuHfB-j_ZooGnuZ_o1aCoMO=qMWen+HQUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jJ0oNeMq+gibuHfB-j_ZooGnuZ_o1aCoMO=qMWen+HQUw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 11:50:49AM -0800, Kees Cook wrote:
> > +
> > +The main purpose of map_files directory is to be able to retrieve a set of
> > +memory mapped files in a fast way instead of parsing /proc/<pid>/maps or
> > +/proc/<pid>/smaps which contain a way more records. Same time one can open(2)
> > +mappings from the listings of two processes and comparing inodes figure out
> > +which anonymous memory areas are actually shared.
> 
> Thanks for details! I still don't understand how this is used for
> checkpoint/restore when the mmap offset isn't shown. Can't a process
> map, say 4K of a file, from different offsets, and it would show up
> as:
> 
> 400000-401000 -> /some/file
> 401000-402000 -> /some/file
> 
> but there'd be no way to know how to restore that mapping?

In criu we use a few sources of information (ie we scan not only
map_files, but have to use /proc/pid/smaps as well which has
offset for mapping). So at the end we have all picture under
our hands.

> Are these symlinks "regular" symlinks, or are they something more
> special that bypasses VFS? If it bypasses VFS, I think adding and open
> check with PTRACE_ATTACH is needed, since now you're able to _modify_
> the memory space of the target process instead of just reading it.

Opening them goes same way as open of /proc/pid/fd/ entries as
far as I can tell. This should be enough, or I miss something
obvious here? Otherwise opening /proc/pid/fd/ should use
PTRACE_ATTACH instead of PTRACE_MODE_READ (as in proc_fd_access_allowed).
