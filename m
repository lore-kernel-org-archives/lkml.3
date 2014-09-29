Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179AbaI2PPy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 11:15:54 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:44694 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbaI2PPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 11:15:52 -0400
MIME-Version: 1.0
In-Reply-To: <20140928180556.GA7996@ZenIV.linux.org.uk>
References: <20140924185521.GC7996@ZenIV.linux.org.uk>
	<CA+55aFzTs5R_TzwdsBRAkw+mGLWF0XT9_sGeb_+ETUy-gJsY_w@mail.gmail.com>
	<20140924201813.GI7996@ZenIV.linux.org.uk>
	<20140925044601.GL7996@ZenIV.linux.org.uk>
	<20140926164442.GA26897@ZenIV.linux.org.uk>
	<20140927044555.GS7996@ZenIV.linux.org.uk>
	<CA+55aFyw8U94tYVB9Xbo7gh1SC_f9ecKSoFL509bXM122dC46Q@mail.gmail.com>
	<20140927183139.GT7996@ZenIV.linux.org.uk>
	<20140927191657.GU7996@ZenIV.linux.org.uk>
	<20140928074747.GZ7996@ZenIV.linux.org.uk>
	<20140928180556.GA7996@ZenIV.linux.org.uk>
Date: Mon, 29 Sep 2014 08:15:51 -0700
X-Google-Sender-Auth: jogAQUBL6mK3IaF-BlrvUrhRDs4
Message-ID: <CA+55aFxZDsD94CSDYfyw9g3WWNkVApZDKxHVhK2zy0ycRsjcmA@mail.gmail.com>
Subject: Re: [PATCH v2] vfs: Don't exchange "short" filenames unconditionally.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mikhail Efremov <sem@altlinux.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 28, 2014 at 11:05 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Folks, care to review and test the following?

No testing, but having thought about this some more, I'm personally
getting quite convinced that doing the RCU delaying of the external
name freeing in the __d_free() path is entirely pointless.

So I think the *only* rcu_free() you need is for just the "free old
name" case in copy_name().

In __d_free(), the name pointer has gone through the same grace period
that the dentry pointer itself went through. If it's not safe to free
the external name, then it damn well wouldn't be safe to free the
dentry itself either.

IOW, I think your games in __d_free() are totally unnecessary.

Now you can tell me why I'm wrong.

              Linus
