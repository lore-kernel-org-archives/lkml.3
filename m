Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869AbaCCV0q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 16:26:46 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:36046 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010AbaCCV0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 16:26:44 -0500
Date: Mon, 3 Mar 2014 21:26:42 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: George Spelvin <linux@horizon.com>
Cc: torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Update of file offset on write() etc. is non-atomic with I/O
Message-ID: <20140303212642.GJ18016@ZenIV.linux.org.uk>
References: <20140303210359.26624.qmail@science.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140303210359.26624.qmail@science.horizon.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2014 at 04:03:59PM -0500, George Spelvin wrote:
> >  struct fd {
> >  	struct file *file;
> > -	int need_put;
> > +	unsigned need_put:1, need_pos_unlock:1;
> >  };
> 
> Since we're rounding up to 2*sizeof(struct file *) anyway, is this a case
> where wasting space on a couple of char (or bool) flags would generate
> better code than a bitfield?
> 
> In particular, the code to set need_pos_unlock (which will be executed
> each read/write for most files) is messy in the bitfield case.
> A byte store is much cleaner.
> 
> (If you want to use bits, why not use the two lsbits of the file pointer
> for the purpose?  That would save a lot of space.)

Most of the cases have it kept separately in registers, actually - there's
a reason why fdget() and friends are inlined.
