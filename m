Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587AbaD2WY6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 18:24:58 -0400
Received: from mail.siteground.com ([67.19.240.234]:57700 "EHLO
	mail.siteground.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644AbaD2WY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 18:24:56 -0400
Message-ID: <536026B3.1020905@1h.com>
Date: Wed, 30 Apr 2014 01:24:51 +0300
From: Marian Marinov <mm@1h.com>
Organization: 1H Ltd.
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Serge Hallyn <serge.hallyn@ubuntu.com>
CC: "Theodore Ts'o" <tytso@mit.edu>, containers@lists.linux-foundation.org,
        LXC development mailing-list 
	<lxc-devel@lists.linuxcontainers.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: ioctl CAP_LINUX_IMMUTABLE is checked in the wrong namespace
References: <535FADDA.2070803@1h.com> <20140429183534.GB19325@thunk.org> <20140429185251.GA27969@ubuntumail> <53601E5B.5050004@1h.com> <20140429220234.GC28410@ubuntumail>
In-Reply-To: <20140429220234.GC28410@ubuntumail>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - mail.siteground.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - 1h.com
X-Get-Message-Sender-Via: mail.siteground.com: none
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2014 01:02 AM, Serge Hallyn wrote:
> Quoting Marian Marinov (mm@1h.com):
>> On 04/29/2014 09:52 PM, Serge Hallyn wrote:
>>> Quoting Theodore Ts'o (tytso@mit.edu):
>>>> On Tue, Apr 29, 2014 at 04:49:14PM +0300, Marian Marinov wrote:
>>>>>
>>>>> I'm proposing a fix to this, by replacing the capable(CAP_LINUX_IMMUTABLE)
>>>>> check with ns_capable(current_cred()->user_ns, CAP_LINUX_IMMUTABLE).
>>>>
>>>> Um, wouldn't it be better to simply fix the capable() function?
>>>>
>>>> /**
>>>>   * capable - Determine if the current task has a superior capability in effect
>>>>   * @cap: The capability to be tested for
>>>>   *
>>>>   * Return true if the current task has the given superior capability currently
>>>>   * available for use, false if not.
>>>>   *
>>>>   * This sets PF_SUPERPRIV on the task if the capability is available on the
>>>>   * assumption that it's about to be used.
>>>>   */
>>>> bool capable(int cap)
>>>> {
>>>> 	return ns_capable(&init_user_ns, cap);
>>>> }
>>>> EXPORT_SYMBOL(capable);
>>>>
>>>> The documentation states that it is for "the current task", and I
>>>> can't imagine any use case, where user namespaces are in effect, where
>>>> using init_user_ns would ever make sense.
>>>
>>> the init_user_ns represents the user_ns owning the object, not the
>>> subject.
>>>
>>> The patch by Marian is wrong.  Anyone can do 'clone(CLONE_NEWUSER)',
>>> setuid(0), execve, and end up satisfying 'ns_capable(current_cred()->userns,
>>> CAP_SYS_IMMUTABLE)' by definition.
>>>
>>> So NACK to that particular patch.  I'm not sure, but IIUC it should be
>>> safe to check against the userns owning the inode?
>>>
>>
>> So what you are proposing is to replace 'ns_capable(current_cred()->userns, CAP_SYS_IMMUTABLE)' with
>> 'inode_capable(inode, CAP_SYS_IMMUTABLE)' ?
>>
>> I agree that this is more sane.
>
> Right, and I think the two operations you're looking at seem sane
> to allow.

If you are ok with this patch, I will fix all file systems and send patches.

Signed-off-by: Marian Marinov <mm@yuhu.biz>
---
  fs/ext4/ioctl.c | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index d011b69..9418634 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -265,7 +265,7 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
                  * This test looks nicer. Thanks to Pauline Middelink
                  */
                 if ((flags ^ oldflags) & (EXT4_APPEND_FL | EXT4_IMMUTABLE_FL)) {
-                   if (!capable(CAP_LINUX_IMMUTABLE))
+                 if (!inode_capable(inode, CAP_LINUX_IMMUTABLE))
                                 goto flags_out;
                 }

---
1.8.4

Marian


>
> thanks,
> -serge
>


-- 
Marian Marinov
Founder & CEO of 1H Ltd.
Jabber/GTalk: hackman@jabber.org
ICQ: 7556201
Mobile: +359 886 660 270
