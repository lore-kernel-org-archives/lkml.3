Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850AbaA1U16 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 15:27:58 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:45736 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755364AbaA1U15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 15:27:57 -0500
Date: Tue, 28 Jan 2014 20:27:54 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: David Howells <dhowells@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-afs@lists.infradead.org, Pali Roh??r <pali.rohar@gmail.com>
Subject: Re: [PATCH] afs: proc cells and rootcell are writeable
Message-ID: <20140128202754.GI10323@ZenIV.linux.org.uk>
References: <CA+55aFz3Zi_PyQwnCS45XHO-om+XSesBby4g0WS0JcQp5i_m+Q@mail.gmail.com>
 <20140126122729.32113.19659.stgit@warthog.procyon.org.uk>
 <10828.1390940412@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10828.1390940412@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 08:20:12PM +0000, David Howells wrote:
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > > -       p = proc_create("cells", 0, proc_afs, &afs_proc_cells_fops);
> > > +       p = proc_create("cells", S_IFREG | S_IRUGO | S_IWUSR, proc_afs, &afs_proc_cells_fops);
> > > -       p = proc_create("rootcell", 0, proc_afs, &afs_proc_rootcell_fops);
> > > +       p = proc_create("rootcell", S_IFREG | S_IRUGO | S_IWUSR, proc_afs, &afs_proc_rootcell_fops);
> > 
> > So the S_IFREG isn't necessary.
> 
> True.  Is it worth creating proc_create_special() that can create a non-regular
> file and then making proc_create() only permit regular files (and complain if
> the S_IFMT field is not zero)?

We already do: in proc_create_data() we have
        struct proc_dir_entry *pde;
        if ((mode & S_IFMT) == 0)
                mode |= S_IFREG;

        if (!S_ISREG(mode)) {
                WARN_ON(1);     /* use proc_mkdir() */
                return NULL;
        }

proc_mkdir{,_data,_mode} are there for purpose.  Nobody had been insane
enough to put FIFOs or sockets in procfs and anything else would need
additional data anyway.  proc_symlink() is there, proc_mknod() isn't and
nobody has complained yet.  Let's keep it that way, plese...
