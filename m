Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756984Ab3HGDbW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 23:31:22 -0400
Received: from intranet.asianux.com ([58.214.24.6]:59834 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756937Ab3HGDbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 23:31:20 -0400
X-Spam-Score: -100.8
Message-ID: <5201BF49.4060305@asianux.com>
Date: Wed, 07 Aug 2013 11:30:17 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>, holt@sgi.com,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] kernel/sys.c: return the current gid when error occurs
References: <5200AD26.8070701@asianux.com> <5200AD67.1030109@asianux.com> <52015ADB.30408@mit.edu>
In-Reply-To: <52015ADB.30408@mit.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2013 04:21 AM, Andy Lutomirski wrote:
> On 08/06/2013 01:01 AM, Chen Gang wrote:
>> According to the API definition, when error occurs, need return current
>> fsgid instead of the previous one.
>>
>> The related informations ("man setfsgid"):
>>
>>   RETURN VALUE
>>          On success, the previous value of fsgid is returned.  On error, the current value of fsgid is returned.
>>
>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
>> ---
>>  kernel/sys.c |    6 +++---
>>  1 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/kernel/sys.c b/kernel/sys.c
>> index 771129b..9356dc8 100644
>> --- a/kernel/sys.c
>> +++ b/kernel/sys.c
>> @@ -775,11 +775,11 @@ SYSCALL_DEFINE1(setfsgid, gid_t, gid)
>>  
>>  	kgid = make_kgid(old->user_ns, gid);
>>  	if (!gid_valid(kgid))
>> -		return old_fsgid;
>> +		return gid;
> 
> Huh?  So if 1234567 is not a valid gid, then setfsgid(1234567) is
> supposed to return 1234567?  This makes no sense.
>

Hmm... one explanation is "current value" means the value which will be
set, it may be incorrect, if so, need return with failure (at least, it
is not conflict with the meaning of "current value").

For using:

  Assume the caller's new fsgid is different with the previous one (or the caller need/should not call it).
  If the return value is not equal to the new fsgid, that means the system call succeeds (it is the previous one which may be useful for caller, too).
  If the return value is equal to the new fsgid (the new fsgid may '1234567'), that means the system call fails.

So at least, "man page" description is correct.

 
> I assume that what the man page means is that the return value is
> whatever fsgid was prior to the call.  On error, fsgid isn't changed, so
> the return value is still "current".
> 

Hmm... which 'variable' can be qualified as "current value" ?

I think, at least it should match 3 requirements.

  1. it must be different with "the previous value" (or "current value" is meaningless).
  2. it must be known about by the caller (or caller can not check whether fails or not).
  3. its meaning should not be conflict with "current value" (if "current value" is incorrect, it should be fail).

It seems only the parameter gid which caller inputs is qualified with
the 3 requirements.


> (FWIW, this behavior is awful and is probably the cause of a security
> bug or three, since success and failure are indistinguishable.  But I
> think your patch is wrong.)
> 

Hmm... at least, the original implementation is incorrect, and we need
discussing for this issues.


> --Andy
> 
> 

Thanks.
-- 
Chen Gang
