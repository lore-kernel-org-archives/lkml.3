Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779AbaAQW6M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 17:58:12 -0500
Received: from relay3.sgi.com ([192.48.152.1]:60722 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753745AbaAQW6J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 17:58:09 -0500
Date: Fri, 17 Jan 2014 16:58:22 -0600
From: Alex Thorlton <athorlton@sgi.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rik van Riel <riel@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Al Viro <viro@zeniv.linux.org.uk>, Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFC PATCHv2 2/2] Change khugepaged to respect MMF_THP_DISABLE
 flag
Message-ID: <20140117225822.GC17626@sgi.com>
References: <1bc8f911363af956b37d8ea415d734f3191f1c78.1389905087.git.athorlton@sgi.com>
 <13c9d1b0213af7cee7afb54de368a0b189e98df8.1389905087.git.athorlton@sgi.com>
 <20140117203444.GA16396@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140117203444.GA16396@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 17, 2014 at 09:34:44PM +0100, Oleg Nesterov wrote:
> On 01/16, Alex Thorlton wrote:
> >
> >  static inline int khugepaged_test_exit(struct mm_struct *mm)
> >  {
> > -	return atomic_read(&mm->mm_users) == 0;
> > +	return atomic_read(&mm->mm_users) == 0 ||
> > +	       (mm->flags & MMF_THP_DISABLE_MASK);
>                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> test_bit(MMF_THP_DISABLE) ?

Probably should just use the bitop here, good call.

> And I am not sure this and another check in transparent_hugepage_enabled
> is actually right...
> 
> I think that MMF_THP_DISABLE_MASK should not disable thp if this
> vma has VM_HUGEPAGE set, iow perhaps madvise() should work even
> after PR_SET_THP_DISABLE?
> 
> IOW, MMF_THP_DISABLE should act as khugepaged_req_madv().

I hadn't thought of this, but maybe that's a good idea.  That way we can
turn off THP in general for an mm, but the places in code that
*specifically* request THP will still get it.  I don't see why that
would be a problem, as long as we go with the assumption that, if
somebody is explicitly requesting THPs, they probably have a good reason
for doing so.

Thanks for the input!

- Alex
