Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759287Ab3DARAj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 13:00:39 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:62242 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759208Ab3DARAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 13:00:37 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzqYkX27E8R7Bu8pvn3xO+hKrgMEC7ec5gDz4kr1JbVtQ@mail.gmail.com>
References: <1364817485-19676-1-git-send-email-anatol.pomozov@gmail.com>
	<CA+55aFzqYkX27E8R7Bu8pvn3xO+hKrgMEC7ec5gDz4kr1JbVtQ@mail.gmail.com>
Date: Mon, 1 Apr 2013 10:00:35 -0700
Message-ID: <CAOMFOmWuo5W53G1-eAONgMqPRrt7HUorVk-HfpBzuddOJD=fjQ@mail.gmail.com>
Subject: Re: [PATCH] loop: prevent bdev freeing while device in use
From: Anatol Pomozov <anatol.pomozov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Salman Qazi <sqazi@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Guo Chao <yan@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Mon, Apr 1, 2013 at 8:16 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Mon, Apr 1, 2013 at 4:58 AM, Anatol Pomozov <anatol.pomozov@gmail.com> wrote:
>>
>> To prevent use-after-free we need to hold device inode in loop_set_fd()
>> and put it later in loop_clr_fd().
>
> Is there something that guarantees that there's only one loop_set_fd()
> and one paired loop_clr_fd()?

Yes there is such guarantee.

Every time we call loop_set_fd() we check that loop_device->lo_state
is Lo_unbound and set it to Lo_bound  If somebody will try to set_fd
again it will get EBUSY. And if we try to loop_clr_fd() on unbound
loop device we'll get ENXIO.

loop_set_fd/loop_clr_fd (and any other loop ioctl) is called under
loop_device->lo_ctl_mutex.

>
> IOW, what protects us from somebody doing loop_clr_fd() on a device
> that hasn't been set up yet, or doing multiple loop_set_fd calls?

> I suspect the "lo->lo_state" is part of the answer, but it's very much
> not obvious, and I'd want this to be explicitly explained.
>
>               Linus
