Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751637AbaEZSL0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 14:11:26 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:45012 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbaEZSLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 14:11:24 -0400
Date: Mon, 26 May 2014 22:11:20 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: Documenting execve() and EAGAIN
Message-ID: <20140526181120.GB11145@cachalot>
References: <537CEC90.7060000@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <537CEC90.7060000@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On Wed, May 21, 2014 at 20:12 +0200, Michael Kerrisk (man-pages) wrote:
> Vasily (and Motohiro),
> 
> Sometime ago, Motohiro raised a documentation bug
> ( https://bugzilla.kernel.org/show_bug.cgi?id=42704 ) which 
> relates to your commit 72fa59970f8698023045ab0713d66f3f4f96945c
> ("move RLIMIT_NPROC check from set_user() to do_execve_common()")
> 
> I have attempted to document this, and I would like to ask you
> (and Motohiro) if you would review the text proposed below for
> the exceve(2) man page.
> 
> Thank you,
> 
> Michael
> 
> 
> ERRORS
>        EAGAIN (since Linux 3.1)
>               Having  changed its real UID using one of the set*uid()
>               calls,  the  caller  was—and  is  now  still—above  its
>               RLIMIT_NPROC  resource limit (see setrlimit(2)).  For a
>               more detailed explanation of this error, see NOTES.
> 
> NOTES
>    execve() and EAGAIN
>        A more detailed explanation of the EAGAIN error that can occur
>        (since Linux 3.1) when calling execve() is as follows.
> 
>        The EAGAIN error can occur when a preceding call to setuid(2),
>        setreuid(2), or setresuid(2) caused the real user  ID  of  the
>        process  to  change,  and  that  change  caused the process to
>        exceed its RLIMIT_NPROC resource limit (i.e.,  the  number  of
>        processes  belonging  to the new real UID exceeds the resource
>        limit).  In Linux 3.0 and earlier, this caused  the  set*uid()
>        call to fail.
> 
>        Since  Linux 3.1, the scenario just described no longer causes
>        the set*uid() call to fail, because it too often led to  secu‐
>        rity  holes because buggy applications didn't check the return
>        status and assumed that—if the caller had root  privileges—the
>        call  would  always succeed.  Instead, the set*uid() calls now
>        successfully change real UID, but the kernel sets an  internal
>        flag,  named  PF_NPROC_EXCEEDED, to note that the RLIMIT_NPROC
>        resource limit has been exceeded.  If the  resource  limit  is
>        still exceeded at the time of a subsequent execve() call, that
>        call fails with the error EAGAIN.  This kernel  logic  ensures
>        that the RLIMIT_NPROC resource limit is still enforced for the
>        common privileged daemon workflow—namely, fork(2)+  set*uid()+
>        execve(2).
> 
>        If  the  resource  limit was not still exceeded at the time of
>        the execve() call (because other processes belonging  to  this
>        real  UID  terminated  between  the  set*uid()  call  and  the
>        execve() call), then the execve() call succeeds and the kernel
>        clears  the  PF_NPROC_EXCEEDED process flag.  The flag is also
>        cleared if a subsequent call to fork(2) by this  process  suc‐
>        ceeds.

Probably explicitly state that NPROC check on execve() is processed only
in case of a previous set*uid() call?  If there was no previous
set*uid() call the semantics of execve() checks are the same as before
(IOW, RLIMIT_NPROC is ignored).

The rest is fine.

Thanks!

-- 
Vasily Kulikov
http://www.openwall.com - bringing security into open computing environments
