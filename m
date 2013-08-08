Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965748Ab3HHNy3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 09:54:29 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:57492 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965666Ab3HHNwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 09:52:42 -0400
Message-ID: <5203A2A4.7030402@gmail.com>
Date: Thu, 08 Aug 2013 15:52:36 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Chen Gang <gang.chen@asianux.com>
CC: Andy Lutomirski <luto@amacapital.net>, Oleg Nesterov <oleg@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>,
        holt@sgi.com, Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] kernel/sys.c: return the current gid when error occurs
References: <5200AD26.8070701@asianux.com> <5200AD67.1030109@asianux.com> <52015ADB.30408@mit.edu> <20130807162147.GA31460@redhat.com> <CALCETrVELXkdccJZQRsm_9mtXrD-8nW_sRW_p-SWNVsXcqX2Cg@mail.gmail.com> <5202F4A3.5070603@asianux.com> <CALCETrUiVT5p5oHEHTavJtdWo3d0BV+Fexurpr-Z9ockwX1SoQ@mail.gmail.com> <5202F8D6.3000607@asianux.com>
In-Reply-To: <5202F8D6.3000607@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/13 03:48, Chen Gang wrote:
> On 08/08/2013 09:35 AM, Andy Lutomirski wrote:
>> On Wed, Aug 7, 2013 at 6:30 PM, Chen Gang <gang.chen@asianux.com> wrote:
>>> On 08/08/2013 12:58 AM, Andy Lutomirski wrote:
>>>> On Wed, Aug 7, 2013 at 9:21 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>>>>> On 08/06, Andy Lutomirski wrote:
>>>>>>
>>>>>> I assume that what the man page means is that the return value is
>>>>>> whatever fsgid was prior to the call.  On error, fsgid isn't changed, so
>>>>>> the return value is still "current".
>>>>>
>>>>> Probably... Still
>>>>>
>>>>>         On success, the previous value of fsuid is returned.
>>>>>         On error, the current value of fsuid is returned.
>>>>>
>>>>> looks confusing. sys_setfsuid() always returns the old value.
>>>>>
>>>>>> (FWIW, this behavior is awful and is probably the cause of a security
>>>>>> bug or three, since success and failure are indistinguishable.
>>>>>
>>>>> At least this all looks strange.
>>>>>
>>>>> I dunno if we can change this old behaviour. I won't be surprized
>>>>> if someone already uses setfsuid(-1) as getfsuid().
>>>>
>>>
>>> Oh, really it is.
>>>
>>> Hmm... as a pair function, we need add getfsuid() too, if we do not add
>>> it, it will make negative effect with setfsuid().
>>>
>>> Since it is a system call, we have to keep compitable.
>>>
>>> So in my opinion, better add getfsuid2()/setfsuid2() instead of current
>>> setfsuid()
>>
>> How about getfsuid() and setfsuid2()?
>>
> 
> Hmm... I have 2 reasons, please check.
> 
> 1st reason: I checked history (just like Kees Cook suggested),
> getfsuid() is mentioned before (you can google to find it), so need use
> getfsuid2() to bypass the history complex.
> 
> And 2nd reason: getfsuid() seems more like the pair of setfsuid(), not
> for setfsuid2().

Time to apply the brakes... *Why* add new system calls here? I don't 
think there is any good reason. Yes, the existing APIs are rubbish,
but, as far as I can tell, they are also obsolete and unneeded.
The fsuid/fsgid mechanism was a bizarre Linuxism whose only purpose
was (as far as I know), to allow for the fact that Linux long ago
applied nonstandard rules when determining when one process could 
send signals to another. Quoting some book on the subject:

    Why does Linux provide the file-system IDs and in what 
    circumstances would we want the effective and file-system 
    IDs to differ? The reasons are primarily historical.
    The file-system IDs first appeared in Linux 1.2. In 
    that kernel version, one process could send a signal to 
    another if the effective user ID of the sender matched
    the real or effective user ID of the target process. 
    This affected certain programs such as the Linux NFS 
    (Network File System) server program, which needed to be
    able to access files as though it had the effective IDs 
    of the corresponding client process. However, if the NFS 
    server changed its effective user ID, it would be 
    vulnerable to signals from unprivileged user processes. 
    To prevent this possibility, the separate file-system user
    and group IDs were devised. By leaving its effective IDs
    unchanged, but changing its file-system IDs, the NFS 
    server could masquerade as another user for the purpose of 
    accessing files without being vulnerable to signals from
    user processes.

    From kernel 2.0 onward, Linux adopted the SUSv3-mandated 
    rules regarding permission for sending signals, and these 
    rules don't involve the effective user ID of the target
    process. Thus, the file-system ID feature is no longer 
    strictly necessary (a process can nowadays achieve the 
    desired results by making judicious use of the system
    calls described later in this chapter to change
    the value of the effective user ID to and from an
    unprivileged value, as required), but it remains for
    compatibility with existing software.

So, I don't think anything needs fixing: there should be no 
new users of these system calls anyway.

Cheers,

Michael


-- 
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface", http://blog.man7.org/

