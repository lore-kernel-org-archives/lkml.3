Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367AbaE2C1d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 22:27:33 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:60249 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbaE2C1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 22:27:32 -0400
MIME-Version: 1.0
In-Reply-To: <1401330205.13555.29.camel@localhost>
References: <cover.1401327752.git.luto@amacapital.net> <833bd6cb411ad1d4e293629c6c34c4abca27a840.1401327752.git.luto@amacapital.net>
 <1401330205.13555.29.camel@localhost>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 28 May 2014 19:27:11 -0700
Message-ID: <CALCETrUcd44WqSOve4BS_fUfXPgk3KEfWrBv=5D1wi+YDnRVdA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] auditsc: audit_krule mask accesses need bounds checking
To: Eric Paris <eparis@redhat.com>
Cc: Philipp Kern <pkern@google.com>, "H. Peter Anvin" <hpa@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. J. Lu" <hjl.tools@gmail.com>,
        "security@kernel.org" <security@kernel.org>,
        Greg Kroah-Hartman <greg@kroah.com>, linux-audit@redhat.com,
        stable@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 7:23 PM, Eric Paris <eparis@redhat.com> wrote:
> On Wed, 2014-05-28 at 18:44 -0700, Andy Lutomirski wrote:
>> Fixes an easy DoS and possible information disclosure.
>>
>> This does nothing about the broken state of x32 auditing.
>>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
>> ---
>>  kernel/auditsc.c | 27 ++++++++++++++++++---------
>>  1 file changed, 18 insertions(+), 9 deletions(-)
>>
>> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
>> index f251a5e..7ccd9db 100644
>> --- a/kernel/auditsc.c
>> +++ b/kernel/auditsc.c
>> @@ -728,6 +728,22 @@ static enum audit_state audit_filter_task(struct task_struct *tsk, char **key)
>>       return AUDIT_BUILD_CONTEXT;
>>  }
>>
>> +static bool audit_in_mask(const struct audit_krule *rule, unsigned long val)
>> +{
>> +     int word, bit;
>> +
>> +     if (val > 0xffffffff)
>> +             return false;
>
> Why is this necessary?

To avoid an integer overflow.  Admittedly, this particular overflow
won't cause a crash, but it will cause incorrect results.

>
>> +
>> +     word = AUDIT_WORD(val);
>> +     if (word >= AUDIT_BITMASK_SIZE)
>> +             return false;
>
> Since this covers it and it extensible...
>
>> +
>> +     bit = AUDIT_BIT(val);
>> +
>> +     return rule->mask[word] & bit;
>
> Returning an int as a bool creates worse code than just returning the
> int.  (although in this case if the compiler chooses to inline it might
> be smart enough not to actually convert this int to a bool and make
> worse assembly...)   I'd suggest the function here return an int.  bools
> usually make the assembly worse...

I'm ambivalent.  The right assembly would use flags on x86, not an int
or a bool, and I don't know what the compiler will do.

--Andy
