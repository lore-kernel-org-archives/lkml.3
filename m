Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759145AbaCTPsd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 11:48:33 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:57681 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757263AbaCTPsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 11:48:31 -0400
MIME-Version: 1.0
In-Reply-To: <20140320153250.GC20618@thunk.org>
References: <1395256011-2423-1-git-send-email-dh.herrmann@gmail.com>
	<20140320153250.GC20618@thunk.org>
Date: Thu, 20 Mar 2014 16:48:30 +0100
Message-ID: <CANq1E4SUXrzAV8FS8HVYxnRVb1oOR6HSTyucJzyFs5PuS5Y88A@mail.gmail.com>
Subject: Re: [PATCH 0/6] File Sealing & memfd_create()
From: David Herrmann <dh.herrmann@gmail.com>
To: tytso@mit.edu, David Herrmann <dh.herrmann@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Karol Lewandowski <k.lewandowsk@samsung.com>,
        Kay Sievers <kay@vrfy.org>, Daniel Mack <zonque@gmail.com>,
        Lennart Poettering <lennart@poettering.net>,
        John Stultz <john.stultz@linaro.org>,
        Greg Kroah-Hartman <greg@kroah.com>, Tejun Heo <tj@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ryan Lortie <desrt@desrt.ca>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Thu, Mar 20, 2014 at 4:32 PM,  <tytso@mit.edu> wrote:
> Why not make sealing an attribute of the "struct file", and enforce it
> at the VFS layer?  That way all file system objects would have access
> to sealing interface, and for memfd_shmem, you can't get another
> struct file pointing at the object, the security properties would be
> identical.

Sealing as introduced here is an inode-attribute, not "struct file".
This is intentional. For instance, a gfx-client can get a read-only FD
via /proc/self/fd/ and pass it to the compositor so it can never
overwrite the contents (unless the compositor has write-access to the
inode itself, in which case it can just re-open it read-write).

Furthermore, I don't see any use-case besides memfd for sealing, so I
purposely avoided changing core VFS interfaces. Protecting
page-allocation/access for SEAL_WRITE like I do in shmem.c is not that
easy to do generically. So if we moved this interface to "struct
inode", all that would change is moving "u32 seals;" from one struct
to the other. Ok, some protections might get easily implemented
generically, but I without proper insight in the underlying
implemenation, I couldn't verify all paths and possible races. Isn't
keeping the API generic enough so far? Changing the underlying
implementation can be done once we know what we want.

Thanks
David
