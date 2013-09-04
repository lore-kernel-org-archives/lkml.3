Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760780Ab3IDVbx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 17:31:53 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:61225 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756214Ab3IDVbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 17:31:51 -0400
MIME-Version: 1.0
In-Reply-To: <1378321523-40893-1-git-send-email-Waiman.Long@hp.com>
References: <1378321523-40893-1-git-send-email-Waiman.Long@hp.com>
Date: Wed, 4 Sep 2013 14:31:49 -0700
X-Google-Sender-Auth: 52ZhmyYVu1R31xsoEDkmfUYsjLQ
Message-ID: <CA+55aFzbzz4_YNaM+9jAP2Znkjzar42iTM2wFfRX6ySDwBAUeQ@mail.gmail.com>
Subject: Re: [PATCH] dcache: Translating dentry into pathname without taking rename_lock
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 4, 2013 at 12:05 PM, Waiman Long <Waiman.Long@hp.com> wrote:
> +       rcu_read_unlock();
> +       if (read_seqretry(&rename_lock, seq))
> +               goto restart;

Btw, you have this pattern twice, and while it's not necessarily
incorrect, it's a bit worrisome for performance.

The rcu_read_unlock() is very possibly going to trigger an immediate
scheduling event, so checking the sequence lock after dropping the
read-lock sounds like it would make it much easier to hit the race
with some rename.

I'm also a tiny bit worried about livelocking on the sequence lock in
the presence of lots of renames, so I'm wondering if the locking
should try to approximate what we do for the RCU lookup path: start
off optimistically using just the RCU lock and a sequence point, but
if that fails, fall back to taking the real lock. Maybe using a
counter ("try twice, then get the rename lock for writing")

Hmm?

             Linus
