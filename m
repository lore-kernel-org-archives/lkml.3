Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751601Ab3CAHDm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 02:03:42 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:53740 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab3CAHDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 02:03:40 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, dhowells@redhat.com,
        "Serge E. Hallyn" <serge@hallyn.com>
References: <20130228234351.GA22046@redhat.com> <87hakw7ypn.fsf@xmission.com>
	<20130301060732.GA20195@redhat.com>
Date: Thu, 28 Feb 2013 23:03:33 -0800
In-Reply-To: <20130301060732.GA20195@redhat.com> (Dave Jones's message of
	"Fri, 1 Mar 2013 01:07:32 -0500")
Message-ID: <87vc9b61q2.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX193aiG+gS5yIGhHDoVS7PtcXfZw5uzyBLY=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0001]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.1 XMSolicitRefs_0 Weightloss drug
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Dave Jones <davej@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: commit_creds oops
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones <davej@redhat.com> writes:

> On Thu, Feb 28, 2013 at 04:25:40PM -0800, Eric W. Biederman wrote:
>  
>  > > [   89.639850] RIP: 0010:[<ffffffff810784b0>]  [<ffffffff810784b0>] commit_creds+0x250/0x2f0
>  > > [   89.658399] Call Trace:
>  > > [   89.658822]  [<ffffffff812c7d9b>] key_change_session_keyring+0xfb/0x140
>  > > [   89.659845]  [<ffffffff8106c665>] task_work_run+0xa5/0xd0
>  > > [   89.660698]  [<ffffffff81002911>] do_notify_resume+0x71/0xb0
>  > > [   89.661581]  [<ffffffff816c9a4a>] int_signal+0x12/0x17
>  > >
>  > > Appears to be..
>  > >
>  > >                 if ((set_ns == subset_ns->parent)  &&
>  > >      850:       48 8b 8a c8 00 00 00    mov    0xc8(%rdx),%rcx
>  > >
>  > > from the inlined cred_cap_issubset
>  > 
>  > Interesting.  That line is protected with the check subset_ns !=
>  > &init_user_ns so subset_ns->parent must be valid or subset_ns is not
>  > a proper user namespace.
>  > 
>  > Ugh.  I think I see what is going on and it is just silly. 
>  > 
>  > It looks like by historical accident we have been reading trying to set
>  > new->user_ns from new->user_ns.  Which is totally silly as new->user_ns
>  > is NULL (as is every other field in new except session_keyring at that
>  > point).
>  > 
>  > It looks like it is safe to sleep in key_change_session_keyring so why
>  > we just don't use prepare_creds there like everywhere else is beyond
>  > me.
>  > 
>  > The intent is clearly to copy all of the fields from old to new so what
>  > we should be doing is is copying old->user_ns into new->user_ns.
>  > 
>  > Dave can you verify that this patch fixes the oops?
>
> Looks like it.  Haven't hit the same thing since applying your patch.
>
> I noticed though that get_user_ns bumps a refcount.  Is this what we
> want if we're just copying ?

Yes.  commit_creds(new) winds up finding old on the current process
and calling put_cred(old).

put_cred when the count drops to zero winds up calling put_cred_rcu
which calls put_user_ns(old->user_ns);

For the same reason we need an extra count on the user namespace new
so that when it eventually is put and put_user_ns(new->user_ns) is
called we don't have a negative count.

Which is a long of way of saying yes we are adding another reference and
we need to increase the reference count.

Eric
