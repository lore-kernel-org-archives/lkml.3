Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393AbaHAWN1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 18:13:27 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:56623 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755837AbaHAWNZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 18:13:25 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Richard Weinberger <richard@nod.at>
Cc: Ram Pai <linuxram@us.ibm.com>, linux-fsdevel@vger.kernel.org,
        viro@zeniv.linux.org.uk, hch@infradead.org, paulmck@linux.vnet.ibm.com,
        jeffm@suse.com, sahne@0x90.at,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1406728756-32443-1-git-send-email-richard@sigma-star.at>
	<53D959A7.5070702@nod.at> <53DAC069.7070606@nod.at>
	<20140801154448.GE24719@ram.oc3035372033.ibm.com>
	<53DBE894.3020900@nod.at>
Date: Fri, 01 Aug 2014 15:09:24 -0700
In-Reply-To: <53DBE894.3020900@nod.at> (Richard Weinberger's message of "Fri,
	01 Aug 2014 21:20:52 +0200")
Message-ID: <87ha1v6ewb.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-AID: U2FsdGVkX1+DhKB7ORD0A03ZzqoAavZIsrx981Yn1bA=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4979]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Richard Weinberger <richard@nod.at>
X-Spam-Relay-Country: 
Subject: Re: MNT_DETACH and mount namespace issue
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Weinberger <richard@nod.at> writes:

> Am 01.08.2014 17:44, schrieb Ram Pai:
>> On Fri, Aug 01, 2014 at 12:17:13AM +0200, Richard Weinberger wrote:
>>> Am 30.07.2014 22:46, schrieb Richard Weinberger:
>>>> Am 30.07.2014 15:59, schrieb Richard Weinberger:
>>>>> If we use the plain list_empty() we might not see the
>>>>> hlist_del_init_rcu() and therefore miss one member of the
>>>>> list.
>>>>>
>>>>> It fixes the following issue:
>>>>> $ unshare -m /usr/bin/sleep 10000 &
>>>>> $ mkdir -p foo/proc
>>>>> $ mount -t proc none foo/proc
>>>>> $ mount -t binfmt_misc none foo/proc/sys/fs/binfmt_misc
>>>>> $ umount -l foo/proc
>>>>> $ rmdir foo/proc
>>>>> rmdir: failed to remove ‘foo/proc’: Device or resource busy
>>>>
>>>> Although my fix was wrong, the issue is real, it seems to exist for a very long
>>>> time. Just was able to reproduce it on 2.6.32.
>>>> Please note that you need a shared root subtree to trigger the issue.
>>>> i.e. mount --shared /
>>>> Maybe this is why nobody noticed it so far as only systemd distros
>>>> have the root subtree shared by default.
>>>>
>>>> I hit the issue on openSUSE 13.1 where an application creates a chroot environment
>>>> and then lazy umounts /proc.
>>>> It happened on very few machines. An analysis showed that only boxes with an OpenVPN tunnel
>>>> were affected. This did not make any sense until I discovered that the OpenVPN systemd
>>>> service file has set "PrivateTmp=true". This setting creates
>>>> a mount namespace for the said service...
>>>>
>>>> In __propagate_umount() the following piece of code is interesting:
>>>>
>>>>  /*
>>>>  * umount the child only if the child has no
>>>>  * other children
>>>>  */
>>>> if (child && list_empty(&child->mnt_mounts)) {
>>>>         hlist_del_init_rcu(&child->mnt_hash);
>>>>         hlist_add_before_rcu(&child->mnt_hash, &mnt->mnt_hash);
>>>> }
>>>>
>>>> child->mnt_mounts is non-empty for the "proc" although the "binfmt_misc"
>>>> subtree was removed.
>>>> I'm not sure whether this is only one more symptom or the main culprit.
>>>
>>> CC'ing Ram Pai.
>>>
>>> Ram, you are the author of the said code. Can you please explain why we need that
>>> list_empty() check?
>>> To my (limited) understanding of VFS, the following change should be fine to fix the issue:
>> 
>> We had made a rule then, that busy vfsmounts cannot be lazily unmounted
>> **implicitly**. Propagated unmounts are implicit unmounts, and if such
>> implicit vfsmounts have child-mounts than obviously they are busy, and
>> hence they cannot be lazy-unmounted implicitly.
>> 
>> the list_empty() is checking for no child-mounts on the vfsmount before
>> letting it unmount.
>> 
>> We did not want a bunch of mounts disappear without the users knowledge.
>> Hence we made the above rule.
>> 
>> Al Viro, will have more insights into this.
>
> Hmm, with the root subtree shared by default this policy will be problematic and
> lead to problems.
> As I observe on openSUSE 13.1.
>
> Al, what do you think?

I have a pending patchset that causes the rmdir to cause all of the
mounts to go away.  It has passed review and has not been merged only
because of stack overflow concerns (which I have not had time to fully
address).

Sigh.  It badly breaks unix semantics for rmdir unlink with no mounts in
the local namespace to fail, and it introduces as denial of service
attack from unprivielged users.

Eric
