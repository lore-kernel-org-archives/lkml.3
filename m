Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748Ab3CXFbl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 01:31:41 -0400
Received: from moltke.seatribe.se ([178.63.100.209]:59104 "EHLO
	moltke.seatribe.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595Ab3CXFbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 01:31:39 -0400
X-Greylist: delayed 1131 seconds by postgrey-1.27 at vger.kernel.org; Sun, 24 Mar 2013 01:31:39 EDT
Date: Sun, 24 Mar 2013 06:12:41 +0100 (CET)
From: Fredrik Tolf <fredrik@dolda2000.com>
To: linux-kernel@vger.kernel.org
Subject: I/O blocked while dirty pages are being flushed
Message-ID: <alpine.DEB.2.02.1303240543280.4028@shack.dolda2000.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.7 (nerv.dolda2000.com [IPv6:2002:54d9:e26d:200::1]); Sun, 24 Mar 2013 06:12:42 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear list,

I've got an mmapped file (a Berkeley DB region file) with an access 
pattern such that it gets some 10-40 MBs of dirtied pages a couple of 
times per minute. When the VM comes around to flush these pages to disk, 
that causes loads of problems. Since the dirty pages are rather 
interspersed in the file, the flusher posts batches of some 3000-5000 
write requests to the disk queue, and since I'm using normal hard drives, 
this might sometimes take 10-30 seconds to complete.

While this flush is running, I find that many a process goes into disk 
sleep waiting for the flush to complete. This includes the process 
manipulating the mmapped file whenever it tries to redirty a page 
currently waiting to be flushed, but also, for instance, programs that 
write() to log files (since, I guess, the buffer page backing the last 
written portion of the log file is being flushed). The common culprits, 
then, are sleep_on_page and sleep_on_buffer. All these processes commonly 
block for up to several tens of seconds, then, which gets me all kind of 
trouble, as I'm sure you can see.

I'd like to hear your opinion on this case. Is Berkeley DB at fault for 
causing these kinds of access patterns? Is the kernel at fault for 
blocking all these processes needlessly? Is the hardware at fault for 
being so hopelessly slow and I should get with the times and get me some 
SSDs? Or am I at fault for not finding the obvious configuration settings 
to avoid the problem? :)

I'm inclined to think that the kernel is at fault for blocking the 
processes needlessly. If the contents of the pages being flushed need to 
be preserved until the write is completed, shouldn't they be copied when 
written to, rather than blocking the writer for who-knows-how-long? It 
seems that if the kernel doesn't do this, then I'm always put at the mercy 
of the hardware, and as long as I have free memory, I shouldn't have to 
be.

However, I could also see that Berkeley DB is somehow at fault for this 
kind of access, causing such massive disk writes, and that perhaps it 
should be using SysV SHM regions or such instead of disk-backed files? 
Would it be possible, perhaps, to get these files treated more like 
anonymous memory, their contents not being flushed back to disk unless 
necessary?

It is worth noting, also, that this seems to be a situation introduced 
somewhere between 2.6.26 and 2.6.32, because I started noticing it when I 
upgraded from Debian 5.0 to 6.0. I've since tried it on 3.2.0, 3.5.4 and 
3.7.1, and it appears in every version. However, I can't easily go back 
and bisect, because the new init scripts don't support kernels older than 
2.6.32, unfortunately.

I'm sorry, also, if this is the completely wrong list for such 
discussions, but I couldn't find another one to match better.

Thanks for reading my wall of text!

--

Fredrik Tolf
