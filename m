Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752311AbaAWG1z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 01:27:55 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:50032 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaAWG1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 01:27:53 -0500
Date: Thu, 23 Jan 2014 10:27:46 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Mel Gorman <mgorman@suse.de>,
        Pavel Emelyanov <xemul@parallels.com>, gnome@rvzt.net,
        drawoc@darkrefraction.com, alan@lxorguk.ukuu.org.uk,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        bugzilla-daemon@bugzilla.kernel.org
Subject: Re: [Bug 67651] Bisected: Lots of fragmented mmaps cause gimp to
 fail in 3.12 after exceeding vm_max_map_count
Message-ID: <20140123062746.GT1574@moon>
References: <20140122190816.GB4963@suse.de>
 <52E04A21.3050101@mit.edu>
 <20140123055906.GS1574@moon>
 <20140122220910.198121ee.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140122220910.198121ee.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 10:09:10PM -0800, Andrew Morton wrote:
> > > 
> > > That being said, this could cause vma blowups for programs that are
> > > actually using this thing.
> > 
> > Hi Andy, indeed, this could happen. The easiest way is to ignore softdirty bit
> > when we're trying to merge vmas and set it one new merged. I think this should
> > be correct. Once I finish I'll send the patch.
> 
> Hang on.  We think the problem is that gimp is generating vmas which
> *should* be merged, but for unknown reasons they differ in
> VM_SOFTDIRTY, yes?

Yes. One place where I forgot to set softdirty bit is setup_arg_pages. But
it called once on elf load, so it can't cause such effect (but should be
fixed too). Also there is do_brk where vmasoftdirty is missed too :/

Another problem is the potential scenario when we have a bunch of vmas
and clear vma-softdirty bit on them, then we try to map new one, flags
won't match and instead of extending old vma the new one will be created.
I think (if only I'm not missing something) that vma-softdirty should
be ignored in such case (ie inside is_mergeable_vma) and once vma extended
it should be marked as dirty one. Again, I need to think and test more.

> Shouldn't we work out where we're forgetting to set VM_SOFTDIRTY? 
> Putting bandaids over this error when we come to trying to merge the
> vmas sounds very wrong?

I'm looking into this as well.

	Cyrill
