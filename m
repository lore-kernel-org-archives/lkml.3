Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947049Ab3BHUp4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 15:45:56 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:53653 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946959Ab3BHUpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 15:45:54 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Josh Boyer <jwboyer@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Mel Gorman <mgorman@suse.de>,
        linux-kernel@vger.kernel.org, williams@redhat.com
References: <20130207215742.GB31684@hansolo.jdub.homelinux.org>
	<20130207141502.04625ea0.akpm@linux-foundation.org>
	<20130208003501.GC31684@hansolo.jdub.homelinux.org>
	<20130208181949.GD31684@hansolo.jdub.homelinux.org>
	<87k3qiwomi.fsf@xmission.com>
	<20130208202314.GF31684@hansolo.jdub.homelinux.org>
Date: Fri, 08 Feb 2013 12:45:47 -0800
In-Reply-To: <20130208202314.GF31684@hansolo.jdub.homelinux.org> (Josh Boyer's
	message of "Fri, 8 Feb 2013 15:23:14 -0500")
Message-ID: <87r4kqttz8.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18BlEzCe2x6ICKsUgCqKngh1Iny4OMd2mc=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  2.5 XMGppyBdWords BODY: Gappy or l33t words
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 FVGT_m_MULTI_ODD Contains multiple odd letter combinations
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.1 XMSolicitRefs_0 Weightloss drug
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Josh Boyer <jwboyer@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: Odd ENOMEM being returned in 3.8-rcX
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Josh Boyer <jwboyer@redhat.com> writes:

> < Two emails fly past each other in the night >

Yep.

>> My best guess in some dark corner of mock has untested code to unshare a
>> pid namespace, and that corner started doing something now that
>> unsharing of the pid namespace actually works.
>> 
>> If mock has called unshare(CLONE_NEWPID). And then forked a process and
>> that process exited, and then forked anothe process that second and all
>> subsequent fork calls will fail with -ENOMEM (because init has exited in
>> the pid namespace).  -ENOMEM will be generated because of a failure of
>> alloc_pid.
>> 
>> Looking at that code path a little closer that just about has to be it,
>> because I goofed and the error path drops the lock but not irqs.  The
>> patch below should fix the nasty warning and confirm where the code is
>> failing in copy_process.
>
> OK.  I'll turn the debug option back on and give this patch a try.

Thanks.  Your minimal test case also confirms my hunch. But we should
fix the error path as well.

>> An strace to see which syscalls mock is making and with which flags
>> would be very interesting.  I am almost certain that there is a
>> unshare(CLONE_NEWPID) somewhere in there.  But in a remote corner of
>> possibility it could weird clone flags, or something else.
>
> Oh, I have that but it's a python app with a helper C app and it's a...
> verbose strace.  It's here for one failure:
>
> http://jwboyer.fedorapeople.org/pub/mock-strace
>
> Hopefully the testcase from my other email will help though.  It's much
> simpler.

Yes.  Your other test case confirms my patch you bisected this to is
working correctly.

>> Beyond that I suspect we want to work with the mock folks so they get
>> their code to use a pid namespace working the way they intended.
>
> Right.  CC'd Clark (for real this time).
>
> I'll let you know on the patch.

Cool.  Looking at the strace I can't figure out what mock expected
to happen or how mock was working before this.  As mock is calling
unshare(CLONE_NEWNS|CLONE_NEWUTS|CLONE_NEWIPC|CLONE_NEWPID) all in one
go.

Previous to my patch enabling CLONE_NEWPID that would cause the unshare
to fail.

So it looks mock is taking a buggy untested code path and things are not
working as it expected.

Eric

