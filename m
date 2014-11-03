Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720AbaKCRXF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 12:23:05 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:56823 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436AbaKCRXB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 12:23:01 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <CALCETrWmivJCvAAZPQo9Jf5gDiSbpWKesjZWfqEQRXPOBSPY9g@mail.gmail.com>
References: <1415015305-15494-1-git-send-email-drysdale@google.com> <1415015305-15494-2-git-send-email-drysdale@google.com> <20141103152036.GA7996@ZenIV.linux.org.uk> <CALCETrWmivJCvAAZPQo9Jf5gDiSbpWKesjZWfqEQRXPOBSPY9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8BIT
From: "Eric W.Biederman" <ebiederm@xmission.com>
Date: Mon, 03 Nov 2014 09:22:38 -0800
To: Andy Lutomirski <luto@amacapital.net>, Al Viro <viro@zeniv.linux.org.uk>
CC: David Drysdale <drysdale@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Meredydd Luff <meredydd@senatehouse.org>,
        Will Drewry <wad@chromium.org>,
        Jorge Lucangeli Obes <jorgelo@google.com>,
        Ricky Zhou <rickyz@google.com>, Lee Campbell <leecam@google.com>,
        Julien Tinnes <jln@google.com>, Mike Depinet <mdepinet@google.com>,
        James Morris <james.l.morris@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Paul Moore <paul@paul-moore.com>,
        Christoph Hellwig <hch@infradead.org>,
        Linux API <linux-api@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Message-ID: <d0973f4d-e8a4-4c5c-8bd1-1b1cb1f080b5@email.android.com>
X-XM-AID: U2FsdGVkX184Bm+s3Rg6rfeMb2dYCln2gQgBZhRzHyI=
X-SA-Exim-Connect-IP: 208.54.64.164
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.3 TooManyTo_001 Multiple "To" Header Recipients 2x (uncommon)
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5018]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Andy Lutomirski <luto@amacapital.net>,Al Viro
	<viro@zeniv.linux.org.uk>
X-Spam-Relay-Country: 
X-Spam-Timing: total 1501 ms - load_scoreonly_sql: 0.06 (0.0%),
	signal_user_changed: 5 (0.3%), parse: 1.36 (0.1%), extract_message_metadata:
	24 (1.6%), get_uri_detail_list: 3 (0.2%), tests_pri_-1000: 23 (1.5%),
	tests_pri_-950: 2 (0.1%), tests_pri_-900: 1.66 (0.1%), tests_pri_-400: 65
	(4.3%), check_bayes: 63 (4.2%), tests_pri_0: 1351 (90.0%), tests_pri_500: 23
	(1.6%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH 1/3] fs: add O_BENEATH flag to openat(2)
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On November 3, 2014 7:42:58 AM PST, Andy Lutomirski <luto@amacapital.net> wrote:
>On Mon, Nov 3, 2014 at 7:20 AM, Al Viro <viro@zeniv.linux.org.uk>
>wrote:
>> On Mon, Nov 03, 2014 at 11:48:23AM +0000, David Drysdale wrote:
>>> Add a new O_BENEATH flag for openat(2) which restricts the
>>> provided path, rejecting (with -EACCES) paths that are not beneath
>>> the provided dfd.  In particular, reject:
>>>  - paths that contain .. components
>>>  - paths that begin with /
>>>  - symlinks that have paths as above.
>>
>> Yecch...  The degree of usefulness aside (and I'm not convinced that
>it
>> is non-zero),
>
>This is extremely useful in conjunction with seccomp.
>
>> WTF pass one bit out of nameidata->flags in a separate argument?
>> Through the mutual recursion, no less...  And then you are not even
>attempting
>> to detect symlinks that are not followed by interpretation of _any_
>pathname.
>
>How many symlinks like that are there?  Is there anything except
>nd_jump_link users?  All of those are in /proc.  Arguably O_BENEATH
>should prevent traversal of all of those links.

Not commenting on the sanity of this one way or another, and I haven't read the patch.  There is an absolutely trivial implementation of this.

After the path is resolved, walk backwards along d_parent and the mount tree, and see if you come to the file or directory dfd refers to.

That can handle magic proc symlinks, and does not need to disallow .. or / explicitly so it should be much simpler code.

My gut says that if Al says blech when looking at your code it is too complex to give you a security guarantee.

Eric
