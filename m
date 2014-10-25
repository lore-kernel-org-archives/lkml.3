Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540AbaJYTRb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 15:17:31 -0400
Received: from mail-qg0-f47.google.com ([209.85.192.47]:62674 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbaJYTR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 15:17:28 -0400
MIME-Version: 1.0
X-Originating-IP: [46.139.80.5]
In-Reply-To: <20141025081845.GJ7996@ZenIV.linux.org.uk>
References: <20141023232539.GA4662@tucsk.piliscsaba.szeredi.hu>
	<20141024022055.GH7996@ZenIV.linux.org.uk>
	<20141024032422.GI7996@ZenIV.linux.org.uk>
	<CAJfpegt-X_Cd8B5H65keshhhuwH2-HPpaBC30atKeS3QjaariA@mail.gmail.com>
	<20141025081845.GJ7996@ZenIV.linux.org.uk>
Date: Sat, 25 Oct 2014 11:53:52 +0200
Message-ID: <CAJfpegvM8d-cizf=3KmTSFVgAYPBDp_0fQAh+G2Q87u=taXm3A@mail.gmail.com>
Subject: Re: [GIT PULL] overlay filesystem v25
From: Miklos Szeredi <miklos@szeredi.hu>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 25, 2014 at 10:18 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Fri, Oct 24, 2014 at 09:24:45AM +0200, Miklos Szeredi wrote:
>
>> The reason I didn't do your "fix" is that it
>>
>>  - adds more lines than it takes,
>>
>>  - I wasn't sure at all if the lockless access is actually correct
>> without the ACCESS_ONCE and all the memory barrier magic that might be
>>  necessary on weird architectures.
>
> _What_ lockless accesses?  There is an extremely embarrassing bug in that
> commit, all right, but it has nothing to do with barriers...  All
> barrier-related issues are taken care of by ovl_path_upper() (and without
> that you'd have tons of worse problems).  Fetching ->upperfile outside of
> ->i_mutex is fine - in the worst case we'll fetch NULL, open the sucker
> grab ->i_mutex and find out that it has already been taken care of.
> In which case we fput() what we'd opened and move on (fput() under
> ->i_mutex is fine - it's going to be delayed until return from syscall
> anyway).

Yes, but it's not about race with copy-up (which the ovl_path_upper()
protects against), but race of two fsync calls with each other.  If
there's no synchronization between them, then that od->upperfile does
indeed count as lockless access, no matter that the assignment was
done under lock.

Thanks,
Miklos
