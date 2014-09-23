Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902AbaIWEzy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 00:55:54 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:33917 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574AbaIWEzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 00:55:52 -0400
Date: Tue, 23 Sep 2014 00:55:49 -0400
From: Tejun Heo <tj@kernel.org>
To: NeilBrown <neilb@suse.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernfs: use stack-buf for small writes.
Message-ID: <20140923045549.GB11740@mtj.dyndns.org>
References: <20140923140633.35efbe7a@notabene.brown>
 <20140923041817.GA11740@mtj.dyndns.org>
 <20140923144650.2aa71b39@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140923144650.2aa71b39@notabene.brown>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Neil.

On Tue, Sep 23, 2014 at 02:46:50PM +1000, NeilBrown wrote:
> seqfile is only safe for reads.  sysfs via kernfs uses seq_read(), so there
> is only a single allocation on the first read.
> 
> It doesn't really related to fixing writes, except to point out that only
> writes need to be "fixed".  Reads already work.

Oh, I meant the buffer seqfile read op writes to, so it depends on the
fact that the allocation is only on the first read?  That seems
extremely brittle to me, especially for an issue which tends to be
difficult to reproduce.

> Separately:
> 
> > Ugh... :( If this can't be avoided at all, I'd much prefer it to be
> > something explicit - a flag marking the file as needing a persistent
> > write buffer which is allocated on open.  "Small" writes on stack
> > feels way to implicit to me.
> 
> How about if we add seq_getbuf() and seq_putbuf() to seqfile
> which takes a 'struct seq_file' and a size and returns the ->buf
> after making sure it is big enough.
> It also claims and releases the seqfile ->lock.
> 
> Then we would be using the same buffer for reads and write.
> 
> Does that sound suitable?  It uses existing infrastructure and avoids having
> to identify in advance which attributes it is important for.

I'd much rather keep things direct and make it explicitly allocate r/w
buffer(s) on open and disallow seq_file operations on such files.

Thanks.

-- 
tejun
