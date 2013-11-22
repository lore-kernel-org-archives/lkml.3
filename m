Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755758Ab3KVNeP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 08:34:15 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:42112 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034Ab3KVNeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 08:34:13 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, hpa@zytor.com,
        mjg59@srcf.ucam.org, greg@kroah.com
References: <1384969851-7251-1-git-send-email-vgoyal@redhat.com>
	<8761rl73s7.fsf@xmission.com> <20131122015518.GA31921@redhat.com>
Date: Fri, 22 Nov 2013 05:34:03 -0800
In-Reply-To: <20131122015518.GA31921@redhat.com> (Vivek Goyal's message of
	"Thu, 21 Nov 2013 20:55:18 -0500")
Message-ID: <87txf4y304.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+yyPlb4LBEiFULuCJ8v/z7aodE96AS70o=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0038]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Vivek Goyal <vgoyal@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 0/6] kexec: A new system call to allow in kernel loading
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> On Thu, Nov 21, 2013 at 03:07:04PM -0800, Eric W. Biederman wrote:
>
> [..]
>> 
>> Before you are done we need an ELF loader.  bzImage really is very
>> uninteresting.  To the point I am not at all convinced that an in kernel
>> loader should support it.
>
> Hi Eric,
>
> Why ELF case is so interesting. I have not use kexec to boot ELF
> images in years and have not seen others using it too. In fact bzImage
> seems to be the most common kernel image format for x86, most of the distros
> ship and use.

ELF is interesting because it is the minimal file format that does
everything you need.   So especially for a proof of concept ELF needs to
come first.  There is an extra virtual address field in the ELF segment
header but otherwise ELF does not have any unnecessary fields.

ELF is interesting because it is the native kernel file format on all
architectures linux supports including x86.

ELF is interesting because producing an ELF image in practice requires
a trivial amount of tooling so it is a good general purpose format to
support.

> So first I did the loader for the common use case. There is no reason 
> that one can't write another loader for ELF images. It just bloats
> the code. Hence I thought that other image loaders can follow slowly. I am
> not sure why do you say that bzImage is uninteresting. 

If you boot anything that isn't a linux kernel bzImage on x86 bzImage is
not the solution you are using.  Furthermore because bzImage is a bunch
of hacks thrown together bzImage keeps evolving in weird and strange
ways.  The complexity of supporting bzImage only grows through the
years.

At the end of the day we will probably need to support bzImage in some
form (possibly just going so far as in userspace extracting the embedded
ELF image) as there are support benefits of only having one blob you
sling around.

But let's first start with the sane general case before worring about x86
legacy weirdness.

For a long term stable ABI to support booting things other than the
linux kernel bzImage is not my first choice.

>> There is also a huge missing piece of this in that your purgatory is not
>> checking a hash of the loaded image before jumping too it.  Without that
>> this is a huge regression at least for the kexec on panic case.  We
>> absolutely need to check that the kernel sitting around in memory has
>> not been corrupted before we let it run very far.
>
> Agreed. This should not be hard. It is just a matter of calcualting
> digest of segments. I will store it in kimge and verify digest again
> before passing control to control page. Will fix it in next version.

Nak.  The verification needs to happen in purgatory. 

The verification needs to happen in code whose runtime environment is
does not depend on random parts of the kernel.  Anything else is a
regression in maintainability and reliability.

It is the wrong direction to add any code to what needs to run in the
known broken environment of the kernel when a panic happens.

Which means that you almost certainly need to go to the trouble of
supporting the complexity needed to support purgatory code written in C.

(For those just tuning in purgatory is our term for the code that runs
between the kernels to do those things that can not happen a priori).

Eric
