Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834AbaGQV2R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 17:28:17 -0400
Received: from imap.thunk.org ([74.207.234.97]:41858 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220AbaGQV2P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 17:28:15 -0400
Date: Thu, 17 Jul 2014 17:28:06 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Mark Kettenis <mark.kettenis@xs4all.nl>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, beck@openbsd.org
Subject: Re: [PATCH, RFC] random: introduce getrandom(2) system call
Message-ID: <20140717212806.GV1491@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Andy Lutomirski <luto@amacapital.net>,
	Mark Kettenis <mark.kettenis@xs4all.nl>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	beck@openbsd.org
References: <201407171848.s6HImBb4027900@glazunov.sibelius.xs4all.nl>
 <53C83383.4040507@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C83383.4040507@amacapital.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 01:35:15PM -0700, Andy Lutomirski wrote:
> 
> Can we please have a mode in which getrandom(2) can neither block nor
> fail?  If that gets added, then this can replace things like AT_RANDOM.

AT_RANDOM has been around for a long time; it's not something we can
remove. 

> There are non-crypto things out there that will want this.  There are
> also probably VM systems (especially ones that have something like my
> KVM_GET_RNG_SEED patches applied, or many VMs on Haswell, for that
> matter) that will have perfectly fine cryptographically secure urandom
> output immediately after bootup but that won't consider themselves
> "initialized" for a while.  At least these will be perfectly fine from
> the POV of those who trust their hypervisor and Intel :)

If you trust Intel, then you can either use RDRAND directly, or you
can use rngd.  There is also plans to set up an hw_random RDRAND that
can be configured to automatically fill the entropy pool using the new
khwrngd, which could be configured using the appropriate boot options
for those who want to blindly trus their hypervisor and/or Intel.

However, I don't think that should be the default.  And on x86 systems
at least, this is largely a moot point, since the /dev/urandom pool
gets initialized *very* quickly after the system boots.  It's only on
the !@#! ARM systems that don't have a cycle counter, or apparently no
reliable way to make sure the cycle counter is present, which seems to
be the place where we have problems.  But I'd much rather gradually
apply more pressure to the ARM folks so they finally fix their CPU
architecture, and this is one step down that path without forcibly
breaking existing userspace.

						- Ted

