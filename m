Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334AbaATJuI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 04:50:08 -0500
Received: from mail-vb0-f47.google.com ([209.85.212.47]:64695 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbaATJuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 04:50:06 -0500
MIME-Version: 1.0
Date: Mon, 20 Jan 2014 15:20:05 +0530
Message-ID: <CAEfL3Kmr4Q43Kn=HsP2yfmLEM+r784oACuhxnVwjB9Cgpk6vtQ@mail.gmail.com>
Subject: sigbus on memcpy despite calling mincore
From: Sandeep Joshi <sanjos100@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks

I have a program which is trying to read a page from the page cache
for a certain file

it calls mmap (PROT_NONE, MAP_SHARED |MAP_LOCKED).

Then it calls mincore to check if the page is in memory

If it does exist, it remaps the same offset using mmap(PROT_READ,
MAP_SHARED|MAP_LOCKED)

After this, it is tries to do a read (memcpy) from the returned
address of the second mmap.

Unfortunately, I am getting a SIGBUS in cases where there is another
thread in the same process trying to write to the same file (though
not at the same offset)

when I look in /proc/<pid>/smaps, I see that the mapped address has
RSS=0 (not in memory) and LOCKED=0 (not locked) which is strange since
I have locked the page and called mincore on it.

I added checking for the filesize (fstat) before the first mmap but
still get a SIGBUS.  I also changed the second and first mmaps to do
MAP_PRIVATE hoping it would give a private copy of the page but that
didnt help either.

Is there some race condition which resets the vma_flags when another
thread in the same process is writing to the same file offset being
read ?

thanks
-Sandeep
