Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958Ab3CAGHj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 01:07:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8821 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758Ab3CAGHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 01:07:37 -0500
Date: Fri, 1 Mar 2013 01:07:32 -0500
From: Dave Jones <davej@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, dhowells@redhat.com,
        "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: commit_creds oops
Message-ID: <20130301060732.GA20195@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, dhowells@redhat.com,
	"Serge E. Hallyn" <serge@hallyn.com>
References: <20130228234351.GA22046@redhat.com>
 <87hakw7ypn.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87hakw7ypn.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 04:25:40PM -0800, Eric W. Biederman wrote:
 
 > > [   89.639850] RIP: 0010:[<ffffffff810784b0>]  [<ffffffff810784b0>] commit_creds+0x250/0x2f0
 > > [   89.658399] Call Trace:
 > > [   89.658822]  [<ffffffff812c7d9b>] key_change_session_keyring+0xfb/0x140
 > > [   89.659845]  [<ffffffff8106c665>] task_work_run+0xa5/0xd0
 > > [   89.660698]  [<ffffffff81002911>] do_notify_resume+0x71/0xb0
 > > [   89.661581]  [<ffffffff816c9a4a>] int_signal+0x12/0x17
 > >
 > > Appears to be..
 > >
 > >                 if ((set_ns == subset_ns->parent)  &&
 > >      850:       48 8b 8a c8 00 00 00    mov    0xc8(%rdx),%rcx
 > >
 > > from the inlined cred_cap_issubset
 > 
 > Interesting.  That line is protected with the check subset_ns !=
 > &init_user_ns so subset_ns->parent must be valid or subset_ns is not
 > a proper user namespace.
 > 
 > Ugh.  I think I see what is going on and it is just silly. 
 > 
 > It looks like by historical accident we have been reading trying to set
 > new->user_ns from new->user_ns.  Which is totally silly as new->user_ns
 > is NULL (as is every other field in new except session_keyring at that
 > point).
 > 
 > It looks like it is safe to sleep in key_change_session_keyring so why
 > we just don't use prepare_creds there like everywhere else is beyond
 > me.
 > 
 > The intent is clearly to copy all of the fields from old to new so what
 > we should be doing is is copying old->user_ns into new->user_ns.
 > 
 > Dave can you verify that this patch fixes the oops?

Looks like it.  Haven't hit the same thing since applying your patch.

I noticed though that get_user_ns bumps a refcount.  Is this what we
want if we're just copying ?

	Dave

