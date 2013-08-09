Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758285Ab3HIBAh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 21:00:37 -0400
Received: from intranet.asianux.com ([58.214.24.6]:9866 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758250Ab3HIBAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:00:36 -0400
X-Spam-Score: -100.8
Message-ID: <52043EF4.6070809@asianux.com>
Date: Fri, 09 Aug 2013 08:59:32 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
CC: Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@amacapital.net>,
        Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>,
        holt@sgi.com, Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] kernel/sys.c: return the current gid when error occurs
References: <5200AD26.8070701@asianux.com> <5200AD67.1030109@asianux.com> <52015ADB.30408@mit.edu> <20130807162147.GA31460@redhat.com> <52039F11.4010806@gmail.com>
In-Reply-To: <52039F11.4010806@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2013 09:37 PM, Michael Kerrisk (man-pages) wrote:
> On 08/07/13 18:21, Oleg Nesterov wrote:
>> On 08/06, Andy Lutomirski wrote:
>>>
>>> I assume that what the man page means is that the return value is
>>> whatever fsgid was prior to the call.  On error, fsgid isn't changed, so
>>> the return value is still "current".
>>
>> Probably... Still
>>
>> 	On success, the previous value of fsuid is returned.
>> 	On error, the current value of fsuid is returned.
>>
>> looks confusing. sys_setfsuid() always returns the old value.
>>
>>> (FWIW, this behavior is awful and is probably the cause of a security
>>> bug or three, since success and failure are indistinguishable.
>>
>> At least this all looks strange.
>>
>> I dunno if we can change this old behaviour. I won't be surprized
>> if someone already uses setfsuid(-1) as getfsuid().
>>
>> And perhaps the man page should be changed. Add Michael.
> 
> Thanks, Oleg. I've applied the following patch to setfsuid.2
> (and a similar patch to setfsgid.2).
> 
> Cheers,
> 
> Michael
> 
> --- a/man2/setfsuid.2
> +++ b/man2/setfsuid.2
> @@ -67,12 +67,8 @@ matches either the real user ID, effective user ID, saved set-user-ID, or
>  the current value of
>  .IR fsuid .
>  .SH RETURN VALUE
> -On success, the previous value of
> -.I fsuid
> -is returned.
> -On error, the current value of
> -.I fsuid
> -is returned.
> +On both success and failure,
> +this call returns the previous filesystem user ID of the caller.
>  .SH VERSIONS
>  This system call is present in Linux since version 1.2.
>  .\" This system call is present since Linux 1.1.44
> @@ -102,7 +98,16 @@ The glibc
>  .BR setfsuid ()
>  wrapper function transparently deals with the variation across kernel versions.
>  .SH BUGS
> -No error messages of any kind are returned to the caller.
> +No error indications of any kind are returned to the caller,
> +and the fact that both successful and unsuccessful calls return
> +the same value makes it impossible to directly determine
> +whether the call succeeded or failed.
> +Instead, the caller must resort to looking at the return value
> +from a further call such as
> +.IR setfsuid(\-1)
> +(which will always fail), in order to determine if a preceding call to
> +.BR setfsuid ()
> +changed the filesystem user ID.
>  At the very
>  least,
>  .B EPERM
> 

Is it suitable to mention this API is obsoleted and unneeded in man page
?  ;-)


Thanks.
-- 
Chen Gang
