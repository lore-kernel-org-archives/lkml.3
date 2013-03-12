Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932636Ab3CLNGq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 09:06:46 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56833 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932183Ab3CLNGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 09:06:17 -0400
Date: Tue, 12 Mar 2013 13:06:14 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: pipe_release oops.
Message-ID: <20130312130614.GA32237@ZenIV.linux.org.uk>
References: <CA+55aFx424SX6S1zFegVaMZ_BkeZctDKCN6eYCLFfaJDKRVG9g@mail.gmail.com>
 <20130307220333.GA31039@redhat.com>
 <20130307223610.GA2494@redhat.com>
 <CA+55aFzdPaFQROzFhz-v1Qn=3aDP=4uGTiOJxR26cR91uJHxyg@mail.gmail.com>
 <20130308145306.GA24085@redhat.com>
 <CA+55aFzwOnRnp2B09fKjt8hd9tOCv44H482z1QpCnYc2mywnpA@mail.gmail.com>
 <20130310221047.GA21522@ZenIV.linux.org.uk>
 <20130311003530.GE21522@ZenIV.linux.org.uk>
 <CA+55aFx+TAg+z9eWVm3EeAHQga3ai6YRFEb7rVQ++iNTn4NhGQ@mail.gmail.com>
 <20130311180543.GF21522@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130311180543.GF21522@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 06:05:43PM +0000, Al Viro wrote:
> On Mon, Mar 11, 2013 at 08:10:10AM -0700, Linus Torvalds wrote:
> > On Sun, Mar 10, 2013 at 5:35 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > >
> > > Hmm...  How the devil would things like pipe_read_open() get called, anyway?
> > > pipe_rdwr_open() can be called, all right - that happens if you do pipe()
> > > and then open() via /proc/self/fd/<n>.  But how could pipe_read_open() and
> > > pipe_write_open() be called?  They are accessible only as ->open() of
> > > read_pipefifo_fops/write_pipefifo_fops.  And those are only used by
> > > fifo_open(), which does reassign file->f_op to them, but does *not* call
> > > their ->open()...
> > 
> > .. same deal? Open the resulting fd from /proc/self/fd/<n> afterwards,
> > which will call file->f_op->open(), no?
> 
> Not really - that would call inode->i_fop, not file->f_op.  You get dentry
> of opened file, but file->f_op is set from scratch - not copied from the
> original struct file.

While we are at it, I don't see any reason for having separate file_operations
for r/o, w/o and r/w cases; the only differences are in EBADF-returning
->read() and ->write() (and ->f_mode checks in vfs_read() et.al. take care of
that) and micro-optimizations in ->release() and ->fasync().

Frankly, I really wonder if we should simply use def_fifo_fops for ->i_fops
in get_pipe_inode() and let open() via /proc/<pid>/fd/<n> act as it would for
FIFOs, O_NONBLOCK and all.  IOW, how about we simply merge all those
file_operations in one, folding fifo.c into pipe.c?  And to hell with any
reassignments of ->f_op.

I'm probably missing something subtle here...
