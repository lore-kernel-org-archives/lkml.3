Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250AbaBOXBT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 18:01:19 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:53110 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbaBOXBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 18:01:17 -0500
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
	<877g8xphw9.fsf@xmission.com> <20140215062922.GA22779@moon>
Date: Sat, 15 Feb 2014 15:01:05 -0800
In-Reply-To: <20140215062922.GA22779@moon> (Cyrill Gorcunov's message of "Sat,
	15 Feb 2014 10:29:22 +0400")
Message-ID: <87lhxc9e1a.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19XNYUFnhYoDnpjDkjxRLrM4aasxtGtmfo=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  3.0 KHOP_BIG_TO_CC Sent to 10+ recipients instaed of Bcc or a list
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4963]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *****;Cyrill Gorcunov <gorcunov@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: [CRIU] [PATCH 1/3] prctl: reduce permissions to change boundaries of data, brk and stack
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov <gorcunov@gmail.com> writes:

> On Fri, Feb 14, 2014 at 12:18:46PM -0800, Eric W. Biederman wrote:
>> >> > 
>> >> > Why can't you have the process of interest do:
>> >> > 	ptrace(PTRACE_ATTACHME);
>> >> > 	execve(executable, args, ...);
>> >> >         
>> >> >         /* Have the ptracer inject the recovery/fixup code */
>> >> > 	    /* Fix up the mostly correct process to look like it has been
>> >> >          * executing for a while.
>> >> >          */
>> >
>> > Erik, it seems I don't understand how it will help us to restore
>> > the mm fields mentioned above?
>> 
>> Because exec is how those mm fields are set when you don't use
>> prctl_set_mm.  So execpt for the stack and the brk limits that
>> will simply result in the values being set to what the usually
>> would be set to.
>
> Yes, all these fields are set up by kernel's elf loader but this
> routine is a way more time consuming than a clone call. But gimme
> some time to examine all possible problems we might have with such
> approach and if there a way to solve them.

Sure.

The really useful observation in all of this is that with exec we have
methods where we allow unprivileged setting of these fields already.  So
it is essentially concerns about applictions being stupid (resource
control) and applications being compromised with evil code and the trace
evidence being hidden that we are trying to protect by limiting changes
to these fields.

So if we can come up with a method that doesn't violate those
invariants, and doesn't lead to massive code maintenance we should be
good.  Reusing exec is just the easiest way to get there.

Eric
