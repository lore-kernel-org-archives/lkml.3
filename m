Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825AbaAVSUF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 13:20:05 -0500
Received: from mail-ve0-f180.google.com ([209.85.128.180]:61426 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbaAVSUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 13:20:02 -0500
MIME-Version: 1.0
In-Reply-To: <20140122062730.GA25601@redhat.com>
References: <20140122062730.GA25601@redhat.com>
Date: Wed, 22 Jan 2014 10:20:01 -0800
X-Google-Sender-Auth: iXnxuqZbw36Hlo81oIqCw24ZR6c
Message-ID: <CA+55aFxnv050RqhhLBbsvV4=dcu-_ZXokbhmuO8Y4zVcvVJ6OQ@mail.gmail.com>
Subject: Re: fanotify use after free.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>, Jan Kara <jack@suse.cz>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 10:27 PM, Dave Jones <davej@redhat.com> wrote:
>
> BUG fanotify_event_info (Not tainted): Poison overwritten

Looking at the poison data, it seems that is is the

        u32 response;

field that has been overwritten (with all zero).

That doesn't really help me guess where the bug is, though. That code
is crazy. For example, looking at one place where it is set, we have:

 - process_access_response():

        re->event->response = response;

        wake_up(&group->fanotify_data.access_waitq);

        kmem_cache_free(fanotify_response_event_cache, re);

which looks buggy in *so* many ways. In particular, we're doing a
kmem_cache_free() on "re", but what happened to "re->event" that we
just used? There was no release of that anywhere. Wut?

So it seems that the lifetime of these "fanotify_event_info"
structures is completely buggered. I don't even see any *attempt* to
maintain reference counts or other lifetime info. People free the
containers that point to them without doing anything at all about the
fsnotify_event that contains the fanotify_event_info that they point
to.

Jan - how is the lifetime of the fanotify_event_info tied to the
lifetime of the fanotify_response_event structure that contains
pointers into it? Because I don't see it.

And considering that it's the response field that gets overwritten, it
really sounds like *that* is the exact issue at play here - there is
some fanotify_response_event structure holding a pointer to the
fanotify_event that is embedded into a fanotify_event_info that has
been freed.

Jan?

                 Linus
