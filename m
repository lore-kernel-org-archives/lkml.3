Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760163Ab3BMRMr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 12:12:47 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:49877 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760111Ab3BMRMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 12:12:45 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: linux-fsdevel@vger.kernel.org
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serge@hallyn.com>,
        Mark Fasheh <mfasheh@suse.com>
References: <87pq38wimv.fsf@xmission.com>
	<1353415420-5457-1-git-send-email-ebiederm@xmission.com>
	<1353415420-5457-9-git-send-email-ebiederm@xmission.com>
	<20121121195114.GM2822@localhost>
Date: Wed, 13 Feb 2013 09:12:37 -0800
In-Reply-To: <20121121195114.GM2822@localhost> (Joel Becker's message of "Wed,
	21 Nov 2012 11:51:15 -0800")
Message-ID: <874nhg5e9m.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/1MCdxgclWxE4DHg6QM/Su75ezFlduRQ4=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  3.0 XMDrug1234561 Drug references
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0113]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *******;linux-fsdevel@vger.kernel.org
X-Spam-Relay-Country: 
Subject: Re: [PATCH RFC 09/12] userns: Convert ocfs2 to use kuid and kgid where appropriate
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joel Becker <jlbec@evilplan.org> writes:

> On Tue, Nov 20, 2012 at 04:43:37AM -0800, Eric W. Biederman wrote:
>> --- a/fs/ocfs2/file.c
>> +++ b/fs/ocfs2/file.c
>> @@ -1116,7 +1116,8 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
>>  			    (unsigned long long)OCFS2_I(inode)->ip_blkno,
>>  			    dentry->d_name.len, dentry->d_name.name,
>>  			    attr->ia_valid, attr->ia_mode,
>> -			    attr->ia_uid, attr->ia_gid);
>> +			    from_kuid(&init_user_ns, attr->ia_uid),
>> +			    from_kgid(&init_user_ns, attr->ia_gid));
>
> Dear Eric,
> 	I have a similar question about init_user_ns to Dave.  As far as
> I can tell, using init_user_ns here means we'll never get translations
> based on the current process namespace.  It just so happens that
> include/linux/user_namespace.h doesn't allow new namespaces yet, but I
> can't see why we would propagate that knowledge elsewhere.
>
> 	Is there some magic about when init_user_ns should be used
> regardless?

Trace statements are fancy print statements, and the tracing
infrastructure is not setup to deal with anyone other than the
one-true-root using it.  Trace is like printk in that way.

So for print statements I always convert the value into the initial user
namespace which every value can be converted to without loss, and is the
same value that we have always been printing.

If at some point the tracing people figure out how deal with multiple
user namespaces it won't be hard to pass the kuids and kgids into the
trace funtions and have the readers of the data perform the conversions.

Eric


