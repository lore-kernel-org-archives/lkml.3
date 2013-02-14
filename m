Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934459Ab3BNO6W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 09:58:22 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:44157 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756339Ab3BNO6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 09:58:20 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Glauber Costa <glommer@parallels.com>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>, <linux-kernel@vger.kernel.org>,
        <containers@lists.linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
References: <1360843000-31228-1-git-send-email-glommer@parallels.com>
	<20130214142745.GA4470@sergelap> <511CF51C.6050504@parallels.com>
Date: Thu, 14 Feb 2013 06:58:12 -0800
In-Reply-To: <511CF51C.6050504@parallels.com> (Glauber Costa's message of
	"Thu, 14 Feb 2013 18:30:52 +0400")
Message-ID: <87wqubc58b.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+MYomAhd3ltmD4FtR3kkHG4naf1zIL0ME=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Glauber Costa <glommer@parallels.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] kernel: allow reboots from user_ns
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber Costa <glommer@parallels.com> writes:

> On 02/14/2013 06:27 PM, Serge Hallyn wrote:
>> Quoting Glauber Costa (glommer@parallels.com):
>>> Reboot support for pid namespaces is already implemented and it works
>>> well. However, in most containers the tasks will join all namespaces,
>>> including the now supported user namespace. In that situation, we will
>>> fail the "capable" test and won't be able to reboot.
>>>
>>> The proposed solution is to allow reboots for CAP_SYS_BOOT processes
>>> in the user namespace that owns the pid namespace.
>>>
>>> Signed-off-by: Glauber Costa <glommer@parallels.com>
>> 
>> Note Li Zefan sent this identical patch last year.  It's in my own
>> built userns kernel, and definately required :)
>> 
> I didn't see that, and using Linus' master my stop container scripts
> stopped working after I started using Eric's userns...

The patch has been sitting in my for-next branch for quite a while
just waiting for the merge window.

Eric

commit 923c7538236564c46ee80c253a416705321f13e3
Author: Li Zefan <lizefan@huawei.com>
Date:   Thu Dec 27 11:39:12 2012 +0800

    userns: Allow unprivileged reboot
    
    In a container with its own pid namespace and user namespace, rebooting
    the system won't reboot the host, but terminate all the processes in
    it and thus have the container shutdown, so it's safe.
    
    Signed-off-by: Li Zefan <lizefan@huawei.com>
    Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

diff --git a/kernel/sys.c b/kernel/sys.c
index 265b376..24d1ef5 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -433,11 +433,12 @@ static DEFINE_MUTEX(reboot_mutex);
 SYSCALL_DEFINE4(reboot, int, magic1, int, magic2, unsigned int, cmd,
                void __user *, arg)
 {
+       struct pid_namespace *pid_ns = task_active_pid_ns(current);
        char buffer[256];
        int ret = 0;
 
        /* We only trust the superuser with rebooting the system. */
-       if (!capable(CAP_SYS_BOOT))
+       if (!ns_capable(pid_ns->user_ns, CAP_SYS_BOOT))
                return -EPERM;
 
        /* For safety, we require "magic" arguments. */
@@ -453,7 +454,7 @@ SYSCALL_DEFINE4(reboot, int, magic1, int, magic2, unsigned int, cmd,
         * pid_namespace, the command is handled by reboot_pid_ns() which will
         * call do_exit().
         */
-       ret = reboot_pid_ns(task_active_pid_ns(current), cmd);
+       ret = reboot_pid_ns(pid_ns, cmd);
        if (ret)
                return ret;
