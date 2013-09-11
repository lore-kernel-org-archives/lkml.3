Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886Ab3IKSw4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 14:52:56 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33123 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab3IKSwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 14:52:54 -0400
Date: Wed, 11 Sep 2013 19:52:48 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Waiman Long <waiman.long@hp.com>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH 1/2] seqlock: Add a new blocking reader type
Message-ID: <20130911185248.GM13318@ZenIV.linux.org.uk>
References: <1378909707-3347-1-git-send-email-Waiman.Long@hp.com>
 <20130911145536.GJ13318@ZenIV.linux.org.uk>
 <52309B5F.70406@hp.com>
 <20130911172624.GK13318@ZenIV.linux.org.uk>
 <20130911184038.GD29749@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130911184038.GD29749@fieldses.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 02:40:38PM -0400, J. Bruce Fields wrote:
> On Wed, Sep 11, 2013 at 06:26:25PM +0100, Al Viro wrote:
> > On Wed, Sep 11, 2013 at 12:33:35PM -0400, Waiman Long wrote:
> > 
> > > >Folks, any suggestions on better names?  The semantics we are getting is
> > > 
> > > I will welcome any better name suggestion and will incorporate that
> > > in the patch.
> > 
> > FWIW, the suggestions I've seen so far had been
> > 
> > seq_exreadlock() [ex for exclusive]
> > seq_exclreadlock() [ditto, and IMO fails the "easily read over the phone"
> > test - /sekv-excre...ARRGH/]
> > seq_prot_readlock() [prot for protected, as in DLM protected read]
> 
> Though the DLM protected read doesn't self-conflict either so that's a
> poor analogy, my bad.
> 
> (Do the users really require that the read be exclusive?)

We want to exclude writers and since the writer is
lock:
	spin_lock(&sl->lock), bump sl->sequence by 1, smp_wmb()
unlock:
	smp_wmb(), bump sl->sequence by 1, spin_unlock(&sl->lock)
the obvious implementation for this new primitive is simply spin_{lock,unlock}
on the same spinlock...
