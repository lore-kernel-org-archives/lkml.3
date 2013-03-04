Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932525Ab3CDVVe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 16:21:34 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:39604 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758726Ab3CDVVd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 16:21:33 -0500
MIME-Version: 1.0
In-Reply-To: <1362417555.5510.58.camel@mattotaupa>
References: <1362415549-18653-1-git-send-email-taysom@chromium.org>
	<1362417555.5510.58.camel@mattotaupa>
Date: Mon, 4 Mar 2013 13:21:31 -0800
Message-ID: <CAKwO_5GOMN+GL+SO4cBNyhSK_OEbrrDYR=wwEWbgG9S51=tJQg@mail.gmail.com>
Subject: Re: [PATCH] md: dm-verity: Fix to avoid a deadlock in dm-bufio
From: Paul Taysom <taysom@google.com>
To: Paul Menzel <pm.debian@googlemail.com>
Cc: Paul Taysom <taysom@chromium.org>, agk@redhat.com, dm-devel@redhat.com,
        neilb@suse.de, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mandeep Singh Baines <msb@chromium.org>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Olof Johansson <olofj@chromium.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 4, 2013 at 9:19 AM, Paul Menzel <pm.debian@googlemail.com> wrote:
>
> Am Montag, den 04.03.2013, 08:45 -0800 schrieb Paul Taysom:
> > Changed the dm-verity prefetching to use a worker thread to avoid
> > a deadlock in dm-bufio.
>
> Do you know of any bug reports about this? Searching for »dm-verity dead
> lock« I found [1], which seems to be the issue, right? If yes, please
> reference it.
>
> > If generic_make_request is called recursively, it queues the I/O
> > request on the current->bio_list without making the I/O request
> > and returns. The routine making the recursive call cannot wait
> > for the I/O to complete.
> >
> > The deadlock occurred when one thread grabbed the bufio_client
> > mutex and waited for an I/O to complete but the I/O was queued
> > on another thread’s current->bio_list and it was waiting to get
> > the mutex held by the first thread.
> >
> > The fix allows only one I/O request from dm-verity to dm-bufio
> > per thread. To do this, the prefetch requests were queued on worker
> > threads.
> >
> > In addition to avoiding the deadlock, this fix made a slight
> > improvement in performance.
> >
> > seconds_kernel_to_login:
> >   with prefetch:    8.43s
> >   without prefetch: 9.2s
> >   worker prefetch:  8.28s
> >
> > Signed-off-by: Paul Taysom <taysom@chromium.org>
> > ---
> >  drivers/md/dm-verity.c | 29 +++++++++++++++++++++++++++--
> >  1 file changed, 27 insertions(+), 2 deletions(-)
>
> Acked-by: Paul Menzel <paulepanter@users.sourceforge.net>
>
>
> Thanks,
>
> Paul
>
>
> [1] https://code.google.com/p/chromium-os/issues/detail?id=39148

Yes, I should have included that this fix addresses http://crosbug.com/39148
Thanks,
Paul
