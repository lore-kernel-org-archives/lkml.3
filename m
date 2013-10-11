Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121Ab3JKWP4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 18:15:56 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:34381 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755819Ab3JKWPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 18:15:54 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Daniel Kiper <daniel.kiper@oracle.com>
Cc: hbabu@us.ibm.com, hpa@linux.intel.com, keescook@chromium.org,
        vgoyal@redhat.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, david.vrabel@citrix.com,
        jbeulich@suse.com, keir@xen.org, xen-devel@lists.xen.org
References: <20131011092837.GZ3626@debian70-amd64.local.net-space.pl>
	<877gdkce6s.fsf@tw-ebiederman.twitter.com>
	<20131011110455.GA3626@debian70-amd64.local.net-space.pl>
Date: Fri, 11 Oct 2013 15:15:38 -0700
In-Reply-To: <20131011110455.GA3626@debian70-amd64.local.net-space.pl> (Daniel
	Kiper's message of "Fri, 11 Oct 2013 13:04:55 +0200")
Message-ID: <877gdjbgj9.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+FYQ8im5koZW13mS1aoXgRBQODH77ca9E=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Daniel Kiper <daniel.kiper@oracle.com>
X-Spam-Relay-Country: 
Subject: Re: kexec: Clearing registers just before jumping into purgatory
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Kiper <daniel.kiper@oracle.com> writes:

> On Fri, Oct 11, 2013 at 03:08:43AM -0700, ebiederm@xmission.com wrote:
>> Daniel Kiper <daniel.kiper@oracle.com> writes:
>>
>> > Hi,
>> >
>> > Could you explain why do you clear all registers just before jumping
>> > into purgatory (please look into arch/x86/kernel/relocate_kernel_64.S
>> > for more details)? There is no any single word about that. I do not
>> > count comment which states what is going on. purgatory on entry does
>> > not assume any value in registers. Are you going to use that feature
>> > for something in the future (e.g. to differentiate between callers
>> > and/or Linux versions if it be needed)?
>>
>> It has been a long time now, but as I recall the reason was to just
>> have things well defined and to make certain that we were not
>> accidentially exporting anything except the stack pointer for
>> applications to depend upon.
>>
>> 0/NULL is a good choice because if you are expecting pointer for some
>> strange reason interesting things happen.
>
> This covers more or less with my expectations.
>
>> purgatory is definitely not the only target and the C version of
>> purgatory was actually written well after kexec came into existence.
>>
>> Is there any particular reason why you are asking?
>
> Yes, we (Xen guys) are discussing is it worth to do it or not in our
> kexec implementation. I think that yes because we used Linux Kernel
> kexec implementation as a base for our work and we use kexec-tools too.
> So we should be aligined to what currently is in the wild. David do not
> agree with me. You could find more here:
>
> http://lists.xen.org/archives/html/xen-devel/2013-10/msg00710.html
> http://lists.xen.org/archives/html/xen-devel/2013-10/msg00296.html
>
> What is your opinion in that case?

I can see documenting the registers other than the stack pointer
as undefined.  (A stack pointer is needed to implement PIC code).

For the implementation I recommend setting these registers to known
values.  The issue is that your implementation will not change much and
if you don't set the registers to known values someone may develop a
dependency on what you happen to have those registers set to.

It is easier to force a fixed value into a register that isn't hard to
maintain into your registers than to discover when you make a change
that there is some odd client that depends on some value that just
happened to be in your register, and that your necessary change is now
made 10x harder by a client you can't afford to break that depends on a
bug in the previous implementation.

So yes I strongly recommend setting the registers to a 0 in this case.

>> Something different is done, and all of the registers should be
>> preserved from the when the return to Linux.
>
> I expected that but purgatory does nothing with them.
> However, maybe I missed something.

Yes.  I think I am mostly in the document that you can't depend on them,
but keep them fixed to prevent problematic dependencies creeping in
because something just works...

Eric
