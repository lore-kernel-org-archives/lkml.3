Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090AbaGaClr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 22:41:47 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:40112 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755871AbaGaClo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 22:41:44 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Andy Lutomirski <luto@amacapital.net>, Paolo Bonzini <pbonzini@redhat.com>,
        linux-crypto@vger.kernel.org,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        James Morris <james.l.morris@oracle.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux API <linux-api@vger.kernel.org>, Julien Tinnes <jln@google.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Moore <paul@paul-moore.com>, David Drysdale <drysdale@google.com>,
        Kees Cook <keescook@chromium.org>,
        Meredydd Luff <meredydd@senatehouse.org>,
        Christoph Hellwig <hch@infradead.org>
References: <CALCETrWGvBfrX1W5XaFgJZhKHLf+oac9YrwPR3ppK=deQtu5hA@mail.gmail.com>
	<20140727210617.GY6725@thunk.org>
	<CALCETrXfzOZEC3mOKkm3_GvitvkEu4kAa3LowRv-fjHnzrQnBg@mail.gmail.com>
	<87oawa740c.fsf@x220.int.ebiederm.org>
	<20140730153713.736881f0@alan.etchedpixels.co.uk>
	<87r412g04a.fsf@x220.int.ebiederm.org>
	<20140730222903.4c83a652@alan.etchedpixels.co.uk>
Date: Wed, 30 Jul 2014 19:37:47 -0700
In-Reply-To: <20140730222903.4c83a652@alan.etchedpixels.co.uk> (One Thousand
	Gnomes's message of "Wed, 30 Jul 2014 22:29:03 +0100")
Message-ID: <87wqaudzic.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/xUXEUFR45StKVrbohYfMTlY2B6keJ4Ss=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
X-Spam-Relay-Country: 
Subject: Re: General flags to turn things off (getrandom, pid lookup, etc)
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk> writes:

> On Wed, 30 Jul 2014 11:41:41 -0700
> ebiederm@xmission.com (Eric W. Biederman) wrote:
>
>> One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk> writes:
>> 
>> >> Andy you seem to be arguing here for two system calls.
>> >> get_urandom() and get_random().
>> >> 
>> >> Where get_urandom only blocks if there is not enough starting entropy,
>> >> and get_random(GRND_RANDOM) blocks if there is currently not enough
>> >> entropy.
>> >> 
>> >> That would allow -ENOSYS to be the right return value and it would
>> >> simply things for everyone.
>> >
>> > So you replace the "no file handle" special case with the "unsupported or
>> > disabled syscall" special case, which is even harder to test.
>> >
>> > Interfaces have failure modes. People who can't deal with that shouldn't
>> > be writing code that does anything important in languages which don't
>> > handle it for them.
>> 
>> Perhaps I misread the earlier conversation but it what I have read of
>> this discussion people want to disable some of get_random() modes with
>> seccomp.  Today get_random does not have any failure codes define except
>> -ENOSYS.
>> 
>> get_random(0) succeeding and get_random(GRND_RANDOM) returning -ENOSYS
>> has every chance of causing applications to legitimately assume the
>> get_random system call is not available in any mode.
>
> Or more likely it'll be used like this
>
> 	get_random(foo);		/* always works */
>
>
> Now the existing failure mode is is
>
> 	open(...)
> 	/* forget the check */
> 	read()
> 	/* forget the check */
>
> and triggered by evil local attacks on file handles. The "improved"
> behaviour is unchecked -ENOSYS returns which are likely to occur
> systemically when users run stuff on old kernels, in vm's with it off etc.
>
> So you've swapped the odd evil user attack on a single target for the
> likelyhood of mass generation of flawed keys with no error reporting.
>
> In fact you could do a better job of the whole mess in libc rather than
> the kernel, because in libc you'd write it like this
>
>          if (open(.. ) < 0)
> 		kill(getpid(), 9);
> 	 if (read(...) < expected)
> 		kill(getpid(), 9);
> 	 close(fd);
>
> and 
> a) on an older library you'd get a good failure (unable to execute the
> binary)
> b) on a newer system you'd get "do or die" behaviour and can improve its
> robustness as desired

I have said enough about the silliness of disabling this syscall with
seccomp or related infrastructure.

The aspect I like about get_random() is that it will silence the
requests from people to enable binary sysctl support in the kernel.
Just so they can get random numbers when /dev/random and /dev/urandom
are absent in their chroots.

sysctl(2) is finally legitmately going fading away.

Eric

