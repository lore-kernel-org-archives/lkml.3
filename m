Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932506Ab3KHXyX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 18:54:23 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:55063 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932371Ab3KHXyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 18:54:19 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Aditya Kali <adityakali@google.com>, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1382737870-12792-1-git-send-email-adityakali@google.com>
	<20131029153610.GB32008@mail.hallyn.com>
Date: Fri, 08 Nov 2013 15:54:07 -0800
In-Reply-To: <20131029153610.GB32008@mail.hallyn.com> (Serge E. Hallyn's
	message of "Tue, 29 Oct 2013 15:36:10 +0000")
Message-ID: <87a9heqwkg.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX197qOubDtIvCJguYoOfjphglIrETQ20KDg=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1239]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Serge E. Hallyn" <serge@hallyn.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] proc: Fix namespace mountpoint path in /proc/mounts
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serge@hallyn.com> writes:

> Quoting Aditya Kali (adityakali@google.com):
>> Commit bf056bfa80596a5d14b26b17276a56a0dcb080e5:
>> "proc: Fix the namespace inode permission checks." converted
>> the namespace files into symlinks. The same commit changed
>> the way namespace bind mounts appear in /proc/mounts:
>>   $ mount --bind /proc/self/ns/ipc /mnt/ipc
>> Originally:
>>   $ cat /proc/mounts | grep ipc
>>   proc /mnt/ipc proc rw,nosuid,nodev,noexec 0 0
>> 
>> After commit bf056bfa80596a5d14b26b17276a56a0dcb080e5:
>>   $ cat /proc/mounts | grep ipc
>>   proc ipc:[4026531839] proc rw,nosuid,nodev,noexec 0 0
>> 
>> This breaks userspace which expects the 2nd field in
>> /proc/mounts to be a valid path. This patch restores the
>> original format of namespace bind-mount entries in
>> /proc/mounts.
>
> Oh, at first I was thinking the mount source was showing up like that,
> not the target.  That is particularly ugly, I agree.
>
> I'm not sure what the purpose was of the ns_dname().  dcache.c says it's
> for filesystems wanting to do 'special "root names"'.  But this file
> gets mounted to real paths, it's not actually rootless (like a pipefs
> inode or anon_inode).  So I think your patch is correct, but I'm waiting
> to hear from Eric, as I'm not sure if you're masking some other effect
> which Eric actually wanted, and maybe this should be fixed another
> way...

My apologies for taking a long time to get back to this one.  I have
been scratching my head on this one.

There is most definitely a bug here, and worth fixing.

But I believe the bug is actually in buried in /proc/mounts. ns_dname
should be irrelevant as we are mounted.

The problem comes down to d_path.

I am not certain which is the best fix at the moment.  It should either
be a case of fixing d_path to see if the dentry is mounted, or making
certain that the dentries have the name ns_dname is giving them when
we allocate the dentries.

I was focusing on the what a ns file descriptor should look like when it
is opened but not mounted, when I wrote ns_dname, and that appearance
really should continue if possible.

I expect the easist way to fix this is to simply modify proc_ns_get_dentry to
compute the dentry name that ns_dname uses today, and pass that name to
d_alloc_psuedo.

At which point we can delete ns_dname without problems.

Eric


>> Signed-off-by: Aditya Kali <adityakali@google.com>
>> ---
>>  fs/proc/namespaces.c | 10 ----------
>>  1 file changed, 10 deletions(-)
>> 
>> diff --git a/fs/proc/namespaces.c b/fs/proc/namespaces.c
>> index 49a7fff..d19989d 100644
>> --- a/fs/proc/namespaces.c
>> +++ b/fs/proc/namespaces.c
>> @@ -48,19 +48,9 @@ static int ns_delete_dentry(const struct dentry *dentry)
>>  	return 1;
>>  }
>>  
>> -static char *ns_dname(struct dentry *dentry, char *buffer, int buflen)
>> -{
>> -	struct inode *inode = dentry->d_inode;
>> -	const struct proc_ns_operations *ns_ops = PROC_I(inode)->ns.ns_ops;
>> -
>> -	return dynamic_dname(dentry, buffer, buflen, "%s:[%lu]",
>> -		ns_ops->name, inode->i_ino);
>> -}
>> -
>>  const struct dentry_operations ns_dentry_operations =
>>  {
>>  	.d_delete	= ns_delete_dentry,
>> -	.d_dname	= ns_dname,
>>  };
>>  
>>  static struct dentry *proc_ns_get_dentry(struct super_block *sb,
>> -- 
>> 1.8.4.1
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
