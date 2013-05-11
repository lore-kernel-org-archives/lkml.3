Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943Ab3EKRFJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 13:05:09 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:63938 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620Ab3EKRFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 13:05:07 -0400
MIME-Version: 1.0
In-Reply-To: <20130509050343.GD25399@ZenIV.linux.org.uk>
References: <20130509050343.GD25399@ZenIV.linux.org.uk>
Date: Sat, 11 May 2013 10:05:05 -0700
X-Google-Sender-Auth: _Xn---Rk8Kx3CcfyAPh90VazMIs
Message-ID: <CA+55aFzNuEx8705x3NckigLdRMrEWehyEmgLcJ3kF=BPDZo+Bg@mail.gmail.com>
Subject: Re: [RFC] next cycle fun: ->release() API change
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 8, 2013 at 10:03 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
>         OK, so I decided to check just how painful would it be to fix that.
> Diff had grown well past anything even remotely reasonable for a single
> commit (443 files changed, 814 insertions(+), 1843 deletions(-) for the
> last snapshot I've taken, just before going to LSFS; about one third of
> megabyte worth of diff, roughly a quarter of drivers/* remaining to be
> converted).  And, naturally enough, a bunch of bugfixes kept calving off
> from it.  That was a flagday approach - ->release() switched to
> void (*release)(struct file *) (struct inode * is both redundant and
> unused by the majority of instances; ones that do use it can simply use
> file_inode(file)).  Originally I planned to ask Linus to merge that monster
> as an after-rc1 special, but it was obviously far too large for that.
>
>         The next plan was to make the thing splittable.  I.e. start with
> adding replacement method (I ended up calling it ->close(), suggestions for
> better names are welcome), teach the (very few) call sites of ->release()
> to try that if available, then convert the users of widely used instances
> to new method (seq_release and friends, mostly), then go driver by driver
> converting them.

Ugh. You know what? I'd almost prefer to just do it as a single big
commit, *without* the extra churn of then also renaming things.
Because the renaming will just be painful and result in *more*
problems, and quite frankly, this particular ABI change is "benign" in
the sense that unconverted drivers will just cause warnings - the code
will still compile (module -Werror, of course, which some
architectures use) and still work perfectly fine (modulo crazy C paper
standard issues that have nothing to do with actual reality).

In fact, the "it still works fine, just complains" makes it perfecly
reasonable to even split it up into multiple independent commits. So
rather than do the stupid renaming, I'd be perfectly happy with one
commit that just changes "int ("release)(..)" to "void (*release)(..)"
and then a boatload of "remove return value from release in
drivers/block/*" kind of commits that do the conversion.

Because renaming really doesn't buy us anything but pain.

                Linus
