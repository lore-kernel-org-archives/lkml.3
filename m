Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760835Ab3DBOQN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 10:16:13 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:42213 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759831Ab3DBOQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 10:16:11 -0400
Date: Tue, 2 Apr 2013 11:16:04 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf: fix bug in isupper() and islower()
Message-ID: <20130402141604.GD1952@ghostprotocols.net>
References: <20130329192950.GA9312@us.ibm.com>
 <876206hixb.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <876206hixb.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Apr 01, 2013 at 03:19:28PM +0900, Namhyung Kim escreveu:
> On Fri, 29 Mar 2013 12:29:50 -0700, Sukadev Bhattiprolu wrote:
> > Subject: [PATCH] perf: fix bug in isupper() and islower()

> > One of the reasons 'perf test' is failing on Power appears to be due to
> > a bug in isupper().

> > isupper(c) and islower(c) should be checking 'c' against the mask 0x20.
> > Instead they are checking sane_ctype[c] which causes isupper() to be true
> > for lower case letters.

> Indeed!
> Acked-by: Namhyung Kim <namhyung@kernel.org>

But can we try to use the same defs as for the kernel? Or at least sync
this code against git.git, that is where it comes from?

There we have:

#define islower(x) sane_iscase(x, 1)
#define isupper(x) sane_iscase(x, 0)

#define sane_istest(x,mask) ((sane_ctype[(unsigned char)(x)] & (mask)) != 0)

static inline int sane_iscase(int x, int is_lower)
{
        if (!sane_istest(x, GIT_ALPHA))
                return 0;

        if (is_lower)
                return (x & 0x20) != 0;
        else
                return (x & 0x20) == 0;
}
----------------------------------------------------------------------------

In the kernel we have instead:

include/linux/ctype.h

#define _U      0x01    /* upper */
#define __ismask(x) (_ctype[(int)(unsigned char)(x)])
#define isupper(c)      ((__ismask(c)&(_U)) != 0)

----------------------------------------------------------------------------

I'm merging this fix now, as it improves things, but this seemingly
needless speciations looks insane, would be great to have at least
tools/perf/  using the same stuff as its landlord, the kernel.

- Arnaldo
