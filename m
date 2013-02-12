Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932810Ab3BLKeW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 05:34:22 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:49892 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932241Ab3BLKeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 05:34:21 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Josh Boyer <jwboyer@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Mel Gorman <mgorman@suse.de>, linux-kernel@vger.kernel.org
References: <20130207215742.GB31684@hansolo.jdub.homelinux.org>
	<20130207141502.04625ea0.akpm@linux-foundation.org>
	<20130208003501.GC31684@hansolo.jdub.homelinux.org>
	<20130208181949.GD31684@hansolo.jdub.homelinux.org>
	<87k3qiwomi.fsf@xmission.com>
	<20130211155701.e7968e64.akpm@linux-foundation.org>
Date: Tue, 12 Feb 2013 02:34:15 -0800
In-Reply-To: <20130211155701.e7968e64.akpm@linux-foundation.org> (Andrew
	Morton's message of "Mon, 11 Feb 2013 15:57:01 -0800")
Message-ID: <87obfphlco.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19OA0gOLuLayI2oCcpLc2BFJL2Qwk9Dvv8=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>
X-Spam-Relay-Country: 
Subject: Re: Odd ENOMEM being returned in 3.8-rcX
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Fri, 08 Feb 2013 12:13:09 -0800
> ebiederm@xmission.com (Eric W. Biederman) wrote:
>
>> If mock has called unshare(CLONE_NEWPID). And then forked a process and
>> that process exited, and then forked anothe process that second and all
>> subsequent fork calls will fail with -ENOMEM (because init has exited in
>> the pid namespace).  -ENOMEM will be generated because of a failure of
>> alloc_pid.
>
> Can we please fix this?  The system is *not* out of memory and it's
> wildly misleading to report this to userspace.
>
> If alloc_pid() can fail for multiple reasons then it should be
> returning an ERR_PTR on failure, not NULL.

We might be able to fix this.

alloc_pid causing fork to fail with ENOMEM when there are simply not
enough pids available to use is a long standing failure mode, and error
code.

I believe to change this responsibily you would have read a lot of
programs to see if fork failing with an additional error code would be
handled or if things would break in subtle ways.  There would need to be
research to see what posix says about this, and the posix view on fork
would have any impact on this in any way.

Furthermore this error is a resource shortage, so ENOMEM isn't even
exactly wrong.

I can understand the problem but I totally don't care enough to push an
ABI change like that through.

Eric
