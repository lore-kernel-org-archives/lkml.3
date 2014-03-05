Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070AbaCEQYa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 11:24:30 -0500
Received: from mailscanner02.zoner.fi ([84.34.166.11]:23479 "EHLO
	mailscanner02.zoner.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbaCEQY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 11:24:28 -0500
Date: Wed, 5 Mar 2014 18:24:22 +0200
From: Lasse Collin <lasse.collin@tukaani.org>
To: Phillip Lougher <phillip@lougher.demon.co.uk>,
        Kyle McMartin <kyle@infradead.org>
Cc: Florian Fainelli <f.fainelli@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] xz: make XZ_DEC_BCJ filters non-optional
Message-ID: <20140305182422.767a6cbe@tukaani.org>
In-Reply-To: <53169123.4020909@lougher.demon.co.uk>
References: <20140228230017.GE14970@merlin.infradead.org>
	<20140303145137.70819698@tukaani.org>
	<CAGVrzcZ7KU-m9s9KgoigK+WdSqeqwEmm=_pY6qF=ep2vFp6WUg@mail.gmail.com>
	<20140304202038.03b36109@tukaani.org>
	<53169123.4020909@lougher.demon.co.uk>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Antivirus-Scanner: Clean mail though you should still use an Antivirus
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-03-05 Phillip Lougher wrote:
> (BTW Kyle you should have CC'd me on the patch as a courtesy).

I could have done that too but somehow I didn't, sorry.

> But speaking as the Squashfs author, the lack of BCJ support for
> an architecture creates a subtle failure mode in Squashfs, this is
> because not all blocks in a Squashfs filesystem get compressed
> with a BCJ filter.  At compression time each block is compressed
> without any BCJ filter, and then with the BCJ filter(s) selected on
> the command line, and the best compression for *that* block is
> chosen.  What this means is kernels without a particular
> BCJ filter can still read the Squashfs metadata (mount, ls etc.) and
> read many of the files, it is only some files that mysteriously
> fail with decompression error.  As such this will be (and has been)
> invariably treated as a bug in Squashfs.

There is an easy way to make Squashfs give an error message in the
kernel log. xz_dec_run() gives XZ_OPTIONS_ERROR when valid-looking but
unsupported input is detected. Currently Squashfs treats all error
codes from xz_dec_run() the same way so the reason for the
decompression error is silently lost.

Below is an *untested* fix. I'm not sure about the exact wording of the
error message, so feel free to improve it.

diff -Narup linux-3.14-rc5.orig/fs/squashfs/xz_wrapper.c linux-3.14-rc5/fs/squashfs/xz_wrapper.c
--- linux-3.14-rc5.orig/fs/squashfs/xz_wrapper.c	2014-03-03 04:56:16.000000000 +0200
+++ linux-3.14-rc5/fs/squashfs/xz_wrapper.c	2014-03-05 18:08:58.729643127 +0200
@@ -170,8 +170,13 @@ static int squashfs_xz_uncompress(struct
 
 	squashfs_finish_page(output);
 
-	if (xz_err != XZ_STREAM_END || k < b)
+	if (xz_err != XZ_STREAM_END || k < b) {
+		if (xz_err == XZ_OPTIONS_ERROR)
+			ERROR("Unsupported XZ-compressed data; check the XZ "
+					"options in the kernel config\n");
+
 		goto out;
+	}
 
 	return total + stream->buf.out_pos;
 

> Moreover, without expert knowledge of Squashfs, and the config
> options, most people will not have a clue how to fix the issue.
> 
> This is why I prefer the first option, which is to reinstate
> the enabling of all filters by default, and then to allow people
> to remove the filters they don't want.

I will submit the first option. In the other email Florian Fainelli
seemed to be OK with that too.

> BTW there is a potential additional fix for Squashfs that will
> make its handling of (lack of) BCJ filters more intelligent
> at mount time, but this of course only addresses Squashfs,
> and it relies on an additional call into XZ being added.  The
> BCJ filters specified at filesystem creation are stored in the
> compression options part of the superblock, and are known at
> mount time.  Squashfs should check that these filters are
> supported by the kernel and refuse to mount it otherwise.  This
> has not been done because AFAIK there is no way to query XZ to
> determine which BCJ filters are supported (beyond passing it a
> test stream which is too messy).

You can use #ifdef CONFIG_XZ_DEC_X86 and such, although maybe that's
not convenient enough.

Adding a function to xz_dec module could be sort of OK. It's important
to keep in mind that the ability to disable filters is there to reduce
code size *slightly*. If you or we add something extra to figure out
what is supported at runtime, the size benefit may get lost.

If all filters are enabled by default, a clear error message on
XZ_OPTIONS_ERROR should be enough, I think.

-- 
Lasse Collin  |  IRC: Larhzu @ IRCnet & Freenode
