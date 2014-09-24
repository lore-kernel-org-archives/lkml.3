Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751237AbaIXFEy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 01:04:54 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:37894 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbaIXFEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 01:04:53 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: LXC development mailing-list <lxc-devel@lists.linuxcontainers.org>
Cc: linux-kernel@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>,
        fuse-devel <fuse-devel@lists.sourceforge.net>,
        Tejun Heo <tj@kernel.org>, Seth Forshee <seth.forshee@canonical.com>,
        serge.hallyn@ubuntu.com
References: <CALRD3qKmpzJCRszkG_S9Z3XgoTGWVMFd7FqeJh+W-9pZqPVhCg@mail.gmail.com>
Date: Tue, 23 Sep 2014 22:04:30 -0700
In-Reply-To: <CALRD3qKmpzJCRszkG_S9Z3XgoTGWVMFd7FqeJh+W-9pZqPVhCg@mail.gmail.com>
	(riya khanna's message of "Tue, 23 Sep 2014 23:34:46 -0500")
Message-ID: <87bnq5vcbl.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+HMu/PIGhWGOfyoE7LLShKKSVdjItFT8o=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.4 XM_Superlative01 Best-rated language
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4999]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;LXC development mailing-list
	<lxc-devel@lists.linuxcontainers.org>
X-Spam-Relay-Country: 
Subject: Re: [lxc-devel] device namespaces
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

riya khanna <riyakhanna1983@gmail.com> writes:

> (Please pardon multiple emails, artifact of merging all separate conversations)
>
> Thanks for your feedback! 
>
> Letting the kernel know about what devices a container could access (based on
> device cgroups) and having devtmpfs in the kernel create device nodes for a
> container that map to corresponding CUSE nodes is what I thought of. For
> example, "echo 29:0 > /proc/<pid>/devices" would prepare a virtual framebuffer
> (based on real fb0 SCREENINFO properties) for this process provided permissions
> allow this operation. To view the framebuffer, the CUSE based virtual device
> would talk to the actual hardware. Since namespaces would have different view of
> the underlying devices, "sysfs" has to made aware of this as well. 
>
> Please let me know your inputs. Thanks again!

The solution hugely depends on what you are trying to do with it.

The situation today is that device nodes are slowly fading out.  In
another 20 years linux may not have any device nodes at all.

Therefore the question becomes what are you trying to support.

If it is just filtering of existing device nodes.  We can do a pretty
good approximation with bind mounts.

If you want to emulate a device you can use normal fuse (not cuse).
As normal fuse file will support arbitrary ioctls.

There are a few cases where it is desirable to emulate what devpts
does for allowing arbitrary users to creating virtual devices in the
kernel.  Loop devices in particular.

Ultimately given the existence of device hotplug I don't see any call
for being able to create device nodes with well known device numbers
(fundamentally what a device namespace would be about).

The conversation last year was about people wanting to multiplex devices
that don't have multiplexer support in the kernel.  If that is your
desire I think it is entirely reasonable to device type by device type
add support for multiplexing that device type to the kernel, or
potentially just use fuse or cuse to implement your multiplexer in
userspace but that has the potential to be unusably slow.

Eric
