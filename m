Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258AbaBZQsn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 11:48:43 -0500
Received: from imap.thunk.org ([74.207.234.97]:34389 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753053AbaBZQsl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 11:48:41 -0500
Date: Wed, 26 Feb 2014 11:48:28 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: viro@zeniv.linux.org.uk, david@fromorbit.com, bpm@sgi.com,
        adilger.kernel@dilger.ca, jack@suse.cz, mtk.manpages@gmail.com,
        lczerner@redhat.com, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ashish Sangwan <a.sangwan@samsung.com>
Subject: Re: [PATCH v6] ext4: Add support FALLOC_FL_COLLAPSE_RANGE for
 fallocate
Message-ID: <20140226164827.GB11452@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Namjae Jeon <linkinjeon@gmail.com>, viro@zeniv.linux.org.uk,
	david@fromorbit.com, bpm@sgi.com, adilger.kernel@dilger.ca,
	jack@suse.cz, mtk.manpages@gmail.com, lczerner@redhat.com,
	linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Namjae Jeon <namjae.jeon@samsung.com>,
	Ashish Sangwan <a.sangwan@samsung.com>
References: <1392908861-3563-1-git-send-email-linkinjeon@gmail.com>
 <20140222170930.GE26637@thunk.org>
 <CAKYAXd9vTbjTnJOQ1Y=pi4QJSYj41fWsQgRD3Fkufskez2W-YA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKYAXd9vTbjTnJOQ1Y=pi4QJSYj41fWsQgRD3Fkufskez2W-YA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 10:22:10AM +0900, Namjae Jeon wrote:
> >> +	ret = ext4_es_remove_extent(inode, punch_start,
> >> +				    EXT_MAX_BLOCKS - punch_start - 1);
> >> +	if (ret) {
> >> +		up_write(&EXT4_I(inode)->i_data_sem);
> >> +		goto out_stop;
> >> +	}
> >
> > Doing this at first is probably a bad idea; you should do this at the
> > end, and then completely invalidate the es cache for that inode.  That
> > way, the right thing happens if you get an error in the middle
> > releasing the boxes and shifting the extents:
> Okay, I see.

Actually, thinking about this some more, we do want to do this first,
since if we error out, we do need to make sure the extent cache is
flushed.

> If there is error in the middle of extent shifting, the hole will
> present between the last shifted extent and the extent at which error
> happen so this will be consistent state.
> IMHO even if there is error in between the shift, filesystem will be
> in consistent state.
> Am I missing something?

No, I was wrong about that; you're right.  The file will be in an
inconsistent statement, which will probably be highly confusing for
the application, but the file system will be fine.

So I withdraw my complaints.  I'll do a bit more testing, but so far
the patch looks fine to me.  Thanks for your reply and your work!

					- Ted
