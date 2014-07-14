Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830AbaGNR1R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 13:27:17 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:54998 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921AbaGNR1K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 13:27:10 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "chenhanxiao\@cn.fujitsu.com" <chenhanxiao@cn.fujitsu.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        "'Daniel P. Berrange \(berrange\@redhat.com\)'" <berrange@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "containers\@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <5871495633F38949900D2BF2DC04883E562293@G08CNEXMBPEKD02.g08.fujitsu.local>
	<20140711142806.GA26441@mail.hallyn.com>
	<87ha2nyi3y.fsf@x220.int.ebiederm.org>
	<5871495633F38949900D2BF2DC04883E5632BD@G08CNEXMBPEKD02.g08.fujitsu.local>
Date: Mon, 14 Jul 2014 10:23:32 -0700
In-Reply-To: <5871495633F38949900D2BF2DC04883E5632BD@G08CNEXMBPEKD02.g08.fujitsu.local>
	(chenhanxiao@cn.fujitsu.com's message of "Mon, 14 Jul 2014 09:32:39
	+0000")
Message-ID: <878unvvoq3.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-AID: U2FsdGVkX19mmAiajnn/uopEjGCMKKYih0cQRvGXG5A=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.3 TooManyTo_001 Multiple "To" Header Recipients 2x (uncommon)
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4989]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;"chenhanxiao\@cn.fujitsu.com" <chenhanxiao@cn.fujitsu.com>
X-Spam-Relay-Country: 
Subject: Re: Could not mount sysfs when enable userns but disable netns
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"chenhanxiao@cn.fujitsu.com" <chenhanxiao@cn.fujitsu.com> writes:

>> -----Original Message-----
>> From: Eric W. Biederman [mailto:ebiederm@xmission.com]
>> Sent: Saturday, July 12, 2014 12:29 AM
>> To: Serge E. Hallyn
>> Cc: Chen, Hanxiao/陈 晗霄; Serge Hallyn (serge.hallyn@ubuntu.com); Greg
>> Kroah-Hartman; containers@lists.linux-foundation.org;
>> linux-kernel@vger.kernel.org
>> Subject: Re: Could not mount sysfs when enable userns but disable netns
>> 
>> "Serge E. Hallyn" <serge@hallyn.com> writes:
>> 
>> > Quoting chenhanxiao@cn.fujitsu.com (chenhanxiao@cn.fujitsu.com):
>> >> Hello,
>> >>
>> >> How to reproduce:
>> >> 1. Prepare a container, enable userns and disable netns
>> >> 2. use libvirt-lxc to start a container
>> >> 3. libvirt could not mount sysfs then failed to start.
>> >>
>> >> Then I found that
>> >> commit 7dc5dbc879bd0779924b5132a48b731a0bc04a1e says:
>> >> "Don't allow mounting sysfs unless the caller has CAP_SYS_ADMIN rights
>> >> over the net namespace."
>> >>
>> >> But why should we check sysfs mouont permission over net namespace?
>> >> We've already checked CAP_SYS_ADMIN though.
>> 
>> We already checked capable(CAP_SYS_ADMIN) and it failed.
>
> But on my machine, capable(CAP_SYS_ADMIN) passed
> but failed in kobj_ns_current_may_mount.

No.  capable(CAP_SYS_ADMIN) did not pass.
fs_fully_visible did passed.

There is a significant distinction.  If capable(CAP_SYS_ADMIN) had
passed kobj_ns_current_may_mount (which is a fancy way of saying
ns_capable(net->user_ns, CAP_SYS_ADMIN)) would also have passed.

> I added some printks in sysfs_mount:
>         if (!(flags & MS_KERNMOUNT)) {
> -               if (!capable(CAP_SYS_ADMIN) && !fs_fully_visible(fs_type))
> +               if (!capable(CAP_SYS_ADMIN) && !fs_fully_visible(fs_type)) {
> +                       printk(KERN_WARNING "Failed in capable\n");
>                         return ERR_PTR(-EPERM);
> +                }
>  
> -               if (!kobj_ns_current_may_mount(KOBJ_NS_TYPE_NET))
> +               if (!kobj_ns_current_may_mount(KOBJ_NS_TYPE_NET)) {
> +                       printk(KERN_WARNING "Failed in kobj_ns_current_may_mount\n");
>                         return ERR_PTR(-EPERM);
> +                }
>
> And found: 
> Jul 14 09:55:26 localhost systemd: Starting Container lxc-chx.
> Jul 14 09:55:26 localhost systemd-machined: New machine lxc-chx.
> Jul 14 09:55:26 localhost systemd: Started Container lxc-chx.
> Jul 14 09:55:26 localhost kernel: [  784.044709] Failed in kobj_ns_current_may_mount
> Jul 14 09:55:26 localhost systemd-machined: Machine lxc-chx terminated.
>
>> 
>> >> What the relationship between sysfs and net namespace,
>> >> or this check is a little redundant?
>> 
>> You want a bind mount not a new fresh mount.
>> 
>
> Yes, we need to modify libvirt's codes to deal with sysfs
> when enable userns but disable netns.

Please go for it.  I don't have any insignt into libvirt so I can't help
you there.

Eric
