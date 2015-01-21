Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709AbbAUQPT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 11:15:19 -0500
Received: from smtp103.biz.mail.bf1.yahoo.com ([98.139.221.62]:46969 "EHLO
	smtp103.biz.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753670AbbAUQPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 11:15:15 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: R6dGGlQVM1kp1NwkvmqfR_upvhHduy6jMAmtMy3jIEPw04t
 _p5qh0obe.b.HOGUJZ.8hz0Xi.5sOraDOFl7F10DgIOI8uENipKZFE_qJM_V
 cd5ChagqngeN7qw8Ezd9BzqG3p4uBWwK8z2qtZ6RNVV15gmdPLy0cE9o.jzg
 V9BUvSxlqJo4gBlzmIs4hFHCOguuoPxly9igJ6pk6abFKCUzwpeBaGh.k.CQ
 miZj3Zj6miSs6EEH6pV.Y_Rl.83iBJMXy97wykGjthRVbfCaY7loraAOsnzr
 _Vk4FR8AWMjAQif653mwvddApH7hppBXlG1zi3JJzkyy2twmcnYItllSSJEH
 ZoVpfBx0rqG7dFwfjfJ7eI1c8WBRNXIngmcROpOsIn17acKQG2DAKdvaCZd5
 0H89hTohU3MKQbFgylr4fkTD3ylTjOnbv8YqrZdIul9sZRchMdJaYLVJ0mhB
 bAjvlp5qURM7LpC2gARaCVvkgLLJ6glLfdNKM5x.WubVg6ziU7qLAMph.XNt
 7hQ8XJHLNPcuekwQIMZ82oQeWjawJ3lglsthBBLkYu2iv4UuetPePFR4vJvf
 g0wORKQSIvAnvBT9nJSWGXlRlRLgdkN4xIDDdT4yp5.b3.z0siQ.5ZJLqgSr
 tLwJSqF7CSUJqL7_uX8.nHw--
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <54BFD090.4000907@schaufler-ca.com>
Date: Wed, 21 Jan 2015 08:15:12 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
        Ben Hutchings <ben@decadent.org.uk>
CC: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, 770492@bugs.debian.org,
        Ben Harris <bjh21@cam.ac.uk>, oss-security@lists.openwall.com,
        John Johansen <john.johansen@canonical.com>,
        Paul Moore <paul@paul-moore.com>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [RFC PATCH RESEND] vfs: Move security_inode_killpriv() after
 permission checks
References: <1421537206.31046.74.camel@decadent.org.uk> <alpine.LRH.2.11.1501211014580.15885@namei.org> <54BFB1B7.4020402@tycho.nsa.gov>
In-Reply-To: <54BFB1B7.4020402@tycho.nsa.gov>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/21/2015 6:03 AM, Stephen Smalley wrote:
> On 01/20/2015 06:17 PM, James Morris wrote:
>> On Sat, 17 Jan 2015, Ben Hutchings wrote:
>>
>>> chown() and write() should clear all privilege attributes on
>>> a file - setuid, setgid, setcap and any other extended
>>> privilege attributes.
>>>
>>> However, any attributes beyond setuid and setgid are managed by the
>>> LSM and not directly by the filesystem, so they cannot be set along
>>> with the other attributes.
>>>
>>> Currently we call security_inode_killpriv() in notify_change(),
>>> but in case of a chown() this is too early - we have not called
>>> inode_change_ok() or made any filesystem-specific permission/sanity
>>> checks.
>>>
>>> Add a new function setattr_killpriv() which calls
>>> security_inode_killpriv() if necessary, and change the setattr()
>>> implementation to call this in each filesystem that supports xattrs.
>>> This assumes that extended privilege attributes are always stored in
>>> xattrs.
>> It'd be useful to get some input from LSM module maintainers on this. 
>>
>> e.g. doesn't SELinux already handle this via policy directives?
> There have been a couple postings of a similar patch set [1] by Jan
> Kara, although I don't believe that series addressed chown().
>
> If I am reading the patches correctly, they (correctly) don't affect
> SELinux or Smack labels; they are just calling the existing
> security_inode_killpriv() hook, which is only implemented for the
> capability module to remove the security.capability xattr.

The description of the change should say that. I can easily
imagine an enthusiastic test developer reading the existing
description and filing bugs because SELinux, Smack and whatever
other xattr based systems might be around don't clear their
attributes. If the intent wasn't clear to the first person to
use xattrs for security purposes, I shouldn't expect the new
and inexperienced to see it.

My position softens. Document it correctly, and I'm fine with it.

>
> [1] http://marc.info/?l=linux-security-module&m=141890696325054&w=2
>

