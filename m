Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932084Ab3KWDXv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 22:23:51 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:48895 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755992Ab3KWDXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 22:23:49 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, hpa@zytor.com,
        mjg59@srcf.ucam.org, greg@kroah.com
References: <1384969851-7251-1-git-send-email-vgoyal@redhat.com>
	<8761rl73s7.fsf@xmission.com> <20131122015518.GA31921@redhat.com>
	<87txf4y304.fsf@xmission.com> <20131122141945.GE4046@redhat.com>
Date: Fri, 22 Nov 2013 19:23:39 -0800
In-Reply-To: <20131122141945.GE4046@redhat.com> (Vivek Goyal's message of
	"Fri, 22 Nov 2013 09:19:46 -0500")
Message-ID: <87li0fvm10.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+Bh3rcy7oqRcupTxrOjynaG1DFt1wAAak=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0004]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Vivek Goyal <vgoyal@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 0/6] kexec: A new system call to allow in kernel loading
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> On Fri, Nov 22, 2013 at 05:34:03AM -0800, Eric W. Biederman wrote:
>
> [..]
>> > Why ELF case is so interesting. I have not use kexec to boot ELF
>> > images in years and have not seen others using it too. In fact bzImage
>> > seems to be the most common kernel image format for x86, most of the distros
>> > ship and use.
>> 
>> ELF is interesting because it is the minimal file format that does
>> everything you need.   So especially for a proof of concept ELF needs to
>> come first.  There is an extra virtual address field in the ELF segment
>> header but otherwise ELF does not have any unnecessary fields.
>> 
>> ELF is interesting because it is the native kernel file format on all
>> architectures linux supports including x86.
>> 
>> ELF is interesting because producing an ELF image in practice requires
>> a trivial amount of tooling so it is a good general purpose format to
>> support.
>
> Ok. I will have a look at ELF loader too. I was hoping to keep only one
> loader in initial patch. But looks like that's not acceptable.

Thank you.  We really need an ELF loader to see that we have handled the
general case and to see that we have a solution that is portable to
non-x86.

> [..]
>> >> There is also a huge missing piece of this in that your purgatory is not
>> >> checking a hash of the loaded image before jumping too it.  Without that
>> >> this is a huge regression at least for the kexec on panic case.  We
>> >> absolutely need to check that the kernel sitting around in memory has
>> >> not been corrupted before we let it run very far.
>> >
>> > Agreed. This should not be hard. It is just a matter of calcualting
>> > digest of segments. I will store it in kimge and verify digest again
>> > before passing control to control page. Will fix it in next version.
>> 
>> Nak.  The verification needs to happen in purgatory. 
>> 
>> The verification needs to happen in code whose runtime environment is
>> does not depend on random parts of the kernel.  Anything else is a
>> regression in maintainability and reliability.
>> 
>> It is the wrong direction to add any code to what needs to run in the
>> known broken environment of the kernel when a panic happens.
>> 
>> Which means that you almost certainly need to go to the trouble of
>> supporting the complexity needed to support purgatory code written in C.
>> 
>> (For those just tuning in purgatory is our term for the code that runs
>> between the kernels to do those things that can not happen a priori).
>
> In general, I agree with not using kernel parts after crash.
>
> But what protects against that purgatory itself has been scribbled over.
> IOW, how different purgatory memory is as compared to kernel memory where
> digest routines are stored. They have got equal probably of being scribbled
> over and if that's the case one is not better than other?
>
> And if they both got equal probability to getting corrupted, then there does
> not seem to be an advantage in moving digest verification inside
> purgatory.

The primary reason is that maintenance of code in the kernel that is
safe during a crash dump is hard.  That is why we boot a second kernel
after all.  If the code to do the signature verification resides in
machine_kexec on the kexec on panic code path in the kernel that has
called panic it is almost a given that at some point or other someone
will add an option that will add a weird dependency that makes the code
unsafe when the kernel is crashing.  I have seen it happen several times
on the existing kexec on panic code path.  I have seen it on other code
paths like netconsole.  Which can currently on some kernels I have
running cause the kernel go go into an endless printk loop if you call
printk from interrupt context.  So what we really gain by moving the
verification into purgatory is protection from inappropriate code reuse.

So having a completely separate piece of code may be a little harder to
write initially but the code is much simpler and more reliable to
maintain.  Essentially requiring no maintenance effort.  Further getting
to the point where purgatory is written in C makes small changes much
more approachable.

Eric

