Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933378Ab3HNVzz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 17:55:55 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:59128 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933121Ab3HNVzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 17:55:53 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andy Lutomirski <luto@amacapital.net>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "Serge E. Hallyn" <serge@hallyn.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <CAJfpegsxgnSRUW-E5HM3uT5QfGyUtn_v=i4Ppkkkutp34287AA@mail.gmail.com>
	<520BD9E0.8050304@mit.edu> <8761v882wj.fsf@xmission.com>
	<CALCETrWnNfQnOKjfXx8hwsVzPfcoUseuY5JD1X7fRSPXOj61MA@mail.gmail.com>
Date: Wed, 14 Aug 2013 14:54:35 -0700
In-Reply-To: <CALCETrWnNfQnOKjfXx8hwsVzPfcoUseuY5JD1X7fRSPXOj61MA@mail.gmail.com>
	(Andy Lutomirski's message of "Wed, 14 Aug 2013 13:25:34 -0700")
Message-ID: <8761v8os4k.fsf@tw-ebiederman.twitter.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/M8kXQmo1K522Nt8OE68KREXNGsKAf/nw=
X-SA-Exim-Connect-IP: 8.25.197.25
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.2014]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andy Lutomirski <luto@amacapital.net>
X-Spam-Relay-Country: 
Subject: Re: DoS with unprivileged mounts
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> writes:

> On Wed, Aug 14, 2013 at 12:53 PM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>> Andy Lutomirski <luto@amacapital.net> writes:
>>
>>> On 08/14/2013 10:42 AM, Miklos Szeredi wrote:
>>>> There's a simple and effective way to prevent unlink(2) and rename(2)
>>>> from operating on any file or directory by simply mounting something
>>>> on it.  In any mount instance in any namespace.
>>>>
>>>> Was this considered in the unprivileged mount design?
>>>>
>>>> The solution is also theoretically simple: mounts in unpriv namespaces
>>>> are marked "volatile" and are dissolved on an unlink type operation.
>>>
>>> I'd actually prefer the reverse: unprivileged mounts don't prevent
>>> unlink and rename.  If the dentry goes away, then the mount could still
>>> exist, sans underlying file.  (This is already supported on network
>>> filesystems.)
>>
>> Of course we do this in network filesystems by pretending the
>> rename/unlink did not actually happen.  The vfs insists that it be lied
>> to instead of mirroring what actually happened.
>>
>> Again all of this is a question about efficient data structures and not
>> really one of semantics.  Can either semantic be implemented in such a
>> way that it does not slow down the vfs?
>
> Given that vfs_unlink has:
>
> 	if (d_mountpoint(dentry))
> 		error = -EBUSY;
>
> I think it's just a matter of changing / deleting that code.

Deleting the code is completely unacceptable as it generates mounts that
can never be unmounted.

Changing this code is what we were discussing.  My point is that an
efficient replacement is not immediately obvious, and a solution that
degrades the performance of the fast path of the vfs to make this case
work better is not likely to be acceptable.

Eric

