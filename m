Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062AbaC2RRi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 13:17:38 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:40655 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbaC2RRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 13:17:36 -0400
MIME-Version: 1.0
In-Reply-To: <20140325150017.GA2336@tucsk.piliscsaba.szeredi.hu>
References: <20140325150017.GA2336@tucsk.piliscsaba.szeredi.hu>
Date: Sat, 29 Mar 2014 10:17:35 -0700
X-Google-Sender-Auth: qPBHrlFxjJlPnh6HeLzv4BBrsiM
Message-ID: <CA+55aFw+xsZYME=L6pwfTQGX20ZNmMiqn5P-W90Y62quqa_qpA@mail.gmail.com>
Subject: Re: splicing pages to the same file
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Michael Kerrisk-manpages <mtk.manpages@gmail.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "zab@redhat.com" <zab@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2014 at 8:00 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> In pipe_to_file() I noticed the "if (buf->page != page)" and started thinking
> about this.  What should be the correct behavior?

I don't think we can have "correct" behavior, because no such behavior exists.

It's very much like memcpy() with the destination and source
overlapping. And as you noticed, doing it as a "memmove()" in
pipe_to_file() wouldn't help, because since we block this up by pages,
there will still be a potential overlap across subsequent page
fragments.

So I think the only reasonable option is to document the fact that
splicing from a file to itself falls under the "you're insane, it may
or may not do what you want". And since it depends on page size and on
which order we move pages around in etc, the rule should simply be
that you cannot sanely expect a splice from a file to itself to work.
Regardless of any actual byte range overlap details. "Don't do it".

Now, we *could* make it work when there isn't any overlap. Right now,
if you splice from a file to itself within the same page, we'll always
just say "screw you", but we could look at the offset too. That
wouldn't make a true overlap work (you could still have overlap that
we'd miss because within one part of a page it wouldn't look like
overlap to us since we only see this one page fragment at a time), but
we could try to make the case where there is no true overlap always
work reliably.

But would that be it worth it, since older kernels would still not
give those guarantees? Why did you even notice?

                   Linus
