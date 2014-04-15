Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696AbaDOXM7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 19:12:59 -0400
Received: from mano-163-44-shared.jabatus.fr ([109.234.163.44]:57282 "EHLO
	mano-163-44-shared.jabatus.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752960AbaDOXM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 19:12:57 -0400
X-Greylist: delayed 34196 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Apr 2014 19:12:56 EDT
X-MailPropre-MailScanner-From: ecolbus@manux.info
X-MailPropre-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=0, required 5, autolearn=not spam)
X-MailPropre-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-MailPropre-MailScanner-ID: 619AC9ABB304.A155A
X-MailPropre-MailScanner-Information: Message sortant - Serveurs o2switch
Message-ID: <534DBCF5.7070209@manux.info>
Date: Wed, 16 Apr 2014 01:12:53 +0200
From: Emmanuel Colbus <ecolbus@manux.info>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20131104 Icedove/17.0.10
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][6/11][MANUX] Kernel compatibility : directory hardlinks
References: <534D3765.4090403@manux.info> <20140415200629.GI4456@thunk.org> <534D9C44.1050505@manux.info> <20140415220119.GM4456@thunk.org>
In-Reply-To: <20140415220119.GM4456@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 16/04/2014 00:01, Theodore Ts'o a écrit :
> On Tue, Apr 15, 2014 at 10:53:24PM +0200, Emmanuel Colbus wrote:

> 
>> The value means that the file is not a true directory, but a directory
>> hardlink. Directory hardlinks, which only appear in my ro-compatible
>> ext2l partitions, are special files that have no content, and simply
>> point to a directory inode by using its inode number. 
> 
> I'm not sure what's the value of having a directory hard link given
> the existence of symlinks.  I undersatnd what the difference is, but
> what value does it give to an end user?  It's confusing, and if there
> is a directory hard link to a directory, you won't be able to delete
> the directory, lest you leave a dangling reference (and you can't just
> remove the primary link to the directory, since then the ".." entry in
> the directory will be pointing to the old parent directory).  That
> makes hard links of files fundamentally different from a directory
> hard link, which will be even more confusing to users.

As for the end users, they aren't supposed to create any : this is a
privileged operation. However, for the operating system, this is very
useful.

Consider for example a program that stores some data within its /tmp. In
my OS, every process is chrooted, so he needs to have its own /tmp. But
then, this raises several issues :
1) Some applications use /tmp as a means of communication between each
other. POSIX explicitely allows this. So how is this supposed to work if
two applications, in two different chroots, try to communicate in this way?
2) How is this /tmp directory supposed to be cleaned when the system
shuts down?

The solution is to use directory hardlinks. This way :
 - applications that want to communicate through /tmp can simply specify
that they have a dependancy on a package that provides a /tmp directory
for them; this way, the package manager will create a directory hardlink
named "/tmp" towards it in their chroot, and they will be able to do
their thing;
- as for the cleaning of /tmp, it is done by having all the /tmp
directories of all the applications hardlinked within the chroot of the
script tasked with cleaning them.

Symlinks, of course, wouldn't work, as they would require giving at
least one application access to the other's root.

> 
> But if I were going to do such an insane thing, instead of trying to
> do it by repurposing an inode field and using an inode, I'd probably
> do it by using a bit in the file_type field of the directory entry to
> indicate that it's this special "directory hard link" thing.

Well, I'm using the underlying file as a mount point, so not having any
file seems tricky. And I'm considering using the file's *content* to
allow turning them into automatic cross-partition hardlinks. (Which
would certainly not be very *hard* -links anymore, but I think I
wouldn't be the first OS to implement not-so-hard hardlinks).

 This
> doesn't solve the semantic questions of what happens if you want to
> delete a directory that has one or more hard links to it, though.

Deleting a directory that has one or more hardlinks towards it simply
fails. (In my ext2l partitions, in the case of directories, I have used
the fragment address field as a counter of hardlinks). My directory
hardlinks are fundamentally different from other hardlinks, both in
their implementation (an additional inode type instead of an additional
directory entry) and in their behaviour (the first hardlink is different
from the other ones).

Regards,

Emmanuel
