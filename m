Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755615AbaAVUB5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 15:01:57 -0500
Received: from relay3.sgi.com ([192.48.152.1]:51970 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753391AbaAVUB4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 15:01:56 -0500
Date: Wed, 22 Jan 2014 14:02:14 -0600
From: Alex Thorlton <athorlton@sgi.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rik van Riel <riel@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Al Viro <viro@zeniv.linux.org.uk>, Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH 0/2] mm->def_flags cleanups (Was: Change khugepaged to
 respect MMF_THP_DISABLE flag)
Message-ID: <20140122200214.GV18196@sgi.com>
References: <1bc8f911363af956b37d8ea415d734f3191f1c78.1389905087.git.athorlton@sgi.com>
 <13c9d1b0213af7cee7afb54de368a0b189e98df8.1389905087.git.athorlton@sgi.com>
 <20140118234957.GB10970@node.dhcp.inet.fi>
 <20140120195812.GD18196@sgi.com>
 <20140120201525.GA31416@redhat.com>
 <20140120204108.GE18196@sgi.com>
 <20140122174553.GA29710@redhat.com>
 <20140122184042.GQ18196@sgi.com>
 <20140122192514.GA1779@redhat.com>
 <20140122194327.GA2826@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140122194327.GA2826@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 08:43:27PM +0100, Oleg Nesterov wrote:
> On 01/22, Oleg Nesterov wrote:
> >
> > On 01/22, Alex Thorlton wrote:
> > > > +	case PR_SET_THP_DISABLE:
> > > > +	case PR_GET_THP_DISABLE:
> > > > +		down_write(&me->mm->mmap_sem);
> > > > +		if (option == PR_SET_THP_DISABLE) {
> > > > +			if (arg2)
> > > > +				me->mm->def_flags |= VM_NOHUGEPAGE;
> > > > +			else
> > > > +				me->mm->def_flags &= ~VM_NOHUGEPAGE;
> > > > +		} else {
> > > > +			error = !!(me->mm->flags && VM_NOHUGEPAGE);
> > >
> > > Should be:
> > >
> > > error = !!(me->mm->def_flags && VM_NOHUGEPAGE);
> >
> > No, we need to return 1 if this bit is set ;)
> 
> Damn, you are right of course, we need "&". I didn't notice "&&"
> in the patch I sent and misunderstood your "&&" above ;) Sorry.

Actually, I didn't catch that either!  Looking at it, though, we
definitely do want bitwise AND here, not logical.

However, what I was originally referring to is:  Shouldn't we be
checking mm->***def_flags*** for the VM_NOHUGEPAGE bit, as opposed
to mm->flags?  i.e. I think we want this:

error = !!(me->mm->def_flags & VM_NOHUGEPAGE);

As opposed to:

error = !!(me->mm->flags && VM_NOHUGEPAGE);

The way I understand it, the VM_NOHUGEPAGE bit is defined for
mm->vma->flags, but not for mm->flags.  Am I wrong here?

- Alex
