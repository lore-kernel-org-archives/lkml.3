Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbaBNTQw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 14:16:52 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:59920 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102AbaBNTQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 14:16:50 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Andrew Vagin <avagin@gmail.com>, Aditya Kali <adityakali@google.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Pavel Emelyanov <xemul@parallels.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org, criu@openvz.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>
References: <1392387209-330-1-git-send-email-avagin@openvz.org>
	<1392387209-330-2-git-send-email-avagin@openvz.org>
	<874n41znl5.fsf@xmission.com> <20140214174314.GA5518@gmail.com>
	<20140214180129.GK13358@moon>
Date: Fri, 14 Feb 2014 11:16:41 -0800
In-Reply-To: <20140214180129.GK13358@moon> (Cyrill Gorcunov's message of "Fri,
	14 Feb 2014 22:01:29 +0400")
Message-ID: <8761ohqzc6.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+ASTaQGDzWEfoyDTgZB01PnffRhbgKGPs=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  3.0 KHOP_BIG_TO_CC Sent to 10+ recipients instaed of Bcc or a list
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.2515]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *****;Cyrill Gorcunov <gorcunov@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: [CRIU] [PATCH 1/3] prctl: reduce permissions to change boundaries of data, brk and stack
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov <gorcunov@gmail.com> writes:

> On Fri, Feb 14, 2014 at 09:43:14PM +0400, Andrew Vagin wrote:
>> > My brain hurts just looking at this patch and how you are justifying it.
>> > 
>> > For the resources you are mucking with below all you have to do is to
>> > verify that you are below the appropriate rlimit at all times and no
>> > CAP_SYS_RESOURCE check is needed.  You only need CAP_SYS_RESOURCE
>> > to exceed your per process limits.
>> > 
>> > All you have to do is to fix the current code to properly enforce the
>> > limits.
>> 
>> I'm afraid what you are suggesting doesn't work.
>> 
>> The first reason is that we can not change both boundaries in one call.
>> But when we are restoring these attributes, we may need to move their
>> too far.
>
> When this code was introduced, there were no user-namespace implementation,
> if I remember correctly, so CAP_SYS_RESOURCE was enough barrier point
> to prevent modifying this values by anyone. Now user-ns brings a limit --
> we need somehow to provide a way to modify these mm fields having no
> CAP_SYS_RESOURCE set. "Verifying rlimit" not an option here because
> we're modifying members one by one (looking back I think this was not
> a good idea to modify the fields in this manner).
>
> Maybe we could improve this api and provide argument as a pointer
> to a structure, which would have all the fields we're going to
> modify, which in turn would allow us to verify that all new values
> are sane and fit rlimits, then we could (probably) deprecate old
> api if noone except c/r camp is using it (I actually can't imagine
> who else might need this api). Then CAP_SYS_RESOURCE requirement
> could be ripped off. Hm? (sure touching api is always "no-no"
> case, but maybe...)

Hmm.  Let me rewind this a little bit.

I want to be very stupid and ask the following.

Why can't you have the process of interest do:
	ptrace(PTRACE_ATTACHME);
	execve(executable, args, ...);
        
        /* Have the ptracer inject the recovery/fixup code */
	/* Fix up the mostly correct process to look like it has been
         * executing for a while.
         */

That should work, set all of the interesting fields, and works as
non-root today.  My gut feel says do that and we can just
deprecate/remove prctl_set_mm.

I am hoping we can move this conversation what makes sense from oh ick
checkpoint/restort does not work with user namespaces.

Eric
