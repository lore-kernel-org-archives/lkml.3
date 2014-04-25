Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921AbaDYXKJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 19:10:09 -0400
Received: from mail.phunq.net ([184.71.0.62]:39964 "EHLO starbase.phunq.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752632AbaDYXKC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 19:10:02 -0400
X-Greylist: delayed 2518 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Apr 2014 19:10:01 EDT
Message-ID: <535AE164.9070309@phunq.net>
Date: Fri, 25 Apr 2014 15:27:48 -0700
From: Daniel Phillips <daniel@phunq.net>
Reply-To: daniel@phunq.net
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-fsdevel@vger.kernel.org, tux3@tux3.org
Subject: Re: Tux3 Report: Untar Unleashed
References: <5359B279.7070003@partner.samsung.com>
In-Reply-To: <5359B279.7070003@partner.samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yesterday I wrote:
 > When we checked read performance on the untarred tree, we immediately saw
 > mixed results. Re-tarring the kernel tree is faster than Ext4, but 
directory listing is
 > slower by a multiple. So we need to analyze and fix ls without 
breaking the good tar
 > and untar behavior. The question is, is it worth another delay before 
putting Tux3
 > patches up for review?

Hirofumi would not let me slink cowardly away from that open question. 
We noticed that Tux3 does slightly more than one seek per directory, 
which is entirely reasonable. But Ext4 goes way beyond that and does 
some special magic to read multiple directories per seek. The only 
possible way to do that is, pack directories together so there are many 
per track. A bit of sleuthing confirmed that this is indeed the case, 
and apparently comes from a patch posted by Ted T'so a few years back:

     lwn.net/Articles/319829/
     [PATCH, RFC] ext4: New inode/block allocation algorithms for 
flex_bg filesystems

That patch was aimed at speeding up fsck and the huge ls speedup appears 
to have gone unnoticed.

Thus inspired, Hirofumi whipped up a prototype patch to allocate new 
directories first, per delta. Result: Tux3 went from 400% slower to 25% 
faster than Ext4, for "ls -R" of the kernel source. Even better, tar and 
untar performance stayed about the same with Tux3 topping the untar test 
at 20% faster and tar at 350%. (The lopsided tar result looks like a 
performance bug for Ext4.)

This optimization only applies to spinning disk. It is pretty hard to 
think of a reason why packing directories together would benefit flash. 
Maybe, directories that are written together are more likely to be 
updated together? But it doesn't hurt flash either, and is another data 
point to support our theory that optimizing for spinning disk also 
optimizes for flash. We are still waiting for the first counterexample 
to show up.

There are a few reasons why Tux3 has an edge for the case exercised by 
the kernel source loads:

   * Defer everything

Tux3 takes the idea of delayed allocation much further and delays nearly 
everything. Directory updates and inode number selection are the only 
exceptions. (In future we will attempt to defer the namespace updates as 
well.)

   * Front back separation

Besides enabling defer-everything, this simplifies locking and reduces 
contention a lot, for both read and update. For now, a naive locking 
strategy serves us well. Eventually we will multithread the backend, 
which will help with high processor core counts, once we get there.

   * Big deltas

Under heavy update load, Tux3 deltas grow as big as cache will allow, so 
per-delta layout algorithms have a big data window available to optimize 
over. With our current strategy, we observe an effect similar to Ext4 
flex_bg, where directories and other metadata tend to self-organize 
along delta boundaries, with beneficial performance effects. We might 
control this behavior more explicitly in future.

   * More inodes per inode table block.

Tux3 stores about 57 inodes per block while Ext4 typically has 16 or 
less. Multiple inodes per block already resembles a kind of inode table 
readahead. Without this, there would be two seeks per directory even 
with directories packed together.

Anyway, I don't think we need to hang our heads in shame for performance 
reasons at this point, even though plenty of major optimization issues 
still remain on the list. For example, you can embarras Tux3 just by 
running a benchmark with 10,000 files per directory. The answer to that 
one is Shardmap, which needs a couple of months to bring up and solves a 
problem that does not come up on your home server or phone. Not a reason 
to get sidetracked again..

Regards,

Daniel
