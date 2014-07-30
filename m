Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755731AbaG3Spm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 14:45:42 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:33835 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501AbaG3Spi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 14:45:38 -0400
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
Date: Wed, 30 Jul 2014 11:41:41 -0700
In-Reply-To: <20140730153713.736881f0@alan.etchedpixels.co.uk> (One Thousand
	Gnomes's message of "Wed, 30 Jul 2014 15:37:12 +0100")
Message-ID: <87r412g04a.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/VOJzD106o0FktWAsh+hMF62Sk2V7/JHY=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4998]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
X-Spam-Relay-Country: 
Subject: Re: General flags to turn things off (getrandom, pid lookup, etc)
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk> writes:

>> Andy you seem to be arguing here for two system calls.
>> get_urandom() and get_random().
>> 
>> Where get_urandom only blocks if there is not enough starting entropy,
>> and get_random(GRND_RANDOM) blocks if there is currently not enough
>> entropy.
>> 
>> That would allow -ENOSYS to be the right return value and it would
>> simply things for everyone.
>
> So you replace the "no file handle" special case with the "unsupported or
> disabled syscall" special case, which is even harder to test.
>
> Interfaces have failure modes. People who can't deal with that shouldn't
> be writing code that does anything important in languages which don't
> handle it for them.

Perhaps I misread the earlier conversation but it what I have read of
this discussion people want to disable some of get_random() modes with
seccomp.  Today get_random does not have any failure codes define except
-ENOSYS.

get_random(0) succeeding and get_random(GRND_RANDOM) returning -ENOSYS
has every chance of causing applications to legitimately assume the
get_random system call is not available in any mode.

So the code either needs a defined error code for bad flags (-EINVAL) or
we need to split the syscall in two.  Now that I think about it having
the seccomp filter return -EINVAL if it doesn't like the parameter is
better that splitting a syscall.  Presumably that is what
get_random(UNSUPPORTED_FLAG) returns.

Eric
