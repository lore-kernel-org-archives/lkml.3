Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554Ab3KZMXs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 07:23:48 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:34386 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755495Ab3KZMXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 07:23:46 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org, hpa@zytor.com,
        Peter Jones <pjones@redhat.com>
References: <1384969851-7251-1-git-send-email-vgoyal@redhat.com>
	<1384969851-7251-5-git-send-email-vgoyal@redhat.com>
	<20131121190350.GC17070@kroah.com>
	<20131121190620.GA25951@srcf.ucam.org>
	<20131121191305.GK16208@redhat.com>
	<20131121191907.GA26366@srcf.ucam.org>
	<20131122185706.GK4046@redhat.com> <87vbzju6ql.fsf@xmission.com>
	<20131125163920.GC23094@redhat.com>
Date: Tue, 26 Nov 2013 04:23:36 -0800
In-Reply-To: <20131125163920.GC23094@redhat.com> (Vivek Goyal's message of
	"Mon, 25 Nov 2013 11:39:21 -0500")
Message-ID: <87fvqj2vxz.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/WA76g037sUYgeaK1zwBFkB/IKkIjMQU4=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1264]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Vivek Goyal <vgoyal@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 4/6] kexec: A new system call, kexec_file_load, for in kernel kexec
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> On Fri, Nov 22, 2013 at 07:39:14PM -0800, Eric W. Biederman wrote:
>
> [..]
>> > Hmm..., I am running out of ideas here. This is what I understand.
>> >
>> > - If I sign the bzImage (using PKCS1.5 signature), and later it is signed
>> >   with authenticode format signatures, then PKCS1.5 signatures will not be
>> >   valid as PE/COFF signing will do some modification to PE/COFF header in
>> >   bzImage. And another problem is that then I don't have a way to find
>> >   PKCS1.5 signature.
>> >
>> > - If bzImage is first signed with authenticode format signature and then
>> >   signed using PKCS1.5 signature, then  authenticode format signature
>> >   will become invalid as it will also hash the data appened at the end
>> >   of file.
>> >
>> > So looks like both signatures can't co-exist on same file. That means
>> > one signature has to be detached.
>> >
>> > I am beginning to think that create a kernel option which allows to choose
>> > between attached and detached signatures. Extend kexec syscall to allow
>> > a parameter to pass in detached signatures. If detached signatures are
>> > not passed, then look for signatures at the end of file. That way, those
>> > who are signing kernels using platform specific format (authenticode) in 
>> > this case, they can generate detached signature while others can just
>> > use attached signatures.
>> >
>> > Any thoughts on how this should be handled?
>> 
>> Inside of a modern bzImage there is an embedded ELF image.  How about in
>> userspace we just strip out the embedded ELF image and write that to a
>> file.  Then we can use the same signature checking scheme as we do for
>> kernel modules.  And you only have to support one file format.
>
> I think there is a problem with that. And that we lose the additional
> metadata info present in bzImage which is important.
>
> For example, knowing how much memory kernel will consume before it
> sets up its own GDT and page tables (init_size) is very important. That
> gives image loader lot of flexibility in figuring out where to place rest
> of the components safely (initrd, GDT, page tables, ELF header segment, 
> backup region etc).

The init_size should be reflected in the .bss of the ELF segments.  If
not it is a bug when generating the kernel ELF headers and should be
fixed.

For use by kexec I don't see any issues with just signing the embedded
ELF image.

Eric
