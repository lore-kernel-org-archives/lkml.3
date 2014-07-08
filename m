Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752AbaGHQzA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 12:55:00 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:54401 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754479AbaGHQy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 12:54:57 -0400
MIME-Version: 1.0
In-Reply-To: <1402655819-14325-1-git-send-email-dh.herrmann@gmail.com>
References: <1402655819-14325-1-git-send-email-dh.herrmann@gmail.com>
Date: Tue, 8 Jul 2014 18:54:56 +0200
Message-ID: <CANq1E4QZ95RmJ7i=6TzEP4e+WREzKtXmmjjDrvz4BgAhVHoeuQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/7] File Sealing & memfd_create()
From: David Herrmann <dh.herrmann@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>, Ryan Lortie <desrt@desrt.ca>,
        linux-mm <linux-mm@kvack.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        Greg Kroah-Hartman <greg@kroah.com>,
        John Stultz <john.stultz@linaro.org>,
        Lennart Poettering <lennart@poettering.net>,
        Daniel Mack <zonque@gmail.com>, Kay Sievers <kay@vrfy.org>,
        Tony Battersby <tonyb@cybernetics.com>,
        Andy Lutomirski <luto@amacapital.net>,
        David Herrmann <dh.herrmann@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Fri, Jun 13, 2014 at 12:36 PM, David Herrmann <dh.herrmann@gmail.com> wrote:
> Hi
>
> This is v3 of the File-Sealing and memfd_create() patches. You can find v1 with
> a longer introduction at gmane:
>   http://thread.gmane.org/gmane.comp.video.dri.devel/102241
> An LWN article about memfd+sealing is available, too:
>   https://lwn.net/Articles/593918/
> v2 with some more discussions can be found here:
>   http://thread.gmane.org/gmane.linux.kernel.mm/115713
>
> This series introduces two new APIs:
>   memfd_create(): Think of this syscall as malloc() but it returns a
>                   file-descriptor instead of a pointer. That file-descriptor is
>                   backed by anon-memory and can be memory-mapped for access.
>   sealing: The sealing API can be used to prevent a specific set of operations
>            on a file-descriptor. You 'seal' the file and give thus the
>            guarantee, that it cannot be modified in the specific ways.
>
> A short high-level introduction is also available here:
>   http://dvdhrm.wordpress.com/2014/06/10/memfd_create2/
>
>
> Changed in v3:
>  - fcntl() now returns EINVAL if the FD does not support sealing. We used to
>    return EBADF like pipe_fcntl() does, but that is really weird and I don't
>    like repeating that.
>  - seals are now saved as "unsigned int" instead of "u32".
>  - i_mmap_writable is now an atomic so we can deny writable mappings just like
>    i_writecount does.
>  - SHMEM_ALLOW_SEALING is dropped. We initialize all objects with F_SEAL_SEAL
>    and only unset it for memfds that shall support sealing.
>  - memfd_create() no longer has a size argument. It was redundant, use
>    ftruncate() or fallocate().
>  - memfd_create() flags are "unsigned int" now, instead of "u64".
>  - NAME_MAX off-by-one fix
>  - several cosmetic changes
>  - Added AIO/Direct-IO page-pinning protection
>
> The last point is the most important change in this version: We now bail out if
> any page-refcount is elevated while setting SEAL_WRITE. This prevents parallel
> GUP users from writing to sealed files _after_ they were sealed. There is also a
> new FUSE-based test-case to trigger such situations.
>
> The last 2 patches try to improve the page-pinning handling. I included both in
> this series, but obviously only one of them is needed (or we could stack them):
>  - 6/7: This waits for up to 150ms for pages to be unpinned
>  - 7/7: This isolates pinned pages and replaces them with a fresh copy
>
> Hugh, patch 6 is basically your code. In case that gets merged, can I put your
> Signed-off-by on it?

Hugh, any comments on patch 5, 6 and 7? Those are the last outstanding
issues with memfd+sealing. Patch 7 (isolating pages) is still my
favorite and has been running just fine on my machine for the last
months. I think it'd be nice if we could give it a try in -next. We
can always fall back to Patch 5 or Patch 5+6. Those will detect any
racing AIO and just fail or wait for the IO to finish for a short
period.

Are there any other blockers for this?

Thanks
David
