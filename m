Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbbAUOFM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 09:05:12 -0500
Received: from emvm-gh1-uea08.nsa.gov ([63.239.67.9]:49299 "EHLO
	emvm-gh1-uea08.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbbAUOFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 09:05:08 -0500
X-TM-IMSS-Message-ID: <1347740b0001dac8@nsa.gov>
Message-ID: <54BFB1B7.4020402@tycho.nsa.gov>
Date: Wed, 21 Jan 2015 09:03:35 -0500
From: Stephen Smalley <sds@tycho.nsa.gov>
Organization: National Security Agency
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>, Ben Hutchings <ben@decadent.org.uk>
CC: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, 770492@bugs.debian.org,
        Ben Harris <bjh21@cam.ac.uk>, oss-security@lists.openwall.com,
        John Johansen <john.johansen@canonical.com>,
        Paul Moore <paul@paul-moore.com>,
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

On 01/20/2015 06:17 PM, James Morris wrote:
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
> 
> It'd be useful to get some input from LSM module maintainers on this. 
> 
> e.g. doesn't SELinux already handle this via policy directives?

There have been a couple postings of a similar patch set [1] by Jan
Kara, although I don't believe that series addressed chown().

If I am reading the patches correctly, they (correctly) don't affect
SELinux or Smack labels; they are just calling the existing
security_inode_killpriv() hook, which is only implemented for the
capability module to remove the security.capability xattr.

[1] http://marc.info/?l=linux-security-module&m=141890696325054&w=2
