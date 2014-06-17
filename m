Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932749AbaFQN00 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 09:26:26 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:59075 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932332AbaFQN0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 09:26:24 -0400
MIME-Version: 1.0
In-Reply-To: <53A030E9.7010701@redhat.com>
References: <1402655819-14325-1-git-send-email-dh.herrmann@gmail.com>
	<CALCETrVoE+JO2rLsBUHAOJdvescEEjxikj8iQ339Nxfopfc7pw@mail.gmail.com>
	<CANq1E4SaWLD=hNEc-CDJbNnrGfXE_PkxZFBhpW4tbK7wor7xPA@mail.gmail.com>
	<CALCETrU8N9EbnJ3=oQ1WQCG9Vunn3nR9Ba=J48wJm0SuH0YB4A@mail.gmail.com>
	<CANq1E4QQUKHabheq18AzkVZk3WDtAeC-6W66tVNB+EKgYOx1Vg@mail.gmail.com>
	<53A01049.6020502@redhat.com>
	<CANq1E4T3KJZ++=KF2OZ_dd+NvPqg+=4Pw6O7Po3-ZxaaMHPukw@mail.gmail.com>
	<53A012C8.7060109@redhat.com>
	<CANq1E4QinvVA-O=dX4N819jVK3xSihJcpz9juFj+A3qv0MXODg@mail.gmail.com>
	<53A030E9.7010701@redhat.com>
Date: Tue, 17 Jun 2014 15:26:23 +0200
Message-ID: <CANq1E4SGFoq1POtrP9DD91=3nbswELK9TH49_XkjE=Wwym4f+w@mail.gmail.com>
Subject: Re: [PATCH v3 0/7] File Sealing & memfd_create()
From: David Herrmann <dh.herrmann@gmail.com>
To: Florian Weimer <fweimer@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
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

Hi

On Tue, Jun 17, 2014 at 2:13 PM, Florian Weimer <fweimer@redhat.com> wrote:
> On 06/17/2014 12:10 PM, David Herrmann wrote:
>
>>>> The file might have holes, therefore, you'd have to allocate backing
>>>> pages. This might hit a soft-limit and fail. To avoid this, use
>>>> fallocate() to allocate pages prior to mmap()
>>>
>>>
>>> This does not work because the consuming side does not know how the
>>> descriptor was set up if sealing does not imply that.
>>
>>
>> The consuming side has to very seals via F_GET_SEALS. After that, it
>> shall do a simple fallocate() on the whole file if it wants to go sure
>> that all pages are allocated. Why shouldn't that be possible? Please
>> elaborate.
>
>
> Hmm.  You permit general fallocate even for WRITE seals.  That's really
> unexpected.

SEAL_WRITE prevents modifications of file-content. fallocate() does
not modify file-contents, so I think it's not unexpected that
fallocate() is still allowed.

> The inode_newsize_ok check in shmem_fallocate can result in SIGXFSZ, which
> doesn't seem to be what's intended here.

It can only result in SIGXFSZ if you _increase_ the file-size with
fallocate(). You shouldn't do that if you only verify that holes are
allocated. Hence, a simple fallocate(st.st_size) cannot result in
SIGXFSZ. Obviously, this requires SEAL_SHRINK to prevent the remote
site to shrink the file while you call fallocate(). But SEAL_WRITE
usually goes together with SEAL_SHRINK for obvious reasons.

> Will the new pages attributed to the process calling fallocate, or to the
> process calling memfd_create?

Pages are always allocated by the caller and charged on current->mm
(current process).

Thanks
David
