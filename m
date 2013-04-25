Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933209Ab3DYSJW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 14:09:22 -0400
Received: from nm25.access.bullet.mail.mud.yahoo.com ([66.94.237.90]:30493
	"EHLO nm25.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933194Ab3DYSJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 14:09:20 -0400
X-Yahoo-Newman-Id: 186064.25178.bm@smtp109.biz.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: pouCGMoVM1mAOEyV0eVnhouA_vFwRhn__.WseIZveSu_NmI
 WSqBobY04_D1tESntQ_vqAZAteCZKnjQ2ypvkuNjmT4c2ZFVGH856nZuXp5B
 7tQIdrUZ.bFKPFwVXXIbN.UNY8OmeBemY1sC_c.iPxHnTKvyHyuVDNsLXNAO
 NfNFr0P2dOF83redZn5sZjcWiWqE3W9.v67Q.ioY21Tzu0lQmvx0hie1aVOO
 Vusv6kB059zi1B30Kd3TxTlTQNRUsMOl_2c0QT4kMa_rdKFXS9G_pvmzyNwM
 6yt2vaxrNRrcgf0R_Ki2FTMuRLXt5n986iVvrdmXoIykc5AbHoCb3SBEpfw0
 gQmo_aUsWasS4A3MaVBLwiztfJovW07_EpeUldWsxic.0PLulsqFAJkDYQwZ
 4nqj9bjHprOz7gNdDwFg272Z2OC25XmWVlunJRP6Uw3TJCCv7d5FAPNqf5SI
 JD_MjM3zmEWJTnb26zyg.H_x3DIgpgDHvgEo5gTUr6CUfvPAjLZSW1u2P36w
 DtS2eSKtdDGC8YgWKud_KEu79
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.103] (casey@24.6.250.25 with plain)
        by smtp109.biz.mail.bf1.yahoo.com with SMTP; 25 Apr 2013 18:09:18 +0000 UTC
Message-ID: <51797153.7050308@schaufler-ca.com>
Date: Thu, 25 Apr 2013 11:09:23 -0700
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
References: <5176ABB7.5080300@schaufler-ca.com> <517863F8.7050606@canonical.com> <51787C1C.1040301@schaufler-ca.com> <47138397.PP25Tg7m1s@sifl>
In-Reply-To: <47138397.PP25Tg7m1s@sifl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/25/2013 8:01 AM, Paul Moore wrote:
> On Wednesday, April 24, 2013 05:43:08 PM Casey Schaufler wrote:
>> On 4/24/2013 4:00 PM, John Johansen wrote:
>>> On 04/24/2013 02:15 PM, Paul Moore wrote:
>>>> On Wednesday, April 24, 2013 01:22:20 PM Casey Schaufler wrote:
> ...
>
>>>>> An interesting aside that may be relevant is that the error
>>>>> condition behavior makes it advisable to have the LSM you care
>>>>> about most go last. If the networking components were strictly
>>>>> FCFS you might have to chose an ordering you might not want for
>>>>> other reasons.
>>>> Well, maybe not ... I think.  If we take a FCFS approach to the network
>>>> controls then only one LSM is really ever going to throw an error on the
>>>> network hooks, yes?
>> You set up the order you want to get the networking handled
>> correctly and you could get filesystem hooks in the wrong order.
>> Not that that really ought to be a problem, but there are wonky
>> admin tools out there.
> I don't quite follow; can you be a bit more explicit about getting the 
> filesystem hooks in the wrong order?

Let's assume that there's a case for the stat() system call that
would get EPERM from SELinux and EACCES from Smack. A carefully
crafted admin tool might take different actions based on the return
code. If Smack ahead of SELinux in the list the tool will respond
one way, whereas if SELinux is ahead it will behave the other way.

If this tool came with Fedora it will likely expect the SELinux
error code. Thus, it will be somewhat important that Smack precede
SELinux in the LSM ordering. That will grant Smack the NetLabel
component. If you want SELinux to use NetLabel you'll have to
explicitly configure that.

It's probably not going to be an issue that often. Making the
ordering implications clear to those who may be affected by them
is probably the best choice and biggest challenge. It would be
nice to keep them to a minimum. I fear some future LSM author
getting clever with error codes and demanding the ultimate
position in all cases.

>>>> I'm still in favor of assigning the network hooks to the LSM at boot
>>>> based on the "security=" configuration.
>>> yeah dealing with selection at boot time is going to be needed
>>> at some point, whether its now or later ...
>> I'll have a go at it then. What that would mean is that:
>>
>> 	security=smack,selinux
>>
>> gives Smack NetLabel and SELinux xfrm and secmark while
>>
>> 	security=selinux,smack
>>
>> gives SELinux all three.
> That seems reasonable, it also keeps the door open for adding a specific 
> network hook ordering option, e.g. "security_net=", at a later date if 
> necessary.
>
>> I would still like it to be possible to explicitly configure the allocation
>> at build time.
> I suppose I have no object to that, I would just place my vote to have the 
> dynamic FCFS (or LCFS if that makes more sense) assignment be the Kconfig 
> default.
>

