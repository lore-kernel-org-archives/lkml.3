Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966Ab3FDCxD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 22:53:03 -0400
Received: from smtp106.biz.mail.gq1.yahoo.com ([98.137.12.181]:22731 "HELO
	smtp106.biz.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755384Ab3FDCw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 22:52:59 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: qf9KpfkVM1l4g1HQm_k3ZzQcjJwJduxr1bVDl.D1i5khOnG
 4poBc6bvT6GvxaJVCwuAYxTV8y6zkq8iGQtSHA29aMuDKE5nSVzrTBvEGxkn
 zfGv5ypN0b9h.pAniBhGQhKwRS5h0XoyCDpXfTFJwwf353kW7uF4IUfciAmo
 kuFzi8PBl0s4nrG3.YbRhCOK_buSi7LcgIfODV3OUXAccn80lSGVB7uD5uBB
 aNrtBcY2peWTEdPyhlPmNsuSEWiXmpQQDdshGh37_4Q3cdj24qCYh8YjlfgR
 GuZGbtirY4MpeEFX9XXM_5pzXJHlvS5ife8C21ZasjcENrxMVJDwaOx8T7Qw
 mHrZD2Aj8uZRFgHGM1ob9EZ8BZKRIm8qoY4CNQ3fkyDOtJ2sc5uDuU536Owm
 5uP6jUUYVUWDF93vff8v17XS8.T4jS6wnItjP3QsYpDs3PhNUgoF.chyvMo6
 H4aVSDc.8Qo26Lx3MffLOeUfaFYYjyJDNq3quayysJ.OF9I6U_15Erya9DJI
 VvjIWfsU-
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.103] (casey@24.6.250.25 with plain)
        by smtp106.biz.mail.gq1.yahoo.com with SMTP; 03 Jun 2013 19:52:58 -0700 PDT
Message-ID: <51AD5689.6080706@schaufler-ca.com>
Date: Mon, 03 Jun 2013 19:52:57 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>, sds@tycho.nsa.gov,
        linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov
Subject: Re: [RFC PATCH 2/2] SELinux: cache inode checks inside struct inode
References: <1370285941-18367-1-git-send-email-eparis@redhat.com>  <1370285941-18367-2-git-send-email-eparis@redhat.com>  <alpine.LFD.2.03.1306040628420.25797@pixel.linux-foundation.org> <1370301501.19018.9.camel@localhost>
In-Reply-To: <1370301501.19018.9.camel@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/3/2013 4:18 PM, Eric Paris wrote:
> On Tue, 2013-06-04 at 06:31 +0900, Linus Torvalds wrote:
>>
>> On Mon, 3 Jun 2013, Eric Paris wrote:
>>>  
>>>  #ifdef CONFIG_SECURITY
>>> +     seqcount_t              i_security_seqcount;
>>> +     u32                     i_last_task_sid;
>>> +     u32                     i_last_granting;
>>> +     u32                     i_last_perms;
>>> +     u32                     i_audit_allow;
>>>       void                    *i_security;
>>>  #endif
>> This is much too big. I was really hoping for "another word that the 
>> security layer can use" or similar.
> Not sure how that can work   :-(
>
>> Something this big would be acceptable if it would be a *generic* security 
>> cache, and others could use it too, and would avoid ever actually calling 
>> into any security layer at all (ie we could do the checks entirely at the 
>> VFS layer). Then it would be fine. But for just the fact that SELinux is 
>> too slow? No.
> There is nothing about it that can't be VFS-erized.  The fields are:
>
> readlockless way to get the data
> which task was allowed
> which perms were allowed
> what generation of security policy allowed it
> what perms should be forced to call security hook anyway

You've defined all of these things as u32 (that is, secids).
Secids are an SELinux artifact and do not belong in general
purpose interfaces.

> defining "perms" from a VFS PoV is hard.

Yes, it is. But I think that for this to work we can't
be looking at the perms, we have to be looking at a previous
determination that can be used to accurately predict what the
outcome would be if we did look at the perms. If, for example,
we saved the pid (in a reuse safe way) of the last process to
successfully access the inode you wouldn't need to look at any
perms (unless the configuration changed) for that pid again.

Yeah, yeah, I know that is an oversimplification that would
likely gain precious little advantage.I seriously doubt it would
be worth doing.

> doing any of this with 'stacking' is hard.  Then again, I'm only so so
> on the value of stacking.  I've waffled a few times...

That's another reason why cashing certain attributes isn't a good idea,
but that caching a result might have value.

> I can do it entirely inside selinux, but we are still going to have the
> cache hit you were originally seeing as we dereference isec to get the
> info....
>
>
>
> --
> This message was distributed to subscribers of the selinux mailing list.
> If you no longer wish to subscribe, send mail to majordomo@tycho.nsa.gov with
> the words "unsubscribe selinux" without quotes as the message.
>

