Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751409Ab3GPFbp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 01:31:45 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47009 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab3GPFbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 01:31:44 -0400
Date: Tue, 16 Jul 2013 06:31:40 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com
Subject: Re: splice vs execve lockdep trace.
Message-ID: <20130716053140.GK4165@ZenIV.linux.org.uk>
References: <20130716015305.GB30569@redhat.com>
 <CA+55aFyLbqJp0-=7=HOF9sKGOHwsa7A7-V76b8tbsnra8Z2=-w@mail.gmail.com>
 <20130716023847.GA31481@redhat.com>
 <CA+55aFxiGXht8+Dox=C2ezYYf1yMaLAzMYr40j=+peP8j5Ha6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxiGXht8+Dox=C2ezYYf1yMaLAzMYr40j=+peP8j5Ha6w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 08:25:14PM -0700, Linus Torvalds wrote:

> The "pipe -> cred_guard_mutex" lock chain is pretty direct, and can be
> clearly attributed to splicing into /proc. Now, whether that is a
> *good* idea or not is clearly debatable, and I do think that maybe we
> should just not splice to/from proc files, but that doesn't seem to be
> new, and I don't think it's necessarily *broken* per se, it's just
> that splicing into /proc seems somewhat unnecessary, and various proc
> files do end up taking locks that can be "interesting".

FWIW, we might attack that one - after all, we could have ->splice_write()
for that guy that would grab cred_guard_mutex, then call splice_from_pipe()
with actor that would map/do security_setprocattr/unmap...  Said that,
considering what it does on write, it really does *not* want to deal with
partial writes, so...
