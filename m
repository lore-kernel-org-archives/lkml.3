Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938AbaHDVTn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 17:19:43 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:65276 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119AbaHDVTl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 17:19:41 -0400
Message-ID: <53DFF8E7.2060906@nod.at>
Date: Mon, 04 Aug 2014 23:19:35 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Ram Pai <linuxram@us.ibm.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Jeff Mahoney <jeffm@suse.com>, sahne@0x90.at,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: MNT_DETACH and mount namespace issue
References: <1406728756-32443-1-git-send-email-richard@sigma-star.at>	<53D959A7.5070702@nod.at> <53DAC069.7070606@nod.at>	<20140801154448.GE24719@ram.oc3035372033.ibm.com>	<53DBE894.3020900@nod.at> <87ha1v6ewb.fsf@x220.int.ebiederm.org>	<CAFLxGvzbdON+fbsG=0iwOv5m_hbQ2=Pz=Ec-AHq728FTNcx4iw@mail.gmail.com> <874mxs2of1.fsf@x220.int.ebiederm.org>
In-Reply-To: <874mxs2of1.fsf@x220.int.ebiederm.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 04.08.2014 18:46, schrieb Eric W. Biederman:
> Richard Weinberger <richard.weinberger@gmail.com> writes:
> 
>> On Sat, Aug 2, 2014 at 12:09 AM, Eric W. Biederman
>> <ebiederm@xmission.com> wrote:
>>> Richard Weinberger <richard@nod.at> writes:
>>>
>>>> Am 01.08.2014 17:44, schrieb Ram Pai:
>>>>> On Fri, Aug 01, 2014 at 12:17:13AM +0200, Richard Weinberger wrote:
>>>>>> Am 30.07.2014 22:46, schrieb Richard Weinberger:
>>>>>>> Am 30.07.2014 15:59, schrieb Richard Weinberger:
>>>>>>>> If we use the plain list_empty() we might not see the
>>>>>>>> hlist_del_init_rcu() and therefore miss one member of the
>>>>>>>> list.
>>>>>>>>
>>>>>>>> It fixes the following issue:
>>>>>>>> $ unshare -m /usr/bin/sleep 10000 &
>>>>>>>> $ mkdir -p foo/proc
>>>>>>>> $ mount -t proc none foo/proc
>>>>>>>> $ mount -t binfmt_misc none foo/proc/sys/fs/binfmt_misc
>>>>>>>> $ umount -l foo/proc
>>>>>>>> $ rmdir foo/proc
>>>>>>>> rmdir: failed to remove ‘foo/proc’: Device or resource busy
>>>>>>>
>>>>>>> Although my fix was wrong, the issue is real, it seems to exist for a very long
>>>>>>> time. Just was able to reproduce it on 2.6.32.
>>>>>>> Please note that you need a shared root subtree to trigger the issue.
>>>>>>> i.e. mount --shared /
>>>>>>> Maybe this is why nobody noticed it so far as only systemd distros
>>>>>>> have the root subtree shared by default.
>>>>>>>
>>>>>>> I hit the issue on openSUSE 13.1 where an application creates a chroot environment
>>>>>>> and then lazy umounts /proc.
>>>>>>> It happened on very few machines. An analysis showed that only boxes with an OpenVPN tunnel
>>>>>>> were affected. This did not make any sense until I discovered that the OpenVPN systemd
>>>>>>> service file has set "PrivateTmp=true". This setting creates
>>>>>>> a mount namespace for the said service...
>>>>>>>
>>>>>>> In __propagate_umount() the following piece of code is interesting:
>>>>>>>
>>>>>>>  /*
>>>>>>>  * umount the child only if the child has no
>>>>>>>  * other children
>>>>>>>  */
>>>>>>> if (child && list_empty(&child->mnt_mounts)) {
>>>>>>>         hlist_del_init_rcu(&child->mnt_hash);
>>>>>>>         hlist_add_before_rcu(&child->mnt_hash, &mnt->mnt_hash);
>>>>>>> }
>>>>>>>
>>>>>>> child->mnt_mounts is non-empty for the "proc" although the "binfmt_misc"
>>>>>>> subtree was removed.
>>>>>>> I'm not sure whether this is only one more symptom or the main culprit.
>>>>>>
>>>>>> CC'ing Ram Pai.
>>>>>>
>>>>>> Ram, you are the author of the said code. Can you please explain why we need that
>>>>>> list_empty() check?
>>>>>> To my (limited) understanding of VFS, the following change should be fine to fix the issue:
>>>>>
>>>>> We had made a rule then, that busy vfsmounts cannot be lazily unmounted
>>>>> **implicitly**. Propagated unmounts are implicit unmounts, and if such
>>>>> implicit vfsmounts have child-mounts than obviously they are busy, and
>>>>> hence they cannot be lazy-unmounted implicitly.
>>>>>
>>>>> the list_empty() is checking for no child-mounts on the vfsmount before
>>>>> letting it unmount.
>>>>>
>>>>> We did not want a bunch of mounts disappear without the users knowledge.
>>>>> Hence we made the above rule.
>>>>>
>>>>> Al Viro, will have more insights into this.
>>>>
>>>> Hmm, with the root subtree shared by default this policy will be problematic and
>>>> lead to problems.
>>>> As I observe on openSUSE 13.1.
>>>>
>>>> Al, what do you think?
>>>
>>> I have a pending patchset that causes the rmdir to cause all of the
>>> mounts to go away.  It has passed review and has not been merged only
>>> because of stack overflow concerns (which I have not had time to fully
>>> address).
>>>
>>> Sigh.  It badly breaks unix semantics for rmdir unlink with no mounts in
>>> the local namespace to fail, and it introduces as denial of service
>>> attack from unprivielged users.
>>
>> Thanks for the pointer!
>> I fear your patch series is nothing we can easily feed into -stable.
>> Is this really the only acceptable solution?
> 
> I am not really certain.  What I know is one of these days I need to
> take the time and get that merged.  It isn't going to be in 3.17
> unfortunately :(
> 
> What I do know is if you are asking questions about sane semantics my
> patch and the approach it takes feeds in.
> 
> It sounds like your problem is with lazy recursive unmounts not being
> propogated because there is a chance that in the destination there might
> be something mounted on top.  
> 
>> The thing is, users get already bitten by that.
> 
> The issue I am dealing with has been biting users for years.
> as root rm -rf dir failing with EBUSY because of a stale process in
> the mount namespace is pretty horrid.
> 
>> i.e. run openSUSE's KIWI tool on a machine where a systemd service
>> with PrivateTmp=yes is installed
>> and you'll end up with a stale mount point.
>> KIWI creates a chroot, populates /proc, lazily unmounts it later and
>> then fails to remove the temporary chroot directory
>> because of EBUSY.
> 
> Hmm.  That problem does sound familiar.
> 
> Is the problem oversharing?  Is the problem that the mount of /proc in
> the chroot directory is propogating into other mount namespaces that
> don't care?

/proc is propagating into another mount namespaces that does not care.
This happens because systemd creates for several services a mount namespace and sets
the root tree to MS_SHARED.

> If the problem is over propogating I would argue that KIWI needs to
> use a mount namespace instead of a chroot and to tweak the mount
> namespace so the mount of /proc simply does not leak out.
> 
> Not that the kernel doesn't need to be fixed but that a design where
> mounts propogate everywhere is a problem in userspace anyway, and it is
> likely going to only need to be a handful of lines of code to fix
> userspace cleanly.  While the kernel fix or fixes are going to require a
> bit more time.

KIWI can bypass the issue by not using a lazy unmount of /proc.
But I fear more applications will need fixing.
While I don't think that it was a wise choice from systemd developers to set
/ shared by default I agree that systemd is not the root cause of the problem.
It is the messenger.

It is just annoying that applications stopped working correctly after upgrading
to systemd.

Thanks,
//richard
