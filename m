Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558Ab3CVAUe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 20:20:34 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39012 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989Ab3CVAUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 20:20:33 -0400
Date: Fri, 22 Mar 2013 00:20:31 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: VFS deadlock ?
Message-ID: <20130322002030.GI21522@ZenIV.linux.org.uk>
References: <20130321203639.GC16406@redhat.com>
 <20130321204704.GZ21522@ZenIV.linux.org.uk>
 <20130321210255.GD16406@redhat.com>
 <CA+55aFxysZEw6fw8+LobMgfzeHuGSSs+hyrUr_frTOjaCGJFLQ@mail.gmail.com>
 <20130321221256.GA30620@redhat.com>
 <CA+55aFx+O13YuJsZyrTS6O9Kws=1ff-knsSv9rV8wTf8yBrPJg@mail.gmail.com>
 <20130321233630.GE21522@ZenIV.linux.org.uk>
 <CA+55aFyLJ9vVm1T994EaE4tnEbV8rHj43m+cWsFFBi_qndao1A@mail.gmail.com>
 <CA+55aFyWNkOnrQ41xCAU8q5sVXdq1-u2P8n+quLY50OdiFo3Zw@mail.gmail.com>
 <20130322001257.GH21522@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130322001257.GH21522@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 22, 2013 at 12:12:57AM +0000, Al Viro wrote:

> See the posting upthread.  We could try to kludge around that as well
> (e.g. have d_ancestor() compare ->d_inode instead of dentries themselves),
> but I really think it's a lousy idea only inviting further abuse.
> 
> What we should do, IMO, is to turn /proc/<pid>/net into a honest symlink -
> to ../nets/<netns ID>/net.  Hell, might even make it a magical symlink
> instead...

BTW, the root cause is that what used to be /proc/net became per-process.
So Eric (IIRC) had added /proc/<pid>/net.  Only they are not really per-process
- they are per-netns.  And instead of putting those per-ns trees elsewhere and
having /proc/<pid>/net resolve to the right one, we got them as directories,
with each entry hardlinked between all /proc/<pid>/net for processes from
the same netns.  Including the subdirectory ones.  Oops...

Another variant is to keep cross-hardlinks for non-directories and duplicate
directory dentries/inodes as we do for /proc/<pid>/net themselves.
