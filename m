Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab3JFAne (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 20:43:34 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52966 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494Ab3JFAnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 20:43:33 -0400
Date: Sun, 6 Oct 2013 01:43:31 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC] apparently broken RLIMIT_CORE
Message-ID: <20131006004331.GY13318@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	elf_core_dump() writes struct elfhdr, then a bunch of
elf_phdr.  It sums the sizes of data being written in 'size',
checking it against cprm->limit as it goes.

	So far, so good, but then it proceeds to write_note_info(),
which neither checks overflows nor contributes to size.  _Then_
it seeks to page boundary and proceeds to loop over the pages,
writing them to dump.  At that point it again starts to count sizes,
bump size and check it against cprm->limit (only for present pages,
though - absent ones are silently skipped, with lseek() done on
output and size not increased).

	In other words, the size of notes section is ignored for
RLIMIT_CORE purposes.  Is that intentional?  Looks like a bug to
me...  FWIW, POSIX says that limit is on the file size and demands
that write would stop at that length, with 0 meaning "suppress
coredump creation completely".  I'm not sure how the holes should
be treated (note, BTW, that when output goes into a pipe we do
feed zeroes into it for absent pages for obvious reasons, but we
do not count them towards the limit), but ignoring the notes doesn't
look intentional...

	Comments?
