Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013AbaFMPGz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 11:06:55 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:60649 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956AbaFMPGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 11:06:52 -0400
MIME-Version: 1.0
In-Reply-To: <1402655819-14325-8-git-send-email-dh.herrmann@gmail.com>
References: <1402655819-14325-1-git-send-email-dh.herrmann@gmail.com> <1402655819-14325-8-git-send-email-dh.herrmann@gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 13 Jun 2014 08:06:31 -0700
Message-ID: <CALCETrWaUsq_D2Z1PwbbwQQWKrnsWTLOdUR6bqPuedi8ZHgvEQ@mail.gmail.com>
Subject: Re: [RFC v3 7/7] shm: isolate pinned pages when sealing files
To: David Herrmann <dh.herrmann@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>, Ryan Lortie <desrt@desrt.ca>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        Greg Kroah-Hartman <greg@kroah.com>,
        John Stultz <john.stultz@linaro.org>,
        Lennart Poettering <lennart@poettering.net>,
        Daniel Mack <zonque@gmail.com>, Kay Sievers <kay@vrfy.org>,
        Hugh Dickins <hughd@google.com>,
        Tony Battersby <tonyb@cybernetics.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 3:36 AM, David Herrmann <dh.herrmann@gmail.com> wrote:
> When setting SEAL_WRITE, we must make sure nobody has a writable reference
> to the pages (via GUP or similar). We currently check references and wait
> some time for them to be dropped. This, however, might fail for several
> reasons, including:
>  - the page is pinned for longer than we wait
>  - while we wait, someone takes an already pinned page for read-access
>
> Therefore, this patch introduces page-isolation. When sealing a file with
> SEAL_WRITE, we copy all pages that have an elevated ref-count. The newpage
> is put in place atomically, the old page is detached and left alone. It
> will get reclaimed once the last external user dropped it.
>
> Signed-off-by: David Herrmann <dh.herrmann@gmail.com>

Won't this have unexpected effects?

Thread 1:  start read into mapping backed by fd

Thread 2:  SEAL_WRITE

Thread 1: read finishes.  now the page doesn't match the sealed page

Is this okay?  Or am I missing something?

Are there really things that keep unnecessary writable pins around?

--Andy
