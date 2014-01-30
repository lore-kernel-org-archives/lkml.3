Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918AbaA3Wlt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 17:41:49 -0500
Received: from smtp1.Stanford.EDU ([171.67.219.81]:52595 "EHLO
	smtp.stanford.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753109AbaA3Wlr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 17:41:47 -0500
X-Greylist: delayed 515 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Jan 2014 17:41:47 EST
From: Russ Allbery <eagle@eyrie.org>
To: Pali =?utf-8?Q?Roh=C3=A1r?= <pali.rohar@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, linux-afs@lists.infradead.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] afs: proc cells and rootcell are writeable
In-Reply-To: <CAHYPw2GborA=wnnVyifmK-Mew0yvdhrk0W69DcWK65XE4jfF8Q@mail.gmail.com>
	("Pali =?utf-8?Q?Roh=C3=A1r=22's?= message of "Thu, 30 Jan 2014 23:15:31
 +0100")
Organization: The Eyrie
References: <20140126122729.32113.19659.stgit@warthog.procyon.org.uk>
	<8761p1m98f.fsf@xmission.com>
	<CA+55aFwrBQJ=kVBXoo2GnBP4xoa3==6WDZfbt-u4OSxz8iQUoA@mail.gmail.com>
	<CAHYPw2GborA=wnnVyifmK-Mew0yvdhrk0W69DcWK65XE4jfF8Q@mail.gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
Date: Thu, 30 Jan 2014 14:33:09 -0800
Message-ID: <871tzpf6ca.fsf@windlord.stanford.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pali Rohár <pali.rohar@gmail.com> writes:
> 2014-01-30 Linus Torvalds <torvalds@linux-foundation.org>:
>> Eric W. Biederman <ebiederm@xmission.com> wrote:

>>> These files have been read-only since this code was merged in 2002.
>>> Over a decade of not being used seems like a strong indication that no
>>> one cares about the write path.

>> I think this is a pretty strong argument. Counter-arguments, anybody?

The current in-tree AFS module is still something of an experiment and is
not widely used by actual clients, essentially all of which are still
using the (old, ugly, frustratingly-difficult-to-maintain) out-of-tree
module.  This is mostly because the in-kernel module is not yet
sufficiently mature to support a variety of use cases.  I think this is a
(minor) step towards making it more mature.

> In afs documentation is written that you need to write to these files. See:

> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/filesystems/afs.txt#n82
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/filesystems/afs.txt#n159

> Without cells file, you cannot specify other cell servers and you can
> use only one rootcell which was specified in kernel cmdline. So for
> mounting other server, you need to reboot kernel (if you compiled afs
> driver statically) and without cells file there is no other option to
> mount more afs servers... (or at least it is not written in that
> documentation). So I think without write access it is hard or maybe
> impossible to use afs driver.

In the AFS world more generally, it is not common to change the root cell
without restarting the client.  It *is*, however, very common to add
configuration for new cells on the fly.  The most common implementation,
OpenAFS, has a command-line tool for root to do that (fs newcell).  The
equivalent for the in-tree AFS module would be writing to this file, so to
support the fs newcell command with the in-tree module, this file would
need to be writable.  This is a common action in some use cases.

By comparison, there is not a standard fs command to set the current local
cell, only to retrieve it.  However, I suspect that's primarily due to
design limitations in the OpenAFS client.  If it's not difficult to
support this operation in the in-tree kernel module, I think it would be a
good idea to do so early, since it's the kind of thing that could be
difficult to retroactively add later.

-- 
Russ Allbery (eagle@eyrie.org)              <http://www.eyrie.org/~eagle/>
