Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762AbbATXc5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 18:32:57 -0500
Received: from smtp107.biz.mail.bf1.yahoo.com ([98.139.244.55]:24789 "EHLO
	smtp107.biz.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751853AbbATXcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 18:32:55 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: ddQ4DU4VM1l1BsYimTsz.S4_im2oOv7GqsUB55XGnjxsH7p
 aHLqoULrBpR.P3Ifuxo25vw0_x7bGaN1U7L0xB0MNtmv3xNWbZ_HoCw8JC6k
 eDxQFHpfCsQq760fxqbwIZh_mPRq531XPKR8jGCdy3KZ8e25uqh2mGUU0mkg
 b4cS_oDqQp8PmpyQG4U6IDDM4wMV94EchhKfS0mYaRDq4MmMTj3ZN3YPUZqp
 sG1FUQXpAgXMQqqT2iMoqWC8IWd2PlZy4fr75EHc8h40E33f82WYdUuoNSDr
 OJD0p8NLW8i6Z8zAUxHFFj29C3vLsbJbDCRGLseoAHYIuzwd182ZpSGM3sz.
 Z6eOIY7GjetPPTL68cbxwsY9bo1jlkRPSNyNOLjH8kHeac4qL0G5s2Z_TCMx
 XIpM.xj.Lc8C2DC6pugamivHPNtHEmVgAxjqRli9bnxrCyk54qHqT05xIfpx
 G3F9RjoLJHJrRfIFl7c4LwkjtncoknO.Ao4y4LYraTFgUScwyaNc3p5Xz1R4
 e_TWbfI2gAQMLETp_shDCHQ--
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <54BEE5A5.5050807@schaufler-ca.com>
Date: Tue, 20 Jan 2015 15:32:53 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>, Ben Hutchings <ben@decadent.org.uk>
CC: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, 770492@bugs.debian.org,
        Ben Harris <bjh21@cam.ac.uk>, oss-security@lists.openwall.com,
        John Johansen <john.johansen@canonical.com>,
        Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [RFC PATCH RESEND] vfs: Move security_inode_killpriv() after
 permission checks
References: <1421537206.31046.74.camel@decadent.org.uk> <alpine.LRH.2.11.1501211014580.15885@namei.org>
In-Reply-To: <alpine.LRH.2.11.1501211014580.15885@namei.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/20/2015 3:17 PM, James Morris wrote:
> On Sat, 17 Jan 2015, Ben Hutchings wrote:
>
>> chown() and write() should clear all privilege attributes on
>> a file - setuid, setgid, setcap and any other extended
>> privilege attributes.
>>
>> However, any attributes beyond setuid and setgid are managed by the
>> LSM and not directly by the filesystem, so they cannot be set along
>> with the other attributes.
>>
>> Currently we call security_inode_killpriv() in notify_change(),
>> but in case of a chown() this is too early - we have not called
>> inode_change_ok() or made any filesystem-specific permission/sanity
>> checks.
>>
>> Add a new function setattr_killpriv() which calls
>> security_inode_killpriv() if necessary, and change the setattr()
>> implementation to call this in each filesystem that supports xattrs.
>> This assumes that extended privilege attributes are always stored in
>> xattrs.
> It'd be useful to get some input from LSM module maintainers on this.

I've already chimed in.

Clearing the Smack label on a file because someone writes to it
makes no sense whatsoever. The same with chown. The Smack label is
attached to the object, which is a container of data, not the data
itself. Smack labels are Mandatory Access Control labels, not Information
labels. If that doesn't mean anything to the reader, check out the
P1003.1e/2c (withdrawn) DRAFT.

The proposed implementation does not correctly handle either
Mandatory Access Control labels or Information labels. The MAC
label is *very different* from the setuid bit.

>
> e.g. doesn't SELinux already handle this via policy directives?
>
>

