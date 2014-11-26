Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956AbaKZJST (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 04:18:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33846 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879AbaKZJSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 04:18:16 -0500
Date: Wed, 26 Nov 2014 10:18:24 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
cc: Seth Jennings <sjenning@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Vojtech Pavlik <vojtech@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Petr Mladek <pmladek@suse.cz>, Miroslav Benes <mbenes@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>, live-patching@vger.kernel.org,
        x86@kernel.org, kpatch@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 0/3] Kernel Live Patching
In-Reply-To: <547596C6.2050303@hitachi.com>
Message-ID: <alpine.LNX.2.00.1411261014510.23174@pobox.suse.cz>
References: <1416935709-404-1-git-send-email-sjenning@redhat.com> <547596C6.2050303@hitachi.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Nov 2014, Masami Hiramatsu wrote:

> > Note to Steve:
> > Masami's IPMODIFY patch is heading for -next via your tree.  Once it arrives,
> > I'll rebase and make the change to set IPMODIFY.  Do not pull this for -next
> > yet.  This version (v4) is for review and gathering acks.
> 
> BTW, as we discussed IPMODIFY is an exclusive flag. So if we allocate 
> ftrace_ops for each function in each patch, it could be conflict each 
> other.

Yup, this corresponds to what Petr brought up yesterday. There are cases 
where all solutions (kpatch, kgraft, klp) would allocate multiple 
ftrace_ops for a single function entry (think of patching one function 
multiple times in a row).

So it's not as easy as just setting the flag.

> Maybe we need to have another ops hashtable to find such conflict and 
> new handler to handle it.

If I understand your proposal correctly, that would sound like a hackish 
workaround, trying to basically trick the IPMODIFY flag semantics you just 
implemented :)

What I'd propose instead is to make sure that we always have 
just a ftrace_ops per function entry, and only update the pointers there 
as necessary. Fortunately we can do the switch atomically, by making use 
of ->private.

-- 
Jiri Kosina
SUSE Labs
