Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933004Ab3DYUVr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 16:21:47 -0400
Received: from nm12-vm0.access.bullet.mail.mud.yahoo.com ([66.94.236.11]:24624
	"EHLO nm12-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932507Ab3DYUVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 16:21:46 -0400
X-Yahoo-Newman-Id: 36760.26135.bm@smtp105.biz.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: IhvlWx4VM1mfXuxEGYWCn9hzYzB9embxIfjc9wBIkTT9AV1
 RBJSrixG4b8rd6hPCrQDvhwMYAotXdJmlMSNkCgdAQYQ1ULDRm8upUVyxMlu
 3.h8bJDxfM2vAkpeSQocOrP_FSdLXBVRzLbYyQQNoQOCHneEP2SCLfsDi6cN
 GT5qEq1zSWt2R9M2kUG3CL62AhT.5LxlKzdS4zqnInRZT4Su9UZmnaZKcdUF
 6DRfWUJnchE1PPmxAkrK_EUWRLHXvBhtiJK.vf3MRoUh7jF_PgaiR5VvG4e3
 YPdpUUgP7WBSWvEu_ZVBf.kjuSqTPJhqOeJHrNF1iWqFBGcoP_pcWkKcIL8j
 PAnsfkO8gOgEbjXcOj_okRqbvdIjndr0EzY7hz0OOzZSZCslhlLc2Mi6IBaI
 W1fmHMkMr8MwoGkSxvDHIqvd3xo.5VPdYk.hgaqfV.6q7sJf0a4aPG4ydcw7
 ueQ--
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.103] (casey@24.6.250.25 with plain)
        by smtp105.biz.mail.bf1.yahoo.com with SMTP; 25 Apr 2013 13:21:44 -0700 PDT
Message-ID: <5179905E.4090207@schaufler-ca.com>
Date: Thu, 25 Apr 2013 13:21:50 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Paul Moore <paul@paul-moore.com>
CC: John Johansen <john.johansen@canonical.com>,
        LSM <linux-security-module@vger.kernel.org>,
        LKLM <linux-kernel@vger.kernel.org>, SE Linux <selinux@tycho.nsa.gov>,
        James Morris <jmorris@namei.org>, Eric Paris <eparis@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Kees Cook <keescook@chromium.org>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH v13 0/9] LSM: Multiple concurrent LSMs
References: <5176ABB7.5080300@schaufler-ca.com> <47138397.PP25Tg7m1s@sifl> <51797153.7050308@schaufler-ca.com> <5010864.rEs2oKk1kF@sifl>
In-Reply-To: <5010864.rEs2oKk1kF@sifl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/25/2013 12:14 PM, Paul Moore wrote:
> On Thursday, April 25, 2013 11:09:23 AM Casey Schaufler wrote:
>> On 4/25/2013 8:01 AM, Paul Moore wrote:
>>> On Wednesday, April 24, 2013 05:43:08 PM Casey Schaufler wrote:
>>>> On 4/24/2013 4:00 PM, John Johansen wrote:
>>>>> On 04/24/2013 02:15 PM, Paul Moore wrote:
>>>>>> On Wednesday, April 24, 2013 01:22:20 PM Casey Schaufler wrote:
>>> ...
>>>
>>>>>>> An interesting aside that may be relevant is that the error
>>>>>>> condition behavior makes it advisable to have the LSM you care
>>>>>>> about most go last. If the networking components were strictly
>>>>>>> FCFS you might have to chose an ordering you might not want for
>>>>>>> other reasons.
>>>>>> Well, maybe not ... I think.  If we take a FCFS approach to the network
>>>>>> controls then only one LSM is really ever going to throw an error on
>>>>>> the
>>>>>> network hooks, yes?
>>>> You set up the order you want to get the networking handled
>>>> correctly and you could get filesystem hooks in the wrong order.
>>>> Not that that really ought to be a problem, but there are wonky
>>>> admin tools out there.
>>> I don't quite follow; can you be a bit more explicit about getting the
>>> filesystem hooks in the wrong order?
>> Let's assume that there's a case for the stat() system call that
>> would get EPERM from SELinux and EACCES from Smack. A carefully
>> crafted admin tool might take different actions based on the return
>> code. If Smack ahead of SELinux in the list the tool will respond
>> one way, whereas if SELinux is ahead it will behave the other way.
>>
>> If this tool came with Fedora it will likely expect the SELinux
>> error code. Thus, it will be somewhat important that Smack precede
>> SELinux in the LSM ordering. That will grant Smack the NetLabel
>> component. If you want SELinux to use NetLabel you'll have to
>> explicitly configure that.
>>
>> It's probably not going to be an issue that often. Making the
>> ordering implications clear to those who may be affected by them
>> is probably the best choice and biggest challenge. It would be
>> nice to keep them to a minimum. I fear some future LSM author
>> getting clever with error codes and demanding the ultimate
>> position in all cases.
> I guess this begs the question, why does the stacking take the return value 
> from the last LSM and not the first?  I'm sure there was a design decision 
> made here, I'm just curious about the reasons why.

The hook loop is trivially simpler if you return the last error than
if you return the first error:

	if (thisrc)
		rc = thisrc;

vs

	if (thisrc && !rc)
		rc = thisrc;

If I had decided to do shortcutting (return on first failure) it
would be a different story.

> To me, and maybe I'm the odd one out here,

I don't know that you're the only odd one here. :)

> but I would think that the first 
> LSM in the stacking order should get precedence;

My desire and intent is that to the extent possible there should
be no "principle" LSM. The choice of last error is purely driven
by the fact that it's the easiest thing to do.

> this is why I'm pushing for a 
> FCFS for the network controls.  If it turns out that the stacking patches give 
> preference for the last LSM in the stacking order (I think this will always 
> seem backwards to me) then we should probably give the networking controls to 
> the last LSM.

I actually think that FCFS for networking services and last error code
hits closest to the sweet spot. "security=yama,smack,selinux" would give
NetLabel to Smack and xfrm and secmark to SELinux. It would also give
SELinux error returns in cases where there are multiple reasons for
denial. Since SELinux has a more sophisticated runtime environment than
Smack this is likely to make Fedora (for example) happier.


