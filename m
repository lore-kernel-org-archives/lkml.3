Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758700Ab3DYAnN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 20:43:13 -0400
Received: from nm19-vm0.access.bullet.mail.mud.yahoo.com ([66.94.236.25]:27494
	"EHLO nm19-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758614Ab3DYAnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 20:43:09 -0400
X-Yahoo-Newman-Id: 170319.74658.bm@smtp103.biz.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: a3NfgUgVM1mcq3d6PrKALmFdVvQBL3ZOu2DZslPG_ineTYq
 lN90wkt9WutrhF8renN41msQ5iEKdu17Vt_kJB6mmPT4XP4XL_Qkri6RzVsf
 mS_s4sheHS0NZBwTVgidMrLhBlDwKwv5hYEm.I2AScCffYHVSStNjqOhe.V1
 JZ1UwoWlHfVY0MaeuY66PpyYXuRjxJOkOLItOODrroAqjPQLRUKQvhhB0YPY
 oXwxhbDDqDgyOonj9sFLw4I118CcI.iWU9n1bAPLbOEJ12igqmwXPnS46GsR
 XcxNZSlxMOp3YonEUjYzQLAYBorotU2FiCwPWpL_W2Ca0BSdydWZtnb2imL7
 fbQkWTS5bK8WBnBDnUFV9eykK.RiPF9lwJ4XS3ja2JwpXZCwONX2RMKHDYjm
 7l5mun52NYs5xgvfLGYvGgsv1ED9YRdwV1vz5qzSFR0qki31JmBderMPqwiN
 NC8OLy2fkiRDRdZI8kLz8a_XpGeUY50run7qId2gyt4Uxq6GV.zRLGzB2l9Y
 CoX6aKd0-
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.103] (casey@24.6.250.25 with plain)
        by smtp103.biz.mail.bf1.yahoo.com with SMTP; 24 Apr 2013 17:43:07 -0700 PDT
Message-ID: <51787C1C.1040301@schaufler-ca.com>
Date: Wed, 24 Apr 2013 17:43:08 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: John Johansen <john.johansen@canonical.com>
CC: Paul Moore <paul@paul-moore.com>,
        LSM <linux-security-module@vger.kernel.org>,
        LKLM <linux-kernel@vger.kernel.org>, SE Linux <selinux@tycho.nsa.gov>,
        James Morris <jmorris@namei.org>, Eric Paris <eparis@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Kees Cook <keescook@chromium.org>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH v13 0/9] LSM: Multiple concurrent LSMs
References: <5176ABB7.5080300@schaufler-ca.com> <3554062.6nBMExN24s@sifl> <51783EFC.8050607@schaufler-ca.com> <3235150.vl4U7U54yV@sifl> <517863F8.7050606@canonical.com>
In-Reply-To: <517863F8.7050606@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/24/2013 4:00 PM, John Johansen wrote:
> On 04/24/2013 02:15 PM, Paul Moore wrote:
>> On Wednesday, April 24, 2013 01:22:20 PM Casey Schaufler wrote:
>>> On 4/24/2013 11:57 AM, Paul Moore wrote:
>>>> I know we had a good discussion about this a while back and I just wanted
>>>> to hear from you about this current patchset; how does the labeled
>>>> networking LSM assignment work?  Is it first-come-first-served based on
>>>> the 'security=' setting?
>>> It's explicitly set in security/Kconfig. The problem with
>>> first-come-first-serve is that the LSMs don't actually register
>>> in the order specified, either at build time or boot time.
>>> Further, until the init phase is complete, you don't know which
>>> LSMs are actually going to register. That, and I promised Tetsuo
>>> I wouldn't go out of my way to prevent late module loading in
>>> the future.
>>>
>>> I could do order checking on module registration and take
>>> the networking component away from an LSM that registered
>>> earlier, but with a larger order number I suppose.
>> Hmmm.  How difficult would it be to enforce the order during LSM registration?  
>> As discussed previously, I'm not a big fan of assigning the network controls 
>> at compile time when the LSMs can be toggled at boot time.
>>
>> The real solution is to just get the netdev folks to accept a security blob in 
>> the sk_buff so we can fix this (and many other problems) once and for all.  I 
>> still haven't given up on this effort but I think it would be silly to hold up 
>> the stacking effort for the sk_buff security blob.

Fighting with hardcore networking people isn't my
idea of fun either. Waiting for them to approve of
a security facility has never been a winning strategy.

>>> The default configuration gives xfrm and secmark to SELinux
>>> and NetLabel to Smack. If Smack is not included NetLabel goes
>>> to SELinux. When LSMs using any of these facilities are added
>>> in the future we'll have to negotiate the defaults.
>> The defaults are always going to be wrong for someone.
>>
>>> An interesting aside that may be relevant is that the error
>>> condition behavior makes it advisable to have the LSM you care
>>> about most go last. If the networking components were strictly
>>> FCFS you might have to chose an ordering you might not want for
>>> other reasons.
>> Well, maybe not ... I think.  If we take a FCFS approach to the network 
>> controls then only one LSM is really ever going to throw an error on the 
>> network hooks, yes?

You set up the order you want to get the networking handled
correctly and you could get filesystem hooks in the wrong order.
Not that that really ought to be a problem, but there are wonky
admin tools out there.

>>> It would be possible to have a boot time specification for
>>> the networking components if you think it's important. I do
>>> worry about making it excessively complicated. I'd be much more
>>> concerned if more LSMs used the networking components.
>> I think the "excessively complicated" boat has already sailed :)

Fair enough.

>> I'm still in favor of assigning the network hooks to the LSM at boot based on 
>> the "security=" configuration.
>>
> yeah dealing with selection at boot time is going to be needed
> at some point, whether its now or later ...

I'll have a go at it then. What that would mean is that:

	security=smack,selinux

gives Smack NetLabel and SELinux xfrm and secmark while

	security=selinux,smack

gives SELinux all three. I would still like it to be possible to
explicitly configure the allocation at build time.


> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

