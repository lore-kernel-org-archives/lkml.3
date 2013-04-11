Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991Ab3DKQbW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 12:31:22 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:47246 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587Ab3DKQbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 12:31:21 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay@vrfy.org>,
        Ming Lei <ming.lei@canonical.com>
References: <20130406165600.GA29660@kroah.com> <87y5cpvhaz.fsf@xmission.com>
	<20130411155606.GA14042@kroah.com>
Date: Thu, 11 Apr 2013 09:31:14 -0700
In-Reply-To: <20130411155606.GA14042@kroah.com> (Greg KH's message of "Thu, 11
	Apr 2013 08:56:06 -0700")
Message-ID: <87vc7t112l.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19jvjr5eVYgzd1m3Up2EqZRKrGwUXIyDfE=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.0 XMSubMetaSx_00 1+ Sexy Words
	*  0.2 XMSubMetaSSx_00 1+ SortaSexy Words + 1 Sexy Word
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg KH <gregkh@linuxfoundation.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] driver core: add uid and gid to devtmpfs
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@linuxfoundation.org> writes:

> On Wed, Apr 10, 2013 at 09:10:12PM -0700, Eric W. Biederman wrote:
>> Greg KH <gregkh@linuxfoundation.org> writes:
>> 
>> > From: Kay Sievers <kay@vrfy.org>
>> >
>> > Some drivers want to tell userspace what uid and gid should be used for
>> > their device nodes, so allow that information to percolate through the
>> > driver core to userspace in order to make this happen.  This means that
>> > some systems (i.e.  Android and friends) will not need to even run a
>> > udev-like daemon for their device node manager and can just rely in
>> > devtmpfs fully, reducing their footprint even more.
>> 
>> This patch is really badly broken in it's uid and gid handling.
>> Nearly every line of this patch is wrong.
>> 
>> uids and gids in the kernel need to be stored in kuid_t's and kgid_t's.
>
> Stored, yes, but defined that way as well?

At this point uid_t and gid_t are like __user pointers.  Something you
really only want to have in code that is directly interacting with
userspace.

Since there are nice typing properties and no runtime downsides we want
to use kuid_t and kgid_t as much as possible.

What I find is that if I push kuid_t and kgid_t everywhere I find kernel
interfaces that I would never has suspected of using uids and gids.

>> > -static char *block_devnode(struct device *dev, umode_t *mode)
>> > +static char *block_devnode(struct device *dev, umode_t *mode,
>> > +			   uid_t *uid, gid_t *gid)
>> This needs be kuid_t and kgid_t.
>> 
>> >  {
>> >  	struct gendisk *disk = dev_to_disk(dev);
>> >  
>> > --- a/drivers/base/core.c
>> > +++ b/drivers/base/core.c
>> > @@ -283,15 +283,21 @@ static int dev_uevent(struct kset *kset,
>> >  		const char *tmp;
>> >  		const char *name;
>> >  		umode_t mode = 0;
>> > +		uid_t uid = 0;
>> > +		gid_t gid = 0;
>> This needs to be:
>> 		kuid_t uid = GLOBAL_ROOT_UID;
>> 		kgid_t gid = GLOBAL_ROOT_GID;
>
> Ok, I'll fix this up and send a follow-on patch, thanks for the review.
>
>> 
>> >  		add_uevent_var(env, "MAJOR=%u", MAJOR(dev->devt));
>> >  		add_uevent_var(env, "MINOR=%u", MINOR(dev->devt));
>> > -		name = device_get_devnode(dev, &mode, &tmp);
>> > +		name = device_get_devnode(dev, &mode, &uid, &gid, &tmp);
>> >  		if (name) {
>> >  			add_uevent_var(env, "DEVNAME=%s", name);
>> > -			kfree(tmp);
>> >  			if (mode)
>> >  				add_uevent_var(env, "DEVMODE=%#o", mode & 0777);
>> > +			if (uid)
>> > +				add_uevent_var(env, "DEVUID=%u", uid);
>> > +			if (gid)
>> > +				add_uevent_var(env, "DEVGID=%u", gid);
>> 
>> Which user namespace are your users in?
>> At the very least this should be:
>> +			if (!uid_eq(uid, GLOBAL_ROOT_UID)
>> +				add_uevent_var(env, "DEVUID=%u", from_kuid(&init_user_ns, uid));
>> +			if (!gid_eq(gid, GLOBAL_ROOT_GID))
>> +				add_uevent_var(env, "DEVGID=%u", from_kgid(&init_user_ns, gid));
>> 
>> I suppose you can assume your users are in the initial user namespace,
>> as mknod won't work in any other user namespace.
>
> Yes.
>
>> Still it approaches being twisted to have files like
>> /sys/class/net/eth0/uevent that anyone can read that will only return
>> values in the initial user namespace.
>
> As the nodes are only valid in the initial namespace, why would this
> matter?
>
>> > +		newattrs.ia_uid = uid;
>> > +		newattrs.ia_gid = gid;
>> This doesn't even compile because the types are wrong.
>
> Yes, this has been fixed.  But note, it only fails the build if
> namespaces are enabled, and given that no one seems to have reported
> this build error in either the 0-day tester, or linux-next, or the
> distro developers that tested this patch on their systems, it seems that
> no one enables namespaces on their systems :(

Yeah.  Not my favorite aspect of this.  Although you could call it the
version of CONFIG_EXPERIMENTAL that distros respect.

Right now I have all of the kernel converted to use kuid_t and kgid_t
except for XFS.  So there is a config guard that prevents XFS and user
namespaces from being enabled at the same time.  Right now allyesconfig
and allmodconfig enable XFS and thus turn off user namespaces.

Hopefully I will get XFS sorted out before too much longer.

Until that happens I have been doing periodic sweeps during the merge
window and after -rc1 to keep things from bit-rotting.

> Again, thanks for the review, I'll go enable namespaces in my test
> kernel and fix up the fallout.

Thanks.

Eric
