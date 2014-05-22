Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889AbaEVN2Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 09:28:25 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:57621 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304AbaEVN2X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 09:28:23 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <20140522114102.66129305@notabene.brown>
References: <537CEC90.7060000@gmail.com> <20140522114102.66129305@notabene.brown>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Thu, 22 May 2014 15:28:03 +0200
Message-ID: <CAKgNAkjhzO7r8MTb408ePiEKb1qfxq6Dr7K+oMNPmhERpe78WA@mail.gmail.com>
Subject: Re: Documenting execve() and EAGAIN
To: NeilBrown <neilb@suse.de>
Cc: Vasiliy Kulikov <segoon@openwall.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 3:41 AM, NeilBrown <neilb@suse.de> wrote:
> On Wed, 21 May 2014 20:12:32 +0200 "Michael Kerrisk (man-pages)"
> <mtk.manpages@gmail.com> wrote:
>
>> Vasily (and Motohiro),
>>
>> Sometime ago, Motohiro raised a documentation bug
>> ( https://bugzilla.kernel.org/show_bug.cgi?id=42704 ) which
>> relates to your commit 72fa59970f8698023045ab0713d66f3f4f96945c
>> ("move RLIMIT_NPROC check from set_user() to do_execve_common()")
>>
>> I have attempted to document this, and I would like to ask you
>> (and Motohiro) if you would review the text proposed below for
>> the exceve(2) man page.
>>
>> Thank you,
>>
>> Michael
>>
>>
>> ERRORS
>>        EAGAIN (since Linux 3.1)
>>               Having  changed its real UID using one of the set*uid()
>>               calls,  the  caller  was—and  is  now  still—above  its
>>               RLIMIT_NPROC  resource limit (see setrlimit(2)).  For a
>>               more detailed explanation of this error, see NOTES.
>>
>> NOTES
>>    execve() and EAGAIN
>>        A more detailed explanation of the EAGAIN error that can occur
>>        (since Linux 3.1) when calling execve() is as follows.
>>
>>        The EAGAIN error can occur when a preceding call to setuid(2),
>>        setreuid(2), or setresuid(2) caused the real user  ID  of  the
>>        process  to  change,  and  that  change  caused the process to
>>        exceed its RLIMIT_NPROC resource limit (i.e.,  the  number  of
>>        processes  belonging  to the new real UID exceeds the resource
>>        limit).  In Linux 3.0 and earlier, this caused  the  set*uid()
>>        call to fail.
>
> I don't know how detailed/precise you want to be, but this failure was from
> 2.6.0 to 3.0.
> Prior to 2.6, the limit was not imposed on processes that changed their uid.
>
> http://git.kernel.org/cgit/linux/kernel/git/history/history.git/commit/?id=909cc4ae86f3380152a18e2a3c44523893ee11c4
>
> $ git describe --contains 909cc4ae86f3380152a18e2a3c44523893ee11c4
> v2.6.0-test2~85^2~5^2~15
>
> Otherwise the description fits my understanding.

Thanks Neil, I've added the details you mention to the draft.

Cheers,

Michael


>>
>>        Since  Linux 3.1, the scenario just described no longer causes
>>        the set*uid() call to fail, because it too often led to  secu‐
>>        rity  holes because buggy applications didn't check the return
>>        status and assumed that—if the caller had root  privileges—the
>>        call  would  always succeed.  Instead, the set*uid() calls now
>>        successfully change real UID, but the kernel sets an  internal
>>        flag,  named  PF_NPROC_EXCEEDED, to note that the RLIMIT_NPROC
>>        resource limit has been exceeded.  If the  resource  limit  is
>>        still exceeded at the time of a subsequent execve() call, that
>>        call fails with the error EAGAIN.  This kernel  logic  ensures
>>        that the RLIMIT_NPROC resource limit is still enforced for the
>>        common privileged daemon workflow—namely, fork(2)+  set*uid()+
>>        execve(2).
>>
>>        If  the  resource  limit was not still exceeded at the time of
>>        the execve() call (because other processes belonging  to  this
>>        real  UID  terminated  between  the  set*uid()  call  and  the
>>        execve() call), then the execve() call succeeds and the kernel
>>        clears  the  PF_NPROC_EXCEEDED process flag.  The flag is also
>>        cleared if a subsequent call to fork(2) by this  process  suc‐
>>        ceeds.
>>
>



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
