Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751402AbaEWWYz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 18:24:55 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:38655 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbaEWWYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 18:24:53 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: Seth Forshee <seth.forshee@canonical.com>, Jens Axboe <axboe@kernel.dk>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        LXC development mailing-list 
	<lxc-devel@lists.linuxcontainers.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20140515221551.GB13306@kroah.com>
	<20140516014959.GD22591@ubuntumail> <20140516043532.GA14149@kroah.com>
	<20140516140607.GA23902@ubuntu-hedt> <20140516185749.GA5131@kroah.com>
	<1400268515.2221.91.camel@dabdike.int.hansenpartnership.com>
	<20140516201841.GC23902@ubuntu-hedt>
	<87mwedfh7c.fsf@x220.int.ebiederm.org>
	<20140520142103.GC137220@ubuntu-hedt>
	<87y4xubxmm.fsf@x220.int.ebiederm.org>
	<20140521223319.GF29211@ubuntumail>
Date: Fri, 23 May 2014 15:23:50 -0700
In-Reply-To: <20140521223319.GF29211@ubuntumail> (Serge Hallyn's message of
	"Wed, 21 May 2014 22:33:19 +0000")
Message-ID: <87ioow9ls9.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18mkExGTFykgol1cm8qCI9cfVCimjhEVOI=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.3972]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Serge Hallyn <serge.hallyn@ubuntu.com>
X-Spam-Relay-Country: 
Subject: Re: [lxc-devel] [RFC PATCH 00/11] Add support for devtmpfs in user namespaces
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge Hallyn <serge.hallyn@ubuntu.com> writes:

> Quoting Eric W. Biederman (ebiederm@xmission.com):
>> 
>> 
>> >> Ultimately the technical challenge is how do we create a block device
>> >> that is safe for a user who does not have any capabilities to use, and
>> >> what can we do with that block device to make it useful.
>> >
>> > Yes, and I'd like to get started solving those challenges. But I also
>> > don't think we can address these two points (support partition blkdevs,
>> > help prevent more priveleged users from using a namespace's loop
>> > devices) sufficiently while having an implementation completely
>> > contained within the loop driver as Greg is requesting.
>> 
>> My key take away from the conversation is that we should reduce the
>> scope of what is being done to something that makes sense and the
>> propblems are immediately visible.
>> 
>> Part of me would like to suggest that fuse and it's ability to imitate
>> device nodes might be a more appropriate solution, to something that
>
> Do you have a link to more info on this?  Some googling got me to an
> interesting but old thread on CUSE, but nothing specifically about fuse
> doing this.

CUSE is probably what I was thinking of.  It is all part of the fuse
code base in the kernel.  And now that I am reminded it is called CUSE
I go Duh that is a character device...

Fuse and everything it can do is definitely the filesystem I would like
to see most have the audits to be enabled in user namespace.  Fuse
was built to be sufficiently paranoid to allow this and so it should not
take a lot to take fuse the rest of the way.

>> just needs block device access and nothing else.
>> 
>> For purposes of discussion let's call it unprivloopfs.  That can reuse
>> code from the loop device or not as appropriate.  Not supporting
>> paritioning I think is a very reasonable first step until it is shown
>> that we can make good use of partitioning support, and there are not
>> better ways of solving the problem.
>> 
>> I expect the most productive thing to talk about is what is your
>> immediate goal?  Mounting a filesystem?  Building an iso?
>
> For me it would be taking an iso and making some changes to it to
> localize it (i.e. take an install iso and add preseed file).
>
> Now of course in the end there is no reason why we can't do all of
> this with a new suite of libraries which simply uses read/write with
> knowledge of the fs layouts to parse and modify the backing files.
> My concern there is that duplicating all of the fs code seems unlikely
> to improve the soundness of either implementation.  Perhaps we can
> autogenerate this from the kernel source?  Does fuse already do
> something like that?

I am not aware of that.  But I have not worked extensively with fuse.

I do agree that finding a way to perform a read-only mount of an ISO by
an unprivielged user is a very interesting use case.  Given it's
interchange medium nature isofs should be as hardened as human possible,
and that is likely easier with a read-only filesystem.  And at less than
4000 lines of code isofs is auditable.

So as a target for unprivileged mounts of a block device isofs looks
like a good place to start.

Eric
