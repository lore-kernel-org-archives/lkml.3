Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933076Ab3CGPsL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 10:48:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41889 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933034Ab3CGPsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 10:48:08 -0500
Date: Thu, 7 Mar 2013 16:48:05 +0100
From: Jan Kara <jack@suse.cz>
To: Harshana Ranmuthu <hranmuthu@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux 3.0+ Disk performance problem - wrong pdflush behaviour
Message-ID: <20130307154805.GH6723@quack.suse.cz>
References: <CABC96KznmDJHp5gfx1YsfX9hdXGFA3buaY31P2dDy1jJQgga7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABC96KznmDJHp5gfx1YsfX9hdXGFA3buaY31P2dDy1jJQgga7w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 06-03-13 20:05:58, Harshana Ranmuthu wrote:
> >   I don't know how to fix the issue without reverting the patch. Sorry.
> 
> with reference to post URL
> http://marc.info/?l=linux-fsdevel&m=134997043820759&w=2
> 
> I was going through this post, as we are also having problems with the
> same commit. In our case, we are appending to a file rather than
> updating.
> 
> Let me explain the issue as I understand and the solution I think
> which can fix the issue.
> 
> If a write() writes to a page (for the second time) which is being
> flushed (because the page was dirty from the fist write), data written
> to disk may have part from the first write and  rest from the second
> write. Although, after the second write, page will have the correct
> data, but disk will have corrupted data, ie, part from first write and
> rest from the second write. After flush(), dirty flag on the page will
> be cleared.
  This isn't true. Dirty bit gets cleared *before* the page is submitted
for IO. So second write sets the dirty bit again and that assures writeback
will happen in future again. So what you propose below is indeed happening.
So my question is: What problems are you really observing?

> If there has been a third write on the same page (this
> time assuming a clean write), then accurate data will be written to
> disk on the next flush. If there's no third write, then file on disk
> will remain to have corrupted data. If we can make sure, after the
> second write(), page remains dirty (because flush and write() happened
> at the same time), then even there's no third write, that page will be
> flushed again with accurate data, correcting the corruption on the
> disk.
> In summery, solution is to make sure the conflicting (write and flush
> happen at the same time) pages kept dirty after the flush. This will
> make sure these pages will be flushed again even there's no subsequent
> write()s to them.
> 
> I don't know how easy / difficult this change is. Hope you'll consider this.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
