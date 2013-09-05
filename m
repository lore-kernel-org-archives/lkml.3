Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758198Ab3IEUqP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 16:46:15 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60869 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757673Ab3IEUqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 16:46:12 -0400
Date: Thu, 5 Sep 2013 21:46:09 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Waiman Long <waiman.long@hp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        George Spelvin <linux@horizon.com>, John Stoffel <john@stoffel.org>
Subject: Re: [PATCH v2 1/1] dcache: Translating dentry into pathname without
 taking rename_lock
Message-ID: <20130905204609.GV13318@ZenIV.linux.org.uk>
References: <1378407316-59852-1-git-send-email-Waiman.Long@hp.com>
 <1378407316-59852-2-git-send-email-Waiman.Long@hp.com>
 <CA+55aFwShEG-bm2JuQJPF3DTq-O5CVdYXzwN5UpSckka0Wgm-A@mail.gmail.com>
 <5228E992.5050901@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5228E992.5050901@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 05, 2013 at 04:29:06PM -0400, Waiman Long wrote:

> It is not as simple as doing a strncpy(). The pathname was built
> from the leaf up to the root, and from the end of buffer toward the
> beginning. As it goes through the while loop, the buffer will look
> like:
> 
> "    /c"
> "  /b/c"
> "/a/b/c"
> 
> If the content of the string is unreliable, I have to do at least 2 passes:
> 1) Locate the end of the string and determine the actual length
> 2) Copy the whole string or byte-by-byte backward

No, you do not need anything of that kind.  All you need is
	a) don't step out of the array (which will contain NUL at the end
at all times, no matter what) and
	b) generate correct output *IF* no d_move() happens while you
do that.

Nothing else matters at all.  You trust the length to be correct in absense
of d_move().  You can not trust it to match the size of ->d_name.name when
d_move() is happening, but you can trust everything up to ->d_name.len *or*
the first NUL, whichever happens first, to be safe to access.

Again, the contents copied into the buffer needs to be valid only if d_move()
hasn't happened; if it has, we don't give a fuck - read_seqretry() will take
care of that.  All you need to care about in that case is not oopsing the
damn thing.

static int prepend_name(char **buffer, int *buflen, struct qstr *name)
{
	const char *s = ACCESS_ONCE(name->name);
	unsigned len = ACCESS_ONCE(name->len);
	char *p;

	*buflen -= len;
	if (*buflen < 0)
		return -ENAMETOOLONG;
	p = *buffer -= len;
	while (len--) {
		c = *s++;
		if (!c)
			break;
		*p++ = c;
	}
        return 0;
}

And that's *all* - just call that under rcu_read_lock() and within
seq = read_seqbegin(&rename_lock)/read_seqretry(&rename_lock, seq)
loop over the whole prepend_path/path_with_deleted/__dentry_path
thing.
