Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407Ab3FZPYx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 11:24:53 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:49144 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab3FZPYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 11:24:50 -0400
Date: Wed, 26 Jun 2013 17:24:46 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: sedat.dilek@gmail.com
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>, fuse-devel@lists.sourceforge.net,
        Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: linux-next: Tree for Jun 26 [ vfs | block | fuse (cpuidle)
 releated? ]
Message-ID: <20130626172446.51f0bd5f@skate>
In-Reply-To: <CA+icZUXtTxVUfOmFak9GzyUdGa7bBuxTr2CJEY0vNn0bH2-4Vw@mail.gmail.com>
References: <CA+icZUWDDCsXBK4+s4fEbM_AGj3EnfCRAe2=yE+8_MT4mauPXg@mail.gmail.com>
	<CA+icZUXtTxVUfOmFak9GzyUdGa7bBuxTr2CJEY0vNn0bH2-4Vw@mail.gmail.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Sedat Dilek,

On Wed, 26 Jun 2013 16:50:55 +0200, Sedat Dilek wrote:

> [ TO/CC char-misc folks ]
> 
> The CULPRIT commit [1] due to my git-bisecting is:
> 
> commit 585d98e00ba7a5e2abe65f7a1eff631cb612289b
> "char: misc: assign file->private_data in all cases"
> 
> After reverting it, my system boots up fine again.
> 
> Can someone from the char-misc folks look at that?

Ok. My understanding is that the misc device registered by
fs/fuse/dev.c:fuse_dev_init() makes the assumption that
file->private_data == NULL when a misc device is opened. But I'm not
sure to fully understand the code flow of the FUSE filesystem.

And since it doesn't provide its own implementation of the ->open()
operation, the misc infrastructure was leaving the file->private_data
defined to NULL before my patch.

With my patch, the file->private_data gets assigned unconditionally
(regardless of whether the misc driver provides or does not provide a
->open() operation) which modifies the unwritten assumption that fuse
was making about the initial value of file->private_data. I believe the
assumption made by fuse over the initial value of this variable is a
bit fragile.

Maybe the FUSE code needs to be slightly adjusted to not make this
assumption?

Best regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
