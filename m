Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132AbaGBP4P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 11:56:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31718 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752148AbaGBP4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 11:56:14 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        akpm@linux-foundation.org, viro@ZenIV.linux.org.uk,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Subject: Re: IMA: kernel reading files opened with O_DIRECT
References: <53B3D3AA.3000408@samsung.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 02 Jul 2014 11:55:41 -0400
In-Reply-To: <53B3D3AA.3000408@samsung.com> (Dmitry Kasatkin's message of
	"Wed, 02 Jul 2014 12:40:58 +0300")
Message-ID: <x49y4wbu54y.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Dmitry,

Dmitry Kasatkin <d.kasatkin@samsung.com> writes:

> Hi,
>
> We are looking for advice on reading files opened for direct_io.

[snip]

> 2. Temporarily clear O_DIRECT in file->f_flags.

[snip]

> 3. Open another instance of the file with 'dentry_open'

[snip]

> Is temporarily clearing O_DIRECT flag really unacceptable or not?

It's acceptable.  However, what you're proposing to do is read the
entire file into the page cache to calculate your checksum.  Then, when
the application goes to read the file using O_DIRECT, it will ignore the
cached copy and re-read the portions of the file it wants from disk.  So
yes, you can do that, but it's not going to be fast.  If you want to
avoid polluting the cache, you can call invalidate_inode_pages2_range
after you're done calculating your checksum.

> Or may be there is a way to allocate "special" user-space like buffer
> for kernel and use it with O_DIRECT?

In-kernel O_DIRECT support has been proposed in the past, but there is
no solution for that yet.

Cheers,
Jeff
