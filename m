Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548Ab3AUViB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 16:38:01 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:36608 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712Ab3AUViA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 16:38:00 -0500
Date: Mon, 21 Jan 2013 13:38:23 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@ghostprotocols.net, Anton Blanchard <anton@au1.ibm.com>,
        paulus@samba.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] perf: Fix compile warnings in tests/attr.c
Message-ID: <20130121213823.GA4774@us.ibm.com>
References: <20130119013052.GA24693@us.ibm.com>
 <20130121135906.GD1995@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20130121135906.GD1995@krava.brq.redhat.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012121-7408-0000-0000-00000C15DCD5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Olsa [jolsa@redhat.com] wrote:
| On Fri, Jan 18, 2013 at 05:30:52PM -0800, Sukadev Bhattiprolu wrote:
| > From 4d266e5040c33103f5d226b0d16b89f8ef79e3ad Mon Sep 17 00:00:00 2001
| > From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
| > Date: Fri, 18 Jan 2013 11:14:28 -0800
| > Subject: [PATCH] perf: Fix compile warnings in tests/attr.c
| > 
| > Replace '%llu' in printf()s with 'PRIu64' in 'tools/perf/tests/attr.c'
| > to fix compile warnings (which become errors due to -Werror).
| 
| i386 and x86_64 compiles fine for me with gcc versions 4.6.3-2 and 4.7.2-2

But is broken on Power for 64bit :-( I am trying to fix that and thought
that use of format specifiers like 'PRIu64' was the way to go.

| 
| with your patch for x86_64 I'm getting following warnings/errors:

| 
|     CC tests/attr.o
| tests/attr.c: In function ‘store_event’:
| tests/attr.c:69:4: error: format ‘%lu’ expects argument of type ‘long unsigned int’, but argument 6 has type ‘__u64’ [-Werror=format]

Here is what I see on an x86_64 box, RHEL6.2 box:

	$ rpm -qf /usr/include/linux/types.h
	kernel-headers-2.6.32-220.4.2.el6.x86_64

	$ cat foo.c
	#include <linux/types.h>

	$ cc -Werror -Wall foo.c
	In file included from /usr/include/asm-generic/types.h:7,
			 from /usr/include/asm/types.h:6,
			 from /usr/include/linux/types.h:4,
			 from foo5.c:1:
	/usr/include/asm-generic/int-ll64.h:31:2: error: #error __u64 defined as unsigned long long

where the #error is my debug message.

<snip>

| make: *** [tests/attr.o] Error 1
| 
| i386 compiles fine

__u64 is 'unsigned long long' on x86 and PRIu64 is 'llu' which is fine.

__u64 is 'unsigned long' on Power and PRIu64 is 'lu' which is again fine.

But __u64 is 'unsigned long long' on x86_64, but PRIu64 is '%lu' bc __WORDSIZE
is 64.

On x86_64, shouldn't __u64, be defined as 'unsigned long' rather than
'unsigned long long' - ie include 'int-l64.h' rather than 'int-ll64.h' ?

BTW, does 'perf' with my patch compile, (with warnings) for you on x86_64
with 'WERROR=0 make' ?

Sukadev

