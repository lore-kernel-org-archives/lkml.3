Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965369AbaFXQrU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 12:47:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58101 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932385AbaFXQrS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 12:47:18 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAJfpegvSkr4NJJOfPH4MOhYvaLe=yWv_pR9kK4uiRpScyiapig@mail.gmail.com>
References: <CAJfpegvSkr4NJJOfPH4MOhYvaLe=yWv_pR9kK4uiRpScyiapig@mail.gmail.com> <CAJfpegtobxoMs+RRrPYLFRPOVSfr_uqZs+HJFLRif3svHGyQwA@mail.gmail.com> <1400838223-30844-1-git-send-email-miklos@szeredi.hu> <28592.1401382081@warthog.procyon.org.uk> <11446.1401420931@jrobl> <7184.1401439773@warthog.procyon.org.uk> <CA+icZUV5P=fVwe_MJJHixwBOBoj7HoKSFuySLdS6AU5L++S=4g@mail.gmail.com> <15839.1401786056@warthog.procyon.org.uk> <CA+icZUUiirxYnoL7pg5TvFEy6pQ+5Q3CuJ0jonJMXTOwhT-LDw@mail.gmail.com> <CA+icZUU8BqGUoQdtuqt403NdCBnJnH1-k64bxTM0b_GSfQr1hQ@mail.gmail.com> <10013.1401791634@warthog.procyon.org.uk> <20140603132153.GA26512@tucsk.piliscsaba.szeredi.hu> <19281.1401809418@warthog.procyon.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: dhowells@redhat.com, Sedat Dilek <sedat.dilek@gmail.com>,
        "J. R. Okajima" <hooanon05g@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Robo Bot <apw@canonical.com>, Felix Fietkau <nbd@openwrt.org>,
        Neil Brown <neilb@suse.de>, Jordi Pujol <jordipujolp@gmail.com>,
        ezk@fsl.cs.sunysb.edu, "mszeredi@suse.cz" <mszeredi@suse.cz>
Subject: Overlayfs rename bug
Date: Tue, 24 Jun 2014 17:46:14 +0100
Message-ID: <17091.1403628374@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> wrote:

> > Tentative Tested-by from me unless I can break it.
> 
> Thanks for testing.

Tested-by retracted temporarily.  There's a bug in rename handling.  If you
clone:

	http://git.infradead.org/users/dhowells/unionmount-testsuite.git

and check out the switch-to-python branch and do:

	./run --no rename-mass

then this works with no unioning used, but if you do:

	./run --ov rename-mass

to run it on overlayfs, then the following occurs:

	[root@andromeda union-testsuite]# ./run --ov rename-mass
	***
	*** ./run --ov --ts=0 rename-mass
	***
	TEST rename-mass.py:15: Mass rename sequential files into each other's vacated name slots
	 ./run --rename /mnt/a/foo103 /mnt/a/foo104
	 ./run --rename /mnt/a/foo102 /mnt/a/foo103
	 ./run --rename /mnt/a/foo101 /mnt/a/foo102
	 ./run --rename /mnt/a/foo100 /mnt/a/foo101
	 ./run --rename /mnt/a/foo104 /mnt/a/foo105
	/mnt/a/foo104: File unexpectedly found

strace shows:

	rename("/mnt/a/foo104", "/mnt/a/foo105") = 0
	lstat("/mnt/a/foo104", {st_mode=S_IFREG|0644, st_size=12, ...}) = 0

which shouldn't happen.

The kernel is 17eb601eb5dbc8a2e200872380c03400813d4f1a from overlayfs.v22.

David
