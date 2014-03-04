Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940AbaCDAXq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 19:23:46 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:36947 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755844AbaCDAXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 19:23:45 -0500
Date: Tue, 4 Mar 2014 00:23:43 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: George Spelvin <linux@horizon.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Update of file offset on write() etc. is non-atomic with I/O
Message-ID: <20140304002342.GS18016@ZenIV.linux.org.uk>
References: <20140303210359.26624.qmail@science.horizon.com>
 <20140303212642.GJ18016@ZenIV.linux.org.uk>
 <CA+55aFwdEbMMTPyCEKop0Fukhxi90OCdvDieX7iB-dX9Ziovdg@mail.gmail.com>
 <20140303220106.GL18016@ZenIV.linux.org.uk>
 <CA+55aFyRJqb1HkVESdZDOcQ+20t-s-JWxZa15SHJpGU+k=6www@mail.gmail.com>
 <20140303232858.GO18016@ZenIV.linux.org.uk>
 <CA+55aFyEXgMh61P3cmjZzw3RxitiL0oymWSyUsiMp96iJ+98Og@mail.gmail.com>
 <20140303234207.GQ18016@ZenIV.linux.org.uk>
 <CA+55aFyWorcX0qYAcD2bj=bOqa-X6Gmb_Ph4g25nqwSPxo4XSg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyWorcX0qYAcD2bj=bOqa-X6Gmb_Ph4g25nqwSPxo4XSg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2014 at 03:59:36PM -0800, Linus Torvalds wrote:

> I doubt it's worth caring about. Even when passing things in memory,
> the end result isn't that much worse than the fget_light() model that
> passes just one of the two fields in memory.

I'm not sure if that's the right approach, TBH.  I wonder if something
like
static inline struct fd fdget(int fd)
{
	unsigned long v = __fdget(fd);
	return (struct fd){(struct file *)(v & ~1), v & 1};
}
would not be a better starting point, with __fdget(fd) being
{
        struct files_struct *files = current->files;
        struct file *file;
        if (atomic_read(&files->count) == 1) {
                file = __fcheck_files(files, fd);
                if (file && (file->f_mode & FMODE_PATH))
                        return 0;
		return (unsigned long)file;
        } else {
                file = __fget(fd, FMODE_PATH);
                return file ? 1 | (unsigned long)file : 0;
        }
}
