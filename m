Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717AbaK0Kwh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 05:52:37 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33867 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031AbaK0Kwf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 05:52:35 -0500
Date: Thu, 27 Nov 2014 11:52:33 +0100
From: Petr Mladek <pmladek@suse.cz>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Seth Jennings <sjenning@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>, Miroslav Benes <mbenes@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>, live-patching@vger.kernel.org,
        x86@kernel.org, kpatch@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 0/3] Kernel Live Patching
Message-ID: <20141127105233.GA5998@pathway.suse.cz>
References: <1416935709-404-1-git-send-email-sjenning@redhat.com>
 <547596C6.2050303@hitachi.com>
 <alpine.LNX.2.00.1411261014510.23174@pobox.suse.cz>
 <20141126152759.GA29079@treble.hsd1.ky.comcast.net>
 <5476F7AD.3020601@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5476F7AD.3020601@hitachi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2014-11-27 19:06:37, Masami Hiramatsu wrote:
> (2014/11/27 0:27), Josh Poimboeuf wrote:
> > On Wed, Nov 26, 2014 at 10:18:24AM +0100, Jiri Kosina wrote:
> >> On Wed, 26 Nov 2014, Masami Hiramatsu wrote:
> >>
> >>>> Note to Steve:
> >>>> Masami's IPMODIFY patch is heading for -next via your tree.  Once it arrives,
> >>>> I'll rebase and make the change to set IPMODIFY.  Do not pull this for -next
> >>>> yet.  This version (v4) is for review and gathering acks.
> >>>
> >>> BTW, as we discussed IPMODIFY is an exclusive flag. So if we allocate 
> >>> ftrace_ops for each function in each patch, it could be conflict each 
> >>> other.
> >>
> >> Yup, this corresponds to what Petr brought up yesterday. There are cases 
> >> where all solutions (kpatch, kgraft, klp) would allocate multiple 
> >> ftrace_ops for a single function entry (think of patching one function 
> >> multiple times in a row).
> >>
> >> So it's not as easy as just setting the flag.
> >>
> >>> Maybe we need to have another ops hashtable to find such conflict and 
> >>> new handler to handle it.
> >>
> >> If I understand your proposal correctly, that would sound like a hackish 
> >> workaround, trying to basically trick the IPMODIFY flag semantics you just 
> >> implemented :)
> > 
> > I think Masami may be proposing something similar to what we do in
> > kpatch today.  We have a single ftrace_ops and handler which is used for
> > all functions.  The handler accesses a global hash of kpatch_func
> > structs which is indexed by the original function's IP address.
> 
> Hmm, I think both is OK. kpatch method is less memory consuming and
> will have a bigger overhead. However, as Steven talked at Plumbers Conf.,
> he will introduce a direct code modifying interface for ftrace. After
> that is introduced, we don't need to care about performance degradation
> by patching :)

Yup, I would prefer to have ftrace_ops per (original) function entry. I mean
that new patches will reuse the existing ftrace_ops for already
patched functions. They will just create new ftrace_ops from the
not-yet-patched symbols.

Using a single ftrace_ops everywhere would kill the win from
Steven's direct ftrace optimization.

> > It actually works out pretty well because it nicely encapsulates the
> > knowledge about which functions are patched in a single place.  And it
> > makes it easy to track function versions (for incremental patching and
> > rollback).
> > 
> >> What I'd propose instead is to make sure that we always have 
> >> just a ftrace_ops per function entry, and only update the pointers there 
> >> as necessary. Fortunately we can do the switch atomically, by making use 
> >> of ->private.
> > 
> > But how would you update multiple functions atomically, to enforce
> > per-thread consistency?
> 
> At this point, both can do it atomically. We just need an atomic flag
> for applying patches.

By other words, we would need something like the "kgr_immutable" flag from
kGraft. It will make sure that everybody stays with the current code until
all function entries are updated.

Best Regards,
Petr
