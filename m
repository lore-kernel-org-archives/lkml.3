Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443AbaJ0IG6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 04:06:58 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:46275 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377AbaJ0IGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 04:06:55 -0400
MIME-Version: 1.0
X-Originating-IP: [46.139.80.5]
In-Reply-To: <20141025170609.GK7996@ZenIV.linux.org.uk>
References: <20141023232539.GA4662@tucsk.piliscsaba.szeredi.hu>
	<20141024022055.GH7996@ZenIV.linux.org.uk>
	<20141024032422.GI7996@ZenIV.linux.org.uk>
	<CAJfpegt-X_Cd8B5H65keshhhuwH2-HPpaBC30atKeS3QjaariA@mail.gmail.com>
	<20141025081845.GJ7996@ZenIV.linux.org.uk>
	<CAJfpegvM8d-cizf=3KmTSFVgAYPBDp_0fQAh+G2Q87u=taXm3A@mail.gmail.com>
	<20141025170609.GK7996@ZenIV.linux.org.uk>
Date: Mon, 27 Oct 2014 09:06:54 +0100
Message-ID: <CAJfpegucroRzo0NHTz=4N0WcrB2oDC0eDiZXk=aKSjc8vdYDjw@mail.gmail.com>
Subject: Re: [GIT PULL] overlay filesystem v25
From: Miklos Szeredi <miklos@szeredi.hu>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-unionfs@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Paul McKenney added to CC]

On Sat, Oct 25, 2014 at 7:06 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Sat, Oct 25, 2014 at 11:53:52AM +0200, Miklos Szeredi wrote:
>
>> Yes, but it's not about race with copy-up (which the ovl_path_upper()
>> protects against), but race of two fsync calls with each other.  If
>> there's no synchronization between them, then that od->upperfile does
>> indeed count as lockless access, no matter that the assignment was
>> done under lock.
>
>         p = global;
>         if (!p) {       // outside of lock
>                 p = alloc();
>                 grab lock
>                 if (!global) {
>                         global = p;
>                 } else {
>                         destroy(p);
>                         p = global;
>                 }
>                 drop lock
>         }
> is a very common pattern, especially if you look for cases when lock is
> a spinlock and allocation is blocking (in those cases you'll often see
> destroy() part done after dropping the lock; that's where what I fucked up in
> what I'd originally pushed.  And it wasn't even needed - fput() under
> ->i_mutex is OK...)

Being a very common pattern does not automatically make it correct...

My understanding of these issues is very limited, but it's not clear
to me what will order initialization of members of p with the storing
of p into global.  E.g. we start out with global == NULL and p->foo ==
0.

CPU1:
  p->foo = 1
  grab lock
  if (!global)
      global = p

CPU1:
  p = global
  if (p)
     q = p->foo

Is it guaranteed that the above sequence (as is, without any barriers
or ACCESS_ONCE() other than the lock acquisition) will result in q ==
1 if p != NULL?

Thanks,
Miklos
