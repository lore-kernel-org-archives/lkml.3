Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564AbaBNUS4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 15:18:56 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:39778 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbaBNUSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 15:18:55 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Pavel Emelyanov <xemul@parallels.com>, Andrew Vagin <avagin@gmail.com>,
        Aditya Kali <adityakali@google.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        criu@openvz.org, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>
References: <1392387209-330-1-git-send-email-avagin@openvz.org>
	<1392387209-330-2-git-send-email-avagin@openvz.org>
	<874n41znl5.fsf@xmission.com> <20140214174314.GA5518@gmail.com>
	<20140214180129.GK13358@moon> <8761ohqzc6.fsf@xmission.com>
	<52FE72C1.9090100@parallels.com> <20140214200622.GN13358@moon>
Date: Fri, 14 Feb 2014 12:18:46 -0800
In-Reply-To: <20140214200622.GN13358@moon> (Cyrill Gorcunov's message of "Sat,
	15 Feb 2014 00:06:22 +0400")
Message-ID: <877g8xphw9.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+zYeH75MswHUYfytDJVZPrXtnLLICa9fQ=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 KHOP_BIG_TO_CC Sent to 10+ recipients instaed of Bcc or a list
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4832]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Cyrill Gorcunov <gorcunov@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: [CRIU] [PATCH 1/3] prctl: reduce permissions to change boundaries of data, brk and stack
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov <gorcunov@gmail.com> writes:

> On Fri, Feb 14, 2014 at 11:47:13PM +0400, Pavel Emelyanov wrote:
>> >> Maybe we could improve this api and provide argument as a pointer
>> >> to a structure, which would have all the fields we're going to
>> >> modify, which in turn would allow us to verify that all new values
>> >> are sane and fit rlimits, then we could (probably) deprecate old
>> >> api if noone except c/r camp is using it (I actually can't imagine
>> >> who else might need this api). Then CAP_SYS_RESOURCE requirement
>> >> could be ripped off. Hm? (sure touching api is always "no-no"
>> >> case, but maybe...)
>> > 
>> > Hmm.  Let me rewind this a little bit.
>> > 
>> > I want to be very stupid and ask the following.
>> > 
>> > Why can't you have the process of interest do:
>> > 	ptrace(PTRACE_ATTACHME);
>> > 	execve(executable, args, ...);
>> >         
>> >         /* Have the ptracer inject the recovery/fixup code */
>> > 	    /* Fix up the mostly correct process to look like it has been
>> >          * executing for a while.
>> >          */
>
> Erik, it seems I don't understand how it will help us to restore
> the mm fields mentioned above?

Because exec is how those mm fields are set when you don't use
prctl_set_mm.  So execpt for the stack and the brk limits that
will simply result in the values being set to what the usually
would be set to.

>> Let's imagine we do that.
>> 
>> This means, that the whole memory contents should be restored _after_
>> the execve() call, since the execve() flushes old mappings. In
>> that case we lose the ability to preserve any shared memory regions
>> between any two processes. This "shared" can be either regular
>> MAP_SHARED mappings or MAP_ANONYMOUS but still not COW-ed ones.
>> 
>> > That should work, set all of the interesting fields, and works as
>> > non-root today.  My gut feel says do that and we can just
>> > deprecate/remove prctl_set_mm.
>> > 
>> > I am hoping we can move this conversation what makes sense from oh ick
>> > checkpoint/restort does not work with user namespaces.
>
> I fear you've got a wrong impression that we're "ick'ing" about user-ns ;)
> Actually it's "must have" feature for containers thus we would _really_
> love to be able to c/r them.

What I meant is that the analysis of how to deal with prctl_set_mm seems
to be knee jerk shallow analysis based upon the fact that things are not
working, and not asking the question what really makes sense here? and
Why are people concerned with these changes and these values?

Eric

