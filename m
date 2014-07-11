Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864AbaGKQcl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 12:32:41 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:48187 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106AbaGKQcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 12:32:39 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: "chenhanxiao\@cn.fujitsu.com" <chenhanxiao@cn.fujitsu.com>,
        "Serge Hallyn \(serge.hallyn\@ubuntu.com\)" <serge.hallyn@ubuntu.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "containers\@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <5871495633F38949900D2BF2DC04883E562293@G08CNEXMBPEKD02.g08.fujitsu.local>
	<20140711142806.GA26441@mail.hallyn.com>
Date: Fri, 11 Jul 2014 09:29:05 -0700
In-Reply-To: <20140711142806.GA26441@mail.hallyn.com> (Serge E. Hallyn's
	message of "Fri, 11 Jul 2014 16:28:06 +0200")
Message-ID: <87ha2nyi3y.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/dO+nBKvpxMSJRSlYw7gyfRkfDb6fzHkw=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.3171]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Serge E. Hallyn" <serge@hallyn.com>
X-Spam-Relay-Country: 
Subject: Re: Could not mount sysfs when enable userns but disable netns
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serge@hallyn.com> writes:

> Quoting chenhanxiao@cn.fujitsu.com (chenhanxiao@cn.fujitsu.com):
>> Hello,
>> 
>> How to reproduce:
>> 1. Prepare a container, enable userns and disable netns
>> 2. use libvirt-lxc to start a container
>> 3. libvirt could not mount sysfs then failed to start.
>> 
>> Then I found that
>> commit 7dc5dbc879bd0779924b5132a48b731a0bc04a1e says:
>> "Don't allow mounting sysfs unless the caller has CAP_SYS_ADMIN rights
>> over the net namespace."
>> 
>> But why should we check sysfs mouont permission over net namespace?
>> We've already checked CAP_SYS_ADMIN though.

We already checked capable(CAP_SYS_ADMIN) and it failed.

>> What the relationship between sysfs and net namespace,
>> or this check is a little redundant?

You want a bind mount not a new fresh mount.

When looking at how evil actors could abuse things it turned out that in
some circumstances the root user (before a user namespace is created)
needs to control the policy on which filesystems may be mounted.  There
are files in sysfs and in proc that you never want to see in a chroot
jail, as they just create more surface area to attack.

The only reason for creating a new fresh mount of sysfs is to get access
to /sys/class/net.  So to keep things simple we restrict creation of
that mount to cases where the mounter has permisions over the network
namespace, and cases where nothing interesing is mounted on top of
sysfs.

If a new /sys/class/net is not needed it is possible to bind mount the
existing copy of sysfs to the new location without loss of
functionality.

> It is not redundant.  The whole point is that after clone(CLONE_NEWUSER)
> you get a newly filled set of capabilities.  But you should not have
> privileges over the host's network namesapce.  After you unshare a new
> network namespace, you *should* have privilege over it.  So the fact
> that we've already check CAP_SYS_ADMIN means nothing, because the
> capabilities need to be targeted.

Exactly the tests are failing because the caller is not the global root
and so the code is properly failing the permission checks.

Eric
