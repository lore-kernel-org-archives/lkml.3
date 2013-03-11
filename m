Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab3CKAfe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 20:35:34 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36501 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454Ab3CKAfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 20:35:33 -0400
Date: Mon, 11 Mar 2013 00:35:31 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: pipe_release oops.
Message-ID: <20130311003530.GE21522@ZenIV.linux.org.uk>
References: <CA+55aFwDYocNRjSCJk1PYw0MFy7dpKf1yMMEiePP--=ewQcX6A@mail.gmail.com>
 <20130307213819.GB19543@redhat.com>
 <CA+55aFx424SX6S1zFegVaMZ_BkeZctDKCN6eYCLFfaJDKRVG9g@mail.gmail.com>
 <20130307220333.GA31039@redhat.com>
 <20130307223610.GA2494@redhat.com>
 <CA+55aFzdPaFQROzFhz-v1Qn=3aDP=4uGTiOJxR26cR91uJHxyg@mail.gmail.com>
 <20130308145306.GA24085@redhat.com>
 <CA+55aFzwOnRnp2B09fKjt8hd9tOCv44H482z1QpCnYc2mywnpA@mail.gmail.com>
 <20130310221047.GA21522@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130310221047.GA21522@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 10, 2013 at 10:10:47PM +0000, Al Viro wrote:
> On Fri, Mar 08, 2013 at 10:30:01AM -0800, Linus Torvalds wrote:
> 
> > I must be missing something, and I wonder if the thing I'm missing is
> > that with OPEN_PATH we may now have open calls that don't actually
> > have FMODE_READ or FMODE_WRITE set at all.
> 
> With OPEN_PATH we don't call ->open() (or anything in the driver, for that
> matter) at all.  I really don't see how that could trigger...

Hmm...  How the devil would things like pipe_read_open() get called, anyway?
pipe_rdwr_open() can be called, all right - that happens if you do pipe()
and then open() via /proc/self/fd/<n>.  But how could pipe_read_open() and
pipe_write_open() be called?  They are accessible only as ->open() of
read_pipefifo_fops/write_pipefifo_fops.  And those are only used by
fifo_open(), which does reassign file->f_op to them, but does *not* call
their ->open()...
