Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536AbaBXMmW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 07:42:22 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:61537 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbaBXMmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 07:42:20 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: David Howells <dhowells@redhat.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] bug: When !CONFIG_BUG, simplify WARN_ON_ONCE and family
Date: Mon, 24 Feb 2014 13:42:09 +0100
Message-ID: <1747419.6FxgzfPen0@wuerfel>
User-Agent: KMail/4.11.3 (Linux/3.11.0-15-generic; KDE/4.11.3; x86_64; ; )
In-Reply-To: <10646.1393243751@warthog.procyon.org.uk>
References: <20140224084437.GG20680@thin> <201402240902.35977.arnd@arndb.de> <10646.1393243751@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:A2S8y8FnwzQkcuCshdV35GlMRn7wvwgySC+C9ugoxV3
 YQma5g4Dq4dgfRmNJAmo76FtdOakg5D36TdRkLf9jDEoMZk2qg
 FhOYScj27FgD0SlyJSzbvgU0KbPCZ2+TIEdBib/GEmV+f9fbwx
 aTzFBL9oTpWp+kb5+4TdWtkLvoknlsHSYoRW3XSj5t93oXCcN1
 uavKY0OgezpL85Rp5hgLBczRmRkC2wcCQFKpjOx+84Tqap/MXw
 ShDdeJlLbmP9y5sAwySAObIPeqj64oBvdOiEJfH71XeME3lIEG
 wHpV/jMOPrjey2CqBX2HjLpN5rIZDpFs8ZXp51L60JLO5pIG2v
 /aGVsQyqqmoX5hNddJXo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 24 February 2014 12:09:11 David Howells wrote:
> Josh Triplett <josh@joshtriplett.org> wrote:
> 
> > > This means we actually want BUG() to end with __builtin_unreachable()
> > > as in the CONFIG_BUG=y case, and also ensure it actually is
> > > unreachable. As I have shown in [1], the there is a small overhead
> > > of doing this in terms of code size.
> > 
> > I agree that allowing BUG() to become a no-op seems suboptimal, if only
> > because of the resulting warnings and mis-optimizations.  However, I
> > think the overhead could be cut down massively, such that BUG() just
> > compiles down to a one-byte undefined instruction.  (__builtin_trap()
> > might do the right thing here; worth checking.)
> 
> Is it possible to use an inline function with an empty body in this?  Let the
> compiler prune away all the arguments?
> 

I think you are thinking of a different problem. BUG() already takes no
arguments, but we get warnings for code like this:

int f(void)
{
	switch (global) {
	case 0:
		return 0;
	case 1:
		return do_something();
	default:
		BUG();
	}
}

BUG() normally causes a fault and we print helpful messages before killing
the task, and gcc knows we never continue because of the
__builtin_unreachable() annotation.

If BUG() is defined as 'do { } while (0)' in the example above, we get
a warning because the function may end without returning a number.
If we define it to 'do { unreachable(); } while (0)', we don't get a
warning, but we can get undefined behavior in the case we ever get to
the end of the function.

__builtin_trap() would be nice as an architecture independent method,
but I just checked what it does on ARM, and it just calls abort(),
which is probably not what we want in the kernel, especially as long
as the ARM abort() function calls BUG(), and most architectures don't
define it at all.

'do { } while (1)' is probably a reasonably generic way to not return
and should compile into a single instruction on most architectures.
panic() would be another option to do something that won't cause
additional data corruption, but it's a varargs function, so that won't
help you much when you just try to save object code size.

	Arnd
