Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862AbaFCSUE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 14:20:04 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:46840 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113AbaFCSUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 14:20:03 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>, Marian Marinov <mm@1h.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        LXC development mailing-list 
	<lxc-devel@lists.linuxcontainers.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <5386D58D.2080809@1h.com> <87tx88nbko.fsf@x220.int.ebiederm.org>
	<53870EAA.4060101@1h.com> <20140529153232.GB9714@ubuntumail>
	<538DFF72.7000209@parallels.com> <20140603172631.GL9714@ubuntumail>
	<538E0848.6060900@parallels.com>
Date: Tue, 03 Jun 2014 11:18:56 -0700
In-Reply-To: <538E0848.6060900@parallels.com> (Pavel Emelyanov's message of
	"Tue, 3 Jun 2014 21:39:20 +0400")
Message-ID: <87oay9j1pr.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX191kiqqcYIkvjzbgfJD7g2+zQMJLWuVZcM=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Pavel Emelyanov <xemul@parallels.com>
X-Spam-Relay-Country: 
Subject: Re: [RFC] Per-user namespace process accounting
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Emelyanov <xemul@parallels.com> writes:

> On 06/03/2014 09:26 PM, Serge Hallyn wrote:
>> Quoting Pavel Emelyanov (xemul@parallels.com):
>>> On 05/29/2014 07:32 PM, Serge Hallyn wrote:
>>>> Quoting Marian Marinov (mm@1h.com):
>>>>> -----BEGIN PGP SIGNED MESSAGE-----
>>>>> Hash: SHA1
>>>>>
>>>>> On 05/29/2014 01:06 PM, Eric W. Biederman wrote:
>>>>>> Marian Marinov <mm@1h.com> writes:
>>>>>>
>>>>>>> Hello,
>>>>>>>
>>>>>>> I have the following proposition.
>>>>>>>
>>>>>>> Number of currently running processes is accounted at the root user namespace. The problem I'm facing is that
>>>>>>> multiple containers in different user namespaces share the process counters.
>>>>>>
>>>>>> That is deliberate.
>>>>>
>>>>> And I understand that very well ;)
>>>>>
>>>>>>
>>>>>>> So if containerX runs 100 with UID 99, containerY should have NPROC limit of above 100 in order to execute any 
>>>>>>> processes with ist own UID 99.
>>>>>>>
>>>>>>> I know that some of you will tell me that I should not provision all of my containers with the same UID/GID maps,
>>>>>>> but this brings another problem.
>>>>>>>
>>>>>>> We are provisioning the containers from a template. The template has a lot of files 500k and more. And chowning
>>>>>>> these causes a lot of I/O and also slows down provisioning considerably.
>>>>>>>
>>>>>>> The other problem is that when we migrate one container from one host machine to another the IDs may be already
>>>>>>> in use on the new machine and we need to chown all the files again.
>>>>>>
>>>>>> You should have the same uid allocations for all machines in your fleet as much as possible.   That has been true
>>>>>> ever since NFS was invented and is not new here.  You can avoid the cost of chowning if you untar your files inside
>>>>>> of your user namespace.  You can have different maps per machine if you are crazy enough to do that.  You can even
>>>>>> have shared uids that you use to share files between containers as long as none of those files is setuid.  And map
>>>>>> those shared files to some kind of nobody user in your user namespace.
>>>>>
>>>>> We are not using NFS. We are using a shared block storage that offers us snapshots. So provisioning new containers is
>>>>> extremely cheep and fast. Comparing that with untar is comparing a race car with Smart. Yes it can be done and no, I
>>>>> do not believe we should go backwards.
>>>>>
>>>>> We do not share filesystems between containers, we offer them block devices.
>>>>
>>>> Yes, this is a real nuisance for openstack style deployments.
>>>>
>>>> One nice solution to this imo would be a very thin stackable filesystem
>>>> which does uid shifting, or, better yet, a non-stackable way of shifting
>>>> uids at mount.
>>>
>>> I vote for non-stackable way too. Maybe on generic VFS level so that filesystems 
>>> don't bother with it. From what I've seen, even simple stacking is quite a challenge.
>> 
>> Do you have any ideas for how to go about it?  It seems like we'd have
>> to have separate inodes per mapping for each file, which is why of
>> course stacking seems "natural" here.
>
> I was thinking about "lightweight mapping" which is simple shifting. Since
> we're trying to make this co-work with user-ns mappings, simple uid/gid shift
> should be enough. Please, correct me if I'm wrong.
>
> If I'm not, then it looks to be enough to have two per-sb or per-mnt values
> for uid and gid shift. Per-mnt for now looks more promising, since container's
> FS may be just a bind-mount from shared disk.
>
>> Trying to catch the uid/gid at every kernel-userspace crossing seems
>> like a design regression from the current userns approach.  I suppose we
>> could continue in the kuid theme and introduce a iiud/igid for the
>> in-kernel inode uid/gid owners.  Then allow a user privileged in some
>> ns to create a new mount associated with a different mapping for any
>> ids over which he is privileged.
>
> User-space crossing? From my point of view it would be enough if we just turn
> uid/gid read from disk (well, from whenever FS gets them) into uids, that would
> match the user-ns's ones, this sould cover the VFS layer and related syscalls
> only, which is, IIRC stat-s family and chown.
>
> Ouch, and the whole quota engine :\

And posix acls.

But all of this is 90% done already.  I think today we just have
conversions to the initial user namespace. We just need a few tweaks to
allow it and a per superblock user namespace setting.

Eric

