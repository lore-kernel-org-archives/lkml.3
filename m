Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119AbaE2EVD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 00:21:03 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:47751 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbaE2EVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:21:01 -0400
MIME-Version: 1.0
In-Reply-To: <20140529031149.GE18016@ZenIV.linux.org.uk>
References: <20140527014054.GR18016@ZenIV.linux.org.uk>
	<20140527031415.GS18016@ZenIV.linux.org.uk>
	<20140527040026.GT18016@ZenIV.linux.org.uk>
	<20140527070409.GA1801@lahna.fi.intel.com>
	<20140528031955.GW18016@ZenIV.linux.org.uk>
	<20140528073751.GB1757@lahna.fi.intel.com>
	<20140528115701.GY18016@ZenIV.linux.org.uk>
	<20140528131136.GA1643@lahna.fi.intel.com>
	<20140528141937.GZ18016@ZenIV.linux.org.uk>
	<20140528183954.GA18016@ZenIV.linux.org.uk>
	<20140529031149.GE18016@ZenIV.linux.org.uk>
Date: Wed, 28 May 2014 21:21:00 -0700
X-Google-Sender-Auth: wROt2y5umnZAg49J4GamhNGzB0U
Message-ID: <CA+55aFyHCF1+DfxndzxkGLLoNErRF2MA0YWtdx7UOTJ=gQWhEw@mail.gmail.com>
Subject: Re: fs/dcache.c - BUG: soft lockup - CPU#5 stuck for 22s! [systemd-udevd:1667]
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 8:11 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Here's an updated patch, hopefully slightly less vomit-inducing.

Hmm. Less vomit-inducing, except for this part:

>                 dentry = list_entry(list->prev, struct dentry, d_lru);
> +
> +               parent = NULL;
>                 spin_lock(&dentry->d_lock);
> +               if (!IS_ROOT(dentry)) {
> +                       parent = dentry->d_parent;
> +                       if (unlikely(!spin_trylock(&parent->d_lock))) {
> +                               spin_unlock(&dentry->d_lock);
> +                               parent = NULL;
> +                               read_seqlock_excl(&rename_lock);
> +                               if (!IS_ROOT(dentry)) {
> +                                       parent = dentry->d_parent;
> +                                       spin_lock(&parent->d_lock);
> +                               }
> +                               read_sequnlock_excl(&rename_lock);
> +                               spin_lock(&dentry->d_lock);
> +                       }
> +               }

Ugh, that just *screams* for a helper function. Something like

        parent = get_parent_and_lock(dentry);

or whatever, with that trylock/renamelock dance separated out. The
rule would be that it would lock the "dentry", and return the
(similarly locked) parent. Or NULL for a root dentry, of course.

Please?

             Linus
