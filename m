Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751658Ab3HSX7R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 19:59:17 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:50223 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333Ab3HSX7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 19:59:16 -0400
MIME-Version: 1.0
In-Reply-To: <20130816190558.GB3592@boyd>
References: <1374800575-32320-1-git-send-email-tyhicks@canonical.com>
	<20130816190558.GB3592@boyd>
Date: Mon, 19 Aug 2013 16:59:15 -0700
X-Google-Sender-Auth: SFT0QKnPbvHX_hI01VtOOWDNFqk
Message-ID: <CAGXu5jJRn_nT-vQNMeXEB7cBjYfciDf51id-XvoDhOju3EUQ0w@mail.gmail.com>
Subject: Re: [PATCH] audit: printk USER_AVC messages when audit isn't enabled
From: Kees Cook <keescook@chromium.org>
To: Tyler Hicks <tyhicks@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        linux-audit@redhat.com, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 16, 2013 at 12:05 PM, Tyler Hicks <tyhicks@canonical.com> wrote:
> On 2013-07-25 18:02:55, Tyler Hicks wrote:
>> When the audit=1 kernel parameter is absent and auditd is not running,
>> AUDIT_USER_AVC messages are being silently discarded.
>>
>> AUDIT_USER_AVC messages should be sent to userspace using printk(), as
>> mentioned in the commit message of
>> 4a4cd633b575609b741a1de7837223a2d9e1c34c ("AUDIT: Optimise the
>> audit-disabled case for discarding user messages").
>>
>> When audit_enabled is 0, audit_receive_msg() discards all user messages
>> except for AUDIT_USER_AVC messages. However, audit_log_common_recv_msg()
>> refuses to allocate an audit_buffer if audit_enabled is 0. The fix is to
>> special case AUDIT_USER_AVC messages in both functions.
>>
>> Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
>> Cc: Al Viro <viro@zeniv.linux.org.uk>
>> Cc: Eric Paris <eparis@redhat.com>
>> Cc: linux-audit@redhat.com
>> ---
>
> Hello Al and Eric - I wanted to bring this patch back to your attention
> so it doesn't get forgotten. This is a fairly nasty bug in distros that
> leave auditd as optional but still build packages against libaudit.

I haven't seen a lot of movement in the audit tree lately, but Andrew
has helped push other fixes like this in the past. This fix seems
entirely reasonable to me. :) Andrew, can you pick this up?

Acked-by: Kees Cook <keescook@chromium.org>

>
> Thanks!
>
> Tyler
>
>>
>> It looks like commit 50397bd1e471391d27f64efad9271459c913de87 ("[AUDIT] clean
>> up audit_receive_msg()") introduced this bug, so I think that this patch should
>> also get the tag:
>>
>>   Cc: <stable@kernel.org> # v2.6.25+

Yeah, this seems like a good idea too.

Thanks,

-Kees

>>
>> Al and Eric, I'll leave that up to you two.
>>
>>
>> Here's my test matrix showing where messages end up as a result of a call to
>> libaudit's audit_log_user_avc_message():
>>
>>               |       unpatched       patched
>> ----------------+--------------------------------
>> w/o audit=1 & |       *dropped*       syslog
>> w/o auditd    |
>>               |
>> w/ audit=1 &  |       syslog          syslog
>> w/o auditd    |
>>               |
>> w/o audit=1 & |       audit.log       audit.log
>> w/ auditd     |
>>               |
>> w/ audit=1 &  |       audit.log       audit.log
>> w/ auditd     |
>>
>> Thanks!
>>
>>  kernel/audit.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/kernel/audit.c b/kernel/audit.c
>> index 91e53d0..f4f2773 100644
>> --- a/kernel/audit.c
>> +++ b/kernel/audit.c
>> @@ -613,7 +613,7 @@ static int audit_log_common_recv_msg(struct audit_buffer **ab, u16 msg_type)
>>       int rc = 0;
>>       uid_t uid = from_kuid(&init_user_ns, current_uid());
>>
>> -     if (!audit_enabled) {
>> +     if (!audit_enabled && msg_type != AUDIT_USER_AVC) {
>>               *ab = NULL;
>>               return rc;
>>       }
>> --
>> 1.8.3.2
>>
>> --
>> Linux-audit mailing list
>> Linux-audit@redhat.com
>> https://www.redhat.com/mailman/listinfo/linux-audit
>
> --
> Linux-audit mailing list
> Linux-audit@redhat.com
> https://www.redhat.com/mailman/listinfo/linux-audit



-- 
Kees Cook
Chrome OS Security
