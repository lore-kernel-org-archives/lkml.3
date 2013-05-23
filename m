Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759362Ab3EWUuM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 16:50:12 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:37026 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758330Ab3EWUuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 16:50:10 -0400
MIME-Version: 1.0
Date: Thu, 23 May 2013 16:49:49 -0400
Message-ID: <CANP1eJFz8kQguZ0zSZHx7KR=3XkNaxNg94bD92MkFZhR3pZHYw@mail.gmail.com>
Subject: Nonblocking buffered AIO from userspace
From: Milosz Tanski <milosz@adfin.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi gang,

I need some advice on the best way to accomplish non-blocking buffered
disk IO from my user space application. Unlike some of the other
database systems I'm trying to outsource as much work to the kernel as
possible. I would prefer to avoid having to resolve to O_DIRECT and
io_submit to fetch the data and having to reimplement the page /
buffer cache & read ahead.

The application is read heavy with occasional long running write jobs.
Since I'm not too concerned about the performance on the write path I
am able to run that work in threads and block.

Current I'm mmaping the files, and the make the read path quite simple
and is great for disk scans when my data set is stored in memory. When
the data is not cached the performance becomes more unpredictable,
esp. when I'm doing an indexed read (giant bitmap indexes). Here's how
my IO path looks like:

application <--> fscache (SSD) <--> cephfs <--> ceph cluster

Ultimately what I'd like is a way to do non-blocking scatter gather IO
from disk or page cache into my application. I'd like to be
non-blocking because it often happens that I can do something useful
while waiting on IO like uncompress indexes for another request that
is waiting, process network IO., etc.

With mmap my blocking is unpredictable and mlock() blocks and only
lets me lock a range and not a vector of page ranges.

If I was doing this in the kernel life would be simple; there are all
sorts of APIs for doing async IO even when my VFS is stack as in above
diagram. Is there any way for me to take advantage of it in user
space... even if it's in units of page.

It's entirely possible that I'm missing something and there's a good
way of doing this that I haven't though of.

Thanks,
- Milosz
