Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757613Ab3HHBbR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 21:31:17 -0400
Received: from intranet.asianux.com ([58.214.24.6]:25308 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757525Ab3HHBbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 21:31:16 -0400
X-Spam-Score: -100.8
Message-ID: <5202F4A3.5070603@asianux.com>
Date: Thu, 08 Aug 2013 09:30:11 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Oleg Nesterov <oleg@redhat.com>, Michael Kerrisk <mtk.manpages@gmail.com>,
        Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>,
        holt@sgi.com, Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] kernel/sys.c: return the current gid when error occurs
References: <5200AD26.8070701@asianux.com> <5200AD67.1030109@asianux.com> <52015ADB.30408@mit.edu> <20130807162147.GA31460@redhat.com> <CALCETrVELXkdccJZQRsm_9mtXrD-8nW_sRW_p-SWNVsXcqX2Cg@mail.gmail.com>
In-Reply-To: <CALCETrVELXkdccJZQRsm_9mtXrD-8nW_sRW_p-SWNVsXcqX2Cg@mail.gmail.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2013 12:58 AM, Andy Lutomirski wrote:
> On Wed, Aug 7, 2013 at 9:21 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>> On 08/06, Andy Lutomirski wrote:
>>>
>>> I assume that what the man page means is that the return value is
>>> whatever fsgid was prior to the call.  On error, fsgid isn't changed, so
>>> the return value is still "current".
>>
>> Probably... Still
>>
>>         On success, the previous value of fsuid is returned.
>>         On error, the current value of fsuid is returned.
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
> 

Oh, really it is.

Hmm... as a pair function, we need add getfsuid() too, if we do not add
it, it will make negative effect with setfsuid().

Since it is a system call, we have to keep compitable.

So in my opinion, better add getfsuid2()/setfsuid2() instead of current
setfsuid()

  for getfsuid2() can just reference to getuid() definition.
  for setfsuid2() can just reference to setuid() definition.
    (which can return error code when failure occurs).

If possible, I will/should sent the related patches for it.

> I suspect that changing this without introducing security or other
> bugs is impossible.  If someone wanted to add new_setfsuid that
> returned an error when it failed, that would be a different story.
> (I'm not going to do that myself.)
> 
>>
>> And perhaps the man page should be changed. Add Michael.
> 
> Agreed.  The text is a bit odd.
> 

I agree that the text is odd, since it is an system call API, we have
to change it to match our current kernel implementation which is:

  "for system call, whether succeed or not, it always return the previous value, the caller can not know whether succeed or not directly"
  "if the caller need know about success or not, the demo like below"
  "	setfsuid(new);"
  "	if (setfsuid(-1) != new)"
  "		/* report failure */" 

And better to give an additional comment:

  "currently, new system call getfsuid2()/setfsuid2() are supplied, setfsuid() is obseleted"

>>
>> Oleg.
>>
> 
> 
> 

Thanks.
-- 
Chen Gang
