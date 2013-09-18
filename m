Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391Ab3IRLim (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 07:38:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5605 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751556Ab3IRLik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 07:38:40 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1379459317-13046-2-git-send-email-daniel.santos@pobox.com>
References: <1379459317-13046-2-git-send-email-daniel.santos@pobox.com> <1379459317-13046-1-git-send-email-daniel.santos@pobox.com>
To: Daniel Santos <daniel.santos@pobox.com>
Cc: dhowells@redhat.com, linux-kbuild <linux-kbuild@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Michal Marek <mmarek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        George Spelvin <linux@horizon.com>
Subject: Re: [PATCH 1/5] scripts: Add mkstrerror.sh
Date: Wed, 18 Sep 2013 12:38:20 +0100
Message-ID: <29168.1379504300@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

danielfsantos@att.net wrote:

> This is a simple bash script that parses our errno*.h files and formats
> them into the error_strings.h header that our strerror and strerror_name
> functions will use later.

I presume you haven't tried building with a "make O=foo" build directory?  I
see:

      /bin/sh: /data/fs/linux-2.6-fscache/include/generated/error_strings.h: No such file or directory

when I try it.

Looking in your generated error_strings.h file, I see:

	static const struct error_strings {
		const unsigned first;
		const unsigned last;
		const unsigned count;
		const char * const desc[2];
	} error_strings[2] = {
		{
			.first = 0,
			.last  = 133,
			.count = 134,
			.desc  = {
	#ifdef CONFIG_STRERROR_NAME
		"\0"                            /* 0 */
		"EPERM\0"                       /* 1 */
		"ENOENT\0"                      /* 2 */
		"ESRCH\0"                       /* 3 */
		"EINTR\0"                       /* 4 */
	...
		"ERFKILL\0"                     /* 132 */
		"EHWPOISON\0"                   /* 133 */,
	#else
		NULL,
	#endif /* CONFIG_STRERROR_NAME */

	#ifdef CONFIG_STRERROR
		"\0"                                                    /* 0 */
		"Operation not permitted\0"                             /* 1 */
		"No such file or directory\0"                           /* 2 */
		"No such process\0"                                     /* 3 */
	...
	        "State not recoverable\0"                               /* 131 */
		"Operation not possible due to RF-kill\0"               /* 132 */
		"Memory page has hardware error\0"                      /* 133 */,
	#else
		NULL,
	#endif /* CONFIG_STRERROR */
			},
		}, {
			.first = 512,
			.last  = 529,
			.count = 18,
			.desc  = {
	#ifdef CONFIG_STRERROR_NAME
		"ERESTARTSYS\0"                 /* 512 */
		"ERESTARTNOINTR\0"              /* 513 */
	...
		"Request initiated, but will not complete before timeout\0"/* 528 */
		"iocb queued, will get completion event\0"              /* 529 */,
	#else
		NULL,
	#endif /* CONFIG_STRERROR */
			},
		}
	};


Some thoughts for you:

 (1) Why are you double-NUL'ing all your strings?  (see the \0 in the strings)

 (2) Storing the leading 'E' for each symbol is redundant as you can add that
     later so you might want to discard it.

 (3) You are storing a pointer to the symbolic name for each error.  On a
     64-bit machine, that's 8 bytes.  If you drop the leading 'E' and the
     trailing NUL, most symbols will fit into an 8 character slot saving you
     the cost of a pointer.

     Okay, you'll have to truncate some of the names (ERESTARTNOINTR ->
     RESNOINT for example) but probably not that many.  Run this:

	grep '["]E[A-Z0-9]' include/generated/error_strings.h |
           cut '-d\' -f1 | cut -dE -f2- | cut -c1-8

     and you'll see what I mean.  Most of them are still recognisable,
     particularly once you stick the 'E' back on the front.  Piping the output
     of that through "wc -l", I get:

	147

     which means the entire string table could be squeezed into 8 * 147 or
     1176 bytes with only one pointer and one count required for each segment
     of the table (you generate two segments).

David
