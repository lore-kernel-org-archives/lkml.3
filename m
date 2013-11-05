Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467Ab3KESmr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 13:42:47 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:52040 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755036Ab3KESls convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 13:41:48 -0500
From: Steven Schlansker <stevenschlansker@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Subject: Multiple copy-on-write branches of an anonymous memory segment
Message-Id: <9492A0F4-990D-44F0-B10A-1B55D25995B6@gmail.com>
Date: Tue, 5 Nov 2013 10:41:43 -0800
To: linux-kernel@vger.kernel.org
Mime-Version: 1.0 (Mac OS X Mail 7.0 \(1816\))
X-Mailer: Apple Mail (2.1816)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am developing a data structure that resides in a large memory buffer.  It is important that I be able to
mutate the data structure without interfering with concurrent reads, and then swap it in at a convenient time.

There is a set of initial data stored in a file.  I use mmap(2) to map the file into memory.  At some later point, I would like to run incremental updates.  This involves copying the data structure, mutating it, then publishing it.  Only a very small percentage of the data structure is changed, but it can change at random.

Currently, I accomplish this by mapping a new anonymous segment, copying the data, and modifying it.  However this is wasteful both in time (copying all that data takes a fair amount of time) and memory (most of the data did not actually change, but now we have two copies).

I would like to utilize kernel support for copy-on-write to eliminate both of these bottlenecks.  Ideally, I would be able to:

1) create a new COW mapping of an existing anonymous mapping that shares pages initially and I can write to without affecting the original
2) At the time of creating that new mapping, extend the buffer with initially-zero pages (in case I need more space to append to the end of the data structure in the new version)

The mmap and mremap documentation get me tantalizingly close — I can resize the segment I already have, I can allocate file-backed copy on write segments.  Also, forking while holding a private mapping seems to provide other bits of the functionality (COW of anonymous segments).  But I can’t seem to figure out how to fit the puzzle pieces together.  Also, I’m running in the JVM, so forking is not a possibility.

There’s a couple of unanswered StackOverflow questions in a similar vein, so I hope I’m not just missing something obvious.  The most relevant is:

http://stackoverflow.com/questions/16965505/allocating-copy-on-write-memory-within-a-process

And it looks like this dance is even possible on Mach, with some clever use of ‘vm_remap'.


I’m hoping that I’m just missing the magic incantation to pass to mmap to achieve this behavior.  I wasn’t brave enough to subscribe to LKML just yet, so please CC me on replies!

TIA,
Steven Schlansker

